import QtQuick 2.13
import QtQuick.Controls 2.13

Rectangle {
    id: root
    property bool hovered: mouseArea.containsMouse
    property bool checkable: false
    property bool checked: false
    property bool pressed: false
    property alias rotation: image.rotation
    property alias mirror: image.mirror
    property alias iconSource: image.source
    property alias iconColor: image.color
    //property alias toolTip: toolTip.text
    property alias padding: image.padding
    property bool toolTipEnabled: true
    property int margins: 0

    signal clicked()
    color: "transparent"

    WBImage {
        id: image
        anchors.fill: root
        anchors.margins: root.margins
        source: root.iconSource
        sourceSize.width: 64
        sourceSize.height: 64

        color: enabled ?
                   hovered || pressed || checked ?
                       constants.highlightIconColor : constants.normalIconColor : constants.disabledIconColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onPressed: {
            root.forceActiveFocus()
            root.pressed = true
        }

        onReleased: {
            root.pressed = false
        }

        onClicked: {
            if (root.checkable) {
                root.checked = !root.checked
            }
            root.clicked()
        }
    }

    // WBToolTip {
    //     id: toolTip
    //     parent: root
    //     visible: root.toolTipEnabled && text !== "" && mouseArea.containsMouse
    // }
}
