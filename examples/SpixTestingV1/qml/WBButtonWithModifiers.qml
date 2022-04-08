import QtQuick 2.6
import QtQuick.Controls 2.1

Rectangle {
    id: root

    property alias text: text
    property alias horizontalAlignment: text.horizontalAlignment
    property alias verticalAlignment: text.verticalAlignment
    property alias hovered: mouseArea.containsMouse
    property bool checkable: false
    property bool checked: false

    width: constants.button01Width
    height: constants.button01Height

    signal clicked(var mouse)
    signal released(var mouse)

    Text {
        id: text
        anchors.fill: parent

        font.family: constants.button01FontFamily
        font.pixelSize: constants.button01FontSize
        color: root.hovered ? constants.button01HoveredFontColor :
                                 root.enabled ? constants.button01FontColor :
                                                   constants.button01DisabledFontColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true

        onClicked: {
            if (root.checkable && (mouse.buttons & Qt.LeftButton)) {
                root.checked = ! root.checked
            }

            root.clicked(mouse)
        }
        onReleased: root.released(mouse)
    }
}
