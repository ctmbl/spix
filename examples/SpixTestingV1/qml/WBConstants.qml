import QtQuick 2.13

//import "qrc:/js/utils.js" as JsUtils

Item {

    //--------------------------------------------------------------------------
    // FONTS
    //--------------------------------------------------------------------------

    FontLoader { id: b612MonoBold; source: "qrc:/fonts/B612 Mono-Bold.ttf" }
    FontLoader { id: b612MonoBoldItalic; source: "qrc:/fonts/B612 Mono-BoldItalic.ttf" }
    FontLoader { id: b612MonoItalic; source: "qrc:/fonts/B612 Mono-Italic.ttf" }
    FontLoader { id: b612MonoRegular; source: "qrc:/fonts/B612 Mono-Regular.ttf" }
    FontLoader { id: b612Bold; source: "qrc:/fonts/B612-Bold.ttf" }
    FontLoader { id: b612Italic; source: "qrc:/fonts/B612-Italic.ttf" }
    FontLoader { id: b612Regular; source: "qrc:/fonts/B612-Regular.ttf" }

    //--------------------------------------------------------------------------
    // Z VALUES
    //--------------------------------------------------------------------------

    readonly property int windowZValue: 1
    readonly property int headerMenuZValue: 100
    readonly property int modalWindowZValue: 200
    readonly property int popUpZValue: 300
    readonly property int tooltipZValue: 400

    //--------------------------------------------------------------------------
    // ICONS
    //--------------------------------------------------------------------------

    readonly property color iconBaseColor: theme.basicColor2

    // hovered
    readonly property color iconHoveredColor: theme.primaryColor30

    // pressed
    readonly property color iconPressedColor: theme.primaryColor11

    // disabled
    readonly property color iconDisabledColor: theme.primaryColor6

    //--------------------------------------------------------------------------
    // WINDOWS
    //--------------------------------------------------------------------------

    readonly property int windowButtonSpacing: 15
    readonly property color errorColor: theme.accentColor1

    //--------------------------------------------------------------------------
    // MAIN WINDOW
    //--------------------------------------------------------------------------

    readonly property int mainWindowDefaultWidth: 1400
    readonly property int mainWindowDefaultHeight: 900
    readonly property int mainWindowMinimumWidth: 600
    readonly property int mainWindowMinimumHeight: 400
    readonly property color mainWindowGradientStartBackgroundColor: theme.primaryColor3
    readonly property color mainWindowGradientStopBackgroundColor: theme.primaryColor10


    //--------------------------------------------------------------------------
    // MENUS
    //--------------------------------------------------------------------------

    readonly property int menuHeight: 26
    readonly property string menuFontFamily: b612Regular.name
    readonly property int menuFontSize: 13
    readonly property color menuFontColor: theme.basicColor2
    readonly property int menuLeftPadding: 10
    readonly property int menuTopPadding: 3
    readonly property color menuBackgroundColor: theme.basicColor0

    // hovered
    readonly property color menuHoveredFontColor: theme.primaryColor11
    readonly property color menuHoveredBackgroundColor: theme.primaryColor2

    // pressed
    readonly property color menuPressedFontColor: theme.primaryColor11
    readonly property color menuPressedBackgroundColor: theme.primaryColor2

    // disabled
    readonly property color menuDisabledFontColor: theme.primaryColor0
    readonly property color menuDisabledBackgroundColor: theme.primaryColor2

    //--------------------------------------------------------------------------
    // SEPARATION LINE
    //--------------------------------------------------------------------------

    readonly property int separationLineWidth: 2
    readonly property color separationLineColor: theme.primaryColor5

    //--------------------------------------------------------------------------
    // ADVANCED PARAMETERS
    //--------------------------------------------------------------------------

    readonly property color advancedUserLevelColor: theme.primaryColor1

    //--------------------------------------------------------------------------
    // BUTTON 01
    //--------------------------------------------------------------------------

    // size
    readonly property int button01Width: 120
    readonly property int button01Height: 24
    readonly property color button01BorderColor: theme.basicColor2
    readonly property int button01BorderWidth: 1
    readonly property int button01Radius: 6
    readonly property string button01FontFamily: b612Regular.name
    readonly property int button01FontSize: 12
    readonly property color button01FontColor: theme.basicColor2
    readonly property color button01BackgroundColor: theme.basicColor1

    // hovered
    readonly property color button01HoveredFontColor: theme.basicColor2
    readonly property color button01HoveredBackgroundColor: theme.primaryColor30

    // disabled
    readonly property color button01DisabledFontColor: theme.primaryColor37
    readonly property color button01DisabledBackgroundColor: theme.primaryColor36
    readonly property color button01DisabledBorderColor: theme.primaryColor38

    //--------------------------------------------------------------------------
    // BUTTON 02
    //--------------------------------------------------------------------------

    // size
    readonly property int button02Width: 140
    readonly property int button02Height: 30
    readonly property string button02FontFamily: b612Regular.name
    readonly property int button02FontSize: 12
    readonly property color button02FontColor: theme.basicColor2
    readonly property color button02DisabledFontColor: theme.primaryColor14
    readonly property color button02BackgroundColor: theme.basicColor1
    readonly property color button02HoveredBackgroundColor: theme.primaryColor30
    readonly property color button02LineColor: theme.basicColor2
    readonly property color button02DisabledLineColor: theme.primaryColor14

    //--------------------------------------------------------------------------
    // BUTTON 03
    //--------------------------------------------------------------------------

    // size
    readonly property int button03Width: 120
    readonly property int button03Height: 24
    readonly property int button03Radius: 6
    readonly property string button03FontFamily: b612Regular.name
    readonly property int button03FontSize: 12
    readonly property color button03FontColor: theme.basicColor2
    readonly property color button03BackgroundColor: theme.primaryColor7

    // hovered
    readonly property color button03HoveredBackgroundColor: theme.primaryColor30

    // disabled
    readonly property color button03DisabledFontColor: theme.primaryColor9
    readonly property color button03DisabledBackgroundColor: theme.primaryColor4

    //--------------------------------------------------------------------------
    // ARROW BUTTON
    //--------------------------------------------------------------------------

    readonly property color arrowButtonColor: theme.basicColor2
    readonly property color arrowButtonDisabledColor: theme.primaryColor14
    readonly property color arrowButtonHoveredColor: theme.primaryColor11

    //--------------------------------------------------------------------------
    // CheckBox
    //--------------------------------------------------------------------------

    readonly property int checkBoxSize: 12
    readonly property string checkBoxFontFamily: b612Regular.name
    readonly property int checkBoxFontSize: 12
    readonly property color checkBoxFontColor: theme.basicColor2
    readonly property color checkBoxBorderColor: theme.primaryColor18
    readonly property color checkBoxBackgroundPartiallyCheckedColor: theme.primaryColor19
    readonly property color checkBoxBackgroundCheckedColor: theme.primaryColor30

    //--------------------------------------------------------------------------
    // CheckBox2
    //--------------------------------------------------------------------------

    readonly property color checkBox2BackgroundColor: theme.primaryColor4
    readonly property color checkBox2CheckedBackgroundColor: theme.primaryColor11
    readonly property color checkBox2ErrorBackgroundColor: theme.accentColor1
    readonly property color checkBox2DisabledBackgroundColor: theme.primaryColor40

    //--------------------------------------------------------------------------
    // TextField
    //--------------------------------------------------------------------------

    readonly property color textFieldTextColor: theme.basicColor2
    readonly property color textFieldBackgroundColor: theme.basicColor1
    readonly property color textFieldSelectionColor: theme.primaryColor1

    //--------------------------------------------------------------------------
    // Console
    //--------------------------------------------------------------------------

    readonly property int consoleMinimumWidth: 800
    readonly property int consoleMinimumHeight: 350
    readonly property int consoleWidth: 800
    readonly property int consoleHeight: 350

    readonly property int consoleFontSize: 11
    readonly property color consoleFontColor: theme.basicColor2
    readonly property color consoleInfoFontColor: theme.primaryColor43
    readonly property color consoleWarningFontColor: theme.primaryColor44
    readonly property color consoleErrorFontColor: theme.primaryColor45

    //--------------------------------------------------------------------------
    // ContextMenu
    //--------------------------------------------------------------------------

    readonly property string contextMenuFontFamily: b612Regular.name
    readonly property int contextMenuFontSize: 11
    readonly property int contextMenuItemHeight: 24
    readonly property color contextMenuFontColor: theme.basicColor2
    readonly property color contextMenuDisabledFontColor: theme.primaryColor0
    readonly property color contextMenuHoveredFontColor: theme.primaryColor11
    readonly property color contextMenuBackgroundColor: theme.primaryColor7
    readonly property color contextMenuHoveredBackgroundColor: theme.primaryColor21
    readonly property color contextMenuLineColor: theme.primaryColor5
    readonly property color contextMenuArrowColor: theme.basicColor2

    //--------------------------------------------------------------------------
    // DOCUMENT WINDOWS
    //--------------------------------------------------------------------------

    // header
    readonly property int documentWindowHeaderHeight: 22
    readonly property color documentWindowHeaderBackgroundColor: theme.primaryColor1
    readonly property int documentWindowHeaderRadius: 6
    readonly property string documentWindowHeaderFontFamily: b612Regular.name
    readonly property int documentWindowHeaderFontSize: 12
    readonly property color documentWindowHeaderFontColor: theme.primaryColor12
    readonly property color documentWindowHeaderErrorFontColor: theme.accentColor0
    readonly property int documentWindowHeaderTopPadding: 3

    // content
    readonly property color documentWindowContentBackgroundColor: theme.basicColor3

    // icon
    readonly property int documentWindowIconWidth: 20
    readonly property int documentWindowIconHeight: 16
    readonly property color documentWindowIconColor: theme.primaryColor42
    readonly property int documentWindowIconSpacing: 10
    readonly property int documentWindowIconHorizontalMargins: 5

    // icon hovered
    readonly property color documentWindowIconHoveredColor: theme.primaryColor11

    // icon pressed
    readonly property color documentWindowIconPressedColor: theme.primaryColor11

    // icon disabled
    readonly property color documentWindowIconDisabledColor: theme.primaryColor14

    //--------------------------------------------------------------------------
    // TAG VIEW
    //--------------------------------------------------------------------------

    readonly property var colorTable: [
        "#2222bb", "#a52a2a", "#008b8b", "#a9a9a9",
        "#bdb76b", "#8b008b", "#ff8c00", "#9932cc",
        "#e9967a", "#9400d3", "#ff00ff", "#ffd700",
        "#4b0082", "#add8e6", "#90ee90", "#d3d3d3",
        "#800000", "#000080", "#808000",
        "#800080", "#ff0000", "#c0c0c0", "#8b0000",
        "#008000", "#ffb6c1", "#ffa500"
    ]

    function getTagColor(str) {
        /*var index = (JsUtils.hashCode(str) & 0xfffffff) % colorTable.length
        return colorTable[index]*/    
        console.log("[-] WARNING For Example purpose, random tag color removed and always replaced by the same color")
        return colorTable[0]
        
    }

    //--------------------------------------------------------------------------
    // ABOUT WINDOW
    //--------------------------------------------------------------------------

    // size
    readonly property int aboutWindowWidth: 500
    readonly property int aboutWindowHeight: 280

    // content
    readonly property color aboutWindowContentBackgroundColor: theme.primaryColor7

    // text
    readonly property int aboutWindowTextX: 57
    readonly property int aboutWindowTextY: 10
    readonly property int aboutWindowTextWidth: 286
    readonly property int aboutWindowTextHeight: 230
    readonly property string aboutWindowTextFontFamily: b612Regular.name
    readonly property int aboutWindowTextFontSize: 13
    readonly property color aboutWindowTextFontColor: theme.basicColor2
    readonly property int aboutWindowTextTopPadding: 3
    readonly property int aboutWindowTextLeftPadding: 2
    readonly property color aboutWindowTextColor: theme.basicColor1
    readonly property color aboutWindowTextEmptyFontColor: theme.primaryColor6
    readonly property string aboutWindowTextText: qsTr("Password")

    // close button
    readonly property int aboutWindowCloseButtonX: 224
    readonly property int aboutWindowCloseButtonY: 240
    readonly property int aboutWindowCloseButtonWidth: 120
    readonly property int aboutWindowCloseButtonHeight: 24
    readonly property string aboutWindowCloseButtonText: qsTr("Close")

    //--------------------------------------------------------------------------
    // MONITORING WINDOW
    //--------------------------------------------------------------------------

    readonly property int monitoringFontSize: 14

    //--------------------------------------------------------------------------
    // PROJECT LIST WINDOW
    //--------------------------------------------------------------------------

    readonly property color listBackgroundColor: theme.primaryColor7

    //--------------------------------------------------------------------------
    // Preselection list (6.1.2.1)
    //--------------------------------------------------------------------------

    readonly property int preselectionListWidth: 220
    readonly property int preselectionListMaximumWidth: 484
    readonly property int preselectionListHeight: 748
    readonly property int preselectionListSpacing: 30

    //--------------------------------------------------------------------------
    // Preselection text button (6.1.2.1.1)
    //--------------------------------------------------------------------------

    readonly property int preselectionButtonX: 10
    readonly property int preselectionButtonY: 14
    readonly property int preselectionButtonWidth: 160
    readonly property int preselectionButtonHeight: 23
    readonly property string preselectionButtonFontFamily: b612Regular.name
    readonly property int preselectionButtonFontSize: 12
    readonly property color preselectionButtonFontColor: theme.primaryColor12
    readonly property int preselectionButtonRightPadding: 8
    readonly property int preselectionButtonBorderWidth: 0

    // hovered
    readonly property color preselectionButtonHoveredFontColor: theme.primaryColor11

    // pressed
    readonly property color preselectionButtonPressedFontColor: theme.primaryColor11

    // selected
    readonly property int preselectionButtonSelectedFontSize: 14
    readonly property color preselectionButtonSelectedFontColor: theme.basicColor2 // theme.primaryColor12
    readonly property int preselectionButtonSelectedBorderWidth: 4
    readonly property color preselectionButtonSelectedBorderColor: theme.primaryColor11

    // disabled
    readonly property color preselectionButtonDisabledFontColor: theme.primaryColor9

    //--------------------------------------------------------------------------
    // Chip
    //--------------------------------------------------------------------------

    readonly property int listChipMinimumWidth: 26
    readonly property int listChipMaximumWidth: 36
    readonly property int listChipHeight: 16
    readonly property int listChipRadius: 8
    readonly property color listChipColor: theme.primaryColor11
    readonly property string listChipFontFamily: b612Regular.name
    readonly property int listChipFontSize: 10
    readonly property color listChipFontColor: theme.basicColor2
    readonly property int listChipTopPadding: 5       

    //--------------------------------------------------------------------------
    // LIST VIEW (6.1.2.3)
    //--------------------------------------------------------------------------

    // Toolbar (6.1.2.3.1)
    readonly property int listToolBarWidth: 1060
    readonly property int listToolBarHeight: 96

    // icons (6.1.2.3.1.1)
    readonly property int listToolBarIconAreaX: 20
    readonly property int listToolBarIconAreaY: 14 // NF Modification: subtract header size
    readonly property int listToolBarIconAreaWidth: 1020
    readonly property int listToolBarIconAreaHeight: 40

    readonly property int listToolBarIconWidth: 22
    readonly property int listToolBarIconHeight: 16
    readonly property int listToolBarIconSpacing: 10

    readonly property color listIconColor: theme.basicColor2
    readonly property color listIconHoveredColor: theme.primaryColor11
    readonly property color listIconDisabledColor: theme.primaryColor14

    // sort criteria area (6.1.2.3.1.2)
    readonly property int listSortAreaX: 0 // NF Modification (prev: 20)
    readonly property int listSortAreaY: 0 // NF Modification (prev: 40)
    readonly property int listSortWidth: 1020
    readonly property int listSortAreaHeight: 56

    readonly property string listSortAreaFontFamily: b612Regular.name
    readonly property int listSortAreaFontSize: 12
    readonly property int listSortAreaTopPadding: 3

    readonly property color listSortAreaFontColor: theme.primaryColor5
    readonly property color listSortAreaSelectedFontColor: theme.basicColor2
    readonly property color listSortAreaHoveredFontColor: theme.primaryColor11

    readonly property color listSortAreaIconColor: theme.basicColor2
    readonly property int listSortAreaIconSpacing: 6
    readonly property int listSortAreaIconHeight: 14 // NF add

    readonly property int listSortAreaCriteriaY: 48

    readonly property int listSortAreaSeparationLineX: 20
    readonly property int listSortAreaSeparationLineY: 70 // NF Modification (prev: 96)
    readonly property int listSortAreaSeparationLineWidth: 1020
    readonly property int listSortAreaSeparationLineHeight: 1

    // project vignette area (6.1.2.3.2)
    readonly property int vignetteAreaX: 0
    readonly property int vignetteAreaY: 76 // NF Modification (prev: 56)
    readonly property int vignetteAreaWidth: 1060
    readonly property int vignetteAreaHeight: 692
    readonly property int vignetteAreaHorizontalSpacing: 30
    readonly property int vignetteAreaVerticalSpacing: 16

    // vignette
    readonly property int vignetteWidth: 230
    readonly property int vignetteHeight: 244

    readonly property string vignetteFontFamily: b612Regular.name
    readonly property int vignetteFontSize: 12
    readonly property int vignetteTopPadding: 3

    readonly property color vignetteFontColor: theme.basicColor2
    readonly property color vignetteHoveredFontColor: theme.primaryColor11

    // header
    readonly property int vignetteHeaderWidth: 230
    readonly property int vignetteHeaderHeight: 24
    readonly property int vignetteHeaderRadius: 6

    readonly property color vignetteHeaderBackgroundColor: theme.primaryColor1
    readonly property color vignetteHeaderHoveredBackgroundColor: theme.primaryColor11

    // progress radial bar
    readonly property color radialBarProgressColor: theme.primaryColor11
    readonly property color radialBarForegroundColor: "#bec3c7"

    // image
    readonly property int vignetteImageX: 0
    readonly property int vignetteImageY: 24
    readonly property int vignetteImageWidth: 230
    readonly property int vignetteImageHeight: 125
    readonly property color vignetteImageBackgroundColor: theme.primaryColor20 // theme.basicColor0
    readonly property int vignetteImageButtonWidth: 20
    readonly property color vignetteImageButtonHoveredColor: theme.primaryColor11
    readonly property real vignetteImageButtonOpacity: 0.7

    // summary
    readonly property int vignetteSummaryX: 0
    readonly property int vignetteSummaryY: 149
    readonly property int vignetteSummaryWidth: 230
    readonly property int vignetteSummaryHeight: 76
    readonly property color vignetteSummaryBackgroundColor: theme.primaryColor15

    // simulation index button
    readonly property int vignetteSimulationButtonRadius: 10
    readonly property int vignetteSimulationButtonY: 6
    readonly property int vignetteSimulationButtonSpacing: 6 // NF Add
    readonly property color vignetteSimulationButtonColor: theme.primaryColor14
    readonly property color vignetteSimulationButtonErrorColor: theme.accentColor1
    readonly property color vignetteSimulationButtonSelectedColor: theme.primaryColor16
    readonly property color vignetteSimulationButtonSelectedErrorColor: theme.accentColor1

    // simulation name
    readonly property int vignetteBodyTextX: 0
    readonly property int vignetteBodyTextY: 20
    readonly property int vignetteBodyTextWidth: 230
    readonly property int vignetteBodyTextHeight: 20 // NF modification (prev: 54)
    readonly property string vignetteBodyTextFontFamily: b612Regular.name
    readonly property int vignetteBodyTextFontSize: 11
    readonly property color vignetteBodyTextFontColor: theme.basicColor2    
    readonly property int vignetteBodyTextLeftPadding: 6
    readonly property int vignetteBodyTextRightPadding: 6
    readonly property color vignetteBodyTextBackgroundColor: theme.primaryColor15
    readonly property color vignetteBodyTextHoveredBackgroundColor: theme.primaryColor1

    // simulation sub body // NF Add
    readonly property int vignetteSimulationSubBodyX: 0
    readonly property int vignetteSimulationSubBodyY: 40
    readonly property int vignetteSimulationSubBody1Y: 30
    readonly property int vignetteSimulationSubBody2Y: 50
    readonly property int vignetteSimulationSubBodyWidth: 230
    readonly property int vignetteSimulationSubBodyHeight: 40
    readonly property string vignetteSimulationSubBodyFontFamily: b612Italic.name
    readonly property int vignetteSimulationSubBodyFontSize: 10
    readonly property color vignetteSimulationSubBodyFontColor: theme.basicColor2
    readonly property color vignetteSimulationSubBodyHoveredFontColor: theme.primaryColor11
    readonly property int vignetteSimulationSubBodyLeftPadding: 6
    readonly property int vignetteSimulationSubBodyRightPadding: 6
    readonly property color vignetteSimulationSubBodyBackgroundColor: theme.primaryColor15

    // footer
    readonly property int vignetteFooterX: 0
    readonly property int vignetteFooterY: 225
    readonly property int vignetteFooterWidth: 230
    readonly property int vignetteFooterHeight: 19
    readonly property int vignetteFooterRadius: 6
    readonly property color vignetteFooterBackgroundColor: theme.primaryColor15

    // progress bar
    readonly property int vignetteCalculationProgressBarX: 3
    readonly property int vignetteCalculationProgressBarY: 3
    readonly property int vignetteCalculationProgressBarWidth: 190
    readonly property int vignetteCalculationProgressBarHeight: 14
    readonly property int vignetteCalculationProgressBarRadius: 5
    readonly property color vignetteCalculationProgressBarColor: theme.primaryColor13
    readonly property string vignetteCalculationProgressBarFontFamily: b612Italic.name
    readonly property int vignetteCalculationProgressBarFontSize: 8
    readonly property color vignetteCalculationProgressBarFontColor: theme.basicColor2
    readonly property int vignetteCalculationProgressBarLeftPadding: 6
    readonly property int vignetteCalculationProgressBarTopPadding: 2 // NF Modification (prev: 6)

    readonly property int vignetteCalculationProgressTextX: 193
    readonly property int vignetteCalculationProgressTextY: 3
    readonly property int vignetteCalculationProgressTextWidth: 34
    readonly property int vignetteCalculationProgressTextHeight: 14
    readonly property int vignetteCalculationProgressTextRadius: 5
    readonly property color vignetteCalculationProgressTextBackgroundColor: theme.primaryColor17
    readonly property string vignetteCalculationProgressTextFontFamily: b612Italic.name
    readonly property int vignetteCalculationProgressTextFontSize: 8
    readonly property color vignetteCalculationProgressTextFontColor: theme.basicColor2
    readonly property int vignetteCalculationProgressTextLeftPadding: 6
    readonly property int vignetteCalculationProgressTextTopPadding: 2 // NF Modification (prev: 6)
    readonly property int vignetteMenuWidth: 120

    //--------------------------------------------------------------------------
    // POPUP MENU
    //--------------------------------------------------------------------------

    // menu

    readonly property int popupMenuItemHeight: 22
    readonly property color popupMenuBackgroundColor: theme.primaryColor1
    readonly property color popupMenuHoveredBackgroundColor: theme.primaryColor21
    readonly property int popupMenuSeparationHeight: 1
    readonly property color popupMenuSeparationColor: theme.primaryColor18
    readonly property string popupMenuFontFamily: b612Regular.name
    readonly property int popupMenuFontSize: 12
    readonly property color popupMenuFontColor: theme.basicColor2
    readonly property color popupMenuHoveredFontColor: theme.primaryColor11
    readonly property int popupMenuLeftPadding: 5
    readonly property int popupMenuTopPadding: 3
    readonly property int popupMenuWidth: 130

    //--------------------------------------------------------------------------
    // GEOMETRY BROWSER WINDOW
    //--------------------------------------------------------------------------

    readonly property int geometryBrowserStartWidth: 800
    readonly property int geometryBrowserStartHeight: 660
    readonly property color geometryBrowserBackgroundColor: theme.primaryColor7
    readonly property real geometryBrowserBackgroundOpacity: 0.8

    //--------------------------------------------------------------------------
    // MESHING OPERATION MANAGER WINDOW
    //--------------------------------------------------------------------------

    readonly property int meshingOperationManagerWidth: 800
    readonly property int meshingOperationManagerHeight: 660
    readonly property int meshingOperationManagerListViewWidth: 340
    readonly property int meshingOperationManagerListViewHeight: 300

    //--------------------------------------------------------------------------
    // IMPORT GEOMETRY WINDOW
    //--------------------------------------------------------------------------

    readonly property int importGeometryWindowWidth: 1000
    readonly property int importGeometryWindowHeight: 480
    readonly property color importGeometryWindowBackgroundColor: theme.primaryColor7

    // 3d viewer
    readonly property int importGeometryViewerX: 0
    readonly property int importGeometryViewerY: 0
    readonly property int importGeometryViewerWidth: 600
    readonly property int importGeometryViewerHeight: 430

    // separation line
    readonly property int importGeometrySeparationLineX: 600
    readonly property int importGeometrySeparationLineY: 30
    readonly property int importGeometrySeparationLineWidth: 1
    readonly property int importGeometrySeparationLineHeight: 380

    // tree view
    readonly property int importGeometryTreeViewX: 610
    readonly property int importGeometryTreeViewY: 30
    readonly property int importGeometryTreeViewWidth: 350
    readonly property int importGeometryTreeViewHeight: 380

    // cancel button
    readonly property int importGeometryCloseButtonX: 30
    readonly property int importGeometryCloseButtonY: 440

    // skip button
    readonly property int importGeometrySkipButtonX: 490
    readonly property int importGeometrySkipButtonY: 440
    readonly property int importGeometrySkipButtonWidth: 140

    // import as single button
    readonly property int importGeometryImportAsSingleButtonX: 650
    readonly property int importGeometryImportAsSingleButtonY: 440
    readonly property int importGeometryImportAsSingleButtonWidth: 140

    // import as multiple button
    readonly property int importGeometryImportAsMultipleButtonX: 810
    readonly property int importGeometryImportAsMultipleButtonY: 440
    readonly property int importGeometryImportAsMultipleButtonWidth: 140

    //--------------------------------------------------------------------------
    // VIEW BROWSER WINDOW
    //--------------------------------------------------------------------------

    readonly property int viewBrowserStartX: 320
    readonly property int viewBrowserStartY: 85
    readonly property int viewBrowserStartWidth: 400
    readonly property int viewBrowserStartHeight: 150
    readonly property color viewBrowserBackgroundColor: theme.primaryColor7
    readonly property real viewBrowserBackgroundOpacity: 0.8

    //--------------------------------------------------------------------------
    // NEW PROJECT WINDOW // NF add
    //--------------------------------------------------------------------------

    readonly property int newProjectWindowWidth: 1000
    readonly property int newProjectWindowHeight: 380

    // cancel button
    readonly property int newProjectWindowCancelButtonX: 30
    readonly property int newProjectWindowCancelButtonY: 337

    // accept button
    readonly property int newProjectWindowAcceptButtonX: 860
    readonly property int newProjectWindowAcceptButtonY: 337

    // content
    readonly property color newProjectWindowContentBackgroundColor: theme.primaryColor7

    readonly property int newProjectWindowLeftPadding: 5
    readonly property string newProjectWindowFontFamily: b612Regular.name
    readonly property int newProjectWindowFontSize: 12

    readonly property int newProjectWindowTextWidth: 140
    readonly property int newProjectWindowTextHeight: 24
    readonly property int newProjectWindowTextFieldWidth: 340
    readonly property color newProjectWindowTextFontColor: theme.primaryColor19
    readonly property color newProjectWindowTextFieldFontColor: theme.primaryColor35
    readonly property color newProjectWindowTextFieldBackgroundColor: theme.primaryColor20


    readonly property int newProjectWindowTextNameX: 0
    readonly property int newProjectWindowTextNameY: 30

    readonly property int newProjectWindowTextFieldX: 160

    readonly property int newProjectWindowTextFieldNameY: 30

    readonly property int newProjectWindowTextDescriptionX: 0
    readonly property int newProjectWindowTextDescriptionY: 80

    readonly property int newProjectWindowTextUserX: 0
    readonly property int newProjectWindowTextUserY: 254

    readonly property int newProjectWindowTextUserValueX: 160
    readonly property int newProjectWindowTextUserValueY: 254
    readonly property color newProjectWindowTextUserValueFontColor: theme.basicColor2

    readonly property int newProjectWindowTextFieldDescriptionY: 80
    readonly property int newProjectWindowTextFieldDescriptionHeight: 150

    //--------------------------------------------------------------------------
    // NEW SIMULATION WINDOW // NF add
    //--------------------------------------------------------------------------

    readonly property int newSimulationWindowWidth: 600
    readonly property int newSimulationWindowHeight: 200

    // cancel button
    readonly property int newSimulationWindowCancelButtonX: 450
    readonly property int newSimulationWindowCancelButtonY: 157

    // accept button
    readonly property int newSimulationWindowAcceptButtonX: 30
    readonly property int newSimulationWindowAcceptButtonY: 157

    // content
    readonly property color newSimulationWindowContentBackgroundColor: theme.primaryColor7

    readonly property int newSimulationWindowLeftPadding: 5
    readonly property string newSimulationWindowFontFamily: b612Regular.name
    readonly property int newSimulationWindowFontSize: 12

    readonly property int newSimulationWindowTextWidth: 200
    readonly property int newSimulationWindowTextHeight: 24
    readonly property int newSimulationWindowTextFieldWidth: 320
    readonly property color newSimulationWindowTextFontColor: theme.primaryColor19
    readonly property color newSimulationWindowTextFieldBackgroundColor: theme.primaryColor4

    readonly property int newSimulationWindowTextNameX: 0
    readonly property int newSimulationWindowTextNameY: 30

    readonly property int newSimulationWindowTextFieldNameX: 220
    readonly property int newSimulationWindowTextFieldNameY: 30

    readonly property int newSimulationWindowTextSolverX: 0
    readonly property int newSimulationWindowTextSolverY: 80

    readonly property int newSimulationWindowComboBoxSolverX: 220
    readonly property int newSimulationWindowComboBoxSolverY: 80
    readonly property int newSimulationWindowComboBoxSolverWidth: 200

    //--------------------------------------------------------------------------
    // 3D VIEWER
    //--------------------------------------------------------------------------

    readonly property color viewerFontColor: theme.primaryColor7
    readonly property string viewerFontFamily: b612Bold.name
    readonly property int viewerFontSize: 12

    //--------------------------------------------------------------------------
    // WINDOW HEADER
    //--------------------------------------------------------------------------

    // header
    readonly property int windowHeaderHeight: 23
    readonly property int windowHeaderRadius: 4
    readonly property color windowHeaderBackgroundColor: theme.primaryColor1
    readonly property real windowHeaderOpacity: 0.8
    readonly property string windowHeaderFontFamily: b612Regular.name
    readonly property int windowHeaderFontSize: 11
    readonly property color windowHeaderFontColor: theme.primaryColor12
    readonly property int windowHeaderTopPadding: 3

    //--------------------------------------------------------------------------
    // WINDOW FOOTER
    //--------------------------------------------------------------------------

    // header
    readonly property int windowFooterHeight: 22
    readonly property color windowFooterBackgroundColor: theme.primaryColor1
    readonly property string windowFooterFontFamily: b612Regular.name
    readonly property int windowFooterFontSize: 11
    readonly property color windowFooterFontColor: theme.primaryColor12
    readonly property int windowFooterTopPadding: 3
    readonly property int windowFooterHorizontalPadding: 3

    //--------------------------------------------------------------------------
    // PROGRESS WINDOW
    //--------------------------------------------------------------------------

    readonly property int progressWindowWidth: 340
    readonly property int progressWindowHeight: 105

    // content
    readonly property color progressWindowContentBackgroundColor: theme.primaryColor1
    readonly property int progressWindowContentRadius: 4
    readonly property real progressWindowContentOpacity: 0.3

    // text
    readonly property int progressWindowTextY: 12
    readonly property int progressWindowTextHeight: 20
    readonly property color progressWindowTextBackgroundColor: theme.basicColor1
    readonly property int progressWindowTextTopPadding: 3
    readonly property string progressWindowTextFontFamily: b612Regular.name
    readonly property int progressWindowTextFontSize: 12
    readonly property color progressWindowTextFontColor: theme.primaryColor19

    // step text
    readonly property int progressWindowStepTextX: 20
    readonly property int progressWindowStepTextWidth: 280

    // progress text
    readonly property int progressWindowProgressTextX: 280
    readonly property int progressWindowProgressTextWidth: 20

    // progress bar
    readonly property int progressWindowProgressBarX: 20
    readonly property int progressWindowProgressBarY: 40
    readonly property int progressWindowProgressBarWidth: 300
    readonly property int progressWindowProgressBarHeight: 4
    readonly property int progressWindowProgressBarRadius: 2
    readonly property color progressWindowProgressBarBackgroundColor: theme.primaryColor29
    readonly property real progressWindowProgressBarOpacity: 0.8
    readonly property color progressWindowProgressBarActiveColor: theme.primaryColor19

    // cancel button
    readonly property int progressWindowCancelButtonX: 110
    readonly property int progressWindowCancelButtonY: 65
    readonly property int progressWindowCancelButtonWidth: 120
    readonly property int progressWindowCancelButtonHeight: 24      

    //--------------------------------------------------------------------------
    // INFORMATION WINDOW // NF add
    //--------------------------------------------------------------------------

    readonly property int messageWindowWidth: 340
    readonly property int messageWindowHeight: 105

    // header
    readonly property int messageWindowHeaderHeight: 23
    readonly property int messageWindowHeaderRadius: 4
    readonly property color messageWindowHeaderBackgroundColor: theme.primaryColor1
    readonly property real messageWindowHeaderOpacity: 0.9
    readonly property string messageWindowHeaderFontFamily: b612Regular.name
    readonly property int messageWindowHeaderFontSize: 11
    readonly property color messageWindowHeaderFontColor: theme.primaryColor12
    readonly property int messageWindowHeaderTopPadding: 3

    // content
    readonly property color messageWindowContentBackgroundColor: theme.primaryColor7
    readonly property int messageWindowContentRadius: 4
    readonly property real messageWindowContentOpacity: 0.7

    // text
    readonly property int messageWindowTextX: 20
    readonly property int messageWindowTextY: 12
    readonly property int messageWindowTextWidth: 300
    readonly property int messageWindowTextHeight: 20

    // textfield
    readonly property int messageWindowTextFieldX: 57
    readonly property int messageWindowTextFieldY: 12
    readonly property int messageWindowTextFieldWidth: 226
    readonly property int messageWindowTextFieldHeight: 20
    readonly property color messageWindowTextFieldEmptyFontColor: theme.primaryColor6

    // horizontal line
    readonly property int messageWindowHorizontalLineX: 16
    readonly property int messageWindowHorizontalLineY: 43
    readonly property int messageWindowHorizontalLineWidth: 308
    readonly property int messageWindowHorizontalLineHeight: 1
    readonly property color messageWindowHorizontalLineColor: theme.primaryColor5


    readonly property color messageWindowTextBackgroundColor: theme.basicColor1
    readonly property int messageWindowTextTopPadding: 3
    readonly property string messageWindowTextFontFamily: b612Regular.name
    readonly property int messageWindowTextFontSize: 12
    readonly property color messageWindowTextFontColor: theme.primaryColor19

    readonly property int messageWindowButtonY: 65
    readonly property int messageWindowButtonWidth: 120
    readonly property int messageWindowButtonHeight: 24

    // left button
    readonly property int messageWindowLeftButtonX: 30

    // right button
    readonly property int messageWindowRightButtonX: 190

    // center button
    readonly property int messageWindowCenterButtonX: 110

    //--------------------------------------------------------------------------
    // QUIT APPLICATION WINDOW
    //--------------------------------------------------------------------------

    readonly property int quitApplicationWindowWidth: 480

    readonly property int quitApplicationWindowSaveAndQuitButtonX: 30
    readonly property int quitApplicationWindowQuitButtonX: 180
    readonly property int quitApplicationWindowCancelButtonX: 330

    // text
    readonly property int quitApplicationWindowTextX: 20
    readonly property int quitApplicationWindowTextY: 12
    readonly property int quitApplicationWindowTextWidth: 440
    readonly property int quitApplicationWindowTextHeight: 20

    //--------------------------------------------------------------------------
    // PALETTE WINDOW
    //--------------------------------------------------------------------------

    // header
    readonly property int paletteWindowHeaderHeight: 22
    readonly property int paletteWindowHeaderRadius: 6
    readonly property color paletteWindowHeaderBackgroundColor: theme.primaryColor1
    readonly property string paletteWindowHeaderFontFamily: b612Regular.name
    readonly property int paletteWindowHeaderFontSize: 11
    readonly property color paletteWindowHeaderFontColor: theme.primaryColor12
    readonly property int paletteWindowHeaderTopPadding: 3
    readonly property int paletteWindowHeaderLeftPadding: 30

    // icon
    readonly property int paletteWindowIconWidth: 14
    readonly property int paletteWindowIconHeight: 14
    readonly property int paletteWindowIconSpacing: 10
    readonly property int paletteWindowIconHorizontalMargins: 5

    //--------------------------------------------------------------------------
    // TOOLBAR
    //--------------------------------------------------------------------------

    readonly property int toolBarWidth: 950
    readonly property int toolBarHeight: 28
    readonly property real toolBarMovingOpacity: 0.5

    // default indicator
    readonly property int toolBarErrorIndicatorWidth: 14
    readonly property int toolBarErrorIndicatorHeight: 30

    readonly property color toolBarErrorIndicatorBorderColor: theme.primaryColor5
    readonly property int toolBarErrorIndicatorBorderWidth: 1

    //--------------------------------------------------------------------------
    // ERROR INDICATOR COLORS
    //--------------------------------------------------------------------------

    readonly property color errorIndicatorNoErrorColor: theme.accentColor4
    readonly property color errorIndicatorErrorColor: theme.accentColor1
    readonly property color errorIndicatorBorderColor: theme.primaryColor7

    //--------------------------------------------------------------------------
    // TOOLBAR
    //--------------------------------------------------------------------------

    readonly property int toolBarIconWidth: 20
    readonly property int toolBarIconHeight: 20

    //--------------------------------------------------------------------------
    // CONTEXT TOOLBAR
    //--------------------------------------------------------------------------

    readonly property int contextToolBarButtonWidth: 80
    readonly property int contextToolBarButtonHeight: 60

    readonly property int contextToolBarButtonErrorIndicatorX: 2
    readonly property int contextToolBarButtonErrorIndicatorY: 2
    readonly property int contextToolBarButtonErrorIndicatorWidth: 4
    readonly property int contextToolBarButtonErrorIndicatorHeight: 56

    // icon
    readonly property int contextToolBarButtonIconX: 6
    readonly property int contextToolBarButtonIconY: 4
    readonly property int contextToolBarButtonIconWidth: 74
    readonly property int contextToolBarButtonIconHeight: 28

    readonly property int contextToolBarIconWidth: 22
    readonly property int contextToolBarIconHeight: 22

    // text
    readonly property int contextToolBarButtonTextX: 6
    readonly property int contextToolBarButtonTextY: 28
    readonly property int contextToolBarButtonTextWidth: 74
    readonly property int contextToolBarButtonTextHeight: 32
    readonly property string contextToolBarButtonFontFamily: b612Regular.name
    readonly property int contextToolBarButtonFontSize: 10
    readonly property int contextToolBarButtonRightPadding: 2
    readonly property int contextToolBarButtonLeftPadding: 2

    //--------------------------------------------------------------------------
    // TIMELINE
    //--------------------------------------------------------------------------

    readonly property color timelineBackgroundColor: theme.primaryColor23

    //--------------------------------------------------------------------------
    // SCRIPT WINDOW
    //--------------------------------------------------------------------------

    readonly property color scriptingTextEditBackgroundColor: "#282A36"
    readonly property color scriptingTextEditFontColor: "#FFFFFF"
    readonly property color scriptingToolBarBackgroundColor: theme.primaryColor23


    //--------------------------------------------------------------------------
    // TABBAR
    //--------------------------------------------------------------------------

    readonly property color tabBarBackgroundColor: theme.primaryColor23
    readonly property color tabBarHoveredBackgroundColor: theme.primaryColor39

    //--------------------------------------------------------------------------
    // GENERIC GRAPHICS STYLES
    //--------------------------------------------------------------------------

    // palette background
    readonly property real paletteBackgroundOpacity: 0.8 // NF modification (prev: 0.9)
    readonly property real paletteBackgroundMovingOpacity: 0.5 // NF add
    readonly property color paletteBackgroundColor: theme.primaryColor7
    readonly property int paletteBackgroundBorderWidth: 1
    readonly property color paletteBackgroundBorderColor: theme.primaryColor5

    // tools menu
    readonly property color toolsMenuBackgroundColor: theme.primaryColor7
    readonly property string toolsMenuFontFamily: b612Regular.name
    readonly property int toolsMenuFontSize: 12
    readonly property color toolsMenuFontColor: theme.basicColor2
    readonly property int toolsMenuLeftPadding: 5
    readonly property int toolsMenuTopPadding: 3

    // tools menu disabled
    readonly property color toolsMenuDisabledBackgroundColor: theme.primaryColor7
    readonly property string toolsMenuDisabledFontFamily: b612Regular.name
    readonly property int toolsMenuDisabledFontSize: 12
    readonly property color toolsMenuDisabledFontColor: theme.primaryColor14
    readonly property int toolsMenuDisabledLeftPadding: 5
    readonly property int toolsMenuDisabledTopPadding: 3

    // background and text highlight
    readonly property color highlightBackgroundColor: theme.primaryColor21
    readonly property string highlightFontFamily: b612Regular.name
    readonly property int highlightFontSize: 12
    readonly property color highlightFontColor: theme.primaryColor11

    // normal menu item
    readonly property color normalMenuItemBackgroundColor: theme.primaryColor7
    readonly property string normalMenuItemFontFamily: b612Regular.name
    readonly property int normalMenuItemFontSize: 12
    readonly property color normalMenuItemFontColor: theme.basicColor2
    readonly property int normalMenuItemLeftPadding: 2
    readonly property int normalMenuItemTopPadding: 3

    // highlight menu item
    readonly property color highlightMenuItemBackgroundColor: theme.primaryColor21 // fix theme.primaryColor7
    readonly property string highlightMenuItemFontFamily: b612Regular.name
    readonly property int highlightMenuItemFontSize: 12
    readonly property color highlightMenuItemFontColor: theme.primaryColor11
    readonly property int highlightMenuItemLeftPadding: 5
    readonly property int highlightMenuItemTopPadding: 3

    // disabled menu item
    readonly property color disabledMenuItemBackgroundColor: theme.primaryColor7 // to fix
    readonly property string disabledMenuItemFontFamily: b612Regular.name
    readonly property int disabledMenuItemFontSize: 12
    readonly property color disabledMenuItemFontColor: theme.primaryColor14
    readonly property int disabledMenuItemLeftPadding: 5
    readonly property int disabledMenuItemTopPadding: 3

    // normal icon
    readonly property color normalIconColor: theme.basicColor2

    // highlight icon
    readonly property color highlightIconColor: theme.primaryColor11

    // disabled icon
    readonly property color disabledIconColor: theme.primaryColor14

    //--------------------------------------------------------------------------
    // SCROLL INDICATOR
    //--------------------------------------------------------------------------

    readonly property color scrollBarIndicatorColor: theme.primaryColor6
    readonly property color hoveredScrollBarIndicatorColor: theme.primaryColor11

    //--------------------------------------------------------------------------
    // SLIDER
    //--------------------------------------------------------------------------

    readonly property color sliderHandleColor: theme.primaryColor6
    readonly property color sliderHoveredHandleColor: theme.primaryColor11
    readonly property color sliderDisabledHandleColor: theme.primaryColor40
    readonly property color sliderBackgroundColor: theme.primaryColor11
    readonly property color sliderDisabledBackgroundColor: theme.primaryColor27

    //--------------------------------------------------------------------------
    // OPERATOR WINDOWS
    //--------------------------------------------------------------------------

    readonly property color operatorListViewBackgroundColor: theme.primaryColor20
    readonly property color operatorListViewErrorBackgroundColor: theme.accentColor1
    readonly property int operatorLeftPadding: 5
    readonly property int operatorVolumeTopPadding: 2
    readonly property string operatorFontFamily: b612Regular.name
    readonly property int operatorFontSize: 11
    readonly property color operatorListViewFontColor: theme.basicColor2

    readonly property int operatorListViewWidth: 200
    readonly property int operatorListViewHeight: 200
    readonly property int operatorListViewTextHeight: 22


    //--------------------------------------------------------------------------
    // FILL VOLUME WINDOW
    //--------------------------------------------------------------------------

    // content    
    readonly property int fillVolumeTypeFieldX: 100

    readonly property color fillVolumeTextFontColor: theme.primaryColor19

    readonly property int fillVolumeTextFieldX: 255
    readonly property color fillVolumeTextFieldBackgroundColor: theme.primaryColor20

    readonly property int fillVolumeResultFieldX: 100

    // buttons
    readonly property int fillVolumeWindowCancelButtonX: 340
    readonly property int fillVolumeClearButtonX: 157
    readonly property int fillVolumeWindowAcceptButtonX: 30

    //--------------------------------------------------------------------------
    // INPUT FIELD
    //--------------------------------------------------------------------------

    // header
    readonly property int inputFieldHeaderWidth: 320
    readonly property int inputFieldHeaderHeight: 24
    readonly property color inputFieldHeaderBackgroundColor: theme.primaryColor23
    readonly property color inputFieldHeaderDisabledBackgroundColor: theme.primaryColor8
    readonly property int inputFieldHeaderTitleLeftPadding: 12
    readonly property int inputFieldHeaderTitleTopPadding: 7
    readonly property string inputFieldHeaderTitleFontFamily: b612Regular.name
    readonly property color inputFieldHeaderTitleFontColor: theme.primaryColor24
    readonly property int inputFieldHeaderTitleFontSize: 13
    readonly property int inputFieldHeaderErrorIndicatorX: 2
    readonly property int inputFieldHeaderErrorIndicatorWidth: 5
    readonly property int inputFieldHeaderErrorIndicatorHeight: 24
    readonly property color inputFieldHeaderErrorIndicatorColor: theme.accentColor1
    readonly property int inputFieldHeaderDeployButtonY: 8
    readonly property int inputFieldHeaderDeployButtonWidth: 14
    readonly property int inputFieldHeaderDeployButtonHeight: 8
    readonly property color inputFieldHeaderIconColor: theme.basicColor2
    readonly property color inputFieldHeaderHoveredIconColor: theme.primaryColor11

    // constants
    readonly property int inputFieldContentY: 4 // NF Add
    readonly property int inputFieldContentWidth: 320
    readonly property int inputFieldContentHeight: 26 // NF modification (prev: 18)

    readonly property int inputFieldLabelWidth: 160
    readonly property int inputFieldLabelHeight: 18
    readonly property int inputFieldLabelLeftPadding: 10
    readonly property int inputFieldLabelRightPadding: 10
    readonly property int inputFieldLabelTopPadding: 2
    readonly property string inputFieldLabelFontFamily: b612Regular.name
    readonly property color inputFieldLabelFontColor: theme.basicColor2
    readonly property color inputFieldDisabledLabelFontColor: theme.primaryColor14
    readonly property int inputFieldLabelFontSize: 11
    readonly property int inputFieldRadius: 3

    readonly property int inputFieldLeftButtonX: 160
    readonly property int inputFieldButtonWidth: 18
    readonly property int inputFieldButtonHeight: 18    

    readonly property int inputFieldInputAreaX: 178
    readonly property int inputFieldInputAreaWidth: 120
    readonly property int inputFieldInputAreaHeight: 18
    readonly property color inputFieldInputAreaBackgroundColor: theme.primaryColor4
    readonly property color inputFieldInputAreaHoveredBackgroundColor: theme.primaryColor21
    readonly property color inputFieldInputAreaErrorBackgroundColor: theme.accentColor1
    readonly property color inputFieldInputAreaDisabledBackgroundColor: theme.primaryColor40
    readonly property int inputFieldInputAreaLeftPadding: 2
    readonly property int inputFieldInputAreaRightPadding: 2
    readonly property int inputFieldInputAreaTopPadding: 2
    readonly property string inputFieldInputAreaFontFamily: b612Regular.name
    readonly property string inputFieldInputAreaItalicFontFamily: b612MonoItalic.name
    readonly property color inputFieldInputAreaFontColor: theme.primaryColor31
    readonly property color inputFieldInputAreaErrorFontColor: theme.primaryColor22
    readonly property color inputFieldInputAreaDisabledFontColor: theme.primaryColor41
    readonly property color inputFieldInputAreaHoveredFontColor: theme.primaryColor11
    readonly property int inputFieldInputAreaFontSize: 11
    readonly property color inputFieldInputAreaSelectionColor: theme.primaryColor11

    readonly property int inputFieldButtonAreaX: 103
    readonly property int inputFieldButtonAreaWidth: 14
    readonly property int inputFieldButtonAreaHeight: 18
    readonly property color inputFieldButtonAreaBackgroundColor: theme.primaryColor27
    readonly property color inputFieldButtonAreaDisabledBackgroundColor: theme.primaryColor4

    readonly property color inputFieldButtonIconColor: theme.primaryColor26
    readonly property color inputFieldButtonHoveredIconColor: theme.primaryColor11
    readonly property int inputFieldIconButtonWidth: 8
    readonly property int inputFieldIconButtonHeight: 5

    readonly property int inputFieldButtonPlusX: 3
    readonly property int inputFieldButtonPlusY: 2

    readonly property int inputFieldButtonMinusX: 3
    readonly property int inputFieldButtonMinusY: 11

    readonly property color inputFieldBorderColor: theme.primaryColor4
    readonly property int inputFieldButtonTopPadding: 2
    readonly property string inputFieldButtonFontFamily: b612Regular.name
    readonly property color inputFieldButtonFontColor: theme.primaryColor26
    readonly property color inputFieldButtonHoveredFontColor: theme.basicColor2
    readonly property int inputFieldButtonFontSize: 10
    readonly property color inputFieldButtonBackgroundColor: theme.primaryColor27
    readonly property color inputFieldButtonHoveredBackgroundColor: theme.primaryColor11
    readonly property color inputFieldButtonDisabledBackgroundColor: theme.primaryColor40
    readonly property color inputFieldButtonErrorBackgroundColor: theme.accentColor1

    //--------------------------------------------------------------------------
    // COMBOBOX
    //--------------------------------------------------------------------------

    readonly property int comboBoxWidth: 133
    readonly property int comboBoxHeight: 18
    readonly property string comboBoxFontFamily: b612Regular.name
    readonly property color comboBoxFontColor: theme.primaryColor32
    readonly property color comboBoxDisabledFontColor: theme.primaryColor41
    readonly property int comboBoxFontSize: 11
    readonly property int comboBoxLeftPadding: 2
    readonly property int comboBoxRightPadding: 4
    readonly property int comboBoxTopPadding: 6
    readonly property color comboBoxBackgroundColor: theme.primaryColor27
    readonly property color comboBoxHoveredBackgroundColor: theme.primaryColor11

    //--------------------------------------------------------------------------
    // TOOLTIP
    //--------------------------------------------------------------------------

    readonly property color toolTipColor: theme.primaryColor34
    readonly property color toolTipErrorColor: theme.accentColor1
    readonly property string toolTipFontFamily: b612Italic.name
    readonly property color toolTipFontColor: theme.basicColor2
    readonly property color toolTipErrorFontColor: theme.primaryColor22
    readonly property int toolTipFontSize: 11
    readonly property int toolTipRadius: 4

    //--------------------------------------------------------------------------
    // MENU
    //--------------------------------------------------------------------------

    readonly property int menuEntryHeight: 20
    readonly property color menuEntryBackgroundColor: theme.primaryColor7
    readonly property color menuEntryHoveredBackgroundColor: theme.primaryColor21
    readonly property color menuEntryLineColor: theme.primaryColor5

    readonly property string menuEntryFontFamily: b612Italic.name
    readonly property color menuEntryFontColor: theme.primaryColor21
    readonly property color menuEntryHoveredFontColor: theme.primaryColor11
    readonly property int menuEntryFontSize: 10
    readonly property int menuEntryTopPadding: 5
    readonly property int menuEntryLeftPadding: 5

    //--------------------------------------------------------------------------
    // LISTVIEW ENTRY
    //--------------------------------------------------------------------------

    readonly property int listViewEntryHeight: 22
    readonly property color listViewEntryBackgroundColor: theme.primaryColor7
    readonly property color listViewEntryHoveredBackgroundColor: theme.primaryColor39
    readonly property color listViewEntryCheckedBackgroundColor: theme.primaryColor21
    readonly property string listViewEntryFontFamily: b612Regular.name
    readonly property int listViewEntryFontSize: 11
    readonly property color listViewEntryFontColor: theme.basicColor2
    readonly property color listViewEntryDisabledFontColor: theme.primaryColor14
    readonly property color listViewEntryHoveredFontColor: theme.primaryColor11
    readonly property color listViewEntrySelectedFontColor: theme.primaryColor0
    readonly property int listViewEntryTopPadding: 3
    readonly property int listViewEntryLeftPadding: 5
    readonly property int listViewEntryRightPadding: 5
    readonly property color listViewEntryIconColor: theme.basicColor2
    readonly property color listViewEntryHoveredIconColor: theme.primaryColor11
    readonly property int listViewEntryErrorIndicatorX: 2
    readonly property int listViewEntryErrorIndicatorY: 1
    readonly property int listViewEntryErrorIndicatorWidth: 5
    readonly property int listViewEntryErrorIndicatorHeight: 20


    //--------------------------------------------------------------------------
    // Launch Window
    //--------------------------------------------------------------------------
    readonly property int launchWindowWidth: 320
    readonly property int launchWindowHeight: 277

    readonly property int launchWindowContentWidth: 320
    readonly property int launchWindowContentHeight: 220
    readonly property color launchWindowContentBackgroundColor: theme.primaryColor7

    // Fields
    readonly property string launchWindowInputFieldFontFamily: b612Regular.name
    readonly property int    launchWindowInputFieldFontSize: 12
    readonly property color  launchWindowInputFieldFontColor: theme.basicColor2
    readonly property color  launchWindowInputFieldEmptyFontColor: theme.primaryColor6

    readonly property string launchWindowHostInputFieldPlaceholder: qsTr("Hostname")
    readonly property string launchWindowPortInputFieldPlaceholder: qsTr("Port")
    readonly property string launchWindowSSHHostInputFieldPlaceholder: qsTr("Host")
    readonly property string launchWindowSSHPortInputFieldPlaceholder: qsTr("Port")
    readonly property string launchWindowSSHLoginInputFieldPlaceholder: qsTr("Login")
    readonly property string launchWindowSSHPasswordInputFieldPlaceholder: qsTr("Please enter password")

    readonly property int    launchWindowButtonHeight: 24
    readonly property int    launchWindowButtonWidth: 120

    // Cancel button
    readonly property int    launchWindowCancelButtonX: 16
    readonly property int    launchWindowCancelButtonY: 235
    readonly property string launchWindowCancelButtonText: qsTr("Cancel")

    // Validate button
    readonly property int    launchWindowValidateButtonX: 184
    readonly property int    launchWindowValidateButtonY: 235

    readonly property string launchWindowValidateButtonText: qsTr("Launch")

    //--------------------------------------------------------------------------
    // Computation table
    //--------------------------------------------------------------------------

    readonly property int computationTableHeaderHeight: 40
    readonly property int computationTableEntryHeight: 40
    readonly property color computationTableHeaderBackgroundColor: theme.primaryColor1
    readonly property color computationTableEntryBackgroundColor: "transparent"
    readonly property color computationTableEntryHoveredBackgroundColor: theme.primaryColor8
    readonly property color computationTableBrowserBackgroundColor: theme.primaryColor20
    readonly property int computationTableBrowserHeight: 264
    readonly property int computationTableBrowserButtonRightPadding: 8
    readonly property int computationTableBrowserButtonLeftPadding: 8
    readonly property int computationTableBrowserButtonBottomPadding: 10
    readonly property int computationTableBrowserButtonSpacing: 10

    //--------------------------------------------------------------------------
    // SEARCH BARS
    //--------------------------------------------------------------------------

    readonly property int itemSearchBarWidth: 160
    readonly property int itemSearchBarHeight: 28
}
