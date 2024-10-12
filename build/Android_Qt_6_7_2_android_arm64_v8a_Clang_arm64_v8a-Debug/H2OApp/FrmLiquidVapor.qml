import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import QtQuick.Layouts
Item {

    StackLayout{
        id: stacklayout
        anchors.fill: parent
         currentIndex:0

         Item{
             id: _item
                InputLiquidVapor{
                    anchors.top :parent.top
                    anchors.topMargin: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                 InputLiquidVapor{
                    anchors.bottom:  parent.bottom
                    anchors.bottomMargin:   30
                    anchors.horizontalCenter: parent.horizontalCenter
                }

             }
         }



}
