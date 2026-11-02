import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Item {
    id: _item

    width: 400
    height: 600
    signal clicked(string state_model,string state,int firstpoint,int Endpoint,int step )
    property string _statemodel: "T"
    property string _state: "Increment"
    Rectangle{
        id:rectangle
        anchors.fill: parent
        radius: 5
        color: Theme._backColor50
        border.color: "white"
        Switch {
            id: customSwitch
            width: 80
            height: 40
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
            onClicked: {
                if (checked){
                    bg.source = "img/pressure.jpg"
                    _statemodel = "P"
                }
                else{
                    bg.source = "img/thermometers.png"
                    _statemodel = "T"
                }
            }

            // Custom indicator for the switch
            indicator: Rectangle {
                width: parent.width
                height: parent.height
                radius: height / 2
                color: customSwitch.checked ? Theme._firstColor : Theme._secendColor
                border.color: Theme._backIndecatorColor
                border.width: 1

                // Add the toggle circle
                Rectangle {
                    width: parent.height - 6
                    height: parent.height - 6
                    radius: width / 2
                    color: Theme._backColor
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
                color: Theme._backIndecatorColor
                border.color: Theme._firstColor
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
            //placeholderTextColor: Theme._backIndecatorColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Arial"
            background: Rectangle {
                color: Theme._backIndecatorColor
                border.color: Theme._firstColor
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
                color: Theme._backIndecatorColor
                border.color: Theme._firstColor
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
                    border.color: option1.checked ? Theme._firstColor : Theme._backIndecatorColor
                    border.width: 2
                    color: Theme._backColor

                    // Inner circle for checked state
                    Rectangle {
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        radius: width / 2
                        color: option1.checked ? Theme._firstColor : "transparent"
                        anchors.centerIn: parent
                    }
                }
                onClicked: {inputFieldloop.text = "1";_state= "Increment" }
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
                    border.color: option2.checked ? Theme._firstColor : Theme._backIndecatorColor
                    border.width: 2
                    color: Theme._backColor

                    // Inner circle for checked state
                    Rectangle {
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        radius: width / 2
                        color: option2.checked ? Theme._firstColor : "transparent"
                        anchors.centerIn: parent

                    }
                }
                onClicked: {
                    inputFieldloop.text = "100"
                    _state = "Intervals"
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
                _item.clicked(_statemodel,_state,inputFieldstart.text,inputFieldend.text,inputFieldloop.text)
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
