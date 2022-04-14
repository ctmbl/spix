import QtQuick 2.13
import QtQuick.Controls 2.13

ListView {
    id: root

    clip: true
    interactive: false
    highlightFollowsCurrentItem : false
    opacity: 0.8

    width: constants.popupMenuWidth
    z: constants.popUpZValue

    property bool controlState
    property var actions: []

    property int verticalAlignement: Text.AlignVCenter
    property int horizontalAlignement: Text.AlignLeft

    property bool open: false
    height: open ? maximumHeight : 0

    readonly property int maximumHeight: constants.popupMenuItemHeight * count
    property bool hovered: false


    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    onControlStateChanged: root.checkAutoClose()
    onHoveredChanged: root.checkAutoClose()

    function checkAutoClose() {
        if (root.open && !controlState && !root.hovered) {
            autoCloseTimer.restart()
        }
        else {
            autoCloseTimer.stop()
        }
    }

    Timer {
        id: autoCloseTimer
        interval: 250
        onTriggered: root.open = false
    }

    delegate: Button {
        id: button

        width: root.width
        height: constants.popupMenuItemHeight

        text: model.title

        onClicked: {
            open = false
            root.currentIndex = index
            root.actions[label]()
        }

        onHoveredChanged: {
            root.hovered = hovered
        }

        contentItem: Item {}

        background: Rectangle {
            id: background
            anchors.fill: parent

            color: button.hovered || button.pressed ?
                       constants.popupMenuHoveredBackgroundColor : constants.popupMenuBackgroundColor

            // top line
            Rectangle {
                width: parent.width
                height: 1
                color: constants.popupMenuSeparationColor
            }

            Text {
                anchors.fill: parent
                text: button.text
                font.family: constants.popupMenuFontFamily
                font.pixelSize: constants.popupMenuFontSize
                color: button.hovered || button.pressed ?
                           constants.popupMenuHoveredFontColor : constants.popupMenuFontColor
                verticalAlignment: root.verticalAlignement
                horizontalAlignment: root.horizontalAlignement
                topPadding: constants.toolsMenuTopPadding
                leftPadding: constants.toolsMenuLeftPadding
            }
        }
    }
}
