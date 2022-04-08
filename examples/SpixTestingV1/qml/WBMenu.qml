import QtQuick 2.13
import QtQuick.Controls 2.13

Menu {
    id: root

    z: constants.popUpZValue

    width: {
        var result = 0
        var padding = 0
        for (var i = 0; i < count; ++i) {
            var item = itemAt(i)
            result = Math.max(item.contentItem.implicitWidth, result)
            padding = Math.max(item.padding, padding)
        }
        return result + padding * 2 + 20;
    }

    delegate: WBMenuItem {}

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 0
        color: constants.menuBackgroundColor
        border.color: root.palette.dark
    }
}
