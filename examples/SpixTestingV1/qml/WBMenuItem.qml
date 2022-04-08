import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.3

MenuItem {
    id: root

    implicitHeight: visible ? constants.menuHeight : 0
    font.family: constants.menuFontFamily
    font.pixelSize: constants.menuFontSize

    contentItem: IconLabel {
        readonly property real arrowPadding: root.subMenu && root.arrow ? root.arrow.width + root.spacing : 0
        readonly property real indicatorPadding: root.checkable && root.indicator ? root.indicator.width + root.spacing : 0
        leftPadding: !root.mirrored ? indicatorPadding : arrowPadding
        rightPadding: root.mirrored ? indicatorPadding : arrowPadding

        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display
        alignment: Qt.AlignLeft

        icon: root.icon
        text: root.text
        font: root.font
        color: root.enabled ? (root.highlighted ? constants.menuHoveredFontColor : constants.menuFontColor) : constants.menuDisabledFontColor
    }

    background: Rectangle {
        implicitHeight: constants.menuHeight
        implicitWidth: menu.width
        color: root.highlighted ? constants.menuHoveredBackgroundColor : constants.menuBackgroundColor
    }

    arrow: ColorImage {
        x: root.mirrored ? root.leftPadding : root.width - width - root.rightPadding
        y: root.topPadding + (root.availableHeight - height) / 2

        visible: root.subMenu
        mirror: root.mirrored
        source: root.subMenu ? "qrc:/qt-project.org/imports/QtQuick/Controls.2/images/arrow-indicator.png" : ""
        color: root.enabled ? (root.highlighted ? constants.menuHoveredFontColor : constants.menuFontColor) : constants.menuDisabledFontColor
    }
}

