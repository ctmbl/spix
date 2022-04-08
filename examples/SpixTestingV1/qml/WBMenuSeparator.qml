import QtQuick 2.13
import QtQuick.Controls 2.13

MenuSeparator {
    implicitWidth: parent.width
    implicitHeight: visible ? constants.menuHeight : 0

    contentItem: Rectangle {
        id: rect
        anchors.fill: parent
        color: constants.menuBackgroundColor

        Rectangle {
            width: parent.width
            height: 1
            anchors.centerIn: rect
            color: constants.menuEntryLineColor
        }
    }
}
