import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.15
// Nf frameworks
import "qrc:/theme/" as Theme
//import Workbench 1.0

ApplicationWindow {
    id: root

    property ApplicationWindow appWindow: root

    // Manage theme
    Theme.ThemeManager {
        id: themeManager
    }

    property alias themeName: themeManager.themeName
    readonly property alias theme: themeManager.theme
    property alias themeManager: themeManager

    readonly property WBConstants constants: WBConstants { id: constants }

    // Shortcut to get available application window size (= excluding menus)
    readonly property int availableWidth: contentItem.width
    readonly property int availableHeight: contentItem.height

    //--------------------------------------------------------------------------
    // Application Window
    //--------------------------------------------------------------------------

    width: constants.mainWindowDefaultWidth
    height: constants.mainWindowDefaultHeight
    minimumWidth: constants.mainWindowMinimumWidth
    minimumHeight: constants.mainWindowMinimumHeight


    // Background color
    Rectangle {
        id: background
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: constants.mainWindowGradientStartBackgroundColor }
            GradientStop { position: 1.0; color: constants.mainWindowGradientStopBackgroundColor }
        }
    }

    //--------------------------------------------------------------------------
    // Window factory methods
    //--------------------------------------------------------------------------

    function createValidationWindow(title, text, onAccepted, onRejected, onLinkActivated) {
        var component = Qt.createComponent("qrc:/widgets/WBInformationWindow.qml")
        var window = component.createObject(contentItem, {
            "title": title, "text": text, "z": constants.modalWindowZValue, "funcOnLinkActivated": onLinkActivated})
        privateScope.manageWindow(window, onAccepted, onRejected)
    }

    function createInformationWindow(title, text, onAccepted, onLinkActivated) {
        var component = Qt.createComponent("qrc:/widgets/WBInformationWindow.qml")
        var window = component.createObject(contentItem, {
            "title": title, "text": text, "z": constants.modalWindowZValue, "buttons": Buttons.Accept, "funcOnLinkActivated": onLinkActivated})
        privateScope.manageWindow(window, onAccepted)
    }

    function createYesNoQuestionWindow(title, text, onAccepted, onRejected, onLinkActivated) {
        var component = Qt.createComponent("qrc:/widgets/WBInformationWindow.qml")
        var window = component.createObject(contentItem, {
            "title": title, "text": text, "question": true, "z": constants.modalWindowZValue, "funcOnLinkActivated": onLinkActivated})
        privateScope.manageWindow(window, onAccepted, onRejected)
    }

    function createCloseStudioWindow(title, text, onAccepted, onRejected) {
        var component = Qt.createComponent("qrc:/widgets/WBInformationWindow.qml")
        var window = component.createObject(contentItem, {
            "title": title, "text": text, "closeStudio": true, "z": constants.modalWindowZValue})
        privateScope.manageWindow(window, onAccepted, onRejected)
    }

    function createInputWindow(title, label, placeholderText, onAccepted, onLinkActivated) {
        var component = Qt.createComponent("qrc:/widgets/WBInputWindow.qml")
        var window = component.createObject(contentItem, {
            "title": title, "label": label, "placeholderText": placeholderText, "z": constants.modalWindowZValue, "funcOnLinkActivated": onLinkActivated})
        privateScope.manageWindow(window, onAccepted)
    }

    function createFileSelectionWindow(title, multipleSelection, save, onAccepted, onRejected) {
        var component = Qt.createComponent("qrc:/widgets/WBFileSelectionWindow.qml")
        var window = component.createObject(null, {
            "title": title, "multipleSelection": multipleSelection, "save": save, "z": constants.modalWindowZValue})
        privateScope.manageWindow(window, onAccepted, onRejected)
    }

    function createFilteredFileSelectionWindow(title, multipleSelection, save, nameFilters, defaultFileName, defaultSuffix, defaultFolder, onAccepted, onRejected) {
        var component = Qt.createComponent("qrc:/widgets/WBFileSelectionWindow.qml")
        var window = component.createObject(null, {
            "title": title, "multipleSelection": multipleSelection, "save": save,
            "folder": defaultFolder, "nameFilters": nameFilters, "currentFile": fileTools.getUrl(defaultFileName),
            "defaultSuffix": defaultSuffix, "z": constants.modalWindowZValue})
        privateScope.manageWindow(window, onAccepted, onRejected)
    }

    function createFolderSelectionWindow(title, folder, onAccepted, onRejected) {
        var component = Qt.createComponent("qrc:/widgets/WBFolderSelectionWindow.qml")
        var window = component.createObject(null, {
            "title": title, "folder" : folder, "z": constants.modalWindowZValue})
        privateScope.manageWindow(window, onAccepted, onRejected)
    }

    //--------------------------------------------------------------------------
    // Private methods
    //--------------------------------------------------------------------------

    QtObject {
        id: privateScope

        function manageWindow(window, onAccepted, onRejected) {
            if (window) {
                window.accepted.connect(function() {
                    onAccepted(window)
                    window.visible = false
                    window.destroy()
                })

                if (onRejected) {
                    window.rejected.connect(function() {
                        onRejected()
                        window.visible = false
                        window.destroy()
                    })
                }
                else {
                    window.rejected.connect(function() {
                        window.visible = false
                        window.destroy()
                    })
                }

                if (window.modal) {
                    raise()
                }

                window.visible = true
            }
            else {
                console.log("ApplicationWindow: Error creating window !")
            }
        }
    }
}
