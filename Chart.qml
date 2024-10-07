import QtQuick
import QtCharts 2.7
import QtQuick.Controls 2.15
Item {
    property string _titel: ""
    signal backClicked
    signal getdata( list<real> x,list <real> y0)
    onGetdata:function(x,y0) {

        for (var i = 0; i < x.length; i++)  {
            lineseries.append(x[i],y0[i])
            scatter1.append(x[i],y0[i])
        }
    }

    ChartView {
        id: chartView
         title: _titel
         anchors.fill: parent
         antialiasing: true
        ValuesAxis{
            id: axisX
            min: 0
            max: 400
        }
        ValuesAxis{
            id: axisY
            min: 0
            max: 250
        }
         LineSeries {
             id: lineseries
            color: "#003B5C"
            name: "line"
            axisX: axisX
            axisY: axisY
            width: 5

        }
     ScatterSeries {
        id: scatter1
        name: "point"
        axisX: axisX
        axisY: axisY
        markerSize:10
        color: "#003B5C"


     }
     PinchArea{
               id: pa
               anchors.fill: parent
               property real currentPinchScaleX: 1
               property real currentPinchScaleY: 1
               property real pinchStartX : 0
               property real pinchStartY : 0

               onPinchStarted: {
                   // Pinching has started. Record the initial center of the pinch
                   // so relative motions can be reversed in the pinchUpdated signal
                   // handler
                   pinchStartX = pinch.center.x;
                   pinchStartY = pinch.center.y;
               }

               onPinchUpdated: {
                   chartView.zoomReset();

                   // Reverse pinch center motion direction
                   var center_x = pinchStartX + (pinchStartX - pinch.center.x);
                   var center_y = pinchStartY + (pinchStartY - pinch.center.y);

                   // Compound pinch.scale with prior pinch scale level and apply
                   // scale in the absolute direction of the pinch gesture
                   var scaleX = currentPinchScaleX * (1 + (pinch.scale - 1) * Math.abs(Math.cos(pinch.angle * Math.PI / 180)));
                   var scaleY = currentPinchScaleY * (1 + (pinch.scale - 1) * Math.abs(Math.sin(pinch.angle * Math.PI / 180)));

                   // Apply scale to zoom levels according to pinch angle
                   var width_zoom = height / scaleX;
                   var height_zoom = width / scaleY;

                   var r = Qt.rect(center_x - width_zoom / 2, center_y - height_zoom / 2, width_zoom, height_zoom);
                   chartView.zoomIn(r);
               }

               onPinchFinished: {
                   // Pinch finished. Record compounded pinch scale.
                   currentPinchScaleX = currentPinchScaleX * (1 + (pinch.scale - 1) * Math.abs(Math.cos(pinch.angle * Math.PI / 180)));
                   currentPinchScaleY = currentPinchScaleY * (1 + (pinch.scale - 1) * Math.abs(Math.sin(pinch.angle * Math.PI / 180)));
               }

               MouseArea{
                   anchors.fill: parent
                   drag.target: dragTarget
                   drag.axis: Drag.XAndYAxis

                   onDoubleClicked: {
                       chartView.zoomReset();
                       parent.currentPinchScaleX = 1;
                       parent.currentPinchScaleY = 1;
                   }
               }

               Item {
                   // A virtual item to receive drag signals from the MouseArea.
                   // When x or y properties are changed by the MouseArea's
                   // drag signals, the ChartView is scrolled accordingly.
                   id: dragTarget

                   property real oldX : x
                   property real oldY : y

                   onXChanged: {
                       chartView.scrollLeft( x - oldX );
                       oldX = x;
                   }
                   onYChanged: {
                       chartView.scrollUp( y - oldY );
                       oldY = y;
                   }
                }
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
        icon.color: "#003B5C"
        flat: true
        highlighted: true
        onClicked: backClicked()

    }
    }
}
