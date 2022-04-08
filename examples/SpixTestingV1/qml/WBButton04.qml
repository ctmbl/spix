import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    id: root
    x: constants.inputFieldLeftButtonX
    width: constants.inputFieldButtonWidth * 2 + constants.inputFieldInputAreaWidth
    height: constants.inputFieldButtonHeight
    property bool error: false
    property bool buttonEnabled: true

    contentItem: Text {
        id: text
        anchors.fill: parent

        text: root.text
        font.family: constants.inputFieldInputAreaFontFamily
        font.pixelSize: constants.inputFieldInputAreaFontSize
        color: root.error ? constants.inputFieldInputAreaErrorFontColor : constants.inputFieldInputAreaFontColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        anchors.fill: parent
        radius: constants.inputFieldRadius
        color: root.error ?
                   constants.inputFieldButtonErrorBackgroundColor :
                   root.enabled && buttonEnabled ?
                       root.hovered || root.checked ?
                           constants.inputFieldButtonHoveredBackgroundColor :
                           constants.inputFieldButtonBackgroundColor : constants.inputFieldButtonDisabledBackgroundColor
    }
}
