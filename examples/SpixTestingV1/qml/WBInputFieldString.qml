import QtQuick 2.13
import QtQuick.Controls 2.13

WBInputFieldBase {
    id: root

    incrementButtonVisible: false

    signal valueUpdated(var newValue)
    signal valueAndOriginChanged(var newValue)
    signal originChanged()

    property string value

    property string previousValue
    property bool updated
    property bool edited: false

    function resetPreviousValue() {
        previousValue = value
        updated = false
    }

    onValueChanged: {
        if (text !== value) {
            resetPreviousValue()
            text = value
        }
    }

    onTextEdited: {
        edited = true

        if (value !== text) {
            valueUpdated(text)

            updated = (previousValue !== text)
        }
    }

    onEditingFinished: {
        if (updated) {
            var newValue = text
            valueAndOriginChanged(newValue)
            // must be done once the model has taken into account new value (possibly refused it)
            resetPreviousValue()
        }
        else if (edited) {
            edited = false
            originChanged()
        }
    }

    onEnterOrReturnPressed: {
        if (updated) {
            var newValue = text
            valueAndOriginChanged(newValue)
            // must be done once the model has taken into account new value (possibly refused it)
            resetPreviousValue()
        }
        else {
            edited = false
            originChanged()
        }
    }
}
