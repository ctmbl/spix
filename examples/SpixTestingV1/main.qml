import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

import "qrc:/qml/" as QmlWidgets

QmlWidgets.WBApplicationWindow {
    objectName: "mainWindow"
    visible: true
    width: 640
    height: 480
    title: qsTr("Spix Example")
    color: "#111111"

    /*menuBar:*/ QmlWidgets.WBMenuBar {
        objectName: "menuBar"

        property string executionStatus:
            simulationDataController.hasMonitoring ?
                (simulationDataController.lastExecutionStatus === MonitoredSimulationStatus.SimulationRunning ?
                     " (Running " + simulationDataController.lastExecutionCompletionPercentage + "%...)" :
                     simulationDataController.lastExecutionStatus === MonitoredSimulationStatus.SimulationTerminatedSuccess ?
                         " (Execution success)" :
                        simulationDataController.lastExecutionStatus === MonitoredSimulationStatus.SimulationTerminatedInterrupted ?
                            " (Interrupted)" :
                            simulationDataController.lastExecutionStatus === MonitoredSimulationStatus.SimulationTerminatedFailure ?
                                " (Execution failure)" : "") : ""

        title:
            simulationDataController.simulationState === Simulation.Opened ?
                (simulationDataController.isDataModified ? "*" : "") +
                currentSimulationModel.simulationName + " - " +
                currentSimulationModel.solverVariantPreset +
                executionStatus : ""

        QmlWidgets.WBMenu {
            objectName: "File"
            title: qsTr("File")
            QmlWidgets.WBMenuItem { 
                text: qsTr("New...")
                objectName: "New..."
                enabled: simulationDataController.simulationState !== Simulation.Opened
                onTriggered: {
                    createSimulationWindow.visible = true
                }
            }
            QmlWidgets.WBMenuItem { 
                text: qsTr("Open...")
                objectName: "Open..."
                enabled: simulationDataController.simulationState !== Simulation.Opened

                onTriggered: {
                    var nameFilters = ["Simcenter SPH Flow Studio simulation (*.nf-studio *.json)",
                                       "Simcenter SPH Flow (*.nml *.yaml)",
                                       "All files (*.*)"]

                    appWindow.createFilteredFileSelectionWindow(
                                qsTr("Select file"),
                                false, // multiple selection
                                false, // save
                                nameFilters,
                                "", // default file name
                                "", // default suffix
                                "", // folder
                                function(window) {
                                    if (fileTools.getFileExtension(window.currentFile) === "nf-studio") {
                                        studioApp.openSimulationFile(fileTools.getFilePathFromUrl(window.currentFile))
                                    }
                                    else {
                                        importSimulationWindow.filePath = fileTools.getFilePathFromUrl(window.currentFile)
                                        importSimulationWindow.visible = true
                                    }
                                })
                }
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Rename...")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: {
                    renameSimulationWindow.text = currentSimulationModel.simulationName
                    renameSimulationWindow.visible = true
                }
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Save (CTRL+S)")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: saveSimulation()
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Save as...")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: {
                    duplicateSimulationWindow.duplicateMode = false
                    duplicateSimulationWindow.sourceSimulationId = simulationDataController.openedSimulationId
                    var solverVariant = simulationListModel.getSimulationProperty(simulationDataController.openedSimulationId, "solver")
                    duplicateSimulationWindow.defaultSolverVariant = solverVariant
                    duplicateSimulationWindow.defaultSimulationName = simulationDataController.findUniqueSimulationName(simulationListModel.getSimulationProperty(simulationDataController.openedSimulationId, "simulationName"))
                    duplicateSimulationWindow.variantModel = simulationDataController.compatibleSolverVariantForMigration(simulationDataController.openedSimulationId, solverVariant)
                    duplicateSimulationWindow.visible = true
                }
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Export...")
                enabled: simulationDataController.simulationState === Simulation.Opened
                visible: !userPreferenceController.standaloneFileSystem() || developerMode
                onTriggered: {
                    simulationWindow.savePreview()
                    exportSimulationDialog.exportCurrentSimulation = true
                    exportSimulationDialog.folder = ""
                    exportSimulationDialog.visible = true
                }
            }

            QmlWidgets.WBMenuSeparator {
                visible: developerMode
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Export to C++...")
                visible: developerMode
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: exportCppDialog.visible = true
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Refresh QML")
                visible: developerMode

                onTriggered: {
                    reloadQML = true;
                    applicationWindow.appWindow.close()
                    studioApp.reloadQML()
                }
            }

            QmlWidgets.WBMenuSeparator { }
            QmlWidgets.WBMenuItem {
                text: qsTr("Close")
                enabled: simulationDataController.simulationState === Simulation.Opened

                onTriggered: {
                    if (simulationDataController.isDataModified) {
                        closeSimulationWindow.visible = true
                    }
                    else {
                        closeSimulation(false)
                    }
                }
            }
            QmlWidgets.WBMenuSeparator { }
            QmlWidgets.WBMenuItem {
                objectName: "Exit_Studio"
                text: qsTr("Exit Simcenter SPH Flow Studio")
                onTriggered: onQuitApplicationEvent()
            }
        }

        QmlWidgets.WBMenu {
            title: qsTr("Edit")
            objectName: "Edit"

            QmlWidgets.WBMenuItem {
                text: qsTr("Undo ")  + undoRedoManager.undoText + " (CTRL+Z)"
                enabled:
                    simulationDataController.simulationState === Simulation.Opened && undoRedoManager.enabled && undoRedoManager.undoAvailable

                onTriggered: undoRedoManager.undo()
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Redo ") + undoRedoManager.redoText + " (CTRL+Y)"
                enabled:
                    simulationDataController.simulationState === Simulation.Opened && undoRedoManager.enabled && undoRedoManager.redoAvailable

                onTriggered: undoRedoManager.redo()
            }
            QmlWidgets.WBMenuSeparator { }
            QmlWidgets.WBMenuItem {
                text: qsTr("Toggle visibility (H)")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: currentContext === StudioContext.Render ? renderResourceListModel.toggleMeshesVisibility() : (currentContext === StudioContext.Graphs ? ( chartListController.chartControllers(simulationWindow.getPlotTabViewIndex()).toggleVisibility() ) : geometryListModel.toggleVisibility())
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Show selected (Ctrl+ H)")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: currentContext === StudioContext.Render ? renderResourceListModel.showSelectedMeshes() : (currentContext === StudioContext.Graphs ? ( chartListController.chartControllers(simulationWindow.getPlotTabViewIndex()).showSelected() ) : geometryListModel.showSelected())
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Hide selected")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: currentContext === StudioContext.Render ? renderResourceListModel.hideSelectedMeshes() : (currentContext === StudioContext.Graphs ? ( chartListController.chartControllers(simulationWindow.getPlotTabViewIndex()).hideSelected() ) : geometryListModel.hideSelected())
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Show all (Shift+ H)")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: currentContext === StudioContext.Render ? renderResourceListModel.showAllMeshes() : (currentContext === StudioContext.Graphs ? ( chartListController.chartControllers(simulationWindow.getPlotTabViewIndex()).showAll() ) : geometryListModel.showAll())
            }
            QmlWidgets.WBMenuItem {
                text: qsTr("Hide all others (Alt+ H)")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: currentContext === StudioContext.Render ? renderResourceListModel.hideAllMeshesExceptSelected() : (currentContext === StudioContext.Graphs ? ( chartListController.chartControllers(simulationWindow.getPlotTabViewIndex()).hideAllExceptSelected() ) : geometryListModel.hideAllExceptSelected())
            }
            QmlWidgets.WBMenuSeparator{

            }
            QmlWidgets.WBMenuItem{
                text: qsTr("Enabling the disabled button")
                onTriggered: {
                    disabledSpixTestingButton.enabled = true
                    disablerOfDisabledButton.visible = true
                    resultsView.appendText("Enabling the disabled button AND Visibling (??) the Disabling-the-disabled-button Button (complicated yes)")
                }
            }
            QmlWidgets.WBMenuItem {
                id: disabledSpixTestingButton
                text: qsTr("Disabled Button for Spix Testing")
                objectName: "Disabled_Button"
                enabled: false
                onTriggered: {
                    console.log("the Disabled Button is : " + disabledSpixTestingButton.enabled)
                    resultsView.appendText("the Disabled Button is : " + disabledSpixTestingButton.enabled)
                }

            }
            QmlWidgets.WBMenuItem{
                id: disablerOfDisabledButton
                visible: false
                enabled: true
                text: qsTr("Disabling the disabled button")
                onTriggered: {
                    disabledSpixTestingButton.enabled = false
                    resultsView.appendText("Disabling the should-be-disabled button")
                }
            }
        }

        QmlWidgets.WBMenu {
            title: qsTr("Tools")

            QmlWidgets.WBMenu {
                title: qsTr("Theme")

                ButtonGroup {
                    id: themeButtonGroup
                }

                QmlWidgets.WBMenuItem {
                    text: qsTr("Light theme")
                    checkable: true
                    checked: themeName === themeManager.lightThemeName
                    ButtonGroup.group: themeButtonGroup

                    onTriggered: themeName = themeManager.lightThemeName
                }

                QmlWidgets.WBMenuItem {
                    text: qsTr("Ocean theme")
                    checkable: true
                    checked: themeName === themeManager.oceanThemeName
                    ButtonGroup.group: themeButtonGroup

                    onTriggered: themeName = themeManager.oceanThemeName
                }

                QmlWidgets.WBMenuItem {
                    text: qsTr("Dark theme")
                    checkable: true
                    checked: themeName === themeManager.darkThemeName
                    ButtonGroup.group: themeButtonGroup

                    onTriggered: themeName = themeManager.darkThemeName
                }

                QmlWidgets.WBMenuItem {
                    text: qsTr("Custom theme")
                    visible: developerMode
                    checkable: true
                    checked: themeName === themeManager.customThemeName
                    ButtonGroup.group: themeButtonGroup

                    onTriggered: themeName = themeManager.customThemeName
                }

                QmlWidgets.WBMenuSeparator {
                    visible: developerMode
                }

                QmlWidgets.WBMenuItem {
                    text: qsTr("Load theme...")
                    visible: developerMode
                    ButtonGroup.group: themeButtonGroup

                    onTriggered: {
                        appWindow.createFilteredFileSelectionWindow(
                                    qsTr("Select theme QML file"),
                                    false, // multiple selection
                                    false,  // save
                                    ["QML File (*.qml)"],
                                    "", // default file name
                                    "",
                                    "",
                                    function(window) {
                                        themeManager.customThemeUrl = window.currentFile
                                    })
                    }
                }

                QmlWidgets.WBMenuItem {
                    text: qsTr("Display theme colors")
                    visible: developerMode
                    onTriggered: themeColorWindow.visible = true
                }
            }

            QmlWidgets.WBMenuItem {
                text: qsTr("Save picture...")
                enabled: simulationDataController.simulationState === Simulation.Opened

                onTriggered: {
                    applicationWindow.savePictureClicked()
                }
            }

            QmlWidgets.WBMenuItem {
                text: qsTr("Copy picture to clipboard")
                enabled: simulationDataController.simulationState === Simulation.Opened

                onTriggered: {
                    applicationWindow.copyPictureToClipboardClicked()
                }
            }

            QmlWidgets.WBMenuSeparator { }

            QmlWidgets.WBMenuItem {
                text: qsTr("Show geometry files")
                enabled: simulationDataController.simulationState === Simulation.Opened && currentContext !== StudioContext.Render && currentContext !== StudioContext.Graphs
                onTriggered: {
                    geometryBrowserWindowVisible = true
                }
            }

            QmlWidgets.WBMenuItem {
                text: qsTr("Show external files")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: {
                    simulationFileBrowserWindow.visible = true
                }
            }

            QmlWidgets.WBMenuItem {
                text: qsTr("Change solver...")
                enabled: simulationDataController.simulationState === Simulation.Opened
                onTriggered: {
                    var solverVariant = simulationListModel.getSimulationProperty(simulationDataController.openedSimulationId, "solver")
                    changeSolverWindow.variantModel = simulationDataController.compatibleSolverVariantForMigration(simulationDataController.openedSimulationId, solverVariant)
                    changeSolverWindow.defaultSolverVariant = solverVariant
                    changeSolverWindow.visible = true
                }
            }

            QmlWidgets.WBMenuSeparator { }

            QmlWidgets.WBMenuItem {
                text: qsTr("Show / hide console")
                onTriggered: {
                    consoleWindow.visible = !consoleWindow.visible
                }
            }

            QmlWidgets.WBMenuItem {
                text: qsTr("User preferences...")
                onTriggered: {
                    userPreferencesWindow.visible = true
                }
            }
        }

        QmlWidgets.WBMenu {
            title: qsTr("Help")

            QmlWidgets.WBMenuItem {
                text: qsTr("Documentations...")
                onTriggered: {
                    fileTools.openUrl(fileTools.getUrl(dirManager.getHelpPath()))
                }
            }

            QmlWidgets.WBMenuItem {
                text: qsTr("About...")
                onTriggered: {
                    aboutWindow.contentText = aboutText
                    aboutWindow.visible = true
                }
            }
        }
    }

    RowLayout {
        objectName: "rowLayout"

        anchors {
            top: parent.top
            left: parent.left
            topMargin: constants.menuHeight*2
            leftMargin: 5
        }

        QmlWidgets.WBButton {
            objectName: "button00"
            text: "Press Me"
			MouseArea {
				anchors.fill: parent
				acceptedButtons:  Qt.AllButtons
				
				onClicked:
				{
					if(mouse.button & Qt.RightButton)
						resultsView.appendText("Button 0 right clicked")
					else
						resultsView.appendText("Button 0 clicked")
				}
			}
        }
        QmlWidgets.WBButton01 {
            objectName: "button01"
            text: "Or Click Me"
			MouseArea {
				anchors.fill: parent
				acceptedButtons:  Qt.AllButtons
				
				onClicked:
				{
					if(mouse.button & Qt.RightButton)
						resultsView.appendText("Button 1 right clicked")
					else
						resultsView.appendText("Button 1 clicked")
				}
			}
        }
        QmlWidgets.WBButton02 {
            objectName: "button_02"
            id: button02
            text: "Button Style 02"
            MouseArea {
				anchors.fill: parent
				acceptedButtons:  Qt.AllButtons
				
				onClicked:
				{
                    resultsView.appendText("Button 02 has an ID AND an objectName (button_02)")
					if(mouse.button & Qt.RightButton)
						resultsView.appendText("Button 2 right clicked")
					else
						resultsView.appendText("Button 2 clicked")
				}
			}

        }
        QmlWidgets.WBButton03 {
            id: button03
            text: "Button Style 03"
			MouseArea {
				anchors.fill: parent
				acceptedButtons:  Qt.AllButtons
				
				onClicked:
				{
                    resultsView.appendText("[+] searched by ID")
					if(mouse.button & Qt.RightButton)
						resultsView.appendText("Button 3 right clicked")
					else
						resultsView.appendText("Button 3 clicked")
				}
			}
        }
        QmlWidgets.WBButton04 {
            id: button04
            text: "Button Style 04"
			MouseArea {
				anchors.fill: parent
				acceptedButtons:  Qt.AllButtons
				
				onClicked:
				{
                    resultsView.appendText("[+] searched by ID")
					if(mouse.button & Qt.RightButton)
						resultsView.appendText("Button 4 right clicked")
                    if(mouse.button & Qt.MiddleButton)
                        resultsView.appendText("Button 4 middle clicked")
					if(mouse.button & Qt.LeftButton)
						resultsView.appendText("Button 4 left clicked")
				}
			}
        }
        QmlWidgets.WBButton04 {
            id: clearButton
            text: "Clear Text"
			MouseArea {
				anchors.fill: parent
				acceptedButtons:  Qt.LeftButton
				
				onClicked:
				{
                    resultsView.clearText()
                }
			}
        }
    }

    ResultsView {
        id: resultsView
        anchors {
            top: parent.verticalCenter
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
