import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    id: root
    property alias text: control.text
    //property alias errorTooltip: errorTooltip.text
    property bool buttonEnabled: true
    signal clicked()

    width: constants.button01Width
    height: constants.button01Height

    Button {
        id: control
        text: qsTr("Button")

        width: constants.button03Width
        height: constants.button03Height

        property alias color: text.color
        property alias horizontalAlignment: text.horizontalAlignment
        property alias verticalAlignment: text.verticalAlignment

        contentItem: Text {
            id: text
            anchors.fill: parent

            text: control.text
            font.family: constants.button03FontFamily
            font.pixelSize: constants.button03FontSize
            color: control.enabled || root.buttonEnabled ? constants.button03FontColor : constants.button03DisabledFontColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        /*WBToolTip {
            id: errorTooltip
            visible: !root.buttonEnabled && parent.hovered
            errorToolTip: true
        }*/

        background: Rectangle {
            anchors.fill: parent
            color: control.enabled && root.buttonEnabled ?
                       control.hovered ?
                           constants.button03HoveredBackgroundColor :
                           constants.button03BackgroundColor : constants.button03DisabledBackgroundColor

            border.color: constants.toolTipErrorColor
            border.width: !root.buttonEnabled ? constants.button03BorderWidth : 0.0
            radius: constants.button03Radius
        }

        onClicked: {
            if (root.buttonEnabled) {
                root.clicked()
            }
        }
    }
}
