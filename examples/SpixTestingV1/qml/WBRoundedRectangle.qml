import QtQuick 2.13

// unfortunaltly, canvas have update issue
// prefer using WBTopRoundedRectangle/ WBBottomRoundedRectangle
Canvas {
    property int topLeftRadius: 0
    property int topRightRadius: 0
    property int bottomLeftRadius: 0
    property int bottomRightRadius: 0

    property color borderColor:  "white"
    property int borderWidth: 0
    property color color: "white"

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onTopLeftRadiusChanged: requestPaint()
    onTopRightRadiusChanged: requestPaint()
    onBottomLeftRadiusChanged: requestPaint()
    onBottomRightRadiusChanged: requestPaint()
    onColorChanged: requestPaint()
    onBorderColorChanged: requestPaint()
    onBorderWidthChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.save()
        ctx.reset()

        ctx.strokeStyle = borderColor
        ctx.lineWidth = borderWidth
        ctx.fillStyle = color

        ctx.beginPath()
        ctx.moveTo(topLeftRadius, 0)                 // top side
        ctx.lineTo(width - topRightRadius, 0)
        // draw top right corner
        ctx.arcTo(width, 0, width, topRightRadius, topRightRadius)
        ctx.lineTo(width, height - bottomRightRadius)    // right side
        // draw bottom right corner
        ctx.arcTo(width, height, width - bottomRightRadius, height, bottomRightRadius)
        ctx.lineTo(bottomLeftRadius, height)              // bottom side
        // draw bottom left corner
        ctx.arcTo(0, height, 0, height - bottomLeftRadius, bottomLeftRadius)
        ctx.lineTo(0, topLeftRadius)                 // left side
        // draw top left corner
        ctx.arcTo(0, 0, topLeftRadius, 0, topLeftRadius)
        ctx.closePath()
        ctx.fill()
        if (borderWidth) {
            ctx.stroke()
        }
        ctx.restore()
    }
}


// another implementation that causes issues with the menus...
/*
import QtQuick.Shapes 1.0


Shape {
    id: root

    property int topLeftRadius: 0
    property int topRightRadius: 0
    property int bottomLeftRadius: 0
    property int bottomRightRadius: 0

    property color borderColor:  "white"
    property int borderWidth: 0
    property color color: "white"

    antialiasing: true
    //z: 0

    ShapePath {
        fillColor: root.color
        strokeWidth: root.borderWidth
        strokeColor: root.borderColor

        startX: root.topLeftRadius
        startY: 0

        PathLine {
            x: root.width - root.topRightRadius
            y: 0
        }

        PathArc {
            x: root.width
            y: root.topRightRadius
            radiusX: root.topRightRadius
            radiusY: root.topRightRadius
        }

        PathLine {
            x: root.width
            y: root.height - root.bottomRightRadius
        }

        PathArc {
            x: root.width - root.bottomRightRadius
            y: root.height
            radiusX: root.bottomRightRadius
            radiusY: root.bottomRightRadius
        }

        PathLine {
            x: root.bottomLeftRadius
            y: root.height
        }

        PathArc {
            x: 0
            y: root.height - root.bottomLeftRadius
            radiusX: root.bottomLeftRadius
            radiusY: root.bottomLeftRadius
        }

        PathLine {
            x: 0
            y: root.topLeftRadius
        }

        PathArc {
            x: root.topLeftRadius
            y: 0
            radiusX: root.topLeftRadius
            radiusY: root.topLeftRadius
        }
    }
}
*/
