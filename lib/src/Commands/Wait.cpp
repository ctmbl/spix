/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include "Wait.h"

#include <Scene/Scene.h>
#include <Scene/Qt/QtItem.h>
#include <Scene/Qt/QtItemTools.h>
#include <QSignalSpy>


#include <iostream>

namespace spix {
namespace cmd {

Wait::Wait(std::chrono::milliseconds waitTime)
: m_waitTime(waitTime),
m_path(""),
m_timeout(-1)
{
}

Wait::Wait(ItemPath path, int timeout)
: m_waitTime(std::chrono::milliseconds(0)),
m_path(path),
m_timeout(timeout)
{
}

void Wait::execute(CommandEnvironment& env)
{
}

bool Wait::canExecuteNow(CommandEnvironment& env)
{
    if(m_path.string().empty()){
        return timerWaitFor();
    }
    return signalWaitFor(env);
}

bool Wait::timerWaitFor(){
    if (!m_timerInitialized) {
        m_timerInitialized = true;
        m_startTime = std::chrono::steady_clock::now();
        return false;
    }

    auto timeSinceStart = std::chrono::steady_clock::now() - m_startTime;
    return timeSinceStart >= m_waitTime;
}

bool Wait::signalWaitFor(CommandEnvironment& env){
    auto item = static_cast<QtItem*>(env.scene().itemAtPath(m_path).get()); //maybe should i use a dynamic_cast here, items return by itemAtPath currently are QtItem but maybe won't be for ever

    if (!item) {
        env.state().reportError("WaitForSignal: [NOTFOUND] Item not found (or cast didn't work ?): " + m_path.string());
        std::cout << "[SIGNAL] Item not found (or cast didn't work ?): " << m_path.string() << "\n";
        return true;
    }

    auto mo = ((QObject*)item->qquickitem())->metaObject();
    auto signal = mo->method(mo->indexOfSignal("clicked()"));


    QSignalSpy spy((QObject*)item->qquickitem(), SIGNAL(clicked()));
    if(spy.wait(m_timeout)){
        std::cout << "[SIGNAL] button clicked signal received within the timeout\n";
        return true;
    }
    std::cout << "[SIGNAL][TIMEOUT] signal has never been received\n";
    env.state().reportError("WaitForSignal: [TIMEOUT] signal '<SIGNAL>' has never been received\n");
    return true;
}

} // namespace cmd
} // namespace spix
