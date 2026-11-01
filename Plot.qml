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
    Component {
        id: chartPage

        Chart {
            id: charts
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
}
