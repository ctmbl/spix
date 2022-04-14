import QtQuick 2.13
import QtQuick.Controls 2.13

Rectangle {
    id: root
    property bool error: false
    property bool shared: true
    property alias label: label.text
    property alias labelTextFormat: label.textFormat
    property string text
    property alias unit: unitText.text

    property alias leftButton: leftButton
    property alias leftButtonEnabled: leftButton.enabled
    property alias rightButton: rightButton
    property string rightButtonToolTip
    property bool forceEnableRightButton: false
    property alias fxLabel: fxLabel

    property bool incrementButtonVisible: false
    property string toolTip
    property bool displayLabelInToolTip: true
    property string errorToolTip
    property string readOnlyToolTip
    property bool editable: true
    property bool readOnly
    property alias validator: inputArea.validator
    property alias inputMethodHints: inputArea.inputMethodHints
    property alias maximumLength : inputArea.maximumLength
    property alias textFocus: inputArea.focus
    property alias textActiveFocus: inputArea.activeFocus
    property alias placeholderText: inputArea.placeholderText
    property alias horizontalAlignment: inputArea.horizontalAlignment
    property alias verticalAlignment: inputArea.verticalAlignment
    property bool textSelectable: true
    property alias textClickable: textMouseArea.enabled

    signal plusClicked()
    signal minusClicked()
    signal textEdited()
    signal textClicked()
    signal editingFinished()
    signal enterOrReturnPressed()
    signal leftButtonClicked()
    signal rightButtonClicked()
    signal undo()
    signal redo()

    function selectAll() {
        inputArea.selectAll()
    }

    function forceTextActiveFocus() {
        inputArea.forceActiveFocus()
    }

    width: labelWidth + inputFieldWidth + (buttonsVisible ? constants.inputFieldButtonWidth * 2 : 0)
    height: visible ? constants.inputFieldContentHeight : 0
    property int radius: constants.inputFieldRadius
    color: "transparent"

    property int labelWidth: constants.inputFieldLabelWidth
    property int inputFieldWidth: buttonsVisible ? constants.inputFieldInputAreaWidth : (constants.inputFieldInputAreaWidth + constants.inputFieldButtonWidth * 2)
    property bool buttonsVisible: true

    property bool topRounded: true
    property bool bottomRounded: true

    Text {
        id: label
        y: constants.inputFieldContentY
        width: root.labelWidth
        height: constants.inputFieldLabelHeight
        leftPadding: constants.inputFieldLabelLeftPadding
        rightPadding: constants.inputFieldLabelRightPadding
        font.family: constants.inputFieldLabelFontFamily
        color: root.readOnly ? constants.inputFieldDisabledLabelFontColor : constants.inputFieldLabelFontColor
        font.pixelSize: constants.inputFieldLabelFontSize
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
        }

        // WBToolTip {
        //     id: toolTip
        //     visible: mouseArea.containsMouse && text !== ""
        //     text: (root.displayLabelInToolTip ?
        //               root.label + (root.toolTip !== "" && root.toolTip !== root.label ? ":\n\n" + root.toolTip : "") : root.toolTip) +
        //           ((root.readOnly && root.readOnlyToolTip !== "") ? ("\n\n" + root.readOnlyToolTip) : "")
        // }
    }

    WBRoundedRectangle2 {
        id: leftButtonRect
        x: root.labelWidth
        y: constants.inputFieldContentY
        width: buttonsVisible ? constants.inputFieldButtonWidth : 0
        height: constants.inputFieldButtonHeight
        visible: buttonsVisible
        radius: constants.inputFieldRadius
        topLeftRounded: root.topRounded
        topRightRounded: false
        bottomLeftRounded: root.bottomRounded
        bottomRightRounded: false
        color: leftButton.enabled ?
                   leftButton.hovered || leftButton.checked ?
                       constants.inputFieldButtonHoveredBackgroundColor :
                       constants.inputFieldButtonBackgroundColor : constants.inputFieldButtonDisabledBackgroundColor

        WBIconButton {
            id: leftButton
            anchors.fill: parent
            anchors.margins: 2
            visible: false
            checkable: false
            iconSource: "qrc:/svg/Lists/Restore.svg"
            iconColor: "white"
            enabled: !root.readOnly

            onClicked: {
                focus = true
                root.leftButtonClicked()
            }
        }

        Text {
            id: fxLabel
            anchors.fill: parent
            visible: false
            color: constants.inputFieldButtonFontColor
            font.family: constants.inputFieldButtonFontFamily
            font.pixelSize: constants.inputFieldButtonFontSize
            font.italic: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideNone
            text: "fx"
        }
    }

    Item {
        x: root.labelWidth + leftButtonRect.width
        y: constants.inputFieldContentY
        height: constants.inputFieldContentHeight - 2 * y
        width: root.inputFieldWidth

        Rectangle {
            anchors.fill: parent

            radius: buttonsVisible ? 0 : constants.inputFieldRadius

            color: root.error ? constants.inputFieldInputAreaErrorBackgroundColor :
                   root.readOnly ? constants.inputFieldInputAreaDisabledBackgroundColor :
                       constants.inputFieldInputAreaBackgroundColor
        }

        WBTextField {
            id: inputArea
            width: parent.width - unitText.width - constants.inputFieldButtonAreaWidth
            height: constants.inputFieldInputAreaHeight
            leftPadding: constants.inputFieldInputAreaLeftPadding
            rightPadding: constants.inputFieldInputAreaRightPadding
            font.family: constants.inputFieldInputAreaFontFamily
            color: root.error ? constants.inputFieldInputAreaErrorFontColor :
                                readOnly ? constants.inputFieldInputAreaDisabledFontColor : constants.inputFieldInputAreaFontColor
            placeHolderColor: root.error ?
                                  constants.inputFieldInputAreaErrorFontColor :
                                  constants.inputFieldInputAreaFontColor
            selectedTextColor: constants.inputFieldInputAreaFontColor
            font.pixelSize: constants.inputFieldInputAreaFontSize
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            selectByMouse: root.textSelectable
            mouseSelectionMode: TextInput.SelectCharacters
            selectionColor: constants.inputFieldInputAreaSelectionColor
            hoverEnabled: true
            text: root.shared ? root.text : ""
            placeholderText: !root.shared && !activeFocus ? qsTr("(multiples values)") : ""
            maximumLength: 40
            readOnly: root.readOnly || !root.editable

            // WBToolTip {
            //     id: errorTooltip
            //     visible: inputArea.hovered && root.error
            //     errorToolTip: true
            //     text: root.errorToolTip
            // }

            // // display text as tooltip if content exceeds text field size
            // WBToolTip {
            //     id: largeTextTooltip
            //     text: root.text
            //     visible: inputArea.contentWidth > inputArea.width &&
            //              inputArea.hovered &&
            //              text !== "" &&
            //              !root.error
            // }

            // // display regular tooltip otherwise
            // WBToolTip {
            //     text: toolTip.text
            //     visible: inputArea.hovered &&
            //              !errorTooltip.visible &&
            //              !largeTextTooltip.visible &&
            //              text !== ""
            //}

            MouseArea {
                id: textMouseArea
                anchors.fill: parent
                enabled: false

                onClicked: root.textClicked()
            }

            onTextEdited: {
                root.text = text
                root.textEdited()
            }

            onEditingFinished: {
                root.editingFinished()
            }

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.enterOrReturnPressed()
                }
                else if (event.key === Qt.Key_Z && (event.modifiers & Qt.ControlModifier)) {
                    event.accepted = true
                    root.editingFinished()
                    root.undo()
                }
                else if (event.key === Qt.Key_Y && (event.modifiers & Qt.ControlModifier)) {
                    event.accepted = true
                    root.editingFinished()
                    root.redo()
                }
            }

            onActiveFocusChanged: {
                if (activeFocus) {
                    selectAll()
                }
            }
        }

        Text {
            id: unitText
            x: parent.width - constants.inputFieldButtonAreaWidth - width
            height: constants.inputFieldInputAreaHeight
            font.family: constants.inputFieldInputAreaFontFamily
            color: inputArea.color
            font.pixelSize: constants.inputFieldInputAreaFontSize
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            rightPadding: constants.inputFieldInputAreaRightPadding
        }

        Item {
            x: parent.width - width
            width: constants.inputFieldButtonAreaWidth
            height: constants.inputFieldButtonAreaHeight
            visible: root.incrementButtonVisible

            WBIconButton {
                id: plusButton
                x: constants.inputFieldButtonPlusX
                y: constants.inputFieldButtonPlusY
                width: constants.inputFieldIconButtonWidth
                height: constants.inputFieldIconButtonHeight
                iconColor: hovered ? constants.inputFieldButtonHoveredIconColor : constants.inputFieldButtonIconColor
                iconSource: "qrc:/svg/Lists/Input_Field.svg"
                rotation: 180
                visible: root.incrementButtonVisible
                enabled: !root.readOnly

                onClicked: {
                    focus = true
                    root.plusClicked()
                }
            }

            WBIconButton {
                id: minusButton
                x: constants.inputFieldButtonMinusX
                y: constants.inputFieldButtonMinusY
                width: constants.inputFieldIconButtonWidth
                height: constants.inputFieldIconButtonHeight
                iconColor: hovered ? constants.inputFieldButtonHoveredIconColor : constants.inputFieldButtonIconColor
                iconSource: "qrc:/svg/Lists/Input_Field.svg"
                visible: root.incrementButtonVisible
                enabled: !root.readOnly

                onClicked: {
                    focus = true
                    root.minusClicked()
                }
            }
        }
    }

    WBRoundedRectangle2 {
        x: root.labelWidth + leftButtonRect.width + root.inputFieldWidth
        y: constants.inputFieldContentY

        width: buttonsVisible ? constants.inputFieldButtonWidth : 0
        height: constants.inputFieldButtonHeight
        visible: buttonsVisible
        radius: constants.inputFieldRadius
        topRightRounded: root.topRounded
        topLeftRounded: false
        bottomRightRounded: root.bottomRounded
        bottomLeftRounded: false
        color: rightButton.enabled || forceEnableRightButton ?
                   rightButton.hovered || rightButton.checked ?
                       constants.inputFieldButtonHoveredBackgroundColor :
                       constants.inputFieldButtonBackgroundColor : constants.inputFieldButtonDisabledBackgroundColor

        WBButton {
            id: rightButton
            anchors.fill: parent
            visible: false
            checkable: false
            textColor: checked || hovered ? constants.inputFieldButtonHoveredFontColor : constants.inputFieldButtonFontColor
            font.family: constants.inputFieldButtonFontFamily
            font.pixelSize: constants.inputFieldButtonFontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideNone
            enabled: !root.readOnly || forceEnableRightButton

            onClicked: root.rightButtonClicked()

            // WBToolTip {
            //     text: root.rightButtonToolTip
            //     visible: text !== "" && rightButton.hovered
            // }
        }
    }
}
