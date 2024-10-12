import QtQuick
import Qt5Compat.GraphicalEffects

Item {

    width: 400
    height: 300
    Rectangle{
        id:rectangle
        anchors.fill: parent
        radius: 5
    }
    DropShadow{
        id: dropShadow
        anchors.fill: rectangle
        horizontalOffset:4
        verticalOffset: 4
        radius: 8
        samples: 17
        color: "#55FFFFFF"
        source: rectangle
    }
}
