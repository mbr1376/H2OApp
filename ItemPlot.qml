import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls 2.15
Item {
    id: _item
    property string _label: "Plot"
    signal itemClicked( int points)
    Rectangle{
        id:rectangel
        anchors.fill: parent
        anchors.margins: 10
        radius: 10
        border.color: Theme._firstColor
        color: Theme._firstColor

    }
    DropShadow{
        id: dropShadow
        anchors.fill: rectangel
        horizontalOffset:4
        verticalOffset: 4
        radius: 8
        samples: 17
        color: Theme._backColor50
        source: rectangel

        Button {
            id: button
            width: 100
            height: 52
            text: qsTr("Ok")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            icon.color: Theme._secendColor
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle{
                color: Theme._secendColor
                border.color: Theme._secendColor
                radius: 10
            }
            onClicked:{

                itemClicked(spinBox.value)
            }
        }


    }
    Label {
        id: label
        text: _label
        anchors.top: parent.top
        anchors.topMargin: 40
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.underline: true
        font.bold: true
        font.pointSize: 20
        color: Theme._textColor
    }

    SpinBox {
        id: spinBox
        x: 269
        y: 230
        value: 100
        anchors.verticalCenter: parent.verticalCenter
        stepSize: 10
        to: 1000
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle{
        radius: 5
            color: Theme._backColor

        }
    }
}
