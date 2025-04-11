import QtQuick 2.15
import QtQuick.Controls 2.15
import App.Theme 1.0
Rectangle {
    id: delayButton
    width: 150
    height: 50
    radius: 12
    color: Theme._firstColor
    border.color: Theme._firstColor
    border.width: 2

    property alias text: buttonText.text
    signal clicked()

    Text {
        id: buttonText
        text: "Button"
        color: Theme._textColor
        font.pixelSize: 16
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!progressAnimation.running) {
                progressAnimation.start();

            }
        }
    }

    // Progress bar for delay effect
    Rectangle {
        id: progressBar
        width: 0
        height: 4
        color: Theme._secendColor
        radius: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    // Animation for delay effect
    PropertyAnimation {
        id: progressAnimation
        target: progressBar
        property: "width"
        from: 0
        to: delayButton.width
        duration: 2000 // 2 seconds delay
        onStopped: {
            delayButton.clicked();
        }
    }
}
