/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/
#include <iostream>

#include "QtItemTools.h"

#include <QQmlContext>
#include <QQuickItem>
#include <QString>

namespace spix {
namespace qt {

const QString repeater_class_name = QString("QQuickRepeater");
const char* item_at_method_name = "itemAt";

QQuickItem* RepeaterChildAtIndex(QQuickItem* repeater, int index)
{
    QQuickItem* retVal = nullptr;
    bool success = QMetaObject::invokeMethod(
        repeater, item_at_method_name, Qt::DirectConnection, Q_RETURN_ARG(QQuickItem*, retVal), Q_ARG(int, index));
    if (success)
        return retVal;

    return nullptr;
}

QQuickItem* RepeaterChildWithName(QQuickItem* repeater, const QString& name)
{
    int itemIndex = 0;
    QQuickItem* item = nullptr;
    do {
        item = RepeaterChildAtIndex(repeater, itemIndex);
        if (item && GetObjectName(item) == name) {
            break;
        }

        ++itemIndex;
    } while (item);

    return item;
}

QString GetObjectName(QObject* object)
{
    if (object == nullptr) {
        return "nullptr";
    }

    // Allow to override id with objectName
    if (!object->objectName().isEmpty()) {
        return object->objectName();
    }
    QQmlContext* const context = qmlContext(object);
    if (context) {
        return context->nameForObject(object);
    }

    return object->objectName();
}

QObject* FindChildItem(QObject* object, const QString& name, int depth)
{
    //std::cout << "[LIST] Children of " << GetObjectName(object).toStdString() << "\n";
    if (auto qquickitem = qobject_cast<const QQuickItem*>(object)) {
        //std::cout << "[+] Cast in QQuickItem* OK\n";

        for (auto child : qquickitem->childItems()) {
            std::cout << std::string(depth, '\t') << " - " << GetObjectName(child).toStdString() << "\n";
            if (GetObjectName(child) == name) {
                return child;
            }
            if (auto item = FindChildItem(child, name, depth +1)) {
                return item;
            }
        }
    } else {
        //std::cout << "[+] NO Cast in QQuickItem* \n";
        for (auto child : object->children()) {
            std::cout << std::string(depth, '\t') << " - " << GetObjectName(child).toStdString() << " [+] NOT A QQuickItem  \n";
            if (GetObjectName(child) == name) {
                return child;
            }
            if (auto item = FindChildItem(child, name, depth + 1)) {
                return item;
            }
        }
    }

    return nullptr;
}

void ListEveryChildren(QObject* object, int depth)
{
    if (auto qquickitem = qobject_cast<const QQuickItem*>(object)) {

        for (auto child : qquickitem->childItems()) {
            std::cout << std::string(depth, '\t') << " - " << GetObjectName(child).toStdString() << "\n";
            ListEveryChildren(child, depth +1);
        }
    } else {
        for (auto child : object->children()) {
            std::cout << std::string(depth, '\t') << " - " << GetObjectName(child).toStdString() << " [+] NOT A QQuickItem  \n";
            ListEveryChildren(child, depth + 1);
        }
    }

    return;
}

void SearchEveryCompletePath(QObject* object, const QString& name, std::vector<std::string>& pathsList, QString path){
    char sep = '/';
    
    if (auto qquickitem = qobject_cast<const QQuickItem*>(object)) {
        for (auto child : qquickitem->childItems()) {
            auto current_item_name = GetObjectName(child);

            auto new_path = QString(path);
            if(!current_item_name.isEmpty()){
                new_path.append(sep).append(current_item_name);
            }
            
            if (current_item_name == name) {
                pathsList.push_back(new_path.toStdString().c_str());
                return;
            }
            SearchEveryCompletePath(child, name, pathsList, new_path);
        }
    } else {
        for (auto child : object->children()) {
            auto current_item_name = GetObjectName(child);

            auto new_path = QString(path);
            if(!current_item_name.isEmpty()){
                new_path.append(sep).append(current_item_name);
            }
            
            if (current_item_name == name) {
                pathsList.push_back(new_path.toStdString().c_str());
                return;
            }
            SearchEveryCompletePath(child, name, pathsList, new_path);
        }
    }

    return;
}

} // namespace qt
} // namespace spix
