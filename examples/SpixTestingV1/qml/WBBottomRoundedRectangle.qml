import QtQuick 2.13

Rectangle {
    id: root

    Rectangle {
        width: parent.width
        color: parent.color
        height: parent.height - parent.radius
    }
}
