#include "ListChildren.h"

#include <iostream>

#include <Scene/Scene.h>


namespace spix {
namespace cmd {

ListChildren::ListChildren(ItemPosition path, bool recursively)
: m_position(std::move(path)),
m_recursively(recursively)
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

    if(!m_recursively){
        for(std::string child : env.scene().listChildrenAtPath(path)){
            std::cout << " - " << child << "\n";
        }
    } else {
        env.scene().listEveryChildrenAtPath(path);
    }


}

} // namespace cmd
} // namespace spix
