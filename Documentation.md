# Spix Documentation

# TODO
- if an object has an object name, spix doesn't check its id (it's explicit by trying "s.existsAndVisible('path/to/item')" we get a False if specifying the ID when the item has an objectName defined)
- the full path isn't needed (exemple: "mainWindow/button00" <=> "mainWindow/rowLayout/button00" )
- the 2nd parameter of mouseClickWithButton is an int following the https://doc.qt.io/qt-5/qt.html#MouseButton-enum doc, meanings:
   - 0: None
   - 1: left
   - 2: right
   - 4: middle
   - SO 3: left AND right
 - The 3rd parameter of enterKey is keyModifier and obey to the following binary rule:
   - 0: None
   - 1: Shift key
   - 2: Control key
   - 4: Alt key
   - 8: Meta key (Windows key ?)
   - SO combination like 3 or 5 (011 and 101) are allowed (like mouseClickWithButton)