/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include "QtScene.h"

#include <Scene/Qt/QtItem.h>
#include <Scene/Qt/QtObject.h>
#include <Scene/Qt/QtItemTools.h>
#include <Spix/Data/ItemPath.h>

#include <QGuiApplication>
#include <QCoreApplication>
#include <QObject>
#include <QQuickItem>
#include <QQuickWindow>
#include <QQmlContext>
#include <QString>

#include <vector>

namespace {

QQuickWindow* getQQuickWindowWithName(const std::string& name)
{
    QString qtName = QString::fromStdString(name);
    QQuickWindow* foundWindow = nullptr;

    auto windows = QGuiApplication::topLevelWindows();
    for (const auto& window : windows) {
        QQuickWindow* qquickWindow = qobject_cast<QQuickWindow*>(window);
        if (qquickWindow && (spix::qt::GetObjectName(qquickWindow) == qtName)) {
            foundWindow = qquickWindow;
            break;
        }
    }

    return foundWindow;
}

QObject* getQObjectWithRoot(const spix::ItemPath& path, QObject* root)
{
    if (path.length() == 0) {
        return nullptr;
    }
    if (!root) {
        return nullptr;
    }

    auto rootClassName = root->metaObject()->className();
    auto itemName = path.rootComponent();
    QObject* subItem = nullptr;

    if (itemName.compare(0, 1, ".") == 0) {
        auto propertyName = itemName.substr(1);
        QQmlContext* const context = qmlContext(root);
        QVariant propertyValue;

        if (context) {
            propertyValue = context->contextProperty(propertyName.c_str());
        } else {
            propertyValue = root->property(propertyName.c_str());
        }

        if (propertyValue.isValid()){
            subItem = propertyValue.value<QObject*>();
        }
    } else {
        if (rootClassName == spix::qt::repeater_class_name) {
            QQuickItem* repeater = static_cast<QQuickItem*>(root);
            subItem = spix::qt::RepeaterChildWithName(repeater, QString::fromStdString(itemName));
        } else {
            subItem = spix::qt::FindChildItem<QObject*>(root, itemName.c_str());
        }
    }

    if (path.length() == 1) {
        return subItem;
    }

    return getQObjectWithRoot(path.subPath(1), subItem);
}

QObject* getQQuickItemAtPath(const spix::ItemPath& path)
{
    auto windowName = path.rootComponent();
    QQuickWindow* itemWindow = getQQuickWindowWithName(windowName);
    QObject* item = nullptr;

    if (!itemWindow) {
        return nullptr;
    }

    if (path.length() > 1) {
        item = getQObjectWithRoot(path.subPath(1), itemWindow);
    } else {
        item = itemWindow->contentItem();
    }

    return item;
}

template <typename T>
T getQQuickItemAtPath(const spix::ItemPath& path)
{
    return qobject_cast<T>(getQQuickItemAtPath(path));
}

} // namespace

namespace spix {

std::unique_ptr<Item> QtScene::itemAtPath(const ItemPath& path)
{
    auto windowName = path.rootComponent();
    QQuickItem* item = getQQuickItemAtPath<QQuickItem*>(path);

    if (item) {
        return std::make_unique<QtItem>(item);
    }
    return std::unique_ptr<QtItem>();
}

std::unique_ptr<Object> QtScene::objectAtPath(const ItemPath& path)
{
    QObject* obj = getQQuickItemAtPath<QObject*>(path);

    if (obj) {
        return std::make_unique<QtObject>(obj, path);
    }
    return std::unique_ptr<QtObject>();
}

Events& QtScene::events()
{
    return m_events;
}

void QtScene::processEvent(){
    QCoreApplication::processEvents();
}

bool QtScene::takeScreenshot(Item& targetItem, const std::string& filePath)
{
    auto item = dynamic_cast<QtItem&>(targetItem).qquickitem();

    // take screenshot of the full window
    auto windowImage = item->window()->grabWindow();

    // get the rect of the item in window space in pixels, account for the device pixel ratio
    QRectF imageCropRectItemSpace {0, 0, item->width(), item->height()};
    auto imageCropRectF = item->mapRectToScene(imageCropRectItemSpace);
    QRect imageCropRect(imageCropRectF.x() * windowImage.devicePixelRatio(),
        imageCropRectF.y() * windowImage.devicePixelRatio(), imageCropRectF.width() * windowImage.devicePixelRatio(),
        imageCropRectF.height() * windowImage.devicePixelRatio());

    // crop the window image to the item rect
    auto image = windowImage.copy(imageCropRect);
    return image.save(QString::fromStdString(filePath));
}

std::vector<std::string> QtScene::searchEveryCompletePath(const ItemPath& path){
    auto windowName = path.rootComponent();
    QQuickWindow* itemWindow = getQQuickWindowWithName(windowName);
    std::vector<std::string> pathsList = {};
    spix::qt::SearchEveryCompletePath(itemWindow, QString(path.subPath(1).string().c_str()), pathsList, QString(path.rootComponent().c_str()));
    return pathsList;

}

} // namespace spix
