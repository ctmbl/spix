import QtQuick 2.13
import QtQuick.Controls 2.13

// Nf Frameworks
import Workbench 1.0

MouseArea {
    property variant target
    property int resizeMode: ResizeMode.Right

    cursorShape: {
        if (enabled) {
            switch (resizeMode) {

            case ResizeMode.Right:
            case ResizeMode.Left:
                return Qt.SizeHorCursor

            case ResizeMode.Top:
            case ResizeMode.Bottom:
                return Qt.SizeVerCursor

            case ResizeMode.TopRight:
            case ResizeMode.BottomLeft:
                return Qt.SizeBDiagCursor

            case ResizeMode.TopLeft:
            case ResizeMode.BottomRight:
                return Qt.SizeFDiagCursor
            }
        }
        return Qt.ArrowCursor
    }

    property int startWindowX: 0
    property int startWindowY: 0
    property int startWindowWidth: 0
    property int startWindowHeight: 0

    property point startMousePos: Qt.point(0, 0)

    onPressed: {
        if (pressed) {
            startMousePos = mapToGlobal(mouse.x, mouse.y)
            startWindowX = target.x
            startWindowY = target.y
            startWindowWidth = target.width
            startWindowHeight = target.height
        }
    }

    onPositionChanged: {
        if (pressed) {
            var mousePos = mapToGlobal(mouseX, mouseY)

            if (resizeMode === ResizeMode.Right || resizeMode === ResizeMode.BottomRight || resizeMode === ResizeMode.TopRight) {
                var newWidth = startWindowWidth + (mousePos.x - startMousePos.x)
                if (maximumWidth > 0) {
                    target.width = Math.min(Math.max(newWidth, minimumWidth), maximumWidth)
                }
                else {                    
                    target.width = Math.min(Math.max(newWidth, minimumWidth), applicationWindow.availableWidth - target.x)
                }
            }

            if (resizeMode === ResizeMode.Bottom || resizeMode === ResizeMode.BottomRight || resizeMode === ResizeMode.BottomLeft) {
                var newHeight = startWindowHeight + (mousePos.y - startMousePos.y)
                if (maximumHeight > 0) {                    
                    target.height = Math.min(Math.max(newHeight, minimumHeight), maximumHeight)
                }
                else {
                    target.height = Math.min(Math.max(newHeight, minimumHeight), applicationWindow.availableHeight - target.y)
                }
            }

            if (resizeMode === ResizeMode.Left || resizeMode === ResizeMode.BottomLeft || resizeMode === ResizeMode.TopLeft) {
                var newX = startWindowX + (mousePos.x - startMousePos.x)
                target.x = Math.min(Math.max(0, newX), target.width - minimumWidth + target.x)
                target.width = startWindowWidth + startWindowX - target.x
            }

            if (resizeMode === ResizeMode.Top || resizeMode === ResizeMode.TopLeft || resizeMode === ResizeMode.TopRight) {
                var newY = startWindowY + (mousePos.y - startMousePos.y)
                target.y = Math.min(Math.max(0, newY), target.height - minimumHeight + target.y)
                target.height = startWindowHeight + startWindowY - target.y
            }
        }
    }
}
