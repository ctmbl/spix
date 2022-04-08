import QtQuick 2.13
import QtQuick.Controls 2.13

// NF Frameworks
import "qrc:/widgets/" as QmlWidgets

QmlWidgets.WBDocumentWindow {
    id: root

    headerVisible: false

    width: applicationWindow.availableWidth
    height: applicationWindow.availableHeight

    movable: false
    resizable: false

    property var projectListView

    function deleteSeletedSimulations(){
        // store projectId, simulationId and simulationName
        var projectIds = []
        var simulationIds = []
        var simulationNames = []
        var doDelete = false

        for (var i = 0; i < projectListView.currentSelection.count; ++i) {
            if (projectListView.isVisible(projectListView.currentSelection.get(i).simulationId) &&
                projectListView.canDelete(projectListView.currentSelection.get(i).simulationId)) {
                projectIds.push(projectListView.currentSelection.get(i).projectId)
                simulationIds.push(projectListView.currentSelection.get(i).simulationId)
                var index = projectListView.indexOfSimulationListModel(projectListView.currentSelection.get(i).projectId, projectListView.currentSelection.get(i).simulationId)
                simulationNames.push(simulationListModel.getSimulationProperty(projectListView.currentSelection.get(i).simulationId, "simulationName"))
                doDelete = true
            }
        }
        if (doDelete)
        {
          deleteSimulationWindow.projectIds = projectIds
          deleteSimulationWindow.simulationIds = simulationIds
          deleteSimulationWindow.simulationNames = simulationNames
          deleteSimulationWindow.visible = true
        }
    }

    //--------------------------------------------------------------------------
    // Window Content
    //--------------------------------------------------------------------------

    content: Rectangle {
        id: contentItem
        color: constants.listBackgroundColor
        focus: true

        Keys.onPressed: {
            if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)) {
                projectListView.selectAll()
            }
            else if (event.key === Qt.Key_Delete) {
                deleteSeletedSimulations()
            }
            else if ((event.modifiers & Qt.ShiftModifier) && event.key === Qt.Key_Up) {
                projectListView.selectionExtendUp()
            }
            else if ((event.modifiers & Qt.ShiftModifier) && event.key === Qt.Key_Down) {
                projectListView.selectionExtendDown()
            }
            else if (event.key === Qt.Key_Up) {
                projectListView.selectNextUp()
            }
            else if (event.key === Qt.Key_Down) {
                projectListView.selectNextDown()
            }
            event.accepted = true
        }

        Item {
            anchors.fill: parent

            Rectangle {
                width: parent.width - simulationPreviewWindow.width - constants.separationLineWidth
                color: constants.paletteWindowHeaderBackgroundColor
                height: 28

                Row {
                    id: projectListViewToolBar
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    spacing: 6

                    ButtonGroup {
                        id: viewModeButtonGroup
                        exclusive: true
                    }

                    QmlWidgets.WBProjectToolBarIconButton {
                        id: listModeThumbnailButton
                        checkable: true
                        checked: true
                        iconSource: "qrc:/svg/Headers/GridView.svg"
                        ButtonGroup.group: viewModeButtonGroup
                        visible: true
                        enabled: !checked
                        anchors.verticalCenter: parent.verticalCenter

                        QmlWidgets.WBToolTip {
                            visible: listModeThumbnailButton.hovered
                            errorToolTip: false
                            text: qsTr("Show preview")
                        }

                        onCheckedChanged : {
                            listModeDetailButton.checked = !listModeThumbnailButton.checked
                            projectListView.detailMode = listModeDetailButton.checked
                        }
                    }

                    QmlWidgets.WBProjectToolBarIconButton {
                        id: listModeDetailButton
                        checkable: true
                        checked: false
                        enabled: !checked
                        iconSource: "qrc:/svg/Headers/List.svg"
                        visible: true
                        ButtonGroup.group: viewModeButtonGroup
                        anchors.verticalCenter: parent.verticalCenter

                        QmlWidgets.WBToolTip {
                            visible: listModeDetailButton.hovered
                            errorToolTip: false
                            text: qsTr("Show details")
                        }

                        onCheckedChanged : {
                            listModeThumbnailButton.checked = !listModeDetailButton.checked
                            projectListView.detailMode = listModeDetailButton.checked
                        }
                    }

                    QmlWidgets.WBSearchBar {
                        id: projectListViewSearchBar
                        width: 300
                        height: parent.height
                        popup: true
                        text: applicationWindow.simulationListFilterText

                        popupModel: ["All", "In simulation names", "In tags", "Recently used"]

                        onPopupClicked: {
                            switch (index) {
                            case 0: // Search all
                                projectListView.searchedRole = "all"
                                break
                            case 1: // Search simulations
                                projectListView.searchedRole = "simulationName"
                                break
                            case 2: // Search tags
                                projectListView.searchedRole = "tagList"
                                break
                            case 3: // Search recently used
                                projectListView.searchedRole = "recentlyUsed"
                                text = "Recently used"
                                break
                            }
                        }

                        onTextChanged: {
                            projectListView.searchedText = text
                            if (projectListView.searchedText === "") {
                               projectListView.searchedRole = ""
                            }
                        }

                    }
                }
            }

            Row {
                anchors.top: parent.top
                width: parent.width
                height : parent.height - mainStatusBar.height

                ProjectListView {
                    id: projectListView

                    width: parent.width - simulationPreviewWindow.width - constants.separationLineWidth
                    height: parent.height
                    detailMode : false
                    searchedRole: applicationWindow.simulationListFilterRole

                    Component.onCompleted: {
                        root.projectListView = projectListView
                    }

                    onDetailModeChanged : {
                        listModeDetailButton.checked = projectListView.detailMode
                    }

                    onSearchedRoleChanged: {
                        // save to user settings
                        applicationWindow.simulationListFilterRole = searchedRole
                    }

                    onSearchedTextChanged: {
                        // save to user settings
                        applicationWindow.simulationListFilterText = searchedText
                    }
                }

                // separation line
                Rectangle {
                    x: constants.preselectionButtonX + constants.preselectionListWidth
                    width: 1
                    height: parent.height
                    color: constants.separationLineColor
                }

                SimulationPreviewWindow {
                    id: simulationPreviewWindow

                    visible: projectListView.currentSelection.count === 1 &&
                             projectListView.currentSelection.get(0).simulationId !== ""

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    title: qsTr("Simulation preview")

                    function updateMonitoringDatas(simulationId) {
                        if (simulationListModel.isSimulationExist(simulationId)) {
                            simulationPreviewWindow.hasMonitoring = simulationListModel.getSimulationProperty(simulationId, "hasMonitoring")
                            if (simulationPreviewWindow.hasMonitoring) {
                                simulationPreviewWindow.simulationStatusId = simulationListModel.getSimulationProperty(simulationId, "simulationStatusId")
                                simulationPreviewWindow.simulationState = simulationListModel.getSimulationProperty(simulationId, "simulationState")
                                simulationPreviewWindow.startTime = simulationListModel.getSimulationProperty(simulationId, "startTime")
                                simulationPreviewWindow.endTimeAvailable = simulationListModel.getSimulationProperty(simulationId, "endTimeAvailable")
                                simulationPreviewWindow.workingDirectory = simulationListModel.getSimulationProperty(simulationId, "workingDirectory")
                                simulationPreviewWindow.processCount = simulationListModel.getSimulationProperty(simulationId, "processCount")

                                if (simulationPreviewWindow.endTimeAvailable) {
                                    simulationPreviewWindow.endTime = simulationListModel.getSimulationProperty(simulationId, "endTime")
                                }

                                var monitoringInfos = simulationListModel.getSimulationProperty(simulationId, "monitoringInfos")
                                if (monitoringInfos.valid) {
                                    simulationPreviewWindow.elapsedTime = monitoringInfos.elapsedTime
                                    simulationPreviewWindow.progression = monitoringInfos.progression
                                    simulationPreviewWindow.monitoringStats = monitoringInfos.monitoringStats
                                }
                            }
                        }
                    }

                    function updateView() {
                        if (projectListView.currentSelection.count === 1) {
                          var simulationId = projectListView.currentSelection.get(0).simulationId

                          if (simulationId !== "" && simulationListModel.isSimulationExist(simulationId)) {
                              simulationPreviewWindow.simulationName = simulationListModel.getSimulationProperty(simulationId, "simulationName")
                              simulationPreviewWindow.tagList = simulationListModel.getSimulationProperty(simulationId, "tagList")
                              simulationPreviewWindow.previewSource = simulationListModel.getSimulationProperty(simulationId, "preview")
                              simulationPreviewWindow.solverName = simulationListModel.getSimulationProperty(simulationId, "solver")
                              simulationPreviewWindow.creationDate = simulationListModel.getSimulationProperty(simulationId, "creationDate")
                              simulationPreviewWindow.updateDate = simulationListModel.getSimulationProperty(simulationId, "updateDate")
                              simulationPreviewWindow.lastSaveSoftwareVersion = simulationListModel.getSimulationProperty(simulationId, "lastSaveSoftwareVersion")
                              simulationPreviewWindow.repositoryType = simulationListModel.getSimulationProperty(simulationId, "repositoryType")
                              simulationPreviewWindow.repositoryLocation = simulationListModel.getSimulationProperty(simulationId, "repositoryLocation")
                              simulationPreviewWindow.updateMonitoringDatas(simulationId)
                          }
                          simulationPreviewWindow.isSimulationFileExist = fileTools.isFileExist(simulationPreviewWindow.repositoryLocation)
                        }
                    }

                    Connections {
                        target: projectListView

                        function onSelectionChanged() {
                            simulationPreviewWindow.updateView()
                        }
                    }

                    Connections {
                        target: monitoredSimulationListModel

                        function onModelChanged() {
                            if (projectListView.currentSelection.count === 1) {
                                var simulationId = projectListView.currentSelection.get(0).simulationId

                                if (simulationId !== "") {
                                    simulationPreviewWindow.updateMonitoringDatas(simulationId)
                                }
                            }
                        }
                    }

                    Connections {
                        target: simulationListModel

                        function onModelChanged() {
                            simulationPreviewWindow.allTagList = simulationListModel.retrieveAllTags()

                             if (projectListView.currentSelection.count === 1) {
                                 var simulationId = projectListView.currentSelection.get(0).simulationId
                                 simulationPreviewWindow.tagList = simulationListModel.getSimulationProperty(simulationId, "tagList")
                             }
                            simulationPreviewWindow.updateView()
                        }
                    }

                    onOpenClicked: projectListView.openSelectedSimulation()
                    onDuplicateClicked: projectListView.duplicateSelectedSimulation()
                    onExportClicked: projectListView.exportSelectedSimulation()
                    onDeleteClicked: {
                        if (projectListView.currentSelection.count === 1) {
                            deleteSeletedSimulations()
                        }
                    }

                    onSimulationNameEdited: {
                        if (projectListView.currentSelection.count === 1) {
                            var simulationId = projectListView.currentSelection.get(0).simulationId

                            if (!simulationDataController.updateSimulationName(simulationId, name)) {
                                informationWindow.title = qsTr("Error updating simulation")
                                informationWindow.text = qsTr("Error while updating the simulation: ") + name
                                informationWindow.visible = true
                            }
                            else {
                                simulationPreviewWindow.simulationName = simulationListModel.getSimulationProperty(simulationId, "simulationName")
                            }
                        }
                    }

                    onSimulationTagListEdited: {
                        if (projectListView.currentSelection.count === 1) {
                            var simulationId = projectListView.currentSelection.get(0).simulationId

                            if (!simulationDataController.updateSimulationTagList(simulationId, tagList)) {
                                informationWindow.title = qsTr("Error updating simulation")
                                informationWindow.text = qsTr("Error while updating the simulation: ") + name
                                informationWindow.visible = true
                            }
                        }
                    }
                }
            }
        }

        QmlWidgets.WBStatusBar {
            id: mainStatusBar
            width: parent.width
            anchors.bottom: parent.bottom

            property var visibleSimulations : projectListView.getVisibleSimulations()
            property var simulationsStatusList : projectListView.getSimulationsStatusListCount()

            leftText: visibleSimulations.length + " simulations (" + simulationsStatusList[1] + " running, " + simulationsStatusList[2] + " success, " + simulationsStatusList[4] + " failure)"

            ConsoleNotificationStatus {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
            }
        }
    }
}
