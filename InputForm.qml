import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Item {
    id: _item

    width: 400
    height: 600
    signal clicked();
    Rectangle{
        id:rectangle
        anchors.fill: parent
        radius: 5
        color: "#55FFFFFF"
        border.color: "white"
        Switch {
            id: customSwitch
            width: 60
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
            onClipChanged: {
                if (checked)
                    bg.source = ""
                else
                    bg.source = "img/thermometers.png"
            }

            // Custom indicator for the switch
            indicator: Rectangle {
                width: parent.width
                height: parent.height
                radius: height / 2
                color: customSwitch.checked ? "#6200ee" : "#cccccc"
                border.color: "#aaaaaa"
                border.width: 1

                // Add the toggle circle
                Rectangle {
                    width: parent.height - 6
                    height: parent.height - 6
                    radius: width / 2
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.left: parent.left
                    //anchors.margins: 3
                    x: customSwitch.checked ? parent.width - width -3 : 3

                    Behavior on x {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
        TextField {
            id: inputFieldstart
            width: parent.width * 0.8
            height: 60
            anchors.top: row.bottom
            anchors.topMargin: 60
            placeholderText: "start point"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Arial"
            background: Rectangle {
                color: "#f0f0f0"
                border.color: "#6200ee"
                border.width: 2
                radius: 8
            }
            padding: 10
            onPressed: text = "0.01"
            validator: DoubleValidator {
                bottom: -1000000.0 // Minimum value
                top: 1000000.0    // Maximum value
                decimals: 2       // Allow up to 2 decimal places
            }
        }
        TextField {
            id: inputFieldend
            width: parent.width * 0.8
            height: 60
            anchors.top: inputFieldstart.bottom
            anchors.topMargin: 60
            placeholderText: "End Point"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Arial"
            background: Rectangle {
                color: "#f0f0f0"
                border.color: "#6200ee"
                border.width: 2
                radius: 8
            }
            padding: 10
            onPressed: text = "373.94599"
            validator: DoubleValidator {
                bottom: 0.01 // Minimum value
                top: 373.94599    // Maximum value
                decimals: 5       // Allow up to 2 decimal places
            }
        }
        TextField {
            id: inputFieldloop
            width: parent.width * 0.8
            height: 60
            text: "1"
            anchors.top: inputFieldend.bottom
            anchors.topMargin: 60
            //placeholderText: "End Point"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Arial"
            background: Rectangle {
                color: "#f0f0f0"
                border.color: "#6200ee"
                border.width: 2
                radius: 8
            }
            padding: 10
            onPressed: text = "373.94599"
            validator: DoubleValidator {
                bottom: 0.01 // Minimum value
                top: 373.94599    // Maximum value
                decimals: 5       // Allow up to 2 decimal places
            }
        }
        Row {
            id: row

            width: parent.width
            height: 50
            anchors.top: customSwitch.bottom
            anchors.topMargin: 120
            leftPadding: 50
            spacing: 30
            RadioButton {
                id: option1
                text: "Increment"
                font.pixelSize: 20
                font.family: "Arial"
                checked:true
                indicator: Rectangle {
                    width: 40
                    height: 40
                    radius: width / 2
                    border.color: option1.checked ? "#6200ee" : "#cccccc"
                    border.width: 2
                    color: "#ffffff"

                    // Inner circle for checked state
                    Rectangle {
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        radius: width / 2
                        color: option1.checked ? "#6200ee" : "transparent"
                        anchors.centerIn: parent
                    }
                }
                onClicked: inputFieldloop.text = "1"
            }

            RadioButton {
                id: option2
                text: "Intervals"
                font.pixelSize: 20
                font.family: "Arial"
                indicator: Rectangle {
                    width: 40
                    height: 40
                    radius: width / 2
                    border.color: option2.checked ? "#6200ee" : "#cccccc"
                    border.width: 2
                    color: "#ffffff"

                    // Inner circle for checked state
                    Rectangle {
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        radius: width / 2
                        color: option2.checked ? "#6200ee" : "transparent"
                        anchors.centerIn: parent

                    }
                }
                onClicked: {
                    inputFieldloop.text = "100"
                }
            }
        }

        CustomDelayButton {
            id: delayButton

            text: qsTr("OK")
            anchors.top: inputFieldloop.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                _item.clicked()
            }

        }

    }

    Image {
        id : bg
        anchors.fill: parent
        source: "img/thermometers.png"
        opacity: 0.1
    }


}
