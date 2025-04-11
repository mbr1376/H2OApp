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
                InputForm{
                    anchors.fill: parent
                    anchors.margins: 15
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                           stacklayout.currentIndex =1
                    }
                }


             }
         FormTable{
            onBackClicked: stacklayout.currentIndex =0
         }

    }



}
