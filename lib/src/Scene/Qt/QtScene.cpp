/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include "QtScene.h"

#include <Scene/Qt/QtItem.h>
#include <Scene/Qt/QtItemTools.h>
#include <Spix/Data/ItemPath.h>

#include <QGuiApplication>
#include <QObject>
#include <QQuickItem>
#include <QQuickWindow>

//own added:
#include <iostream>
#include <vector>
#include <QString>

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

QQuickItem* getQQuickItemWithRoot(const spix::ItemPath& path, QObject* root)
{
    if (path.length() == 0) {
        return nullptr;
    }
    if (!root) {
        return nullptr;
    }

    auto rootClassName = root->metaObject()->className();
    auto itemName = path.rootComponent();
    QQuickItem* subItem = nullptr;

    if (itemName.compare(0, 1, ".") == 0) {
        auto propertyName = itemName.substr(1);
        QVariant propertyValue = root->property(propertyName.c_str());
        if (propertyValue.isValid()) {
            subItem = propertyValue.value<QQuickItem*>();
        }
    } else {
        if (rootClassName == spix::qt::repeater_class_name) {
            QQuickItem* repeater = static_cast<QQuickItem*>(root);
            std::cout << "[*] enter repeater case in getQQuickItemWith Root in QtScene.cpp with root=" << spix::qt::GetObjectName(root).toStdString() << "\n";
            subItem = spix::qt::RepeaterChildWithName(repeater, QString::fromStdString(itemName));
        } else {
            subItem = spix::qt::FindChildItem<QQuickItem*>(root, itemName.c_str());
        }
    }

    if (path.length() == 1) {
        printf("[RETURN] in getQQuickItemWithRoot, find subItem | path=%s ; subItem=", path.string().c_str());
        if(subItem != nullptr)
            std::cout << spix::qt::GetObjectName(subItem).toStdString() << "\n";
        else
            std::cout << "nullptr" << "\n";
        return subItem;
    }
    printf("[STEP] in getQQuickItemWithRoot | path=%s ; subItem=", path.string().c_str());
    if(subItem != nullptr)
        std::cout << spix::qt::GetObjectName(subItem).toStdString() << "\n";
    else
        std::cout << "nullptr" << "\n";
    return getQQuickItemWithRoot(path.subPath(1), subItem);
}

QQuickItem* getQQuickItemAtPath(const spix::ItemPath& path)
{
    auto windowName = path.rootComponent();
    QQuickWindow* itemWindow = getQQuickWindowWithName(windowName);
    QQuickItem* item = nullptr;

    if (!itemWindow) {
        return nullptr;
    }

    if (path.length() > 1) {
        item = getQQuickItemWithRoot(path.subPath(1), itemWindow);
    } else {
        item = itemWindow->contentItem();
    }

    return item;
}

} // namespace

namespace spix {

std::unique_ptr<Item> QtScene::itemAtPath(const ItemPath& path)
{
    auto windowName = path.rootComponent();
    printf("[START] itemAtPath | path=%s ; root component=%s\n",path.string().c_str(), windowName.c_str());
    QQuickItem* item = getQQuickItemAtPath(path);

    if (item) {
        return std::make_unique<QtItem>(item);
    }
    return std::unique_ptr<QtItem>();
}

Events& QtScene::events()
{
    return m_events;
}

void QtScene::takeScreenshot(const ItemPath& targetItem, const std::string& filePath)
{
    auto item = getQQuickItemAtPath(targetItem);
    if (!item) {
        return;
    }

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
    image.save(QString::fromStdString(filePath));
}


//own added
std::vector<std::string> QtScene::listChildrenAtPath(const ItemPath& path){

    QQuickItem* item = getQQuickItemAtPath(path);

    std::vector<std::string> children = {};

    if (auto qquickitem = qobject_cast<const QQuickItem*>(item)) {

        for (auto child : qquickitem->childItems()) {
            children.push_back(spix::qt::GetObjectName(child).toStdString());
        }
    } else {
        for (auto child : item->children()) {
            children.push_back(spix::qt::GetObjectName(child).toStdString());
        }
    }

    return children;
}

void QtScene::listEveryChildrenAtPath(const ItemPath& path ){
    spix::qt::ListEveryChildren(getQQuickItemAtPath(path));
}

std::vector<std::string> QtScene::searchEveryCompletePath(const ItemPath& path){
    auto windowName = path.rootComponent();
    QQuickWindow* itemWindow = getQQuickWindowWithName(windowName);
    std::vector<std::string> pathsList = {};
    spix::qt::SearchEveryCompletePath(itemWindow, QString(path.subPath(1).string().c_str()), pathsList, QString(path.rootComponent().c_str()));
    return pathsList;

}

} // namespace spix
