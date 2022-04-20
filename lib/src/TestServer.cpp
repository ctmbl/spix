/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include <Spix/TestServer.h>

#include <CommandExecuter/CommandExecuter.h>

#include <Commands/ClickOnItem.h>
#include <Commands/CustomCmd.h>
#include <Commands/DragBegin.h>
#include <Commands/DragEnd.h>
#include <Commands/DropFromExt.h>
#include <Commands/EnterKey.h>
#include <Commands/ExistsAndVisible.h>
#include <Commands/GetBoundingBox.h>
#include <Commands/GetProperty.h>
#include <Commands/GetTestStatus.h>
#include <Commands/InputText.h>
#include <Commands/Quit.h>
#include <Commands/Screenshot.h>
#include <Commands/SetProperty.h>
#include <Commands/Wait.h>
#include <Commands/SearchItem.h>

#include <Commands/ClickAndExpect.h>

#include <Spix/Events/Identifiers.h>

namespace spix {

TestServer::~TestServer()
{
    if (m_thread.joinable()) {
        m_thread.join();
    }
}

void TestServer::start()
{
    if (!m_cmdExec) {
        throw std::runtime_error("Cannot start TestServer as no command executer was set");
    }

    m_thread = std::thread([this] { executeTest(); });
}

void TestServer::setCommandExecuter(CommandExecuter* exec)
{
    m_cmdExec = exec;
}

void TestServer::setGenericCommandHandler(std::function<void(std::string, std::string)> handler)
{
    m_handler = handler;
}

// ####################
// # Commands
// ####################

void TestServer::wait(std::chrono::milliseconds waitTime)
{
    m_cmdExec->enqueueCommand<cmd::Wait>(waitTime);
}

void TestServer::mouseClick(ItemPath path)
{
    m_cmdExec->enqueueCommand<cmd::ClickOnItem>(path, spix::MouseButtons::Left);
}

void TestServer::mouseClick(ItemPath path, MouseButton mouseButton)
{
    m_cmdExec->enqueueCommand<cmd::ClickOnItem>(path, mouseButton);
}

void TestServer::mouseBeginDrag(ItemPath path)
{
    m_cmdExec->enqueueCommand<cmd::DragBegin>(path);
}

void TestServer::mouseEndDrag(ItemPath path)
{
    m_cmdExec->enqueueCommand<cmd::DragEnd>(path);
}

void TestServer::mouseDropUrls(ItemPath path, const std::vector<std::string>& urls)
{
    m_cmdExec->enqueueCommand<cmd::DropFromExt>(path, makePasteboardContentWithUrls(urls));
}

void TestServer::genericCommand(std::string command, std::string payload)
{
    m_cmdExec->enqueueCommand<cmd::CustomCmd>(
        [=](spix::CommandEnvironment&) { m_handler(command, payload); }, []() { return true; });
}

void TestServer::inputText(ItemPath path, std::string text)
{
    m_cmdExec->enqueueCommand<cmd::InputText>(path, std::move(text));
}

void TestServer::enterKey(ItemPath path, int keyCode, unsigned modifiers)
{
    m_cmdExec->enqueueCommand<cmd::EnterKey>(path, keyCode, modifiers);
}

std::string TestServer::getStringProperty(ItemPath path, std::string propertyName)
{
    std::promise<std::string> promise;
    auto result = promise.get_future();
    auto cmd = std::make_unique<cmd::GetProperty>(path, std::move(propertyName), std::move(promise));
    m_cmdExec->enqueueCommand(std::move(cmd));

    return result.get();
}

void TestServer::setStringProperty(ItemPath path, std::string propertyName, std::string propertyValue)
{
    m_cmdExec->enqueueCommand<cmd::SetProperty>(path, std::move(propertyName), std::move(propertyValue));
}

Rect TestServer::getBoundingBox(ItemPath path)
{
    std::promise<Rect> promise;
    auto result = promise.get_future();
    auto cmd = std::make_unique<cmd::GetBoundingBox>(path, std::move(promise));
    m_cmdExec->enqueueCommand(std::move(cmd));

    return result.get();
}

bool TestServer::existsAndVisible(ItemPath path)
{
    std::promise<bool> promise;
    auto result = promise.get_future();
    auto cmd = std::make_unique<cmd::ExistsAndVisible>(path, std::move(promise));
    m_cmdExec->enqueueCommand(std::move(cmd));

    return result.get();
}

std::vector<std::string> TestServer::getErrors()
{
    std::promise<std::vector<std::string>> promise;
    auto result = promise.get_future();
    auto cmd = std::make_unique<cmd::GetTestStatus>(true, std::move(promise));
    m_cmdExec->enqueueCommand(std::move(cmd));

    return result.get();
}

bool TestServer::takeScreenshot(ItemPath targetItem, std::string filePath)
{
    std::promise<bool> promise;
    auto result = promise.get_future();
    m_cmdExec->enqueueCommand<cmd::Screenshot>(targetItem, std::move(filePath), std::move(promise));

    return result.get();
}

void TestServer::quit()
{
    m_cmdExec->enqueueCommand<cmd::Quit>();
}

std::vector<std::string> TestServer::searchItem(ItemPath path)
{
    std::promise<std::vector<std::string>> promise;
    auto result = promise.get_future();
    auto cmd = std::make_unique<cmd::SearchItem>(path, false, std::move(promise));
    m_cmdExec->enqueueCommand(std::move(cmd));

    return result.get();
}

int TestServer::clickAndExpect(ItemPath pathToButton, ItemPath pathToStudiedObject, std::string property, std::string value, int timeout){
    std::promise<int> promise;
    auto result = promise.get_future();
    auto cmd = std::make_unique<cmd::ClickAndExpect>(pathToButton, spix::MouseButtons::Left, pathToStudiedObject, std::move(property), std::move(value), timeout, std::move(promise));
    m_cmdExec->enqueueCommand(std::move(cmd));

    return result.get();
}

} // namespace spix
