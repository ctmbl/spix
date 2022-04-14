import QtQuick 2.13
import QtQuick.Controls 2.13


MouseArea {
    property variant target
    property bool moving: enabled && pressed

    property int startWindowX: 0
    property int startWindowY: 0

    property point startMousePos

    preventStealing: true

    cursorShape: pressed ? Qt.SizeAllCursor : Qt.ArrowCursor

    onPressed: {
        if (pressed) {
            startMousePos = mapToGlobal(mouse.x, mouse.y)
            startWindowX = target.x
            startWindowY = target.y
        }
    }

    onPositionChanged: {
        if (pressed) {
            var mousePos = mapToGlobal(mouseX, mouseY)

            var newX = startWindowX + (mousePos.x - startMousePos.x)
            var newY = startWindowY + (mousePos.y - startMousePos.y)

            target.x = Math.min(Math.max(newX, 0),
                                (target.parent ? target.parent.width : applicationWindow.availableWidth) - target.width)
            target.y = Math.min(Math.max(newY, 0),
                                (target.parent ? target.parent.height : applicationWindow.availableHeight) - target.height)
        }
    }
}

