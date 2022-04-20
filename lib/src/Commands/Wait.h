/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#pragma once

#include "Command.h"

#include <Spix/Data/ItemPath.h>
#include <Scene/Events.h>

#include <functional>
#include <chrono>

namespace spix {
namespace cmd {

class Wait : public Command {
public:
    Wait(std::chrono::milliseconds waitTime);
    //own added
    Wait(ItemPath path, int timeout);

    void execute(CommandEnvironment&) override;
    bool canExecuteNow(CommandEnvironment& env) override; //env param own added

    //own added
    bool timerWaitFor();
    bool signalWaitFor(CommandEnvironment& env);

private:
    bool m_timerInitialized = false;
    std::chrono::steady_clock::time_point m_startTime;
    std::chrono::milliseconds m_waitTime;

    //own added
    ItemPath m_path;
    int m_timeout;
};

} // namespace cmd
} // namespace spix
