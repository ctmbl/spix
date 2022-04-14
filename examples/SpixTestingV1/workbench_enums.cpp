#include "workbench_enums.h"

// Qt / Qml
#include <QQmlApplicationEngine>

void WorkbenchEnums::init()
{
  qRegisterMetaType<WorkbenchEnums::ResizeMode>("WorkbenchEnums::ResizeMode");
  qmlRegisterUncreatableType<WorkbenchEnums>("Workbench", 1, 0, "ResizeMode", "Error, Can't create ResizeMode");

  qRegisterMetaType<WorkbenchEnums::Buttons>("WorkbenchEnums::Buttons");
  qmlRegisterUncreatableType<WorkbenchEnums>("Workbench", 1, 0, "Buttons", "Error, Can't create Buttons");

  qRegisterMetaType<WorkbenchEnums::Orientation>("WorkbenchEnums::Orientation");
  qmlRegisterUncreatableType<WorkbenchEnums>("Workbench", 1, 0, "Orientation", "Error, Can't create Orientation");  
}
