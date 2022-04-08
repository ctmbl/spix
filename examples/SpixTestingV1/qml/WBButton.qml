import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    id: root
    text: ""

    property alias textColor: text.color
    property alias textLeftPadding: text.leftPadding
    property alias textRightPadding: text.rightPadding
    property alias textTopPadding: text.topPadding
    property alias textBottomPadding: text.bottomPadding
    property alias elide: text.elide
    property int borderWidth: 0
    property color borderColor: "transparent"
    property color backgroundColor: "transparent"
    property alias horizontalAlignment: text.horizontalAlignment
    property alias verticalAlignment: text.verticalAlignment

    activeFocusOnTab: false

    bottomPadding: 0
    topPadding: 0
    rightPadding: 0
    leftPadding: 0

    contentItem: Text {
        id: text
        color: "white"
        text: root.text
        font: root.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        wrapMode: Text.Wrap
    }

    background: Rectangle {
        id: background
        anchors.fill: parent

        color: root.backgroundColor
        border.width: root.borderWidth
        border.color: root.borderColor
    }
}
