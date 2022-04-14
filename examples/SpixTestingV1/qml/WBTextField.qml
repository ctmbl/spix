import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.3 as T

T.TextField {
    id: root

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            placeholderText ? placeholder.implicitWidth + leftPadding + rightPadding : 0)
                            || contentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    color: constants.textFieldTextColor
    property color placeHolderColor: root.palette.text
    selectionColor: constants.textFieldSelectionColor
    selectedTextColor: constants.textFieldTextColor
    verticalAlignment: TextInput.AlignVCenter
    property color backgroundColor: constants.textFieldBackgroundColor

    cursorDelegate: Rectangle {
        id: cursor
        width: 1
        height: root.contentHeight
        color: root.color
        visible: blink && root.activeFocus

        property bool blink: true

        Timer {
            running: root.activeFocus
            repeat: true
            interval: 500
            onTriggered: cursor.blink = !cursor.blink
        }
    }

    PlaceholderText {
        id: placeholder
        x: root.leftPadding
        y: root.topPadding
        width: root.width - (root.leftPadding + root.rightPadding)
        height: root.height - (root.topPadding + root.bottomPadding)

        text: root.placeholderText
        font.family: root.font.family
        font.italic: true
        font.pixelSize: root.font.pixelSize
        opacity: 0.8
        color: root.placeHolderColor
        verticalAlignment: root.verticalAlignment
        visible: !root.length && !root.preeditText && (!root.activeFocus || root.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }

    background: Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
    }
}
