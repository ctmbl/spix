import QtQuick 2.13
import QtQuick.Controls 2.13

AbstractButton {
    id: root

    property string toolTip: ""
    font.family: constants.normalMenuItemFontFamily
    font.pixelSize: constants.normalMenuItemFontSize

    width: content.width
    height: constants.toolBarHeight

    property string iconSource
    property bool displayErrorIndicator: false
    property bool error: false

    contentItem: Row {
        id: content
        width: errorIndicator.width + image.width + text.width + 10
        height: parent.height

        WBErrorIndicator {
            id: errorIndicator
            error: root.error
            width: visible ? constants.inputFieldHeaderErrorIndicatorWidth : 0
            y: 2
            height: parent.height - y * 2
            visible: root.displayErrorIndicator
        }

        Item {
            id: image
            width: parent.height
            height: parent.height

            WBImage {
                anchors.centerIn: parent
                source: root.iconSource
                color: root.enabled ? root.pressed || root.hovered || root.checked ? constants.highlightIconColor : constants.normalIconColor : constants.disabledIconColor
                width: constants.toolBarIconWidth
                height: constants.toolBarIconHeight
                sourceSize.width: width
                sourceSize.height: height
            }
        }

        Text {
            id: text
            text: root.text
            height: parent.height
            font.family: root.hovered || root.pressed ? constants.highlightFontFamily : constants.toolsMenuFontFamily
            font.pixelSize: root.hovered || root.pressed ? constants.highlightFontSize : constants.toolsMenuFontSize
            color: root.enabled ? root.hovered || root.pressed || root.checked ? constants.highlightFontColor : constants.toolsMenuFontColor : constants.toolsMenuDisabledFontColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: constants.normalMenuItemLeftPadding
        }
    }

    background: Rectangle {
        id: background
        anchors.margins: 0
        anchors.fill: parent

        color: "transparent"

        WBToolTip {
            parent: background
            visible: root.toolTip !== "" && root.hovered
            text: root.toolTip
        }
    }
}
