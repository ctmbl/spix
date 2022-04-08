// Qt Quick Framework
import QtQuick 2.13
import QtQuick.Controls 2.13

// NF Frameworks
import "qrc:/widgets/" as QmlWidgets

Row {
    signal deleteSimulationClicked()
    signal importSimulationClicked()

    QmlWidgets.WBToolBarSeparator {
    }

    QmlWidgets.WBToolBarButton {
        iconSource: "qrc:/svg/Headers/Add4.svg"
        text: qsTr("New...")

        onClicked: {
            createSimulationWindow.visible = true
        }
    }

    QmlWidgets.WBToolBarSeparator {
    }

    QmlWidgets.WBToolBarButton {
        id: openSimulationsButton
        iconSource: "qrc:/svg/Headers/Import2.svg"
        text: qsTr("Open...")

        onClicked: {
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

    QmlWidgets.WBToolBarSeparator {}

    QmlWidgets.WBToolBarButton {
        iconSource: "qrc:/svg/Tools/Combine.svg"
        text: qsTr("Compare")
        enabled: selectionSize() === 2

        onClicked: {
            projectListWindow.projectListView.compareSelectedSimulations()
        }
    }

    QmlWidgets.WBToolBarSeparator {}

    QmlWidgets.WBToolBarButton {
        id: removeSelectedSimulationsButton
        iconSource: "qrc:/svg/Headers/Delete.svg"
        text: qsTr("Delete...")
        enabled: canDeletedSelectedSimulation()

        onClicked: {
            deleteSimulationClicked()
        }
    }
}

