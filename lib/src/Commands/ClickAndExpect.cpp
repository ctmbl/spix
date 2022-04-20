#include "ClickAndExpect.h"
#include "Wait.h"

#include <QCoreApplication>

#include <Scene/Scene.h>

namespace spix {
namespace cmd {

ClickAndExpect::ClickAndExpect(ItemPosition positionButton, MouseButton mouseButton, ItemPath pathObject,
    std::string property, std::string value, int timeout, std::promise<int> promise)
: m_positionButton(std::move(positionButton))
, m_mouseButton(mouseButton)
, m_pathObject(std::move(pathObject))
, m_property(property)
, m_value(value)
, m_timeout(timeout)
, m_promise(std::move(promise))
{
}


void ClickAndExpect::execute(CommandEnvironment& env){

	auto buttonPath = m_positionButton.itemPath();
	auto button = env.scene().itemAtPath(buttonPath);

    // 0: everytrhing went well, 1: timeout on property, 2: timeout on existsAndVisible, 3: button isn't visible
    if (!button || !(button->visible())){
		m_promise.set_value(3);
		env.state().reportError("ClickAndExpect: [NOTFOUND] button not found: " + buttonPath.string());
        return;
	}

    
    auto size = button->size();
    auto mousePoint = m_positionButton.positionForItemSize(size);
    env.scene().events().mouseDown(button.get(), mousePoint, m_mouseButton);
    env.scene().events().mouseUp(button.get(), mousePoint, m_mouseButton);

    QCoreApplication::processEvents();
    auto clock = cmd::Wait(std::chrono::milliseconds(m_timeout));

	auto object = env.scene().itemAtPath(m_pathObject);

    if (!object || !(object->visible())) {
        while (!object || !(object->visible())) {
            if (clock.timerWaitFor()) {
				m_promise.set_value(2);
				env.state().reportError("ClickAndExpect: [NOTFOUND] object to study not found/visible (or property doesn't exist?): " + m_pathObject.string());
        		return;
            }
        }
    }
    while(object->stringProperty(m_property) != m_value) {
        if (clock.timerWaitFor()) {
			m_promise.set_value(1);
			env.state().reportError("ClickAndExpect: [TIMEOUT] timeout of: " + std::to_string(m_timeout));
			return;
        }
    }
	m_promise.set_value(0);
	return;
}



} // namespace cmd
} // namespace spix
