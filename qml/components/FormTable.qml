import QtQuick
import QtQuick.Controls 2.15
import App.Theme 1.0
Item {
   signal backClicked()
    Rectangle{
        anchors.fill: parent
        color: "blue"
    }
    RoundButton {
        id: roundButton
        width: 64
        height: 64
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.topMargin: 8
        icon.height: 32
        icon.width: 32
        icon.source: "img/back.png"
        icon.color: Theme._firstColor
        flat: true
        highlighted: true
        onClicked: backClicked()

    }

}
