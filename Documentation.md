# Spix Documentation

## Spix paths

- if an object **has an object name**, spix **doesn't check its ID** (it's explicit by trying "s.existsAndVisible('path/to/item')" we get a False if specifying the ID when the item has an objectName defined)
- the full path **isn't needed** *(exemple: "mainWindow/button00" <=> "mainWindow/rowLayout/button00")*
- Some items like **Menu Item from a Menu in a Menu Bar**, even the QML Menu declaration itself, aren't visible in the path tree saw by Spix, because of the delegate they are instantiated when the Menu is clicked, the same remark applied at PopUp

## About existsAndVisible and mouseClick
  EDIT: in the delegate property of WBMenuBar, objectName must be specified relatively to WBMenu declared in main.qml to differentiate them
- mouseClick **can't click** on a WBMenuItem from a **non-deployed WBMenu**
- mouseClick clicks anyway no matter the enabled and visible properties, but QML won't take in account the click on a disabled or invisible item 
- existsAndVisible is as its name says, return True if exists and visible, **don't mind** the **enable** property
- when clicking on a enabled(and instantiated) but invisible object the bounding box is found so Spix clicks where it thinks the invisible button is, therefore sometimes another button is triggered leading to unexpected behavior

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

 - to drag: s.mouseBeginDrag("path/to/header/of/dragged/item") then s.mouseEndDrag("path/to/item/near/position/destination")
 - it's possible to use the WBResizableBehavior Widget and drag and drop to resize popup windows
 - resize using drag and drop respect resizing rules set in qml
 - we can overwrite these rules by changing width OR the resizable property with setStringProperty
 - setStringProperty can also completely modify the widget behavior, especially in the case of Template widget when a sigle widget is used in several different cases by setting a parameter true or false, take care these kind of actions aren't possible for the user so it doesn't present a vulnerability, setStringProperty must be used carefully because it can create bugs that don't really exist
 - 