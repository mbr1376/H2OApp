import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Controls.Material
import QtQuick.Layouts
import Plots 1.0

Item {
    id: root
    anchors.fill: parent

    PlotCpp {
        id: plotcpp
    }

    // جایگزین StackLayout: استفاده از StackView
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: listPage // صفحه شروع
    }

    // صفحه اول: لیست آیتم‌ها
    Component {
        id: listPage

        Item {
            ListView {
                id: listView
                anchors.fill: parent
                clip: true

                // ایجاد حالت ورق زدن صفحه به صفحه
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange

                model: ListModel {
                    ListElement { label: "plot P-T";  value_plot: 0;  not: false; pOrt: true  }
                    ListElement { label: "Plot P-V";  value_plot: 1;  not: true;  pOrt: true  }
                    ListElement { label: "Plot T-V";  value_plot: 2;  not: true;  pOrt: false }
                    ListElement { label: "Plot P-h";  value_plot: 3;  not: true;  pOrt: false }
                    ListElement { label: "Plot T-h";  value_plot: 4;  not: true;  pOrt: false }
                    ListElement { label: "Plot P-roh";value_plot: 5;  not: true;  pOrt: false }
                    ListElement { label: "Plot T-roh";value_plot: 6;  not: true;  pOrt: false }
                    ListElement { label: "Plot P-S";  value_plot: 7;  not: true;  pOrt: false }
                    ListElement { label: "plot T-S";  value_plot: 8;  not: true;  pOrt: false }
                    ListElement { label: "Plot P-u";  value_plot: 9;  not: true;  pOrt: false }
                    ListElement { label: "Plot T-u";  value_plot: 10; not: true;  pOrt: false }
                    ListElement { label: "Plot P-cv"; value_plot: 11; not: true;  pOrt: false }
                    ListElement { label: "Plot T-cv"; value_plot: 12; not: true;  pOrt: false }
                    ListElement { label: "Plot P-cp"; value_plot: 13; not: false; pOrt: false }
                    ListElement { label: "Plot T-cp"; value_plot: 14; not: true;  pOrt: false }
                    ListElement { label: "Plot P-w";  value_plot: 15; not: true;  pOrt: false }
                    ListElement { label: "Plot T-w";  value_plot: 16; not: true;  pOrt: false }
                    ListElement { label: "Plot P-k";  value_plot: 17; not: true;  pOrt: false }
                    ListElement { label: "Plot T-k";  value_plot: 18; not: true;  pOrt: false }
                }

                delegate: ItemPlot {
                    // تمام‌صفحه شدن آیتم
                    width: listView.width
                    height: listView.height

                    _label: label
                    onItemClicked: function(value) {
                        plotcpp.drowPlot(value_plot, value);

                        // هدایت به صفحه چارت با انتقال پارامترها
                        stackView.push(chartPage, {
                            "_titel": label,
                            "targetX": plotcpp.X,
                            "targetY0": plotcpp.Y0,
                            "targetY1": plotcpp.Y1,
                            "targetNot": not,
                            "targetPOrt": pOrt
                        });
                    }
                }
            }
        }
    }

    // صفحه دوم: کامپوننت چارت
                         // صفحه دوم: کامپوننت چارت با قابلیت جابجایی و زوم
                         Component {
                             id: chartPage

                             Item {
                                 id: chartContainer
                                 anchors.fill: parent
                                 clip: true // جلوگیری از بیرون زدن چارت هنگام زوم و جابجایی

                                 // بخش کنترل زوم با دو انگشت (Pinch to Zoom)
                                 PinchArea {
                                     id: pinchArea
                                     anchors.fill: parent

                                     // محدوده مجاز برای مقیاس زوم (بین 0.5 برابر تا 5 برابر)
                                     pinch.minimumScale: 0.5
                                     pinch.maximumScale: 5.0

                                     // اجازه جابجایی دو انگشتی به صورت افقی و عمودی
                                     pinch.dragAxis: Pinch.XAndYAxis
                                     pinch.target: chartWrapper

                                     // بخش درگ و جابجایی با یک انگشت (یا ماوس)
                                     MouseArea {
                                         id: dragArea
                                         anchors.fill: parent
                                         drag.target: chartWrapper
                                         drag.axis: Drag.XAndYAxis

                                         // برای بازنشانی (Reset) زوم و موقعیت با دابل کلیک/دابل تپ
                                         onDoubleClicked: {
                                             chartWrapper.scale = 1.0
                                             chartWrapper.x = 0
                                             chartWrapper.y = 0
                                         }
                                     }
                                 }

                                 // لایه دربرگیرنده چارت که تغییر مقیاس و موقعیت روی آن اعمال می‌شود
                                 Item {
                                     id: chartWrapper
                                     anchors.fill: parent

                                     // نقطه کانونی زوم (مرکز چارت)
                                     transformOrigin: Item.Center

                                     Chart {
                                         id: charts
                                         anchors.fill: parent

                                         property var targetX
                                         property var targetY0
                                         property var targetY1
                                         property bool targetNot: false
                                         property bool targetPOrt: false

                                         Component.onCompleted: {
                                             getdata(targetX, targetY0, targetY1, targetNot, targetPOrt)
                                         }

                                         // بازگشت به صفحه قبل
                                         onBackClicked: stackView.pop()
                                     }
                                 }

                                 // دکمه کمکی برای ریست کردن زوم (اختیاری)
                                 RoundButton {
                                     text: "⟲ Reset"
                                     anchors.right: parent.right
                                     anchors.bottom: parent.bottom
                                     anchors.margins: 16
                                     visible: chartWrapper.scale !== 1.0 || chartWrapper.x !== 0 || chartWrapper.y !== 0
                                     onClicked: {
                                         chartWrapper.scale = 1.0
                                         chartWrapper.x = 0
                                         chartWrapper.y = 0
                                     }
                                 }
                             }
                         }

}
