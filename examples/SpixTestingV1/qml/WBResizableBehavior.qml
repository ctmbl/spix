import QtQuick 2.13
import QtQuick.Controls 2.13

import Workbench 1.0

Item {
    id: root
    property bool enabled: true        
    property bool allowRightResize: true
    property bool allowLeftResize: true
    property bool allowBottomResize: true
    property bool allowTopResize: true
    property int minimumWidth: 0
    property int minimumHeight: 0
    property int maximumWidth: 0
    property int maximumHeight: 0
    property variant target

    property int thickness: 4

    // Manage window resize - right
    WBResizableBehaviorTemplate {
        id: resizableBehaviorRight
        enabled: root.enabled && root.allowRightResize
        target: root.target
        anchors.right: parent.right
        width: root.thickness
        height: parent.height
        resizeMode: ResizeMode.Right
    }

    // Manage window resize - left
    WBResizableBehaviorTemplate {
        id: resizableBehaviorLeft
        enabled: root.enabled && root.allowLeftResize
        target: root.target
        anchors.left: parent.left
        width: root.thickness
        height: parent.height
        resizeMode: ResizeMode.Left
    }

    // Manage window resize - bottom
    WBResizableBehaviorTemplate {
        id: resizableBehaviorBottom
        enabled: root.enabled && root.allowBottomResize
        target: root.target
        anchors.bottom: parent.bottom
        width: parent.width
        height: root.thickness
        resizeMode: ResizeMode.Bottom
    }

    // Manage window resize - top
    WBResizableBehaviorTemplate {
        id: resizableBehaviorTop
        enabled: root.enabled && root.allowTopResize
        target: root.target
        anchors.top: parent.top
        width: parent.width
        height: root.thickness
        resizeMode: ResizeMode.Top
    }

    // Manage window resize - top-left
    WBResizableBehaviorTemplate {
        id: resizableBehaviorTL
        enabled: root.enabled && root.allowTopResize && root.allowLeftResize
        target: root.target
        anchors.top: parent.top
        anchors.left: parent.left
        width: root.thickness
        height: root.thickness
        resizeMode: ResizeMode.TopLeft
    }

    // Manage window resize - top-right
    WBResizableBehaviorTemplate {
        id: resizableBehaviorTR
        enabled: root.enabled && root.allowTopResize && root.allowRightResize
        target: root.target
        anchors.top: parent.top
        anchors.right: parent.right
        width: root.thickness
        height: root.thickness
        resizeMode: ResizeMode.TopRight
    }

    // Manage window resize - bottom-right
    WBResizableBehaviorTemplate {
        id: resizableBehaviorBR
        enabled: root.enabled && root.allowBottomResize && root.allowRightResize
        target: root.target
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: root.thickness
        height: root.thickness
        resizeMode: ResizeMode.BottomRight
    }

    // Manage window resize - bottom-left
    WBResizableBehaviorTemplate {
        id: resizableBehaviorBL
        enabled: root.enabled && root.allowBottomResize && root.allowLeftResize
        target: root.target
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: root.thickness
        height: root.thickness
        resizeMode: ResizeMode.BottomLeft
    }
}
