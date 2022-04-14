#pragma once

//#include "qml_widgets_global.h"

#include <QObject>

//namespace enums {

class WorkbenchEnums
{
  Q_GADGET

public:
  static void init();

  enum class ResizeMode
  {
    Right,
    Left,
    Top,
    Bottom,
    TopRight,
    TopLeft,
    BottomRight,
    BottomLeft
  };
  Q_ENUM(ResizeMode)

  enum class Buttons
  {
    Accept,
    Cancel,
    Both,
    None
  };
  Q_ENUM(Buttons)

  enum class Orientation
  {
    Vertical,
    Horizontal
  };
  Q_ENUM(Orientation)
};

//} //namespace enums
