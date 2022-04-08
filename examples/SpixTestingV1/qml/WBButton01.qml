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

        width: constants.button01Width
        height: constants.button01Height

        property alias color: text.color
        property alias horizontalAlignment: text.horizontalAlignment
        property alias verticalAlignment: text.verticalAlignment

        contentItem: Text {
            id: text
            text: control.text
            font.family: constants.button01FontFamily
            font.pixelSize: constants.button01FontSize
            color: control.hovered ? constants.button01HoveredFontColor :
                                     control.enabled || root.buttonEnabled ? constants.button01FontColor :
                                                       constants.button01DisabledFontColor
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
            color: control.enabled && root.buttonEnabled ?
                           control.hovered ?
                               constants.button01HoveredBackgroundColor :
                               constants.button01BackgroundColor : constants.button01DisabledBackgroundColor

            border.color: !root.buttonEnabled ? control.enabled || root.buttonEnabled ? constants.toolTipErrorColor : constants.button01BorderColor : constants.button01DisabledBorderColor
            border.width: constants.button01BorderWidth
            radius: constants.button01Radius
        }

        onClicked: {
            if (root.buttonEnabled) {
                root.clicked()
            }
        }
    }
}
