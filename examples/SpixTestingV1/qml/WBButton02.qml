import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    id: root
    text: ""

    font.pixelSize: constants.button02FontSize
    font.family: constants.button02FontFamily

    width: constants.button02Width
    height: constants.button02Height

    bottomPadding: 0
    topPadding: 0
    rightPadding: 3
    leftPadding: 0

    contentItem: Text {
        id: text
        color: root.enabled ? constants.button02FontColor : constants.button02DisabledFontColor
        text: root.text
        font: root.font
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: root.hovered ? constants.button02HoveredBackgroundColor : constants.button02BackgroundColor

        Rectangle {
            width: parent.width
            height: 1
            color: root.enabled ? constants.button02LineColor : constants.button02DisabledLineColor
            anchors.bottom: parent.bottom
        }
    }
}
