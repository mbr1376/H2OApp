pragma Singleton
import QtQuick 2.15

QtObject{
  readonly property int fontSizeSmall: 13
  readonly property int fontSizeMedium: 18
  readonly property int fontSizeLarge: 20
  readonly property var fontFamily: FontLoader{
        source: fontFilesModel.get(0).filename
    }
    // readonly property var fontFamilyRegular: FontLoader{
    //       source: fontFilesModel.get(2).filename
    //   }
    // readonly property var fontFamilyWeather: FontLoader{
    //       source: fontFilesModel.get(3).filename
     // }
    property ListModel fontFilesModel: ListModel {
           ListElement { filename: "qrc:/font/OpenSans-Bold.ttf" }
           ListElement { filename: "qrc:/font/OpenSans-ExtraBold.ttf" }
           ListElement { filename: "qrc:/font/OpenSans-Regular.ttf" }
           ListElement { filename: "qrc:/font/weather.ttf" }
       }
  readonly property color  _firstColor: "#003B5C"
  readonly property color  _secendColor: "#E91E63"
  readonly property color  _textColor : "#FFFFFF"
  readonly property color  _iconColor : "#FFFFFF"
  readonly property color  _backColor : "#FFFFFF"
  readonly property color  _lineColor : "#FF0000"
  readonly property color  _backColor50 : "#66FFFFFF"
  readonly property color  _backIndecatorColor : "#aaaaaa"
  readonly property color  _backApp: "#282829"

}
