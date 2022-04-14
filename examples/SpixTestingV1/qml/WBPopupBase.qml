import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.3 as T

T.Popup {
    id: control

    property real modalOpacityShadow: 0.5

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentWidth > 0 ? contentWidth + leftPadding + rightPadding : 0)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentHeight > 0 ? contentHeight + topPadding + bottomPadding : 0)

    contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
    contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)

    background: Rectangle {
        color: control.palette.window
        border.color: control.palette.dark
    }

    T.Overlay.modal: Rectangle {
        color: Color.transparent(control.palette.shadow, control.modalOpacityShadow)
    }

    T.Overlay.modeless: Rectangle {
        color: Color.transparent(control.palette.shadow, 0.12)
    }
}
