#include "ClickAndExpect.h"

#include <Scene/Scene.h>

#include <chrono>
#include <thread>

namespace spix {
namespace cmd {

ClickAndExpect::ClickAndExpect(ItemPosition positionButton, MouseButton mouseButton, ItemPath pathObject,
    std::string property, std::string value, int timeout, std::promise<int> promise)
: m_positionButton(std::move(positionButton))
, m_mouseButton(mouseButton)
, m_pathObject(std::move(pathObject))
, m_property(property)
, m_expectedValue(value)
, m_timeout(timeout)
, m_promise(std::move(promise))
{
}


void ClickAndExpect::execute(CommandEnvironment& env){
    // Time the thread waits before re-trying getting object and property
    std::chrono::milliseconds sleepTime = std::chrono::milliseconds(30);

	auto buttonPath = m_positionButton.itemPath();
	auto button = env.scene().itemAtPath(buttonPath);

    // 0: everything went well, 1: timeout on property value, 2: timeout on object founding, 3: button doesn't exist
    if (!button){
		m_promise.set_value(3);
		env.state().reportError("ClickAndExpect: [NOTFOUND] button not found: " + buttonPath.string());
        return;
	}

    // TODO: Maybe a more precise check on the state of the button could be needed, for example if it is visible/enabled and so on

    auto size = button->size();
    auto mousePoint = m_positionButton.positionForItemSize(size);
    env.scene().events().mouseDown(button.get(), mousePoint, m_mouseButton);
    env.scene().events().mouseUp(button.get(), mousePoint, m_mouseButton);

    // Force the event loop to process once to take in account the previous click
    env.scene().processEvent();

    // Timer initialization
    auto startTime = std::chrono::steady_clock::now();
    auto timeout = std::chrono::milliseconds(m_timeout);

    auto elapsedTime = std::chrono::steady_clock::now() - startTime;

    auto object = env.scene().objectAtPath(m_pathObject);
    while (!object) {
        // Sleep (30ms ?)
        std::this_thread::sleep_for(sleepTime);

        object = env.scene().objectAtPath(m_pathObject);

        // Re-compute elapsed time
        elapsedTime = std::chrono::steady_clock::now() - startTime;
        if (elapsedTime >= timeout) {
            m_promise.set_value(2);
            env.state().reportError("ClickAndExpect: [NOTFOUND] object to study not found: " + m_pathObject.string());
            return;
        }
    }
    std::string error;
    std::string valueString;

    std::tie(valueString, error) = object->stringProperty(m_property.c_str());
    while(valueString != m_expectedValue) {
        // Sleep (30ms ?)
        std::this_thread::sleep_for(sleepTime);

        std::tie(valueString, error) = object->stringProperty(m_property.c_str());

        // Re-compute elapsed time
        elapsedTime = std::chrono::steady_clock::now() - startTime;
        if (elapsedTime >= timeout) {
			m_promise.set_value(1);
            env.state().reportError("ClickAndExpect: [TIMEOUT] after " + std::to_string(m_timeout)+"ms. See next error for further details.");
            if(!error.empty()){
                env.state().reportError("ClickAndExpect: " + error);
            } else {
                env.state().reportError("ClickAndExpect: Property value was '" + valueString + "', expecting '" + m_expectedValue + "'.");
            }
			return;
        }
    }
	m_promise.set_value(0);
	return;
}



} // namespace cmd
} // namespace spix
