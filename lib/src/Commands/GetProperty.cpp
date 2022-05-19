/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include "GetProperty.h"

#include <Scene/Scene.h>

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

    std::string error;
    std::string valueString;

    // Checks whether the targeted object can be found
    if(obj){
        std::tie(valueString, error) = obj->stringProperty(m_propertyName.c_str());
    } else {
        valueString = std::string("");
        error = std::string("Item not found: " + m_path.string());
    }
    
    m_promise.set_value(valueString);
    if (!error.empty()){
        error = "GetProperty: " + error;
        env.state().reportError(error);
    }
}

} // namespace cmd
} // namespace spix
