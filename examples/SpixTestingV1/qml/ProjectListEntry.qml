import QtQuick 2.13
import QtQuick.Controls 2.13

// NF Frameworks
import "qrc:/js/canvas.js" as JsCanvas
import "qrc:/widgets/" as QmlWidgets

Item {
    id: root
    height: 40

    property bool editable : false

    property alias text: readOnlyText.text
    property alias textColor: readOnlyText.color
    property alias verticalAlignment: readOnlyText.verticalAlignment
    property alias horizontalAlignment: readOnlyText.horizontalAlignment    

    signal textEdited(var text)

    function startEdit() {
        readOnlyText.visible = false
        inputTextField.visible = true
        inputTextField.focus = true
        inputTextField.selectAll()
    }


    Text {
        id: readOnlyText
        anchors.fill: parent
        visible: true

        color: constants.menuFontColor
        font.family: constants.menuFontFamily
        font.pixelSize: 11
        rightPadding: 3
        leftPadding: 3
        topPadding: 3

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap

        onTextChanged: {
            // no binding between readOnlyText and inputTextField
            // otherwise update will be done while user write data
            inputTextField.text = root.text
        }
    }

    QmlWidgets.WBTextField {
        id: inputTextField
        visible: false

        rightPadding: 3
        leftPadding: 3
        topPadding: 3

        color: root.textColor
        font.family: readOnlyText.font.family
        font.pixelSize: readOnlyText.font.pixelSize
        selectedTextColor: constants.inputFieldInputAreaFontColor
        selectByMouse: true
        mouseSelectionMode: TextInput.SelectCharacters
        selectionColor: constants.inputFieldInputAreaSelectionColor
        hoverEnabled: true

        implicitWidth: width
        anchors.fill: parent

        onEditingFinished: {
            if (inputTextField.text !== root.text) {
                root.textEdited(inputTextField.text)
                inputTextField.visible = false
                readOnlyText.visible = true
            }
        }
    }
}
