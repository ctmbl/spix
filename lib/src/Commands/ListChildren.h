#pragma once


#include <Spix/spix_export.h>

#include "Command.h"
#include <Scene/Events.h>
#include <Spix/Data/ItemPosition.h>

namespace spix {
namespace cmd {

class SPIX_EXPORT ListChildren : public Command {
public:
    ListChildren(ItemPosition path);

    void execute(CommandEnvironment& env) override;

private:
    ItemPosition m_position;
};

} // namespace cmd
} // namespace spix