/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include "Wait.h"



//own added
#include <Scene/Scene.h>
#include <Scene/Qt/QtItem.h>
#include <Scene/Qt/QtItemTools.h>


#include <QSignalSpy> //to be modified, Qt include shouldn't appear here
#include <iostream>

namespace spix {
namespace cmd {

Wait::Wait(std::chrono::milliseconds waitTime)
: m_waitTime(waitTime),
m_path(""),
m_timeout(-1)
{
}

Wait::Wait(ItemPath path, std::string str_signal, int timeout)
: m_waitTime(std::chrono::milliseconds(0)),
m_path(path),
m_timeout(timeout),
m_str_signal(str_signal)
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
    auto quickitem = env.scene().itemAtPath(m_path);    //forced to instance the std::unique_ptr in the function scope ! 
    auto item = dynamic_cast<QtItem*>(quickitem.get()); //get the raw pointer from the std::unique_ptr

    if (!item) {
        env.state().reportError("WaitForSignal: [NOTFOUND] Item not found (or cast didn't work ?): " + m_path.string());
        std::cout << "[SIGNAL][ERROR] Item not found (or cast didn't work ?): " << m_path.string() << "\n";
        return true;
    }

    auto Qobj = item->qquickitem();

    if(Qobj == nullptr){
        env.state().reportError("WaitForSignal: [NOQUICKITEM] Unable to get QQuickItem from: " + m_path.string());
        std::cout << "[SIGNAL][ERROR] Unable to get QQuickItem from: " << m_path.string() << "\n";
        return true;
    }

    auto mo = Qobj->metaObject();
    auto signalIndex = mo->indexOfSignal(m_str_signal.c_str());
    if(signalIndex < 0){
        env.state().reportError("WaitForSignal: [NOTASIGNAL] '" + m_str_signal + "' isn't a signal, at least isn't a signal of: " + m_path.string());
        std::cout << "[SIGNAL][NOTASIGNAL] '" + m_str_signal + "' isn't a signal, at least isn't a signal of: " << m_path.string() << "\n";
        return true;
    }
    auto signal = mo->method(signalIndex);

    QSignalSpy spy(Qobj, signal); //to be modified, Qt include shouldn't appear here

    if(spy.wait(m_timeout)){
        std::cout << "[SIGNAL] button clicked signal received within the timeout\n";
        return true;
    }
    std::cout << "[SIGNAL][TIMEOUT] signal has never been received\n";
    env.state().reportError("WaitForSignal: [TIMEOUT] signal '" + signal.name().toStdString() + "' has never been received");
    return true;
}

} // namespace cmd
} // namespace spix
