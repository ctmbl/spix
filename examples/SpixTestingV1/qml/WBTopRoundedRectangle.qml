import QtQuick 2.13

Rectangle {
    id: root

    Rectangle {
        width: parent.width
        color: parent.color
        y: parent.radius
        height: parent.height - y
    }
}
