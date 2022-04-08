import QtQuick 2.13
import QtQuick.Controls 2.13


MenuBar {
    id: root
    contentHeight : constants.menuHeight
    property string title

    delegate: MenuBarItem {
        id: menuBarItem

        implicitHeight: constants.menuHeight

        contentItem: Text {
            text: menuBarItem.text
            font.family: constants.menuFontFamily
            font.pixelSize: constants.menuFontSize
            color: menuBarItem.enabled ? (menuBarItem.highlighted ? constants.menuHoveredFontColor : constants.menuFontColor) : constants.menuDisabledFontColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            topPadding: constants.menuTopPadding
        }

        background: Rectangle {
            implicitHeight: constants.menuHeight
            color: menuBarItem.enabled ? (menuBarItem.highlighted ? constants.menuHoveredBackgroundColor : constants.menuBackgroundColor) : constants.menuDisabledBackgroundColor
        }
    }

    background: Rectangle {
        implicitHeight: constants.menuHeight
        color: constants.menuBackgroundColor

        Text {
            anchors.centerIn: parent
            height: constants.menuHeight
            text: root.title
            font.family: constants.menuFontFamily
            font.pixelSize: constants.menuFontSize
            color: constants.menuFontColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            topPadding: constants.menuTopPadding
        }
    }
}
