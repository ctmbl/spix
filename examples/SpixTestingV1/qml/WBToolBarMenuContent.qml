import QtQuick 2.13
import QtQuick.Controls 2.13


// NF Frameworks
import Workbench 1.0
import "qrc:/js/canvas.js" as JsCanvas

ListView {
    id: listView

    clip: true
    interactive: false
    highlightFollowsCurrentItem : false

    property bool open: false
    height: open ? contentHeight : 0

    property bool hovered: false

    signal itemClicked(var label)

    Behavior on height {
        NumberAnimation {
            id: openAnimation
            duration: 200
        }
    }

    delegate: Button {
        id: button

        width: listView.width
        height: model.available ? constants.toolBarHeight : 0

        text: model.title

        checked: index === 0 // check first item
        checkable: true
        autoExclusive: true

        visible: model.available
        enabled: !model.disabled

        onClicked: {
            if (!openAnimation.running && model.available) {
                open = false
                listView.currentIndex = index
                listView.itemClicked(label)
            }
        }

        onHoveredChanged: {
            listView.hovered = hovered
        }

        contentItem: Item {}

        background: Rectangle {
            id: background
            anchors.fill: parent

            color: !model.disabled ?
                       button.hovered || button.pressed ?
                           constants.highlightMenuItemBackgroundColor : constants.normalMenuItemBackgroundColor : constants.disabledMenuItemBackgroundColor

            Item {
                id: icon
                width: model.iconSource ? parent.height : 0
                height: model.iconSource ? parent.height : 0

                WBImage {
                    anchors.centerIn: parent
                    source: model.iconSource ? model.iconSource : ""
                    width: constants.toolBarIconWidth
                    height: constants.toolBarIconHeight
                    sourceSize.width: width
                    sourceSize.height: height

                    color: !model.disabled ?
                               button.hovered || button.pressed ? constants.highlightMenuItemFontColor :
                                                                  constants.normalMenuItemFontColor : constants.disabledMenuItemFontColor
                }
            }

            Text {
                x: icon.width
                height: parent.height
                text: button.text
                font.family: constants.normalMenuItemFontFamily
                font.pixelSize: constants.normalMenuItemFontSize
                color: !model.disabled ?
                           button.hovered || button.pressed ? constants.highlightMenuItemFontColor :
                                                              constants.normalMenuItemFontColor : constants.disabledMenuItemFontColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                topPadding: constants.toolsMenuTopPadding
                leftPadding: constants.toolsMenuLeftPadding
            }

            Rectangle {
                width: parent.width
                height: 1
                opacity: 0.2
                anchors.bottom: parent.bottom
                color: "white"
            }
        }
    }
}
