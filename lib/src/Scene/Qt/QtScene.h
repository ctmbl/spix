/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#pragma once

#include <Scene/Qt/QtEvents.h>
#include <Scene/Scene.h>

#include <map>
#include <string>

class QQuickWindow;

namespace spix {

class ItemPath;

class QtScene : public Scene {
public:
    // Request objects
    std::unique_ptr<Item> itemAtPath(const ItemPath& path) override;

    std::unique_ptr<Object> objectAtPath(const ItemPath& path) override;

    // Events
    Events& events() override;

    // Tasks
    bool takeScreenshot(Item& targetItem, const std::string& filePath) override;

    std::vector<std::string> searchEveryCompletePath(const ItemPath& );

private:
    QtEvents m_events;
};

} // namespace spix
