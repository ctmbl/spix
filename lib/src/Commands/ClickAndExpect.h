#pragma once

#include "Command.h"
#include <Spix/Data/ItemPath.h>
#include <Spix/Data/ItemPosition.h>
#include <Spix/Events/Identifiers.h>

#include <future>


namespace spix {
namespace cmd {

class SPIX_EXPORT ClickAndExpect : public Command {
public:
    ClickAndExpect(ItemPosition positionButton, MouseButton mouseButton, ItemPath pathObject, std::string property, std::string value, int timeout, std::promise<int> promise);

    void execute(CommandEnvironment& env) override;

private:
    ItemPosition m_positionButton;
    MouseButton m_mouseButton;
    ItemPath m_pathObject;
    std::string m_property;
    std::string m_value;
    int m_timeout;
    std::promise<int> m_promise;
};

} // namespace cmd
} // namespace spix