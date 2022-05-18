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
#include <QtQml>

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

    // Checks whether the targeted object can be found
    if (!obj){
        m_promise.set_value("");
        env.state().reportError("GetProperty: Item not found: " + m_path.string());
        return;
    }

    QQmlContext* const context = qmlContext(obj);
    QVariant value;

    // Checks if the property is a context property 
    // (context properties can overwrite properties so checking it first gives, intentionally, priority to context)
    if (context) {
        value = context->contextProperty(m_propertyName.c_str());

        // If the QVariant property is valid (meaning property has be found) it doesn't check "classic" properties then (return anyway)
        if (value.isValid()){

            // Checks if the property can actually be converted to a string
            auto valueString = value.toString().toStdString();
            if (!valueString.empty()){ 
                m_promise.set_value(valueString);
                return;
            }
            m_promise.set_value("");
            env.state().reportError("GetProperty: Property '" + m_propertyName + "' in Object at path: " + m_path.string() + " can't be converted to string.");
            return;
        }
    }


    value = obj->property(m_propertyName.c_str());

    if (value.isValid()){

        // Checks if the property can actually be converted to a string
        auto valueString = value.toString().toStdString();
        if (!valueString.empty()){
            m_promise.set_value(valueString);
            return;
        }
        m_promise.set_value("");
        env.state().reportError("GetProperty: Property '" + m_propertyName + "' in Object at path: " + m_path.string() + " can't be converted to string.");
        return;
    }

    // No property QVariant property (context and classic) is valid, meaning the property doesn't exists for this Object
    m_promise.set_value("");
    env.state().reportError("GetProperty: Property not found: '" + m_propertyName + "' in Object at path: " + m_path.string());
}

} // namespace cmd
} // namespace spix
