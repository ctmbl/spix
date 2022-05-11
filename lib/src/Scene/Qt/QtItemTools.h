/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#pragma once

#include <QObject>
#include <QQuickItem>

#include <vector>

class QString;

namespace spix {
namespace qt {

extern const QString repeater_class_name;
extern const char* item_at_method_name;

QQuickItem* RepeaterChildAtIndex(QQuickItem* repeater, int index);
QQuickItem* RepeaterChildWithName(QQuickItem* repeater, const QString& name);

QString GetObjectName(QObject* object);

/**
 * @brief Find a child object with the given name.
 *
 * This works similar to `QObject::findChild`. However, once it
 * encounters a `QQuickItem`, it no longer iterates over the object's
 * `children()`, but rather its `childItems()`.
 */
QObject* FindChildItem(QObject* object, const QString& name, int depth = 0);

void ListEveryChildren(QObject* object, int depth = 0);

void SearchEveryCompletePath(QObject* object, const QString& name, std::vector<std::string>& pathsList, QString path);

template <typename T>
T FindChildItem(QObject* object, const QString& name, int depth = 0)
{
    return qobject_cast<T>(FindChildItem(object, name));
}

} // namespace qt
} // namespace spix
