import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.3 as QmlModel
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.3

// Nextflow Frameworks
import Nextflow.Studio 1.0
import Workbench 1.0
import QtUtilities 1.0
import QtRendering 1.0
import SortFilterProxyModel 0.2
import "qrc:/widgets/" as QmlWidgets
import "qrc:/js/algorithm.js" as JsAlgorithm
import "qrc:/js/utils.js" as JsUtils

QmlWidgets.WBApplicationWindow {
    id: applicationWindow
    visible: true

    property var currentWorkspace :
          (simulationDataController.simulationState === Simulation.Opened) && (currentSimulationModel.standAloneFileSystem) ?
          (" [file: " + currentSimulationModel.storageLocation + "]") :
          (userPreferenceController.qStorageDataPath() !== userPreferenceController.qDefaultStorageDataPath()) ? (" [workspace: " + userPreferenceController.qStorageDataPath() + "]"): ""
    title: "Simcenter SPH Flow Studio " + Qt.application.version + currentWorkspace

    // Uncomment to track focused item
    //onActiveFocusItemChanged: console.log("activeFocusItem", activeFocusItem)

    property bool meshingOperationManagerWindowVisible: false
    property bool geometryBrowserWindowVisible: false
    property bool transformWindowVisible: false
    property bool snapWindowVisible: false
    property bool adjustCameraWindowVisible: false
    property bool selectionInformationWindowVisible: false
    property bool clipPlanesWindowVisible: false
    property bool compareWindowVisible: false
    property int measurementToolsWindowIndex: 0
    property bool measurementToolsWindowVisible: false
    property bool saveRenderFieldDialogVisible: false
    property bool saveGroupRenderFieldDialogVisible: false
    property bool saveGroupRenderGeometriesDialogVisible: false
    property int currentContext: -1
    property color viewerBackgroundColor: "white"
    property bool reloadQML: false

    onVisibleChanged: {
        projectDataController.deleteEmptyProjects()
        // tutorials must be install after that point to have access to DB tool
        projectDataController.installTutorialProjects()
        if (userPreferenceController.isPluginSelectionEmpty()) {
            informationWindow.title = qsTr("Warning")
            informationWindow.text = qsTr("No plugins have been loaded!")
            informationWindow.visible = true
        }
        else if (userPreferenceController.isPluginSelectionAmbiguous()) {
            userPreferencesWindow.solverButtonChecked = true
            userPreferencesWindow.visible = true
        }

        viewerBackgroundColor = userPreferenceController.viewerBackgroundColor()
    }

    Shortcut {
        sequence: "Ctrl+Z"
        onActivated: undoRedoManager.undo()
    }

    Shortcut {
        sequence: "Ctrl+Y"
        onActivated: undoRedoManager.redo()
    }

    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            saveSimulation()
        }
    }

    //--------------------------------------------------------------------------
    // Persistent user settings
    //--------------------------------------------------------------------------

    Settings {
        id: settings
        property alias themeName: applicationWindow.themeName
        property alias csvSeparator: applicationWindow.csvSeparator
        property alias exportPicturesDirectory: applicationWindow.exportPicturesDirectory
        property alias exportMeshesDirectory: applicationWindow.exportMeshesDirectory
        property string captionsFontFamily: "Times"
        property int scalarBarTitleFontSize: 16
        property int scalarBarLabelFontSize: 12
        property color scalarBarTextColor: "black"
        property bool scalarBarBackgroundVisible: true
        property color scalarBarBackgroundColor: Qt.rgba(0.0, 0.0, 0.0, 0.1)
        property bool renderTimeVisible: false
        property string renderTimeFormat: "Time: %1.4f"
        property real renderTimeShift: 0.
        property real renderTimeScale: 1.
        property int renderTimeFontSize: 16
        property color renderTimeTextColor: "black"
        property alias simulationListFilterRole: applicationWindow.simulationListFilterRole
        property alias simulationListFilterText: applicationWindow.simulationListFilterText
    }

    property string csvSeparator: ","
    property string exportPicturesDirectory: ""
    property string exportMeshesDirectory: ""
    property string captionsFontFamily
    property int scalarBarTitleFontSize
    property int scalarBarLabelFontSize
    property color scalarBarTextColor
    property bool scalarBarBackgroundVisible
    property color scalarBarBackgroundColor
    property bool renderTimeVisible
    property string renderTimeFormat
    property real renderTimeShift
    property real renderTimeScale
    property int renderTimeFontSize
    property color renderTimeTextColor
    property string simulationListFilterRole: ""
    property string simulationListFilterText: ""

    //--------------------------------------------------------------------------
    // Utility classes
    //--------------------------------------------------------------------------

    DirManager {
        id: dirManager
    }

    FileTools {
        id: fileTools
    }

    SystemTools {
        id: systemTools
    }

    ConversionHelper {
        id: conversionHelper
    }

    EnvironmentTools {
        id: environmentTools
    }

    ClipboardTools {
        id: clipboardTools
    }

    SystemCommandManager {
        id: systemCommandManager
    }

    ItemFactory {
        id: itemFactory
    }

    //--------------------------------------------------------------------------
    // Application events
    //--------------------------------------------------------------------------

    signal savePictureClicked()
    signal copyPictureToClipboardClicked()

    //--------------------------------------------------------------------------
    // Menus
    //--------------------------------------------------------------------------

    menuBar: QmlWidgets.WBMenuBar {

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
            title: qsTr("File")
            QmlWidgets.WBMenuItem { text: qsTr("New...")
                enabled: simulationDataController.simulationState !== Simulation.Opened
                onTriggered: {
                    createSimulationWindow.visible = true
                }
            }
            QmlWidgets.WBMenuItem { text: qsTr("Open...")
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
                text: qsTr("Exit Simcenter SPH Flow Studio")
                onTriggered: onQuitApplicationEvent()
            }
        }

        QmlWidgets.WBMenu {
            title: qsTr("Edit")

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

    //--------------------------------------------------------------------------
    // About Window
    //--------------------------------------------------------------------------

    QmlWidgets.WBAboutWindow {
        id: aboutWindow
    }

    //--------------------------------------------------------------------------
    // User preferences window
    //--------------------------------------------------------------------------
    UserPreferences {
        id: userPreferencesWindow
    }

    //--------------------------------------------------------------------------
    // Color dialog
    //--------------------------------------------------------------------------
    ColorDialog {
        id: colorDialog

        visible: false
        modality: Qt.WindowModal

        property var funcOnAccepted

        showAlphaChannel: false
        onAccepted: funcOnAccepted()
    }

    //--------------------------------------------------------------------------
    // Project List Window
    //--------------------------------------------------------------------------

    ProjectListWindow {
        id: projectListWindow
        visible: simulationDataController.simulationState === Simulation.Closing || simulationDataController.simulationState === Simulation.Closed
    }


    //--------------------------------------------------------------------------
    // Simulation Window
    //--------------------------------------------------------------------------

    SimulationWindow {
        id: simulationWindow
        visible: simulationDataController.simulationState === Simulation.Opening || simulationDataController.simulationState === Simulation.Opened
    }

    //--------------------------------------------------------------------------
    // Rename simulation Window
    //--------------------------------------------------------------------------

    QmlWidgets.WBInputWindow {
        id: renameSimulationWindow

        title: qsTr("Rename simulation")
        label: qsTr("Simulation")

        onAccepted: {
            simulationDataController.updateSimulationName(simulationDataController.openedSimulationId, text)
            visible = false
        }

        onRejected: {
            visible = false
        }

        onKeysPressed: {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                simulationDataController.updateSimulationName(simulationDataController.openedSimulationId, text)
                visible = false
                event.accepted = true
            }

            if (event.key === Qt.Key_Escape) {
                visible = false
                event.accepted = true
            }
        }
    }

    //--------------------------------------------------------------------------
    // Modal progress window
    //--------------------------------------------------------------------------

    QmlWidgets.WBProgressWindow {
        id: progressWindow
        z: constants.modalWindowZValue
    }

    //--------------------------------------------------------------------------
    // Export simulation dialog
    //
    //  This dialog is used only on develop mode, to export as JSON
    //--------------------------------------------------------------------------

    ExportSimulationDialog {
        id: exportSimulationDialog
        exportKind : exportKind_Simulation
    }

    //--------------------------------------------------------------------------
    // Export computation dialog
    //--------------------------------------------------------------------------

    ExportSimulationDialog {
        id: exportComputationDialog
        exportKind : exportKind_Computation
    }

    //--------------------------------------------------------------------------
    // Console window
    //--------------------------------------------------------------------------

    Component {
        id: consoleWindowComponent

        ConsoleWindow {
            onRunClicked: {
                scriptController.executeScript(scriptContent)
            }
        }
    }

    property ConsoleWindow consoleWindow: consoleWindowComponent.createObject()

    Connections {
        target: loggerController

        function onLoggingTextChanged() {
            var newMessages = loggerController.getAddedLoggingText()
            for (var i = 0; i < newMessages.length; ++i) {
              consoleWindow.appendText(newMessages[i].level, newMessages[i].headerMessage, newMessages[i].levelMessage, newMessages[i].message)
            }
        }
    }

    Connections {
        target: loggerController

        function onOpenConsoleRequested() {
            consoleWindow.visible = true
        }
    }

    Connections {
        target: scriptController

        function onNewCommandAdded() {
            var newMessage = scriptController.getLastCommand()
            if (newMessage.length > 0) {
                consoleWindow.appendCommand(newMessage)
            }
        }
    }


    //--------------------------------------------------------------------------
    // Geometry Browser Window
    //--------------------------------------------------------------------------

    GeometryFileBrowserWindow {
        x: Math.ceil(parent.width / 2 - width / 2)
        y: Math.ceil(parent.height / 2 - height / 2)

        visible:
            geometryBrowserWindowVisible &&
            simulationDataController.simulationState === Simulation.Opened &&
            currentContext === StudioContext.Geometries

        onClose: {
            geometryBrowserWindowVisible = false
        }
    }

    //--------------------------------------------------------------------------
    // File manager
    //--------------------------------------------------------------------------

    SimulationFileBrowserWindow {
        id : simulationFileBrowserWindow
        x: Math.ceil(parent.width / 2 - width / 2)
        y: Math.ceil(parent.height / 2 - height / 2)
    }

    //--------------------------------------------------------------------------
    // Error information window
    //--------------------------------------------------------------------------

    QmlWidgets.WBInformationWindow {
        id: errorMessageWindow
        z: constants.modalWindowZValue

        buttons: Buttons.Accept
        textFormat: Text.PlainText // because some error messages can contains HTML-like markups

        onAccepted: visible = false
    }

    Connections {
        target: appProgressListener

        function onError(title, message, cancelled) {
            // TODO: provides a context to ensure it's a meshing operation
            geometryListModel.meshingAutoUpdateEnabled = false
        }
    }

    //--------------------------------------------------------------------------
    // Global information window
    //--------------------------------------------------------------------------

    QmlWidgets.WBInformationWindow {
        id: informationWindow
        z: constants.modalWindowZValue

        buttons: Buttons.Accept

        onAccepted: visible = false
    }

    //--------------------------------------------------------------------------
    // Input matrix 2x2 window
    //--------------------------------------------------------------------------

    QmlWidgets.WBInputMatrix2x2Window {
        id: inputMatrix2x2Window
        title: qsTr("Edit matrix")

        property var funcAccepted

        z: constants.modalWindowZValue

        onAccepted: {
            if (funcAccepted) funcAccepted()
            visible = false
        }

        onRejected: {
            visible = false
        }
    }

    //--------------------------------------------------------------------------
    // Input matrix 3x3 window
    //--------------------------------------------------------------------------

    QmlWidgets.WBInputMatrix3x3Window {
        id: inputMatrix3x3Window
        title: qsTr("Edit matrix")

        property var funcAccepted

        z: constants.modalWindowZValue

        onAccepted: {
            if (funcAccepted) funcAccepted()
            visible = false
        }

        onRejected: {
            visible = false
        }
    }

    //--------------------------------------------------------------------------
    // Input matrix 4x4 window
    //--------------------------------------------------------------------------

    QmlWidgets.WBInputMatrix4x4Window {
        id: inputMatrix4x4Window
        title: qsTr("Edit matrix")

        property var funcAccepted

        z: constants.modalWindowZValue

        onAccepted: {
            if (funcAccepted) funcAccepted()
            visible = false
        }

        onRejected: {
            visible = false
        }
    }

    //--------------------------------------------------------------------------
    // Interactive tools
    //--------------------------------------------------------------------------

    /*InteractiveTools {
        id: interactiveTools
        sceneManager: mainSceneController.sceneManager
    }*/


    Item {
        id: interactiveToolsHelper
        property var allowedToTakeFocus : []

        function isRectangle(item) {
            return item instanceof Rectangle
        }

        function isItem(item) {
            return item instanceof Item
        }

        function isSameOrChildOf(widgetToCompare, widgetWithChildren) {
            if (!widgetToCompare) {
              return false
            }
            if (widgetWithChildren === widgetToCompare) {
                return true
            }
            if (isRectangle(widgetWithChildren)) {
                // special case: not a parent/child relation ship
                for (var i = 0; i < widgetWithChildren.contentItem.children.length; i++) {
                  if (isSameOrChildOf(widgetToCompare, widgetWithChildren.contentItem.children[i])) {
                    return true
                  }
                }
            }
            if (isItem(widgetWithChildren)) {
                if (widgetToCompare.parent) {
                    if (isSameOrChildOf(widgetToCompare.parent, widgetWithChildren)) {
                        return true
                    }
                }
            }
            return false
        }

        function hasLostFocus(widgetWithFocus) {
            for (var i = 0; i < allowedToTakeFocus.length; ++i) {
                if (isSameOrChildOf(widgetWithFocus, allowedToTakeFocus[i])) {
                    return false
                }
            }
            return true
        }
    }

    //--------------------------------------------------------------------------
    // Delete selected geometries
    //--------------------------------------------------------------------------

    function deleteSelectedGeometries() {
        if (currentContext === StudioContext.Render) {
            let geometryUserLabelList = []
            let dependencyKeys = []
            let selectedKeys = renderResourceListModel.selectedMeshListModel.selectedKeys
            JsAlgorithm.forEach(selectedKeys, function(geometryKey) {
                geometryUserLabelList.push("- " + renderResourceListModel.selectedMeshListModel.getUserLabel(geometryKey))
            })

            appWindow.createValidationWindow(
                        qsTr("Delete geometries"),
                        qsTr("Are you sure you want to delete selected geometries?") + "<br/>" + JsUtils.mergeStringList(geometryUserLabelList, "<br/>"),
                        function() {
                            renderResourceListModel.selectedMeshListModel.removeSelectedGeometries()
                        })
        }
        else {
            let geometryUserLabelList = []
            let dependencyKeys = []
            let selectedKeys = geometryListModel.selectedKeys
            JsAlgorithm.forEach(selectedKeys, function(geometryKey) {
                geometryUserLabelList.push("- " + geometryListModel.getUserLabel(geometryKey))

                let usedGeometryKeys = geometryController.getGeometryKeysUsingGeometry(geometryKey)

                JsAlgorithm.forEach(usedGeometryKeys, function(usedGeometryKey) {
                    if (!JsAlgorithm.find(dependencyKeys, usedGeometryKey)) {
                        dependencyKeys.push(usedGeometryKey)
                    }
                })
            })

            appWindow.createValidationWindow(
                        qsTr("Delete geometries"),
                        qsTr("Are you sure you want to delete selected geometries?") + "<br/>" + JsUtils.mergeStringList(geometryUserLabelList, "<br/>"),
                        function() {
                            geometryController.removeSelectedGeometries()
                        })

        }
    }

    //--------------------------------------------------------------------------
    // Ordered project list model
    //--------------------------------------------------------------------------

    SortFilterProxyModel {
        id: orderedProjectListModel

        sourceModel: projectListModel

        function indexOf(projectId) {
          for (var i = 0; i < count; ++i) {
            if (get(index, "projectId") === projectId) {
              return i
            }
          }
          return -1
        }

        sorters: [
            StringSorter {
                roleName: "name"
                caseSensitivity: Qt.CaseInsensitive
                sortOrder: Qt.AscendingOrder
            }
        ]
    }

    //--------------------------------------------------------------------------
    // Following stuff ensure transfers are finished before logout/exit
    //--------------------------------------------------------------------------

    function logout(saveSimulation) {
        // if simulation is open, ensure to close everything before logout
        closeSimulation(saveSimulation)

        // close all windows
        projectListWindow.visible = false
        simulationWindow.visible = false
        simulationFileBrowserWindow.visible = false
    }

    function quitApplication(saveSimulation) {
        logout(saveSimulation)
        dirManager.cleanTempDirectory()
        Qt.quit()
    }

    function closeSimulationWhenSaveDone() {
        simulationDataController.onSaveDone.disconnect(closeSimulationWhenSaveDone)
        if (studioApp.closeCurrentSimulation()) {
            projectDataController.updateProjectListModel();
            consoleWindow.clear()
        }
    }

    function closeSimulation(save) {
        if (simulationDataController.simulationState === Simulation.Opened) {
            if (save) {
                simulationDataController.onSaveDone.connect(closeSimulationWhenSaveDone)
                saveSimulation()
                return
            }
            if (studioApp.closeCurrentSimulation()) {
                projectDataController.updateProjectListModel();
                consoleWindow.clear()
            }
        }

    }

    Connections {
        target: simulationDataController

        function onSaveProtectedSimulationRequested(
            reason,
            cancelOption,
            cancelAction,
            newOption,
            newAction,
            upgradeOption,
            upgradeAction,
            alwaysUpgradeOption,
            alwaysUpgradeAction) {
            multipleChoiceDialog.text = reason
            multipleChoiceDialog.option1 = cancelOption
            multipleChoiceDialog.lambda1 = cancelAction
            multipleChoiceDialog.option2 = newOption
            multipleChoiceDialog.lambda2 = newAction
            multipleChoiceDialog.option3 = upgradeOption
            multipleChoiceDialog.lambda3 = upgradeAction
            multipleChoiceDialog.option4 = alwaysUpgradeOption
            multipleChoiceDialog.lambda4 = alwaysUpgradeAction
            multipleChoiceDialog.visible = true
        }

        function onExitRequested() {
            // no user confirmation, it's a "force exit", called after
            // user has already confirmed
            quitApplication(false)
        }

        function onError(message) {
            informationWindow.title = qsTr("Error")
            informationWindow.text = message
            informationWindow.visible = true
        }

        function onWarning(message) {
            informationWindow.title = qsTr("Warning")
            informationWindow.text = message
            informationWindow.visible = true
        }
    }


    Connections {
        target: studioApp

        function onInfo(message) {
            informationWindow.title = qsTr("Information")
            informationWindow.text = message
            informationWindow.visible = true
        }

        function onWarning(message) {
            informationWindow.title = qsTr("Warning")
            informationWindow.text = message
            informationWindow.visible = true
        }

        function onError(message) {
            informationWindow.title = qsTr("Error")
            informationWindow.text = message
            informationWindow.visible = true
        }
    }

    Connections {
        target: projectDataController

        function onError(message) {
            informationWindow.title = qsTr("Error")
            informationWindow.text = message
            informationWindow.visible = true
        }

        function onSimulationImported(projectId, simulationId) {
          projectListWindow.projectListView.selectOne(projectId, simulationId, true)
          informationWindow.title = qsTr("Import simulation")
          informationWindow.text = qsTr("Simulation imported successfully.")
          informationWindow.visible = true
        }

        function onOpenExternalDiffEditorRequest(file1, file2) {
            // checks diff tool is declared
            if (userPreferenceController.diffTool() === "") {
                appWindow.createInformationWindow(
                                qsTr("No execution path"),
                                qsTr("External diff tool is not specified.\nyou can set it in Tools/User Preferences."),
                                function() {})
                return;
            }
            // launch the diff tool
            systemTools.executeDetached(userPreferenceController.diffTool(), [file1, file2])
        }

        function onExportJsonSimulationSuccess(exportDirectory) {
            var linkTarget = exportDirectory.toString()
            appWindow.createInformationWindow(
                        qsTr("Export simulation"),
                        qsTr("Simulation exported successfully: <a href=\"") +
                        linkTarget +
                        qsTr("\">open directory</a>."),
                        function() {},
                        function(link) { fileTools.openUrl(linkTarget) })
        }
    }

    //--------------------------------------------------------------------------
    // Close simulation window
    //--------------------------------------------------------------------------

    SaveWindow {
        id: closeSimulationWindow

        title: qsTr("Close simulation")
        text: qsTr("Do you want to save changes to this simulation before closing?\n" +
                   "If you don't save, your changes will be lost.")

        onSaveAndQuit: {
            closeSimulation(true)
            visible = false
        }

        onQuit: {
            closeSimulation(false)
            visible = false
        }

        onRejected: {
            visible = false
        }
    }

    //--------------------------------------------------------------------------
    // Quit application window
    //--------------------------------------------------------------------------

    SaveWindow {
        id: quitApplicationWindow

        title: qsTr("Quit application")
        text: qsTr("Do you want to save changes to this simulation before closing?\n" +
                   "If you don't save, your changes will be lost.")

        onSaveAndQuit: {
            visible = false
            // check if the save will lead to version upgrade
            if (simulationDataController.canSaveWithoutUserConfirmation()) {
                saveSimulation(function() {quitApplication(true)})
            } else {
                // show dialog to ask user if he really wants to save
                simulationDataController.saveSimulationDataThenRaiseExitSignal()
                // do not quit immediately, wait for user choice
            }
        }

        onQuit: {
            visible = false
            quitApplication(false)
        }

        onRejected: {
            visible = false
        }
    }

    function onQuitApplicationEvent() {
        if (simulationDataController.simulationState === Simulation.Opened && simulationDataController.isDataModified) {
            quitApplicationWindow.visible = true
        }
        else {
            appWindow.createValidationWindow(
                        qsTr("Quit application"),
                        qsTr("Are you sure you want to quit application?"),
                        function() { quitApplication(false) })
        }
    }

    //--------------------------------------------------------------------------
    // Quit application because license server is down or unavailable
    //--------------------------------------------------------------------------

    Connections {
        target: licenseManager

        function onLicenseTimeout(message) {
            if (simulationDataController.simulationState === Simulation.Opened) {
                licenseErrorApplicationWindow.text = message + "\n" +
                        "Do you want to save changes to this simulation before closing?\n" +
                        "If you don't save, your changes will be lost."
                licenseErrorApplicationWindow.simulationOpened = true
            }
            else
                licenseErrorApplicationWindow.text = message;
            licenseErrorApplicationWindow.visible = true
        }

        function onLicenseConnectionLost(message) {
            if (simulationDataController.simulationState === Simulation.Opened) {
                licenseErrorApplicationWindow.text = message + "\n" +
                        "Do you want to save changes to this simulation before closing?\n" +
                        "If you don't save, your changes will be lost."
                licenseErrorApplicationWindow.simulationOpened = true
            }
            else
                licenseErrorApplicationWindow.text = message;
            licenseErrorApplicationWindow.visible = true
        }

        function onLicenseConnectionRegain(message) {
            licenseErrorApplicationWindow.visible = false
        }
    }

    LicenseErrorWindow {
        id: licenseErrorApplicationWindow

        title: qsTr("License error")

        onSaveAndQuit: {
            visible = false
            quitApplication(true)
        }

        onQuit: {
            visible = false
            quitApplication(false)
        }
    }

    //--------------------------------------------------------------------------
    // Catch onClosing event
    //--------------------------------------------------------------------------

    onClosing: {
        if(!reloadQML)
        {
            onQuitApplicationEvent()
            close.accepted = false
        }
        // Reloading QML => we only want to close the previous QML window, not closing the application
        else
        {
            reloadQML = false
        }
    }

    //--------------------------------------------------------------------------
    // Geometry tree window
    //--------------------------------------------------------------------------

    GeometryTreeWindow {
        id: geometryTreeWindow
    }

    //--------------------------------------------------------------------------
    // External file selection window
    //--------------------------------------------------------------------------

    ImportFileWindow {
        id: importFileWindow
    }

    ChangeSolverWindow {
        id: changeSolverWindow
    }

    //--------------------------------------------------------------------------
    // Simulation launcher
    //--------------------------------------------------------------------------
    LocalLaunchWindow {
        id: localLaunchWindow
        z: constants.modalWindowZValue
        width: 500

        function displayMissingParameters() {
            if (userPreferenceController.solverExecutionPath() === "") {
                appWindow.createInformationWindow(
                            qsTr("No execution path"),
                            qsTr("Execution path is not specified.\nyou can set it in Tools/User Preferences."),
                            function() {})
                return;
            }

            localLaunchWindow.restart = false
            localLaunchWindow.visible = true
        }

        function runSolverOrDisplayMissingParameters() {
            if (userPreferenceController.solverExecutionPath() === "") {
                appWindow.createInformationWindow(
                            qsTr("No execution path"),
                            qsTr("Execution path is not specified.\nyou can set it in Tools/User Preferences."),
                            function() {})
                return;
            }

            localLaunchWindow.restart = false

            sidmController.getLocalSolverExecutionParameters(userPreferenceSolverParameterModel)
            for (var i = 0; i < userPreferenceSolverParameterModel.count; ++i) {
                // check is parameter value has been saved
                if (userPreferenceSolverParameterModel.getProperty(i, "value") === "") {
                    // need to ask to user
                    localLaunchWindow.visible = true
                    return
                }
            }
            studioApp.launchSimulation(computationController.generateWorkingDir(), userPreferenceSolverParameterModel.getLocalParametersAsMap())
        }
    }

    MultipleChoiceDialog {
        id: multipleChoiceDialog
        z: constants.modalWindowZValue
    }

    //--------------------------------------------------------------------------
    // Open simulation (from project list or running simulations status)
    //--------------------------------------------------------------------------
    function openProjectAndSimulation(projectId, simulationId) {
        if (simulationDataController.simulationState !== Simulation.Closed) {
            console.log("Cannot open simulation: another one is already opened.")
            return
        }
        if (simulationDataController.hasRecoveredSimulation(simulationId)) {
            appWindow.createYesNoQuestionWindow(
                            qsTr("Restore Simulation"),
                            qsTr("Simulation didn't shut down correctly. Would you like to restore unsaved changes ?"),
                            function() { simulationLoadedSuccessfully(studioApp.openSimulation(simulationId, true)) },
                            function() { simulationLoadedSuccessfully(studioApp.openSimulation(simulationId, false)) })
        } else {
            simulationLoadedSuccessfully(studioApp.openSimulation(simulationId, false))
        }
    }

    function simulationLoadedSuccessfully(isLoaded) {
        if (isLoaded) {
            consoleWindow.clear()
        }
    }

    //--------------------------------------------------------------------------
    // Save simulation
    //--------------------------------------------------------------------------

    function saveSimulation(onCompleted) {
        if (simulationDataController.simulationState === Simulation.Opened) {
            simulationWindow.savePreview(function() {studioApp.saveCurrentSimulation(); if (onCompleted) onCompleted()})
        }
    }

    //--------------------------------------------------------------------------
    // Export output file browser
    //--------------------------------------------------------------------------

    Connections {
        target: renderResourceListModel

        function onExportAsCsvFinished(exportDirectory) {
            appWindow.createInformationWindow(
                        qsTr("Export fields"),
                        qsTr("CSV exported successfully: <a href=\"") +
                        exportDirectory.toString() +
                        qsTr("\">open directory</a>."),
                        function() {},
                        function(link) { fileTools.openUrl(exportDirectory) })
        }
    }

    Connections {
        target: geometryListModel

        function onExportMeshesFinished(exportDirectory) {
            appWindow.createInformationWindow(
                    qsTr("Export meshes"),
                    qsTr("Meshes exported successfully: <a href=\"") +
                    exportDirectory.toString() +
                    qsTr("\">open directory</a>."),
                    function() {},
                    function(link) { fileTools.openUrl(exportDirectory) })
        }
    }


    Connections {
        target: computationController

        function onExportNamelistSimulationSuccess(exportDirectory) {
            appWindow.createInformationWindow(
                        qsTr("Export simulation"),
                        qsTr("Simulation exported successfully: <a href=\"") +
                        exportDirectory.toString() +
                        qsTr("\">open directory</a>."),
                        function() {},
                        function(link) { fileTools.openUrl(exportDirectory) })
        }
    }

    //--------------------------------------------------------------------------
    // C++ export output file browser
    //--------------------------------------------------------------------------

    QmlWidgets.WBFileSelectionWindow {
        id: exportCppDialog
        title: qsTr("Export simulation as C++")
        save: true
        nameFilters: ["C++ (*.cpp)"]

        onAccepted: {
            sidmController.exportCppSimulation(file)
        }
    }

    //--------------------------------------------------------------------------
    // Theme color viewer (for dev mode)
    //--------------------------------------------------------------------------

    QmlWidgets.WBThemeColorWindow {
        id: themeColorWindow
        title: qsTr("Display all color for current them")
    }

    //--------------------------------------------------------------------------
    // Import simulation window
    //--------------------------------------------------------------------------

    ImportSimulationWindow {
        id: importSimulationWindow
    }

    //--------------------------------------------------------------------------
    // Create simulation window
    //--------------------------------------------------------------------------

    CreateSimulationWindow {
        id: createSimulationWindow
    }

    //--------------------------------------------------------------------------
    // Create simulation window
    //--------------------------------------------------------------------------

    DeleteSimulationWindow {
        id: deleteSimulationWindow
    }

    //--------------------------------------------------------------------------
    // Duplicate simulation window
    //--------------------------------------------------------------------------

    DuplicateSimulationWindow {
        id: duplicateSimulationWindow
    }

    //--------------------------------------------------------------------------
    // Import file dialog
    //--------------------------------------------------------------------------

    ImportGeometryFilesWindow {
        id: importGeometryFileDialog
    }

    //--------------------------------------------------------------------------
    // IDM parameters edition dialog
    //--------------------------------------------------------------------------
    ParametersDialog {
        id: parametersDialog

        x: applicationWindow.availableWidth / 2 - width / 2
        y: applicationWindow.availableHeight / 2 - height / 2
    }

    //--------------------------------------------------------------------------
    // Generic dialogs "factory"
    //--------------------------------------------------------------------------

    QmlWidgets.WBFolderSelectionWindow {
        id: selectFolderDialog
        property var action
        title: "Select folder"

        onAccepted: {
            action.execute(folder)
        }
    }

    QmlWidgets.WBInputListWindow {
      id: itemSelectionWindow
      property var action

      onAccepted: {
        action.execute(itemSelectionWindow.selectedItem)
      }
    }

    Connections {
        target: studioDialogController

        function onOpenSelectFolderDialogRequest(title, action) {
            selectFolderDialog.title = title
            selectFolderDialog.action = action
            selectFolderDialog.visible = true
        }

        function onYesNoDialogRequest(title, message, action) {
            appWindow.createValidationWindow(
                        title,
                        message,
                        function() {
                            action.execute()
                        })
        }

        function onInformationDialogRequest(title, message) {
            appWindow.createInformationWindow(
                        title,
                        message,
                        function() {})
        }

        function onSelectItemDialogRequest(title, message, items, action) {
          itemSelectionWindow.title = title
          itemSelectionWindow.label = message
          itemSelectionWindow.items = items
          itemSelectionWindow.action = action
          itemSelectionWindow.visible = true
        }

        function onChangeSolverDialogRequest() {
            var solverVariant = simulationListModel.getSimulationProperty(simulationDataController.openedSimulationId, "solver")
            changeSolverWindow.variantModel = simulationDataController.compatibleSolverVariantForMigration(simulationDataController.openedSimulationId, solverVariant)
            changeSolverWindow.defaultSolverVariant = solverVariant
            changeSolverWindow.visible = true
        }

        function onRunSolverOrDisplayMissingParametersRequest() {
            localLaunchWindow.runSolverOrDisplayMissingParameters()
        }

        function onOpenRunSolverDialogRequest() {
            localLaunchWindow.displayMissingParameters()
        }

        function onOpenSelectFolderAndGenerateSolverInputRequest() {
            exportComputationDialog.folder = computationController.generateWorkingDir()
            exportComputationDialog.exportCurrentSimulation = true
            exportComputationDialog.visible = true
        }

        function onOpenAttributesEditionDialogRequest(title, attributeListModel) {
            parametersDialog.title = title
            parametersDialog.attributeListModel = attributeListModel
            parametersDialog.visible = true
        }

    }

    //--------------------------------------------------------------------------
    // Helper function
    //--------------------------------------------------------------------------

    function fitToBoundingBox(viewer, boundingBox) {

        // Reminder: scene and selection bounding boxes are always given in meters
        var scaleFactor = unitSystemController.convert(1.0, "m", unitSystemController.renderingReferenceUnitSymbol, "Length")

        var scaleMatrix = Qt.matrix4x4()
        scaleMatrix.scale(scaleFactor)

        if (boundingBox.isValid()) {
            if (!boundingBox.isNull()) {
                viewer.fitToBoundingBox(boundingBox.transformed(scaleMatrix))
            }
            else {
                var center = boundingBox.center
                viewer.fitToBoundingBox(QtBoundingBoxFactory.fromCenterAndSize(center.x, center.y, center.z, 1.0, 1.0, 1.0).transformed(scaleMatrix))
            }
        }
        else {
            viewer.fitToBoundingBox(QtBoundingBoxFactory.fromCenterAndSize(0, 0, 0, 1.0, 1.0, 1.0).transformed(scaleMatrix))
        }
    }

    function setFocusToCurrentViewer() {
        simulationWindow.currentViewer.forceActiveFocus()
    }

    // Helper function to display vector3d
    function displayVector3d(vect, separator) {

        var precision = 3

        if (sidmController.viewMode === ViewMode.View2D) {
            return vect.x.toPrecision(precision) + separator + vect.y.toPrecision(precision)
        }
        else { // ViewMode.View3D
            return vect.x.toPrecision(precision) + separator + vect.y.toPrecision(precision) + separator + vect.z.toPrecision(precision)
        }
    }
}
