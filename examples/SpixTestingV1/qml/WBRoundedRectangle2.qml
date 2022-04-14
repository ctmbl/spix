import QtQuick 2.13

Rectangle {
    id: root

    property bool topLeftRounded: true
    property bool topRightRounded: true
    property bool bottomLeftRounded: true
    property bool bottomRightRounded: true

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.radius
        height: parent.radius
        color: parent.color
        visible: !root.topLeftRounded
    }

    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.radius
        height: parent.radius
        color: parent.color
        visible: !root.topRightRounded
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.radius
        height: parent.radius
        color: parent.color
        visible: !root.bottomLeftRounded
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: parent.radius
        height: parent.radius
        color: parent.color
        visible: !root.bottomRightRounded
    }
}
