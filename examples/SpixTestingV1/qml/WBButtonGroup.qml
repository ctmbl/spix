import QtQuick 2.13
import QtQuick.Controls 2.13

ButtonGroup {

    function selectAll() {
        for (var button in buttons) {
            button.checked = true
        }
    }

    function unselectAll() {
        for (var button in buttons) {
            button.checked = false
        }
    }
}
