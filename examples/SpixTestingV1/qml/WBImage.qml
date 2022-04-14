import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.0

Item {
    id: root

    property alias source: image.source
    property color color: "transparent"
    property int padding: 0
    property alias antialiasing: image.antialiasing
    property alias mipmap: image.mipmap
    property alias smooth: image.smooth
    property alias fillMode: image.fillMode
    property alias horizontalAlignment: image.horizontalAlignment
    property alias verticalAlignment: image.verticalAlignment
    property alias sourceSize: image.sourceSize
    property alias backgroundColor: background.color
    property alias rotation: image.rotation
    property alias mirror: image.mirror

    Rectangle {
        id: background
        anchors.centerIn: parent
        width: image.paintedWidth
        height: image.paintedHeight
        color: "transparent"
    }

    Image {
        id: image
        anchors.fill: parent
        anchors.margins: root.padding
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true
        antialiasing: false
        asynchronous: true

        layer.enabled: root.color !== "transparent"
        layer.effect: ColorOverlay {
            color: root.color
        }
    }
}
