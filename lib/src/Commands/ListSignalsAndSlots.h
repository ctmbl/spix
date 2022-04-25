#pragma once


#include <Spix/spix_export.h>

#include "Command.h"
#include <Scene/Events.h>
#include <Spix/Data/ItemPath.h>

#include <vector>
#include <future>

namespace spix {
namespace cmd {

class SPIX_EXPORT ListSignalsAndSlots : public Command {
public:
    ListSignalsAndSlots(ItemPath path, std::promise<std::vector<std::string>> promise);

    void execute(CommandEnvironment& env) override;

private:
    ItemPath m_path;
    std::promise<std::vector<std::string>> m_promise;
};

} // namespace cmd
} // namespace spix