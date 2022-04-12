# Spix Documentation

## Spix paths

- if an object **has an object name**, spix **doesn't check its ID** (it's explicit by trying "s.existsAndVisible('path/to/item')" we get a False if specifying the ID when the item has an objectName defined)
- the full path **isn't needed** *(exemple: "mainWindow/button00" <=> "mainWindow/rowLayout/button00")*

## About existsAndVisible and mouseClick
- Right now mouseClick **can't trigger WBMenu** but **can WBMenuItem** 
  EDIT: spix can trigger WBMenuBar, pb is that it clicks (by default) at the (x + width/2;y + height/2) point, yet WBMenuBar width is the window width so in most of the cases (normal window size, not extremely small) it clicks in empty spaces
- mouseClick **can't click** on a WBMenuItem from a **non-deployed WBMenu**
- mouseClick clicks only if **visible AND enable** are **true**
- existsAndVisible is as its name says, return True if exists and visible, **don't mind** the **enable** property

# TODO

- the 2nd parameter of mouseClickWithButton is an int following the https://doc.qt.io/qt-5/qt.html#MouseButton-enum binary rule, meanings:
   - 0: None
   - 1: left
   - 2: right
   - 4: middle
   - SO 3 triggers left AND right
 - The 3rd parameter of enterKey is keyModifier and obey to the following binary rule:
   - 0: None
   - 1: Shift key
   - 2: Control key
   - 4: Alt key
   - 8: Meta key (Windows key ?)
   - SO combination like 3 or 5 (011 and 101) are allowed (like mouseClickWithButton)

