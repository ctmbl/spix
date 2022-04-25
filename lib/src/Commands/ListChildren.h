#pragma once


#include <Spix/spix_export.h>

#include "Command.h"
#include <Scene/Events.h>
#include <Spix/Data/ItemPath.h>

namespace spix {
namespace cmd {

class SPIX_EXPORT ListChildren : public Command {
public:
    ListChildren(ItemPath path, bool recursively);

    void execute(CommandEnvironment& env) override;

private:
    ItemPath m_path;
    bool m_recursively;
};

} // namespace cmd
} // namespace spix