import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import QtQuick.Layouts
import Plots 1.0
Item {
    PlotCpp{
        id: plotcpp
    }

    StackLayout{
        id: stacklayout
        anchors.fill: parent
         currentIndex:0

         Item{
             ListView {

                 id: listView
                 anchors.fill: parent
                 model: ListModel {
                     ListElement {
                         label:"plot P-T"
                     }

                     ListElement {
                         label:"Plot P-V"
                     }

                     ListElement {
                         label:"Plot T-V"
                     }

                     ListElement {
                         label:"Plot P-h"
                     }
                     ListElement {
                         label:"Plot T-h"
                     }
                     ListElement {
                         label:"Plot P-roh"
                     }
                     ListElement {
                         label:"Plot P-S"
                     }
                     ListElement {
                         label:"plot T-S"
                     }

                     ListElement {
                         label:"Plot P-u"
                     }

                     ListElement {
                         label:"Plot T-u"
                     }

                     ListElement {
                         label:"Plot P-cp"
                     }
                     ListElement {
                         label:"Plot P-w"
                     }
                     ListElement {
                         label:"Plot T-w"
                     }
                     ListElement {
                         label:"Plot P-k"
                     }
                     ListElement{
                         label:"Plot T-k"
                     }
                 }
                 delegate:ItemPlot{
                     width: listView.width
                     height: 200
                     _label:label
                     onItemClicked:function(value) {
                         stacklayout.currentIndex = 1
                         charts._titel = label
                         plotcpp.Plot_Pt(value);
                         charts.getdata(plotcpp.X,plotcpp.Y0)

                     }
                 }

             }
         }
         Chart{
            id: charts
            onBackClicked: stacklayout.currentIndex = 0
         }
    }




}
