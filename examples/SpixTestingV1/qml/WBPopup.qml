import QtQuick 2.13
import QtQuick.Controls 2.13

// NF frameworks
import Workbench 1.0
//import "qrc:/js/utils.js" as JsUtils

WBPopupBase {
    id: root

    width: 300
    height: background.height

    visible: false
    closePolicy: "NoAutoClose"

    property string title: ""
    property int minimumWidth: 100
    property int minimumHeight: 200

    property bool movable: true
    property bool resizable: true
    property bool moving: false

    property bool allowRightResize: true
    property bool allowLeftResize: true
    property bool allowBottomResize: true
    property bool allowTopResize: true

    property Component header

    property int contentRadius: 0
    property color contentBackgroundColor: "#FFFFFF"
    property real contentBackgroundOpacity: 1.0
    property real contentOpacity: 1.0

    property Component content

    signal keysPressed(var event)

    background: Item {
        id: backgroundItem
        height: headerLoader.height + contentLoader.height

        onVisibleChanged: {
            if (visible) {
                backgroundItem.forceActiveFocus()
            }
        }

        Keys.onPressed: {
            root.keysPressed(event)
        }

        WBBottomRoundedRectangle {
            id: background
            y: headerLoader.height
            width: root.width
            height: contentLoader.height

            radius: root.contentRadius
            color: "grey"//JsUtils.createColor(root.contentBackgroundColor, root.contentBackgroundOpacity)
            opacity: root.contentOpacity

            Loader {
                id: contentLoader
                sourceComponent: root.content
            }
        }

        Loader {
            id: headerLoader

            width: root.width
            sourceComponent: root.header

            // Manage window movement
            WBMovableBehavior {
                anchors.fill: parent
                enabled: root.movable
                target: root
                onMovingChanged: root.moving = moving
            }
        }

        // Manage window resize
        WBResizableBehavior {
            id: resizableBehavior
            anchors.fill: parent
            enabled: root.resizable
            allowRightResize: root.allowRightResize
            allowLeftResize: root.allowLeftResize
            allowBottomResize: root.allowBottomResize
            allowTopResize: root.allowTopResize
            minimumWidth: root.minimumWidth
            minimumHeight: root.minimumHeight
            target: root
        }
    }
}

