import QtQuick 2.13
import QtQuick.Controls 2.13

Item {
    property alias title: text.text

    height: constants.windowHeaderHeight

    WBTopRoundedRectangle {
        anchors.fill: parent
        color: constants.windowHeaderBackgroundColor
        radius: constants.windowHeaderRadius        
    }

    Text {
        id: text
        anchors.fill: parent
        font.family: constants.windowHeaderFontFamily
        font.pixelSize: constants.windowHeaderFontSize
        color: constants.windowHeaderFontColor
        topPadding: constants.windowHeaderTopPadding
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
