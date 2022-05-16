/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include "GetProperty.h"

#include <Scene/Scene.h>

// TODO clean includes 
#include <QObject>
#include <QVariant>

namespace spix {
namespace cmd {

GetProperty::GetProperty(ItemPath path, std::string propertyName, std::promise<std::string> promise)
: m_path(std::move(path))
, m_propertyName(std::move(propertyName))
, m_promise(std::move(promise))
{
}

void GetProperty::execute(CommandEnvironment& env)
{
    auto obj = env.scene().objectAtPath(m_path);

    if (obj) {
        auto value = obj->property(m_propertyName.c_str());
        m_promise.set_value(value.toString().toStdString());
    } else {
        m_promise.set_value("");
        env.state().reportError("GetProperty: Item not found: " + m_path.string());
    }
}

} // namespace cmd
} // namespace spix
