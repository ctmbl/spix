import QtQuick 2.13
import QtQuick.Controls 2.13

// NF frameworks
import Workbench 1.0

WBPopup {
    id: root

    property string text
    property string label
    property string placeholderText

    signal accepted()
    signal rejected()

    modalOpacityShadow: 0.3

    property int buttons: Buttons.Both

    x: applicationWindow.availableWidth / 2 - width / 2
    y: applicationWindow.availableHeight / 2 - height / 2

    width: constants.messageWindowWidth

    modal: true
    movable: false
    resizable: false

    header: WBWindowHeader {
        title: root.title
    }

    contentRadius: constants.messageWindowContentRadius
    contentBackgroundColor: constants.messageWindowContentBackgroundColor
    contentBackgroundOpacity: constants.messageWindowContentOpacity

    content: Item {
        clip: true

        width: root.width
        height: constants.messageWindowHeight

        WBInputFieldString {
            id: textField
            y: constants.messageWindowTextFieldY
            buttonsVisible: false

            label: root.label

            onTextChanged: root.text = text
            maximumLength: 256

            // Get focus when window open
            Connections {
                target: root

                function onVisibleChanged() {
                    if (visible) {
                        textField.text = root.text
                        textField.forceTextActiveFocus()
                    }
                }

                function onKeysPressed(event) {
                    if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                        root.accepted()
                        event.accepted = true
                    }

                    if (event.key === Qt.Key_Escape) {
                        root.rejected()
                        event.accepted = true
                    }
                }
            }
        }

        WBButton01 {
            id: acceptButton
            visible: root.buttons === Buttons.Both || root.buttons === Buttons.Accept
            x: acceptButton.visible && cancelButton.visible ? constants.messageWindowLeftButtonX : constants.messageWindowCenterButtonX
            y: constants.messageWindowButtonY
            width: constants.messageWindowButtonWidth
            height: constants.messageWindowButtonHeight
            text: cancelButton.visible ? qsTr("Accept") : qsTr("Ok")
            enabled: textField.text !== ""

            onClicked: root.accepted()
        }

        WBButton01 {
            id: cancelButton
            visible: root.buttons === Buttons.Both || root.buttons === Buttons.Cancel
            x: acceptButton.visible && cancelButton.visible ? constants.messageWindowRightButtonX : constants.messageWindowCenterButtonX
            y: constants.messageWindowButtonY
            width: constants.messageWindowButtonWidth
            height: constants.messageWindowButtonHeight
            text: qsTr("Cancel")

            onClicked: root.rejected()
        }
    }
}
