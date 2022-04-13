#include "ListChildren.h"

#include <iostream>

#include <Scene/Scene.h>


namespace spix {
namespace cmd {

ListChildren::ListChildren(ItemPosition path)
: m_position(std::move(path))
{
}

void ListChildren::execute(CommandEnvironment& env)
{
    auto path = m_position.itemPath();
    auto item = env.scene().itemAtPath(path);

    if (!item) {
        env.state().reportError("ListChildren: Item not found: " + path.string());
        return;
    }

    for(std::string child : env.scene().listChildrenAtPath(path)){
        std::cout << " - " << child << "\n";
    }
}

} // namespace cmd
} // namespace spix
