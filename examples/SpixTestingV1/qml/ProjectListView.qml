import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml.Models 2.3

// NF Frameworks
import QtUtilities 1.0
import Nextflow.Studio 1.0
import SortFilterProxyModel 0.2
import "qrc:/widgets/" as QmlWidgets
import "qrc:/tools/" as QmlTools
import "qrc:/js/date.js" as JsDate
import "qrc:/js/utils.js" as JsUtils
import "qrc:/js/algorithm.js" as JsAlgorithm

Item {
    id: root

    property bool detailMode: false
    property alias currentSelection: currentSelection
    property string filteredProjectName: ""
    property string searchedRole: ""
    property string searchedText: ""
    property int stateShiftKey
    property bool filterRecentlyUsed: false

    property string sortRole: "updateDate"
    property int sortOrder: SortOrder.DescendingOrder
    
    function canDeletedSelectedSimulation() {
        for (var i = 0; i < filteredSimulationListModel.count; ++i) {
          if (currentSelection.isSelected(filteredSimulationListModel.get(i, "simulationId"))) {
            if (!filteredSimulationListModel.get(i, "canDelete")) {
              return false
            }
          }
        }
        return currentSelection.count >= 1
    }

    function selectionSize() {
        return currentSelection.count
    }

    SortFilterProxyModel {
        id: filteredSimulationListModel

        sourceModel: simulationListModel

        filters: [
            AllOf {
                ValueFilter {
                    roleName: "projectName"
                    enabled: root.filteredProjectName !== ""
                    value: root.filteredProjectName
                }
                RegExpFilter {
                    roleName: "simulationName"
                    enabled: root.searchedText !== "" && root.searchedRole === "simulationName"
                    caseSensitivity: Qt.CaseInsensitive
                    pattern: "^.*" + root.searchedText
                }
                RegExpContainerFilter {
                    roleName: "tagList"
                    enabled: root.searchedText !== "" && root.searchedRole === "tagList"
                    caseSensitivity: Qt.CaseInsensitive
                    pattern: "^.*" + root.searchedText
                }
                ExpressionFilter {
                    enabled: root.searchedRole === "recentlyUsed"
                    // display last 10 simulations used (using updated date value)
                    expression: updateDate >= simulationListModel.updateDateOfNthLastUpdatedSimulation(10)
                }
                AnyOf {
                    enabled: root.searchedText !== "" && root.searchedRole === "all"

                    RegExpFilter {
                        roleName: "simulationName"
                        enabled: root.searchedText !== "" && root.searchedRole === "all"
                        caseSensitivity: Qt.CaseInsensitive
                        pattern: "^.*" + root.searchedText
                    }
                    RegExpContainerFilter {
                        roleName: "tagList"
                        enabled: root.searchedText !== "" && root.searchedRole === "all"
                        caseSensitivity: Qt.CaseInsensitive
                        pattern: "^.*" + root.searchedText
                    }
                }
            }
        ]

        sorters: [
            StringSorter {
                roleName: root.sortRole
                caseSensitivity: Qt.CaseInsensitive
                sortOrder: root.sortOrder === SortOrder.DescendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
            }
        ]
    }

    ListModel {
        id: currentSelection

        function addToSelection(projectId, simulationId) {
            var index = indexOf(simulationId)
            if (index === -1) {
                append({"projectId": projectId, "simulationId": simulationId})
                addedToSelection(projectId, simulationId)
                selectionChanged()
            }
        }

        function removeFromSelection(projectId, simulationId) {
            var index = indexOf(simulationId)
            if (index >= 0) {
                remove(index)
                removedFromSelection(projectId, simulationId)
                selectionChanged()
            }
        }

        function select(projectId, simulationId) {
            clear()
            addToSelection(projectId, simulationId)
        }

        function indexOf(simulationId) {
            for (var i = 0; i < currentSelection.count; ++i) {
                if (get(i).simulationId === simulationId) {
                    return i
                }
            }
            return -1
        }

        function isSelected(simulationId) {
            return indexOf(simulationId) >= 0
        }

        function isEmpty() {
            return currentSelection.count === 0
        }

        function clear() {
            var ids = []

            for (var i = 0; i < currentSelection.count; ++i) {
                var projectId = currentSelection.get(i).projectId
                var simulationId = currentSelection.get(i).simulationId

                ids.push({"projectId": currentSelection.get(i).projectId, "simulationId": currentSelection.get(i).simulationId})
            }

            for (var i = 0; i < ids.length; ++i) {
                removeFromSelection(ids[i].projectId, ids[i].simulationId)
            }
        }
    }

    signal addedToSelection(var projectId, var simulationId)
    signal removedFromSelection(var projectId, var simulationId)
    signal selectionChanged()

    function selectionExtendUp() {
        var simulations = getVisibleSimulations()
        if (simulations.length > 0) {
            var keys = []
            var selectedIndex
            for (var i = simulations.length - 1; i >= 0; --i) {
                if (currentSelection.isSelected(simulations[i].simulationId)) {
                    selectedIndex = i
                    keys.push(selectedIndex)
                }
            }

            if (stateShiftKey === 0 || keys.length === 1) {
                var k = selectedIndex - 1
                var n = simulations.length
                var nextIndex = ((k % n)+n)%n

                var lastSimulationIndex = simulations.length - 1
                if (currentSelection.isSelected(simulations[0].simulationId) &&
                    currentSelection.isSelected(simulations[lastSimulationIndex].simulationId)) {
                    for (var i = simulations.length - 1; i >= 0; --i) {
                        if (!currentSelection.isSelected(simulations[i].simulationId)) {
                            nextIndex = i
                            break
                        }
                    }
                }

                keys.push(nextIndex)
                stateShiftKey = 0
            }
            else if (stateShiftKey === 1 && keys.length > 1) {
                var lastSimulationIndex = simulations.length - 1
                if (currentSelection.isSelected(simulations[0].simulationId) &&
                    currentSelection.isSelected(simulations[lastSimulationIndex].simulationId)) {
                    keys.length = 0
                    var beforeState = 0
                    for (var i = simulations.length - 1; i >= 0; --i) {
                        if (currentSelection.isSelected(simulations[i].simulationId)) {
                            if (beforeState === 0) {
                                keys.push(i)
                            }
                            beforeState = 0
                        }
                        else {
                            beforeState = 1
                        }
                    }
                }
                else {
                    keys.shift()
                }
                stateShiftKey = 1
            }
            currentSelection.clear()
            for (var j = 0; j < keys.length; ++j) {
                detailView.setSelected(keys[j] , true)
            }
        }
    }

    function selectionExtendDown() {
        var simulations = getVisibleSimulations()
        if (simulations.length > 0) {
            var keys = []
            var selectedIndex
            for (var i = 0; i < simulations.length; ++i) {
                if (currentSelection.isSelected(simulations[i].simulationId)) {
                    selectedIndex = i
                    keys.push(selectedIndex)
                }
            }

            if (stateShiftKey === 1 || keys.length === 1) {
                var nextIndex = (selectedIndex + 1) % simulations.length

                var lastSimulationIndex = simulations.length - 1
                if (currentSelection.isSelected(simulations[0].simulationId) &&
                    currentSelection.isSelected(simulations[lastSimulationIndex].simulationId)) {
                    for (var i = 0; i < simulations.length; ++i) {
                        if (!currentSelection.isSelected(simulations[i].simulationId)) {
                            nextIndex = i
                            break
                        }
                    }
                }

                keys.push(nextIndex)
                stateShiftKey = 1
            }
            else if (stateShiftKey === 0 && keys.length > 1) {
                var lastSimulationIndex = simulations.length - 1
                if (currentSelection.isSelected(simulations[0].simulationId) &&
                    currentSelection.isSelected(simulations[lastSimulationIndex].simulationId)) {
                    keys.length = 0
                    var beforeState = 0
                    for (var i = 0; i < simulations.length; ++i) {
                        if (currentSelection.isSelected(simulations[i].simulationId)) {
                            if (beforeState === 0) {
                                keys.push(i)
                            }
                            beforeState = 0
                        }
                        else {
                            beforeState = 1
                        }
                    }
                }
                else {
                    keys.shift()
                }
                stateShiftKey = 0
            }
            currentSelection.clear()
            for (var j = 0; j < keys.length; ++j) {
                detailView.setSelected(keys[j] , true)
            }
        }
    }

    function selectNextUp() {
        var lastSelectedIndex
        var simulationId
        var simulations = getVisibleSimulations()
        for (var i = simulations.length - 1; i >= 0; --i) {
            simulationId = simulations[i].simulationId
            if (currentSelection.isSelected(simulationId)) {
                lastSelectedIndex = i
            }
            else {
                var lastSimulationIndex = simulations.length - 1
                if (currentSelection.isSelected(simulations[lastSimulationIndex].simulationId)) {
                    break
                }
            }
        }

        var k = lastSelectedIndex - 1
        var n = simulations.length
        var nextIndex = ((k % n)+n)%n
        currentSelection.clear()
        detailView.setSelected(nextIndex , true)
    }

    function selectNextDown() {
        var lastSelectedIndex
        var simulationId
        var simulations = getVisibleSimulations()
        for (var i = 0; i < simulations.length; ++i) {
            simulationId = simulations[i].simulationId
            if (currentSelection.isSelected(simulationId)) {
                lastSelectedIndex = i
            }
            else {
                var lastSimulationIndex = simulations.length - 1
                if (currentSelection.isSelected(simulations[lastSimulationIndex].simulationId)) {
                    break
                }
            }
        }

        var nextIndex = (lastSelectedIndex + 1) % simulations.length
        currentSelection.clear()
        detailView.setSelected(nextIndex , true)
    }


    function selectFirst() {
        currentSelection.clear()
        if (detailView.count > 0) {
            detailView.setSelected(0, true)
        }
    }

    function selectAll() {
        currentSelection.clear()
        var simulations = getVisibleSimulations()
        for (var i = 0; i < simulations.length; ++i) {
            currentSelection.addToSelection(simulations[i].projectId,simulations[i].simulationId)
        }
    }

    function indexOfSimulationListModel(projectId, simulationId) {
        for (var i = 0; i < simulationListModel.count; ++i) {
            if (filteredSimulationListModel.get(i, "projectId") === projectId && filteredSimulationListModel.get(i, "simulationId") === simulationId) {
                return i
            }
        }

        return -1
    }

    function selectOne(projectId, simulationId, positionViewToSelection) {
        currentSelection.clear()
        currentSelection.select(projectId, simulationId)
        if (positionViewToSelection) {
            // position views to selected item
            var index = indexOfSimulationListModel(projectId, simulationId)
            gridView.positionViewAtIndex(index, GridView.Visible)
            detailView.positionViewAtIndex(index, ListView.Visible)
        }
    }

    function openSelectedSimulation() {
        if (currentSelection.count === 1) {
            openProjectAndSimulation(currentSelection.get(0).projectId, currentSelection.get(0).simulationId)
            currentSelection.clear()
        }
    }

    function duplicateSelectedSimulation() {

        console.assert(currentSelection.count == 1)

        duplicateSimulationWindow.duplicateMode = true
        duplicateSimulationWindow.sourceSimulationId = currentSelection.get(0).simulationId
        var index = indexOfSimulationListModel(currentSelection.get(0).projectId, currentSelection.get(0).simulationId)
        var solverVariant = filteredSimulationListModel.get(index, "solver")
        duplicateSimulationWindow.defaultSolverVariant = solverVariant
        duplicateSimulationWindow.defaultSimulationName = simulationDataController.findUniqueSimulationName(filteredSimulationListModel.get(index, "simulationName"))
        duplicateSimulationWindow.variantModel = simulationDataController.compatibleSolverVariantForMigration(duplicateSimulationWindow.sourceSimulationId, solverVariant)
        duplicateSimulationWindow.visible = true
    }

    function exportSelectedSimulation() {
        for (var i = 0; i < currentSelection.count; ++i) {
            exportSimulationDialog.projectId = currentSelection.get(i).projectId
            exportSimulationDialog.simulationId = currentSelection.get(i).simulationId
            exportSimulationDialog.exportCurrentSimulation = false
            exportSimulationDialog.folder = ""
            exportSimulationDialog.visible = true
        }
    }

    function compareSelectedSimulations() {
        projectDataController.generateFilesForComparison(currentSelection.get(0).simulationId,
                                                         currentSelection.get(1).simulationId)
    }

    function isVisible(simulationId) {
        for (var i = 0; i < filteredSimulationListModel.count; ++i) {
            if (filteredSimulationListModel.get(i).simulationId === simulationId) {
                return true
            }
        }
        return false
    }

    function canDelete(simulationId) {
        for (var i = 0; i < filteredSimulationListModel.count; ++i) {
            if (filteredSimulationListModel.get(i).simulationId === simulationId) {
                return filteredSimulationListModel.get(i).canDelete
            }
        }
        return false
    }

    function getVisibleSimulations() {
        var simulations = []
        for (var i = 0; i < filteredSimulationListModel.count; ++i) {
            simulations.push({"projectId": filteredSimulationListModel.get(i).projectId, "simulationId": filteredSimulationListModel.get(i).simulationId})
        }
        return simulations
    }

    function getVisibleSelectedSimulations() {
        var simulations = []
        for (var i = 0; i < filteredSimulationListModel.count; ++i) {
            if (currentSelection.isSelected(filteredSimulationListModel.get(i).simulationId)) {
                simulations.push({"projectId": filteredSimulationListModel.get(i).projectId, "simulationId": filteredSimulationListModel.get(i).simulationId})
            }
        }
        return simulations
    }

    function getSimulationsStatusListCount() {
        // [Pending, Running, Success, Interrupted, Failure]
        var simulationsStatusCount = [0, 0, 0, 0, 0]
        for (var i = 0; i < filteredSimulationListModel.count; ++i) {
            var status = filteredSimulationListModel.get(i, "simulationState")
            if (status)
                simulationsStatusCount[status] += 1
        }
        return simulationsStatusCount
    }

    Connections {
        target: simulationListModel

        function onCountChanged() {
            if (simulationListModel.count > 0) {
                if (currentSelection.isEmpty()) {
                    selectFirst()
                }
            }
            else {
                currentSelection.clear()
            }
        }
    }

    Item {
        id: toolBar

        width: parent.width
        height: constants.toolBarHeight
        anchors.top : root.top

        Rectangle {
            id: rightToolBar
            color: constants.paletteBackgroundColor

            anchors.top: parent.top
            anchors.right: parent.right

            z: 1 // to ensure menus are on top

            ProjectListToolBar {
                anchors.right: parent.right

                // Delete multiples simulations
                onDeleteSimulationClicked: {
                    // store projectId, simulaitionId and simulationName
                    var projectIds = []
                    var simulationIds = []
                    var simulationNames = []

                    for (var i = 0; i < currentSelection.count; ++i) {
                        if (isVisible(currentSelection.get(i).simulationId)) {
                            projectIds.push(currentSelection.get(i).projectId)
                            simulationIds.push(currentSelection.get(i).simulationId)
                            var index = indexOfSimulationListModel(currentSelection.get(i).projectId, currentSelection.get(i).simulationId)
                            simulationNames.push(filteredSimulationListModel.get(index, "simulationName"))
                        }
                    }

                    deleteSimulationWindow.projectIds = projectIds
                    deleteSimulationWindow.simulationIds = simulationIds
                    deleteSimulationWindow.simulationNames = simulationNames
                    deleteSimulationWindow.visible = true
                }
            }
        }
    }

    Item {
        anchors.fill: parent
        clip: true

        Item {
            x: constants.listSortAreaX
            y: constants.listSortAreaY
            width: root.width  - 40
            height: constants.listSortAreaHeight

            ButtonGroup {
                id: criteriaButtonGroup
            }

            QmlWidgets.WBCriteriaButton {
                id: simulationHeader
                x: 20
                y: constants.listSortAreaCriteriaY
                text: qsTr("Simulation")
                ButtonGroup.group: criteriaButtonGroup
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "simulationName"
                }
            }

            QmlWidgets.WBCriteriaButton {
                id: tagHeader
                x: simulationHeader.x + detailView.simulationHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Tags")
                enabled: false
                visible: detailMode
            }


            QmlWidgets.WBCriteriaButton {
                id: updatedHeader
                x: tagHeader.x + detailView.tagHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Last modification")
                ButtonGroup.group: criteriaButtonGroup
                checked: true
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "updateDate"
                }
            }

            QmlWidgets.WBCriteriaButton {
                id: solverHeader
                x: updatedHeader.x + detailView.updatedHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Solver")
                ButtonGroup.group: criteriaButtonGroup
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "solver"
                }
            }

            QmlWidgets.WBCriteriaButton {
                id: statusHeader
                x: solverHeader.x + detailView.solverHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Status")
                ButtonGroup.group: criteriaButtonGroup
                visible: detailMode
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "sortedSimulationState"
                }
            }

            QmlWidgets.WBCriteriaButton {
                id: elapsedTimeHeader
                x: statusHeader.x + detailView.statusHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Elapsed time")
                ButtonGroup.group: criteriaButtonGroup
                visible: detailMode
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "elapsedTime"
                }
            }

            QmlWidgets.WBCriteriaButton {
                id: processCountHeader
                x: elapsedTimeHeader.x + detailView.elapsedTimeHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Process count")
                ButtonGroup.group: criteriaButtonGroup
                visible: detailMode
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "processCount"
                }
            }

            QmlWidgets.WBCriteriaButton {
                id: progressionHeader
                x: processCountHeader.x + detailView.processCountHeaderWidth
                y: constants.listSortAreaCriteriaY
                text: qsTr("Progression")
                ButtonGroup.group: criteriaButtonGroup
                visible: detailMode
                onClicked: {
                    root.sortOrder = sortOrder
                    root.sortRole = "progression"
                }
            }

            // separation line
            Rectangle {
                x: constants.listSortAreaSeparationLineX
                y: constants.listSortAreaSeparationLineY
                width: root.width  - 40
                height: constants.listSortAreaSeparationLineHeight
                color: constants.separationLineColor
            }
        }

        QmlWidgets.WBButtonGroup {
            id: vignetteButtonGroup
            exclusive: false
        }

        GridView {
            id: gridView

            visible: !detailMode

            model: filteredSimulationListModel

            ScrollBar.vertical: QmlWidgets.WBScrollBar {
                policy: parent.contentHeight > parent.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded

                anchors {
                    right: gridView.right
                    top: gridView.top
                    bottom: gridView.bottom
                    rightMargin: 14
                }
            }

            property int marginX: constants.vignetteAreaX + constants.vignetteAreaHorizontalSpacing / 2
            x: Math.floor(marginX + parent.width / 2 - width / 2)
            y: constants.vignetteAreaY + constants.vignetteAreaVerticalSpacing / 2
            width: Math.floor(parent.width / gridView.cellWidth) * gridView.cellWidth
            height: parent.height - y
            clip: true

            cellWidth: constants.vignetteWidth + constants.vignetteAreaHorizontalSpacing
            cellHeight: constants.vignetteHeight + constants.vignetteAreaVerticalSpacing

            function createString(date) {
                var days = JsDate.daySince(date)
                if (days > 0) {
                    return qsTr("Created ") + days + qsTr(" days ago")
                }
                return qsTr("Created today")
            }

            delegate: QmlWidgets.WBSimulationVignette {
                id: delegate
                x: constants.vignetteAreaHorizontalSpacing / 2
                y: constants.vignetteAreaVerticalSpacing / 2

                width: constants.vignetteWidth
                height: constants.vignetteHeight

                buttonGroup: vignetteButtonGroup

                headerText: simulationName
                previewUrl: preview
                property bool warningLicense : !simulationDataController.checkSolverLicense(solver)
                bodyText: solver
                bodyColor : warningLicense ? constants.inputFieldInputAreaErrorBackgroundColor : constants.vignetteBodyTextFontColor
                bodyToolTip : warningLicense  ? "No license found" : bodyText
                subBodyText: gridView.createString(creationDate)
                canDelete: model.canDelete

                property string modelProjectName: projectName

                progressionVisible: hasMonitoring && monitoringInfos.valid
                progression: hasMonitoring && monitoringInfos.valid ? monitoringInfos.progression : 0

                function updateSelection() {
                    var selected = false
                    for (var i = 0; i < currentSelection.count; ++i) {
                        var selectedSimulationId = currentSelection.get(i).simulationId
                        if (selectedSimulationId === model.simulationId) {
                            selected = true
                            break
                        }
                    }
                    delegate.checked = selected
                }

                Connections {
                    target: root

                    function onAddedToSelection() { delegate.updateSelection() }
                    function onRemovedFromSelection() { delegate.updateSelection() }
                }

                Connections {
                    target: simulationListModel

                    function onModelChanged() { delegate.updateSelection() }
                }

                Component.onCompleted: delegate.updateSelection()

                onBodyClicked: {
                    vignetteButtonGroup.unselectAll()
                    currentSelection.select(projectId, simulationId)
                }

                onBodyDoubleClicked: {
                    // Open simulation
                    openProjectAndSimulation(projectId, simulationId)
                }

                onTitleDoubleClicked: {
                    // switch to list view
                    projectListViewSearchBar.text = model.simulationName
                    detailMode = true
                }

                // delete a simulation
                onDeleteClicked: {
                    // store projectId, simulaitionId and simulationName
                    var projectIds = []
                    var simulationIds = []
                    var simulationNames = []

                    if (isVisible(model.simulationId)) {
                        projectIds.push(model.projectId)
                        simulationIds.push(model.simulationId)
                        simulationNames.push(model.simulationName)
                        }

                    deleteSimulationWindow.projectIds = projectIds
                    deleteSimulationWindow.simulationIds = simulationIds
                    deleteSimulationWindow.simulationNames = simulationNames
                    deleteSimulationWindow.visible = true
                }
            }
        }

        ListView {
            id: detailView
            visible: detailMode
            spacing: 0
            clip: true
            cacheBuffer: count * constants.computationTableEntryHeight

            x: constants.listSortAreaX + 10
            y: constants.listSortAreaSeparationLineY + 10
            width: parent.width - x
            height: parent.height - y

            model: filteredSimulationListModel

            ScrollBar.vertical: QmlWidgets.WBScrollBar {
                policy: parent.contentHeight > parent.height ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            }

            readonly property int scrollBarWidth: 14

            readonly property int simulationHeaderWidth: 180
            readonly property int updatedHeaderWidth: 150
            readonly property int solverHeaderWidth: 150
            readonly property int statusHeaderWidth: 80
            readonly property int elapsedTimeHeaderWidth: 100
            readonly property int processCountHeaderWidth: 100
            readonly property int progressHeaderWidth: 80
            readonly property int tagHeaderWidth: 150

            property int lastSelectedIndex: 0

            function setSelected(index, selected) {
                var projectId = filteredSimulationListModel.get(index, "projectId")
                var simulationId = filteredSimulationListModel.get(index, "simulationId")

                if (selected) {
                    currentSelection.addToSelection(projectId, simulationId)
                }
                else {
                    currentSelection.removeFromSelection(projectId, simulationId)
                }
            }

            function isSelected(index) {
                var simulationId = filteredSimulationListModel.get(index, "simulationId")
                return currentSelection.isSelected(simulationId)
            }

            delegate: ProjectListViewRow {
                id: detailItem
                width: detailView.width - detailView.scrollBarWidth
                height: visible ? constants.computationTableEntryHeight : 0

                onClicked: {
                    var doToggle = (mouse.modifiers & Qt.ControlModifier) && (mouse.button & Qt.LeftButton)

                    // release previous selection if CTRL is not pressed and if it's not a right click button on already selected item
                    if (!doToggle) {
                        currentSelection.clear()
                    }

                    if (mouse.modifiers & Qt.ShiftModifier) {
                        var startIndex = Math.min(detailView.lastSelectedIndex, index)
                        var endIndex = Math.max(detailView.lastSelectedIndex, index)
                        for (var i = startIndex; i <= endIndex; ++i) {
                            detailView.setSelected(i, doToggle ? detailView.isSelected(detailView.lastSelectedIndex) : true)
                        }
                    } else {
                        // save index for shift selection
                        detailView.lastSelectedIndex = index
                        detailView.setSelected(index, doToggle ? !detailView.isSelected(index) : true)
                    }
                }

                function updateSelection() {
                    var selected = false
                    for (var i = 0; i < currentSelection.count; ++i) {
                        var selectedSimulationId = currentSelection.get(i).simulationId
                        if (selectedSimulationId === model.simulationId) {
                            selected = true
                            break
                        }
                    }
                    detailItem.checked = selected
                }

                Connections {
                    target: root

                    function onAddedToSelection() {
                        updateAvailableTags()
                        detailItem.updateSelection()
                    }

                    function onRemovedFromSelection() {
                        updateAvailableTags()
                        detailItem.updateSelection()
                    }
                }

                Connections {
                    target: simulationListModel

                    function onModelChanged() {
                        updateAvailableTags()
                        detailItem.updateSelection()
                    }
                }

                Component.onCompleted: detailItem.updateSelection()

                // Delete multiples simulations
                onDeleteRequested: {
                    // store projectId, simulaitionId and simulationName
                    var projectIds = []
                    var simulationIds = []
                    var simulationNames = []

                    for (var i = 0; i < currentSelection.count; ++i) {
                        if (isVisible(currentSelection.get(i).simulationId)) {
                            projectIds.push(currentSelection.get(i).projectId)
                            simulationIds.push(currentSelection.get(i).simulationId)
                            var index = indexOfSimulationListModel(currentSelection.get(i).projectId, currentSelection.get(i).simulationId)
                            simulationNames.push(filteredSimulationListModel.get(index, "simulationName"))
                        }
                    }

                    deleteSimulationWindow.projectIds = projectIds
                    deleteSimulationWindow.simulationIds = simulationIds
                    deleteSimulationWindow.simulationNames = simulationNames
                    deleteSimulationWindow.visible = true
                }

                onOpenSimulationClicked: {
                    currentSelection.clear()
                    openProjectAndSimulation(projectId, simulationId)
                }

                onAddTag: {
                    var simulations = getVisibleSelectedSimulations()
                    for (var i = 0; i < simulations.length; ++i) {
                        var tagList = simulationListModel.getSimulationProperty(simulations[i].simulationId, "tagList")
                        if (!JsAlgorithm.find(tagList, tag)) {
                            tagList.push(tag)
                            simulationDataController.updateSimulationTagList(simulations[i].simulationId, tagList)
                        }
                    }
                    closeMenu()
                }

                onRemoveTag: {
                    var simulations = getVisibleSelectedSimulations()
                    for (var i = 0; i < simulations.length; ++i) {
                        var tagList = simulationListModel.getSimulationProperty(simulations[i].simulationId, "tagList")
                        if (JsAlgorithm.remove(tagList, tag)) {
                            simulationDataController.updateSimulationTagList(simulations[i].simulationId, tagList)
                        }
                    }
                    closeMenu()
                }
            }
        }
    }
}
