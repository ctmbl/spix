import QtQuick 2.13
import QtQuick.Controls 2.13

// NF Frameworks
import Workbench 1.0

WBMovabelItem {
    id: root

    property Component content

    width: constants.toolBarWidth
    height: constants.toolBarHeight

    opacity:
        movableBehavior.moving ? constants.toolBarMovingOpacity : constants.paletteBackgroundOpacity
    color: constants.paletteBackgroundColor

    onVisibleChanged: {
        if (visible) {
            WBWindowManager.setFocusedItem(root)
        }
    }

    WBMovableBehavior {
        id: movableBehavior
        target: root
        anchors.fill: parent

        onMovingChanged: {
            root.moving = moving
        }
    }

    Loader {
        x: 1
        width: constants.toolBarWidth - x
        height: constants.toolBarHeight

        sourceComponent: root.content
    }
}
