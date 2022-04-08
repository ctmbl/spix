import QtQuick 2.13
import QtQuick.Controls 2.13

// NF Frameworks
import Nextflow.Studio 1.0
import "qrc:/widgets/" as QmlWidgets
import "qrc:/js/algorithm.js" as JsAlgorithm

Button {
    id: root
    height: constants.computationTableEntryHeight

    checkable: true

    signal pressed(var mouse)
    signal clicked(var mouse)
    signal openSimulationClicked()
    signal deleteRequested()
    signal addTag(var tag)
    signal removeTag(var tag)

    property var addableTags: []
    property var removableTags: []

    function containsTag(simulationId, tag) {
        var tagList = simulationListModel.getSimulationProperty(simulationId, "tagList")
        return JsAlgorithm.find(tagList, tag)
    }

    function updateAvailableTags() {
        addableTags = []
        var allTags = simulationListModel.retrieveAllTags()
        JsAlgorithm.copyIf(allTags, addableTags, function(tag) {
            // copy only if tag is not already applied to whole selection
            for (var i = 0; i < currentSelection.count; ++i) {
                if (!containsTag(currentSelection.get(i).simulationId, tag)) {
                    return true
                }
                return false
            }
        })
        addableTagsChanged()

        removableTags = []
        for (var i = 0; i < currentSelection.count; ++i) {
            var tagList = simulationListModel.getSimulationProperty(currentSelection.get(i).simulationId, "tagList")
            JsAlgorithm.copyIf(tagList, removableTags, function(tag) {
                return !JsAlgorithm.find(removableTags, tag)
            })
        }
        removableTagsChanged()
    }


    function closeMenu() {
        rowMenu.dismiss()
    }

    function updateFocus() {
        parent.forceActiveFocus()
    }

    background: Rectangle {
        id: background
        anchors.fill: parent

        color: detailItem.hovered ?
                   constants.listViewEntryHoveredBackgroundColor :
                   detailItem.checked ?
                       constants.listViewEntryCheckedBackgroundColor : "transparent"
    }

    QmlWidgets.WBContextMenu {
        id: rowMenu

        QmlWidgets.WBContextMenuItem {
            text: "Add new tag..."

            onTriggered: {
                appWindow.createInputWindow("Add new tag", "Tag", "New tag", function(window) {
                    addTag(window.text)
                })
            }
        }

        QmlWidgets.WBContextMenu {
            id: addTagMenu
            title: "Add tag"
            enabled: count > 0

            Instantiator {
                model: addableTags

                delegate: QmlWidgets.WBContextMenuItem {
                    text: modelData

                    indicator: Item {
                        implicitWidth: constants.contextMenuItemHeight
                        implicitHeight: constants.contextMenuItemHeight

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            color: constants.getTagColor(text)
                        }
                    }

                    onTriggered: addTag(modelData)
                }

                onObjectAdded: addTagMenu.insertItem(index, object)
                onObjectRemoved: addTagMenu.removeItem(object)
            }
        }

        QmlWidgets.WBContextMenu {
            id: removeTagMenu
            title: "Remove tag"
            enabled: count > 0

            Instantiator {
                model: removableTags

                delegate: QmlWidgets.WBContextMenuItem {
                    text: modelData

                    indicator: Item {
                        implicitWidth: constants.contextMenuItemHeight
                        implicitHeight: constants.contextMenuItemHeight

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            color: constants.getTagColor(text)
                        }
                    }

                    onTriggered: removeTag(modelData)
                }

                onObjectAdded: removeTagMenu.insertItem(index, object)
                onObjectRemoved: removeTagMenu.removeItem(object)
            }
        }

        QmlWidgets.WBContextMenuSeparator {}

        QmlWidgets.WBContextMenuItem {
            text: "Compare setup"
            enabled: selectionSize() === 2

            onTriggered: {
                projectListWindow.projectListView.compareSelectedSimulations()
            }
        }

        QmlWidgets.WBContextMenuItem {
            text: "Delete"
            enabled: canDeletedSelectedSimulation()

            onTriggered: {
                deleteRequested()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        propagateComposedEvents : true

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: root.pressed(mouse)
        onClicked: {
            root.updateFocus()
            mouse.accepted = false

            if (mouse.button & Qt.RightButton) {
                if (!checked) {
                    root.clicked(mouse)
                }

                rowMenu.popup()
            }
            else {
                root.clicked(mouse)
            }
        }
        onDoubleClicked: {
            if (mouse.button === Qt.LeftButton) {
                root.openSimulationClicked()
                mouse.accepted = true
            }
        }
    }

    contentItem : Item {

        anchors.fill: parent
        anchors.leftMargin: 10

        Row {
            id: detailRow
            anchors.fill: parent

            ProjectListEntry {
                id: simulationNameEntry
                width: detailView.simulationHeaderWidth
                text: simulationName
                textColor: detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor
            }
            Item {
                width: detailView.tagHeaderWidth
                height: 40

                QmlWidgets.WBTagView {
                    width: detailView.tagHeaderWidth
                    height: Math.min(parent.height, contentHeight)
                    anchors.verticalCenter: parent.verticalCenter
                    readOnly: true
                    model: tagList
                    scrollBarVisible: false
                }
            }
            ProjectListEntry {
                width: detailView.updatedHeaderWidth
                text: Qt.formatDateTime(updateDate, "yyyy-MM-dd hh:mm:ss")
                textColor: detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor
            }
            ProjectListEntry {
                id: solverEntry
                width: detailView.solverHeaderWidth
                property bool warningLicense : !simulationDataController.checkSolverLicense(solver)

                text: solver
                textColor: warningLicense ?
                               constants.inputFieldInputAreaErrorBackgroundColor :
                               (detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor)

                QmlWidgets.WBToolTip {
                    visible: root.hovered && solverEntry.warningLicense
                    text: "No license found"
                }
            }
            ProjectListEntry {
                width: detailView.statusHeaderWidth
                visible: hasMonitoring

                text: getStateString(simulationState)

                function getStateString(enumSimulationState) {
                    switch (enumSimulationState) {
                    case MonitoredSimulationStatus.SimulationPending:
                        return "Pending"
                    case MonitoredSimulationStatus.SimulationRunning:
                        return "Running"
                    case MonitoredSimulationStatus.SimulationTerminatedSuccess:
                        return "Success"
                    case MonitoredSimulationStatus.SimulationTerminatedInterrupted:
                        return "Interrupted"
                    case MonitoredSimulationStatus.SimulationTerminatedFailure:
                        return "Failure"
                    }
                    return "Unknown"
                }
                textColor: detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor
            }
            ProjectListEntry {
                width: detailView.elapsedTimeHeaderWidth
                visible: hasMonitoring && monitoringInfos.valid

                text: monitoringInfos && monitoringInfos.valid ? conversionHelper.secondsToString(monitoringInfos.elapsedTime) : ""

                textColor: detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor
            }
            ProjectListEntry {
                width: detailView.processCountHeaderWidth
                visible: hasMonitoring && monitoringInfos && monitoringInfos.valid

                text: monitoringInfos ? monitoringInfos.processCount : 0

                textColor: detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor
            }
            ProjectListEntry {
                width: detailView.progressHeaderWidth
                visible: hasMonitoring && monitoringInfos && monitoringInfos.valid

                text: monitoringInfos ? monitoringInfos.progression + "%" : ""

                textColor: detailItem.hovered || detailItem.checked ? constants.listViewEntryHoveredFontColor : constants.listViewEntryFontColor
            }
        }
    }
}
