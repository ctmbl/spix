#include "ListChildren.h"

#include <iostream>

#include <Scene/Scene.h>


namespace spix {
namespace cmd {

ListChildren::ListChildren(ItemPath path, bool recursively)
: m_path(std::move(path)),
m_recursively(recursively)
{
}

void ListChildren::execute(CommandEnvironment& env)
{
    auto item = env.scene().itemAtPath(m_path);

    if (!item) {
        env.state().reportError("ListChildren: Item not found: " + m_path.string());
        return;
    }

    if(!m_recursively){
        for(std::string child : env.scene().listChildrenAtPath(m_path)){
            std::cout << " - " << child << "\n";
        }
    } else {
        env.scene().listEveryChildrenAtPath(m_path);
    }


}

} // namespace cmd
} // namespace spix
