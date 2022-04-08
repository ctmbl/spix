import QtQuick 2.13
import QtQuick.Controls 2.13


Item {
    id: root
    property var model
    property var actions

    property alias text: mainButton.text
    property alias iconSource: mainButton.iconSource

    function onItemClicked(label) {
        actions[label]()
    }

    function getItem(label) {
      for(var i = 0; i < model.count; ++i) {
          if (model.get(i).label === label) {
              return model.get(i)
          }
      }
      return null
    }

    height: constants.toolBarHeight
    width: mainButton.width

    WBToolBarButton {
        id: mainButton
        anchors.fill: parent        

        onClicked: {
            menu.open = !menu.open
        }

        onHoveredChanged: checkAutoClose()
    }

    function checkAutoClose() {
        if (menu.open && !mainButton.hovered && !menu.hovered) {
            autoCloseTimer.restart()
        }
        else {
            autoCloseTimer.stop()
        }
    }

    Timer {
        id: autoCloseTimer
        interval: 250
        onTriggered: menu.open = false
    }

    WBToolBarMenuContent {
        id: menu
        y: root.height + 1
        width: root.width

        model: root.model

        onHoveredChanged: checkAutoClose()

        onOpenChanged: {
            if (!open) {
                autoCloseTimer.stop()
            }
        }

        onItemClicked: root.onItemClicked(label)
    }
}
