import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import QtQuick.Layouts
ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    color: "#332d2d"
    title: qsTr("Hello World")
    header: Rectangle{
        width: window.width
        height: 40
        color: "#003B5C"
        Text {
            id: textHeader
            anchors.centerIn: parent
            color: "#FFFFFF"
            font.bold: true
            font.pointSize: 18
            text: "saturated Liquid-vapor"

        }
    }

StackLayout{
    anchors.fill: parent
          // Don't cover up the topBar
        currentIndex: tabBar.currentIndex

        FrmLiquidVapor{

        }

        Item {
            id: page2
            Rectangle {
                id: w2
                anchors.fill: parent
                color: 'blue'
            }
        }
            Item {
                id: page3
                Rectangle {
                    id: w3
                    anchors.fill: parent
                    color: 'orange'
                }
            }
            Item {
                id: page4
                Rectangle {
                    id: w4
                    anchors.fill: parent
                    color: 'red'
                }
            }
            Plot{

            }


}
    footer: TabBar {
                id: tabBar
                currentIndex: tabBar.currentIndex
                Material.background:  "#003B5C"
                width: parent.width

                TabButton {
                    font.bold: true
                    font.pointSize: 14
                    icon.source: "img/liquid-vapor.png"
                    icon.color: checked ?  "#E91E63": "#FFFFFF"
                    text: "saturated Liquid-vapor"
                    onClicked: textHeader.text = text
                    display: AbstractButton.IconOnly


                }
                TabButton {
                    font.bold: true
                    font.pointSize: 14
                    text: qsTr("Compressed Liquid")
                    display: AbstractButton.IconOnly
                    icon.source: "img/Compressed.png"
                    icon.color: checked ?  "#E91E63": "#FFFFFF"
                    onClicked: textHeader.text = text

                }
                TabButton{
                    font.bold: true
                    font.pointSize: 14
                    text: qsTr("Superheated Vapor")
                    display: AbstractButton.IconOnly
                    icon.source: "img/vapor.png"
                    icon.color: checked ?  "#E91E63": "#FFFFFF"
                    onClicked: textHeader.text = text

                }
                TabButton{
                    font.bold: true
                    font.pointSize: 14
                    text: qsTr("Sturation Point")
                    display: AbstractButton.IconOnly
                    icon.source: "img/saturation_Point.png"
                    icon.color: checked ?  "#E91E63": "#FFFFFF"
                    onClicked: textHeader.text = text
                }
                TabButton{
                    font.bold: true
                    font.pointSize: 14
                    checkable: true
                    icon.color: checked ?  "#E91E63": "#FFFFFF"
                    icon.source: "img/scatter-graph.png"
                    text: "plot"
                    display: AbstractButton.IconOnly
                    onClicked: textHeader.text = text
                }
            }

}

/*##^##
Designer {
    D{i:0;annotation:"1 //;;//  //;;//  //;;// <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\nhr { height: 1px; border-width: 0; }\nli.unchecked::marker { content: \"\\2610\"; }\nli.checked::marker { content: \"\\2612\"; }\n</style></head><body style=\" font-family:'.AppleSystemUIFont'; font-size:13pt; font-weight:400; font-style:normal;\">\n<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br /></p></body></html> //;;// 1727457806";customId:""}
}
##^##*/
