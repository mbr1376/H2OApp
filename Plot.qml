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
                         value_plot:0
                         not: false
                         pOrt: true
                     }

                     ListElement {
                         label:"Plot P-V"
                         value_plot:1
                         not: true
                         pOrt: true
                     }

                     ListElement {
                         label:"Plot T-V"
                          value_plot:2
                          not: true
                          pOrt: false
                     }


                     ListElement {
                         label:"Plot P-h"
                         value_plot:3
                         not:true
                     }
                     ListElement {
                         label:"Plot T-h"
                          value_plot: 4
                          not: true
                     }
                     ListElement {
                         label:"Plot P-roh"
                          value_plot: 5
                          not:true
                     }
                     ListElement {
                         label:"Plot T-roh"
                          value_plot: 6
                          not:true
                     }
                     ListElement {
                         label:"Plot P-S"
                          value_plot:7
                          not: true
                     }
                     ListElement {
                         label:"plot T-S"
                          value_plot: 8
                          not:true
                     }

                     ListElement {
                         label:"Plot P-u"
                         value_plot: 9
                         not:true
                     }

                     ListElement {
                         label:"Plot T-u"
                         value_plot:10
                         not:true
                     }
                     ListElement {
                         label:"Plot P-cv"
                         value_plot:11
                         not:true

                     }
                     ListElement {
                         label:"Plot T-cv"
                         value_plot:12
                         not:true

                     }
                     ListElement {
                         label:"Plot P-cp"
                         value_plot:13

                     }
                     ListElement {
                         label:"Plot T-cp"
                         value_plot:14
                         not:true

                     }
                     ListElement {
                         label:"Plot P-w"
                         value_plot:15
                         not: true

                     }
                     ListElement {
                         label:"Plot T-w"
                         value_plot:16
                         not:true

                     }
                     ListElement {
                         label:"Plot P-k"
                         value_plot:17
                         not:true

                     }
                     ListElement{
                         label:"Plot T-k"
                         value_plot:18
                         not  :true

                     }
                 }
                 delegate:ItemPlot{
                     width: listView.width
                     height: 200
                     _label:label
                     onItemClicked:function(value) {
                         stacklayout.currentIndex = 1
                         charts._titel = label
                         console.log(value_plot)
                         plotcpp.drowPlot(value_plot,value);
                         charts.getdata(plotcpp.X,plotcpp.Y0,plotcpp.Y1,not,pOrt)

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
