/***
 * Copyright (C) Falko Axmann. All rights reserved.
 * Licensed under the MIT license.
 * See LICENSE.txt file in the project root for full license information.
 ****/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <Spix/QtQmlBot.h>
#include <Spix/AnyRpcServer.h>

#include <iostream>

#include "workbench_enums.h"

#include <QtQml/QQmlDebuggingEnabler>
QQmlDebuggingEnabler enabler;

class MyTests : public spix::TestServer {
protected:
    void executeTest() override
    {
        mouseClick(spix::ItemPath("mainWindow/Button_1"));
        wait(std::chrono::milliseconds(500));
        mouseClick(spix::ItemPath("mainWindow/Button_2"));
        wait(std::chrono::milliseconds(500));
        mouseClick(spix::ItemPath("mainWindow/Button_2"));
        wait(std::chrono::milliseconds(500));
        mouseClick(spix::ItemPath("mainWindow/Button_1"));
        wait(std::chrono::milliseconds(500));
        mouseClick(spix::ItemPath("mainWindow/Button_2"));
        wait(std::chrono::milliseconds(500));
        mouseClick(spix::ItemPath("mainWindow/Button_1"));
        wait(std::chrono::milliseconds(500));

        auto result = getStringProperty("mainWindow/results", "text");
        std::cout << "-------\nResult:\n-------\n" << result << "\n-------" << std::endl;
    }
};

int main(int argc, char* argv[])
{

    WorkbenchEnums::init();

    // Init Qt Qml Application
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // Instantiate and run tests
    MyTests tests;
    spix::AnyRpcServer server;
    auto bot = new spix::QtQmlBot();
    

    printf("This is my Spix Proj to test the possibilities of Spix and its limits\n");

    if(argc == 1)
        printf("[+] No options has been given, run app only, no bot\n");
    else if(argc > 2)
        printf("[+] Only one arg INTEGER is taken into account\n");        
    else {
        switch (std::stoi(argv[1]))
        {
        case 1:
            printf("[+] Run the app with integrated tests\n");
            bot->runTestServer(tests);
            break;
        
        case 2:
            printf("[+] Run the app with remote control\n");
            bot->runTestServer(server);
            break;
        default:
            printf("[+] Unknown mode number\n");
            break;
        }
    } 
    

    return app.exec();
}
