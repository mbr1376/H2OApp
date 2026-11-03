import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts
import App.Theme 1.0
import Steam 1.0
import Plots 1.0
import Qt5Compat.GraphicalEffects
ApplicationWindow {
    id: root
    width: 420
    height: 900
    minimumWidth: 340
    minimumHeight: 620
    visible: true
    color: "#0F172A"
    title: "SteamLab"

    property color cardColor: "#1E293B"
    property color cardBorder: "#334155"
    property color accent: "#38BDF8"
    property color primaryText: "#F1F5F9"
    property color secondaryText: "#94A3B8"
    property int selectedPage: 0
    property string selectedState: "saturatedVapor"
    property var resultData: ({})
    property var tableRows: []
    property var plotX: []
    property var plotY0: []
    property var plotY1: []
    property int selectedPlot: 1
    property real plotZoom: 1
    property real plotCenterX: 0.5
    property real plotCenterY: 0.5
    property int selectedPointIndex: -1
    property int selectedPointSeries: 0
    property real selectedPointX: 0
    property real selectedPointY: 0
    property string calculationError: ""
    readonly property var plotTypes: [
        {name: "P-T", title: "Pressure – Temperature", xLabel: "Temperature (°C)", yLabel: "Pressure (bar)", first: "Saturation pressure", second: ""},
        {name: "P-v", title: "Pressure – Specific volume", xLabel: "Pressure (bar)", yLabel: "ln(Specific volume, m³/kg)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-v", title: "Temperature – Specific volume", xLabel: "Temperature (°C)", yLabel: "ln(Specific volume, m³/kg)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-h", title: "Pressure – Enthalpy", xLabel: "Pressure (bar)", yLabel: "Enthalpy (kJ/kg)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-h", title: "Temperature – Enthalpy", xLabel: "Temperature (°C)", yLabel: "Enthalpy (kJ/kg)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-ρ", title: "Pressure – Density", xLabel: "Pressure (bar)", yLabel: "Density (kg/m³)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-ρ", title: "Temperature – Density", xLabel: "Temperature (°C)", yLabel: "Density (kg/m³)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-s", title: "Pressure – Entropy", xLabel: "Pressure (bar)", yLabel: "Entropy (kJ/kg·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-s", title: "Temperature – Entropy", xLabel: "Temperature (°C)", yLabel: "Entropy (kJ/kg·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-u", title: "Pressure – Internal energy", xLabel: "Pressure (bar)", yLabel: "Internal energy (kJ/kg)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-u", title: "Temperature – Internal energy", xLabel: "Temperature (°C)", yLabel: "Internal energy (kJ/kg)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-cv", title: "Pressure – Cv", xLabel: "Pressure (bar)", yLabel: "Cv (kJ/kg·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-cv", title: "Temperature – Cv", xLabel: "Temperature (°C)", yLabel: "Cv (kJ/kg·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-cp", title: "Pressure – Cp", xLabel: "Pressure (bar)", yLabel: "Cp (kJ/kg·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-cp", title: "Temperature – Cp", xLabel: "Temperature (°C)", yLabel: "Cp (kJ/kg·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-w", title: "Pressure – Speed of sound", xLabel: "Pressure (bar)", yLabel: "Speed of sound (m/s)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-w", title: "Temperature – Speed of sound", xLabel: "Temperature (°C)", yLabel: "Speed of sound (m/s)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "P-k", title: "Pressure – Thermal conductivity", xLabel: "Pressure (bar)", yLabel: "Thermal conductivity (W/m·K)", first: "Saturated liquid", second: "Saturated vapor"},
        {name: "T-k", title: "Temperature – Thermal conductivity", xLabel: "Temperature (°C)", yLabel: "Thermal conductivity (W/m·K)", first: "Saturated liquid", second: "Saturated vapor"}
    ]

    SteamCalculator {
        id: calculator
    }

    PlotCpp {
        id: plotBackend
    }

    function loadPlot(index) {
        if (index < 0 || index >= plotTypes.length)
            return
        selectedPlot = index
        plotBackend.drowPlot(index, 100)
        plotX = plotBackend.X
        plotY0 = plotBackend.Y0
        plotY1 = plotBackend.Y1
        resetPlotView()
        plotCanvas.requestPaint()
    }

    function resetPlotView() {
        plotZoom = 1
        plotCenterX = 0.5
        plotCenterY = 0.5
        selectedPointIndex = -1
        plotCanvas.requestPaint()
    }

    function zoomPlot(factor) {
        plotZoom = Math.max(1, Math.min(32, plotZoom * factor))
        plotCanvas.requestPaint()
    }

    function basePlotBounds() {
        let xMin = Infinity
        let xMax = -Infinity
        let yMin = Infinity
        let yMax = -Infinity
        for (let i = 0; i < plotX.length; ++i) {
            const x = Number(plotX[i])
            const y0 = Number(plotY0[i])
            const y1 = Number(plotY1[i])
            if (Number.isFinite(x) && Number.isFinite(y0)) {
                xMin = Math.min(xMin, x)
                xMax = Math.max(xMax, x)
                yMin = Math.min(yMin, y0)
                yMax = Math.max(yMax, y0)
            }
            if (Number.isFinite(x) && Number.isFinite(y1)) {
                xMin = Math.min(xMin, x)
                xMax = Math.max(xMax, x)
                yMin = Math.min(yMin, y1)
                yMax = Math.max(yMax, y1)
            }
        }
        if (!Number.isFinite(xMin) || !Number.isFinite(yMin))
            return null
        if (xMax === xMin) {
            xMin -= 1
            xMax += 1
        }
        if (yMax === yMin) {
            yMin -= 1
            yMax += 1
        }
        const xPadding = (xMax - xMin) * 0.04
        const yPadding = (yMax - yMin) * 0.08
        xMin -= xPadding
        xMax += xPadding
        yMin -= yPadding
        yMax += yPadding
        return {xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax}
    }

    function currentPlotBounds() {
        const bounds = basePlotBounds()
        if (!bounds)
            return null
        const xSpan = (bounds.xMax - bounds.xMin) / plotZoom
        const ySpan = (bounds.yMax - bounds.yMin) / plotZoom
        const xMiddle = bounds.xMin + (bounds.xMax - bounds.xMin) * plotCenterX
        const yMiddle = bounds.yMin + (bounds.yMax - bounds.yMin) * plotCenterY
        return {
            xMin: xMiddle - xSpan / 2,
            xMax: xMiddle + xSpan / 2,
            yMin: yMiddle - ySpan / 2,
            yMax: yMiddle + ySpan / 2
        }
    }

    function selectPlotPoint(canvasX, canvasY) {
        const bounds = currentPlotBounds()
        if (!bounds)
            return
        const left = 48
        const right = plotCanvas.width - 12
        const top = 16
        const bottom = plotCanvas.height - 38
        if (canvasX < left || canvasX > right || canvasY < top || canvasY > bottom)
            return

        const xMap = value => left + (value - bounds.xMin) / (bounds.xMax - bounds.xMin) * (right - left)
        const yMap = value => bottom - (value - bounds.yMin) / (bounds.yMax - bounds.yMin) * (bottom - top)
        let nearestDistance = 36
        let nearestIndex = -1
        let nearestSeries = 0
        let nearestY = 0
        for (let i = 0; i < plotX.length; ++i) {
            const xValue = Number(plotX[i])
            if (!Number.isFinite(xValue))
                continue
            for (let series = 0; series < 2; ++series) {
                const values = series === 0 ? plotY0 : plotY1
                if (i >= values.length)
                    continue
                const yValue = Number(values[i])
                if (!Number.isFinite(yValue))
                    continue
                const dx = xMap(xValue) - canvasX
                const dy = yMap(yValue) - canvasY
                const distance = Math.sqrt(dx * dx + dy * dy)
                if (distance < nearestDistance) {
                    nearestDistance = distance
                    nearestIndex = i
                    nearestSeries = series
                    nearestY = yValue
                }
            }
        }
        if (nearestIndex >= 0) {
            selectedPointIndex = nearestIndex
            selectedPointSeries = nearestSeries
            selectedPointX = Number(plotX[nearestIndex])
            selectedPointY = nearestY
            plotCanvas.requestPaint()
        }
    }

    function calculate() {
        calculationError = ""
        const temperature = Number(temperatureField.text)
        const pressure = Number(pressureField.text)
        if (temperatureField.text.trim() === "" || !Number.isFinite(temperature)
                || (selectedState !== "saturatedLiquid" && selectedState !== "saturatedVapor"
                    && (pressureField.text.trim() === "" || !Number.isFinite(pressure)))) {
            calculationError = "Please enter valid numeric values."
            return
        }

        const nextResult = calculator.calculate(selectedState, temperature, pressure)
        if (!nextResult.ok) {
            calculationError = nextResult.error
            return
        }
        resultData = nextResult
        selectedPage = 1
        plotCanvas.requestPaint()
    }

    Component.onCompleted: {
        tableRows = calculator.saturationTable()
        loadPlot(selectedPlot)
    }

    header: Rectangle {
        visible: root.selectedPage !== 3
        color: "#111D31"
        height: 64
        border.color: "#1E293B"
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 10
            Image {
                source: "assets/img/water_drop.svg"
                Layout.preferredWidth: 26
                       Layout.preferredHeight: 26
                       fillMode: Image.PreserveAspectFit
            }
            Text {
                text: "SteamLab"
                color: root.primaryText
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
            }
            Text {
                text: "WATER & STEAM"
                color: root.secondaryText
                font.pixelSize: 9
                font.bold: true
            }
        }
    }

    StackLayout {
        id: pages
        anchors.fill: parent
        anchors.margins: root.selectedPage === 3 ? 0 : 16
        anchors.bottomMargin: root.selectedPage === 3 ? 0 : 8
        currentIndex: root.selectedPage

        ScrollView {
            clip: true
            contentWidth: availableWidth
            ColumnLayout {
                width: pages.width
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Text {
                        text: "Calculate properties"
                        color: root.primaryText
                        font.pixelSize: 22
                        font.bold: true
                    }
                    Text {
                        text: "IF97 water and steam properties"
                        color: root.secondaryText
                        font.pixelSize: 13
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: stateSelector.implicitHeight + 24
                    radius: 18
                    color: root.cardColor
                    border.color: root.cardBorder
                    ColumnLayout {
                        id: stateSelector
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        Text {
                            text: "STATE"
                            color: root.secondaryText
                            font.pixelSize: 10
                            font.bold: true
                        }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: width < 360 ? 1 : 2
                            columnSpacing: 8
                            rowSpacing: 8
                            Repeater {
                                model: [
                                    {label: "Saturated liquid", value: "saturatedLiquid"},
                                    {label: "Saturated vapor", value: "saturatedVapor"},
                                    {label: "Compressed liquid", value: "compressed"},
                                    {label: "Superheated vapor", value: "superheated"}
                                ]
                                delegate: Button {
                                    Layout.fillWidth: true
                                    implicitHeight: 42
                                    text: modelData.label
                                    checkable: true
                                    checked: root.selectedState === modelData.value
                                    onClicked: {
                                        root.selectedState = modelData.value
                                        root.calculationError = ""
                                    }
                                    background: Rectangle {
                                        radius: 10
                                        color: checked ? "#123B57" : "#142236"
                                        border.color: checked ? root.accent : "#334155"
                                    }
                                    contentItem: Text {
                                        text: parent.text
                                        color: parent.checked ? root.accent : root.secondaryText
                                        font.pixelSize: 12
                                        font.bold: parent.checked
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: inputColumn.implicitHeight + 32
                    radius: 18
                    color: root.cardColor
                    border.color: root.cardBorder
                    ColumnLayout {
                        id: inputColumn
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14
                        Text {
                            text: "INPUT"
                            color: root.secondaryText
                            font.pixelSize: 10
                            font.bold: true
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Text {
                                text: root.selectedState.startsWith("saturated")
                                      ? "Saturation temperature (°C)" : "Temperature (°C)"
                                color: root.primaryText
                                font.pixelSize: 13
                            }
                            TextField {
                                id: temperatureField
                                Layout.fillWidth: true
                                text: "100.0"
                                color: root.primaryText
                                font.pixelSize: 16
                                selectByMouse: true
                                inputMethodHints: Qt.ImhFormattedNumbersOnly
                                validator: DoubleValidator { bottom: 0.01; top: 2000; decimals: 4 }
                                background: Rectangle {
                                    radius: 10
                                    color: "#101B2D"
                                    border.color: temperatureField.activeFocus ? root.accent : root.cardBorder
                                }
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            opacity: root.selectedState.startsWith("saturated") ? 0.45 : 1
                            Text {
                                text: "Pressure (bar)"
                                color: root.primaryText
                                font.pixelSize: 13
                            }
                            TextField {
                                id: pressureField
                                Layout.fillWidth: true
                                text: "1.013"
                                enabled: !root.selectedState.startsWith("saturated")
                                color: root.primaryText
                                font.pixelSize: 16
                                selectByMouse: true
                                inputMethodHints: Qt.ImhFormattedNumbersOnly
                                validator: DoubleValidator { bottom: 0.0061; top: 1000; decimals: 5 }
                                background: Rectangle {
                                    radius: 10
                                    color: "#101B2D"
                                    border.color: pressureField.activeFocus ? root.accent : root.cardBorder
                                }
                            }
                        }
                        Text {
                            visible: root.selectedState.startsWith("saturated")
                            text: "Pressure is calculated from saturation temperature."
                            color: root.secondaryText
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                        }
                    }
                }

                Button {
                    Layout.fillWidth: true
                    implicitHeight: 50
                    text: "CALCULATE"
                    onClicked: root.calculate()
                    background: Rectangle {
                        radius: 12
                        color: root.accent
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#08263A"
                        font.pixelSize: 15
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Text {
                    visible: root.calculationError.length > 0
                    Layout.fillWidth: true
                    text: root.calculationError
                    color: "#FDA4AF"
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }

                Text {
                    Layout.fillWidth: true
                    text: "Choose a state, enter conditions, then calculate."
                    color: root.secondaryText
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
            }
        }

        ScrollView {
            clip: true
            contentWidth: availableWidth
            ColumnLayout {
                width: pages.width
                spacing: 14
                Text {
                    text: "State results"
                    color: root.primaryText
                    font.pixelSize: 22
                    font.bold: true
                }
                Text {
                    visible: root.resultData.ok !== true
                    Layout.fillWidth: true
                    text: "Calculate a state to see its properties."
                    color: root.secondaryText
                    font.pixelSize: 13
                    wrapMode: Text.Wrap
                }
                Rectangle {
                    visible: root.resultData.ok === true
                    Layout.fillWidth: true
                    implicitHeight: 46
                    radius: 14
                    color: "#123B57"
                    border.color: "#1D5A7D"
                    Text {
                        anchors.centerIn: parent
                        text: {
                            const states = {
                                saturatedLiquid: "Saturated liquid",
                                saturatedVapor: "Saturated vapor",
                                compressed: "Compressed liquid",
                                superheated: "Superheated vapor"
                            }
                            return states[root.resultData.state] || ""
                        }
                        color: root.accent
                        font.pixelSize: 14
                        font.bold: true
                    }
                }
                GridLayout {
                    visible: root.resultData.ok === true
                    Layout.fillWidth: true
                    columns: width < 350 ? 1 : 2
                    columnSpacing: 10
                    rowSpacing: 10
                    Repeater {
                        model: [
                            {name: "Enthalpy", value: "enthalpy", unit: "kJ/kg"},
                            {name: "Entropy", value: "entropy", unit: "kJ/kg·K"},
                            {name: "Specific volume", value: "volume", unit: "m³/kg"},
                            {name: "Density", value: "density", unit: "kg/m³"},
                            {name: "Internal energy", value: "internalEnergy", unit: "kJ/kg"},
                            {name: "Cp", value: "cp", unit: "kJ/kg·K"},
                            {name: "Cv", value: "cv", unit: "kJ/kg·K"},
                            {name: "Speed of sound", value: "soundSpeed", unit: "m/s"}
                        ]
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 104
                            radius: 14
                            color: root.cardColor
                            border.color: root.cardBorder
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 4
                                Text {
                                    text: modelData.name
                                    color: root.secondaryText
                                    font.pixelSize: 12
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: Number(root.resultData[modelData.value] || 0).toLocaleString(Qt.locale(), 'f', 3)
                                    color: root.primaryText
                                    font.pixelSize: 22
                                    font.bold: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: modelData.unit
                                    color: root.secondaryText
                                    font.pixelSize: 10
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    visible: root.resultData.ok === true
                    Layout.fillWidth: true
                    implicitHeight: 48
                    radius: 12
                    color: root.cardColor
                    border.color: root.cardBorder
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        Text { text: "Temperature"; color: root.secondaryText; font.pixelSize: 12 }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: Number(root.resultData.temperature || 0).toFixed(3) + " °C"
                            color: root.primaryText
                            font.pixelSize: 13
                        }
                    }
                }
                Rectangle {
                    visible: root.resultData.ok === true
                    Layout.fillWidth: true
                    implicitHeight: 48
                    radius: 12
                    color: root.cardColor
                    border.color: root.cardBorder
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        Text { text: "Pressure"; color: root.secondaryText; font.pixelSize: 12 }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: Number(root.resultData.pressure || 0).toFixed(5) + " bar"
                            color: root.primaryText
                            font.pixelSize: 13
                        }
                    }
                }
            }
        }

        ScrollView {
            clip: true
            contentWidth: availableWidth
            ColumnLayout {
                width: pages.width
                spacing: 14
                Text {
                    text: "Saturation table"
                    color: root.primaryText
                    font.pixelSize: 22
                    font.bold: true
                }
                Text {
                    text: "Values are calculated by the water/steam engine."
                    color: root.secondaryText
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 42
                    radius: 10
                    color: "#123B57"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 4
                        Repeater {
                            model: ["T (°C)", "P (bar)", "hL (kJ/kg)", "hV (kJ/kg)"]
                            delegate: Text {
                                Layout.fillWidth: true
                                text: modelData
                                color: root.accent
                                font.pixelSize: 10
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }
                Repeater {
                    model: root.tableRows
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 48
                        radius: 10
                        color: index % 2 === 0 ? root.cardColor : "#172337"
                        border.color: root.cardBorder
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 4
                            Repeater {
                                model: [
                                    Number(modelData.temperature).toFixed(0),
                                    Number(modelData.pressure).toFixed(4),
                                    Number(modelData.liquidEnthalpy).toFixed(1),
                                    Number(modelData.vaporEnthalpy).toFixed(1)
                                ]
                                delegate: Text {
                                    Layout.fillWidth: true
                                    text: modelData
                                    color: root.primaryText
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }
                }
                Text {
                    visible: root.tableRows.length === 0
                    text: "Saturation data is unavailable."
                    color: "#FDA4AF"
                    font.pixelSize: 12
                }
            }
        }

        ScrollView {
            clip: true
            contentWidth: availableWidth
            ColumnLayout {
                width: pages.width
                spacing: root.selectedPage === 3 ? 10 : 14
                RowLayout {
                    Layout.fillWidth: true
                    implicitHeight: 48
                    spacing: 10
                    ToolButton {
                        text: "‹"
                        implicitWidth: 42
                        implicitHeight: 42
                        onClicked: root.selectedPage = 0
                        background: Rectangle {
                            radius: 12
                            color: root.cardColor
                            border.color: root.cardBorder
                        }
                        contentItem: Text {
                            text: parent.text
                            color: root.accent
                            font.pixelSize: 28
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: "SteamLab"
                            color: root.primaryText
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Text {
                            text: "FULL-SCREEN PLOTTER"
                            color: root.secondaryText
                            font.pixelSize: 9
                            font.bold: true
                        }
                    }
                    Text {
                        text: root.plotTypes[root.selectedPlot].name
                        color: root.accent
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
                Text {
                    text: "Steam property plots"
                    color: root.primaryText
                    font.pixelSize: 22
                    font.bold: true
                }
                Text {
                    text: "Choose from all 19 plots provided by the steam calculation backend."
                    color: root.secondaryText
                    font.pixelSize: 12
                    wrapMode: Text.Wrap
                }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: plotSelector.implicitHeight + 20
                    radius: 14
                    color: root.cardColor
                    border.color: root.cardBorder
                    ColumnLayout {
                        id: plotSelector
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8
                        Text {
                            text: "SELECT A DIAGRAM"
                            color: root.secondaryText
                            font.pixelSize: 10
                            font.bold: true
                        }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: width < 360 ? 3 : 4
                            columnSpacing: 6
                            rowSpacing: 6
                            Repeater {
                                model: root.plotTypes
                                delegate: Button {
                                    Layout.fillWidth: true
                                    implicitHeight: 36
                                    text: modelData.name
                                    onClicked: root.loadPlot(index)
                                    background: Rectangle {
                                        radius: 9
                                        color: root.selectedPlot === index ? "#123B57" : "#142236"
                                        border.color: root.selectedPlot === index ? root.accent : root.cardBorder
                                    }
                                    contentItem: Text {
                                        text: parent.text
                                        color: root.selectedPlot === index ? root.accent : root.secondaryText
                                        font.pixelSize: 12
                                        font.bold: root.selectedPlot === index
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3
                        Text {
                            Layout.fillWidth: true
                            text: root.plotTypes[root.selectedPlot].title
                            color: root.primaryText
                            font.pixelSize: 17
                            font.bold: true
                            wrapMode: Text.Wrap
                        }
                        Text {
                            text: "Zoom " + root.plotZoom.toFixed(1) + "×"
                            color: root.secondaryText
                            font.pixelSize: 11
                        }
                    }
                    Button {
                        text: "−"
                        implicitWidth: 42
                        implicitHeight: 40
                        enabled: root.plotZoom > 1
                        onClicked: root.zoomPlot(1 / 1.4)
                        background: Rectangle {
                            radius: 11
                            color: root.cardColor
                            border.color: root.cardBorder
                        }
                        contentItem: Text {
                            text: parent.text
                            color: root.primaryText
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Button {
                        text: "+"
                        implicitWidth: 42
                        implicitHeight: 40
                        enabled: root.plotZoom < 32
                        onClicked: root.zoomPlot(1.4)
                        background: Rectangle {
                            radius: 11
                            color: root.cardColor
                            border.color: root.cardBorder
                        }
                        contentItem: Text {
                            text: parent.text
                            color: root.primaryText
                            font.pixelSize: 22
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Button {
                        text: "Reset"
                        implicitHeight: 40
                        onClicked: root.resetPlotView()
                        background: Rectangle {
                            radius: 11
                            color: "#123B57"
                            border.color: "#1D5A7D"
                        }
                        contentItem: Text {
                            text: parent.text
                            color: root.accent
                            font.pixelSize: 11
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(360, root.height * 0.58)
                    radius: 20
                    color: "#101B2D"
                    border.color: root.cardBorder
                    Canvas {
                        id: plotCanvas
                        anchors.fill: parent
                        anchors.margins: 14
                        onPaint: {
                            const ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            const left = 48
                            const right = width - 12
                            const top = 16
                            const bottom = height - 38
                            const bounds = root.currentPlotBounds()
                            if (!bounds) {
                                ctx.fillStyle = root.secondaryText
                                ctx.font = "13px sans-serif"
                                ctx.fillText("No plot data available.", 12, 24)
                                return
                            }
                            const xMin = bounds.xMin
                            const xMax = bounds.xMax
                            const yMin = bounds.yMin
                            const yMax = bounds.yMax
                            const xMap = value => left + (value - xMin) / (xMax - xMin) * (right - left)
                            const yMap = value => bottom - (value - yMin) / (yMax - yMin) * (bottom - top)
                            ctx.strokeStyle = "#26374C"
                            ctx.lineWidth = 1
                            ctx.fillStyle = root.secondaryText
                            ctx.font = "10px sans-serif"
                            const tickCount = 5
                            for (let tick = 0; tick <= tickCount; ++tick) {
                                const value = xMin + (xMax - xMin) * tick / tickCount
                                const x = xMap(value)
                                ctx.beginPath()
                                ctx.moveTo(x, top)
                                ctx.lineTo(x, bottom)
                                ctx.stroke()
                                ctx.fillText(value.toPrecision(3), x - 12, bottom + 14)
                                const yValue = yMin + (yMax - yMin) * tick / tickCount
                                const y = yMap(yValue)
                                ctx.beginPath()
                                ctx.moveTo(left, y)
                                ctx.lineTo(right, y)
                                ctx.stroke()
                                ctx.fillText(yValue.toPrecision(3), 2, y + 3)
                            }
                            ctx.fillStyle = root.secondaryText
                            ctx.fillText(root.plotTypes[root.selectedPlot].xLabel, (left + right) / 2 - 45, height - 4)
                            ctx.save()
                            ctx.translate(11, (top + bottom) / 2)
                            ctx.rotate(-Math.PI / 2)
                            ctx.fillText(root.plotTypes[root.selectedPlot].yLabel, -70, 0)
                            ctx.restore()
                            ctx.save()
                            ctx.beginPath()
                            ctx.rect(left, top, right - left, bottom - top)
                            ctx.clip()
                            const drawSeries = (values, color) => {
                                ctx.beginPath()
                                ctx.strokeStyle = color
                                ctx.lineWidth = 2
                                let started = false
                                for (let i = 0; i < root.plotX.length && i < values.length; ++i) {
                                    const xValue = Number(root.plotX[i])
                                    const yValue = Number(values[i])
                                    if (!Number.isFinite(xValue) || !Number.isFinite(yValue)) {
                                        started = false
                                        continue
                                    }
                                    const x = xMap(xValue)
                                    const y = yMap(yValue)
                                    if (!started) {
                                        ctx.moveTo(x, y)
                                        started = true
                                    } else {
                                        ctx.lineTo(x, y)
                                    }
                                }
                                ctx.stroke()
                            }
                            drawSeries(root.plotY0, "#38BDF8")
                            if (root.plotY1.length > 0)
                                drawSeries(root.plotY1, "#F87171")
                            if (root.selectedPointIndex >= 0) {
                                const pointX = xMap(root.selectedPointX)
                                const pointY = yMap(root.selectedPointY)
                                ctx.beginPath()
                                ctx.arc(pointX, pointY, 7, 0, Math.PI * 2)
                                ctx.fillStyle = root.selectedPointSeries === 0 ? "#38BDF8" : "#F87171"
                                ctx.fill()
                                ctx.lineWidth = 2
                                ctx.strokeStyle = "#F1F5F9"
                                ctx.stroke()
                                ctx.beginPath()
                                ctx.setLineDash([4, 4])
                                ctx.strokeStyle = "#94A3B8"
                                ctx.lineWidth = 1
                                ctx.moveTo(pointX, top)
                                ctx.lineTo(pointX, bottom)
                                ctx.moveTo(left, pointY)
                                ctx.lineTo(right, pointY)
                                ctx.stroke()
                                ctx.setLineDash([])
                            }
                            ctx.restore()
                        }
                        TapHandler {
                            onTapped: eventPoint => root.selectPlotPoint(eventPoint.position.x, eventPoint.position.y)
                            onDoubleTapped: root.resetPlotView()
                        }
                        PinchHandler {
                            target: null
                            property real previousScale: 1
                            onActiveChanged: previousScale = 1
                            onScaleChanged: {
                                if (active && previousScale > 0) {
                                    root.zoomPlot(scale / previousScale)
                                    previousScale = scale
                                }
                            }
                        }
                        WheelHandler {
                            onWheel: event => {
                                root.zoomPlot(event.angleDelta.y > 0 ? 1.15 : 1 / 1.15)
                                event.accepted = true
                            }
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 76
                    radius: 14
                    color: root.selectedPointIndex >= 0 ? "#123B57" : root.cardColor
                    border.color: root.selectedPointIndex >= 0 ? "#1D5A7D" : root.cardBorder
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 12
                        Rectangle {
                            width: 30
                            height: 30
                            radius: 10
                            color: root.selectedPointIndex >= 0
                                   ? (root.selectedPointSeries === 0 ? "#38BDF8" : "#F87171")
                                   : "#334155"
                            Text {
                                anchors.centerIn: parent
                                text: root.selectedPointIndex >= 0 ? "●" : "＋"
                                color: "#0F172A"
                                font.pixelSize: 14
                                font.bold: true
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3
                            Text {
                                text: root.selectedPointIndex >= 0
                                      ? (root.selectedPointSeries === 0
                                         ? root.plotTypes[root.selectedPlot].first
                                         : root.plotTypes[root.selectedPlot].second)
                                      : "Select a point"
                                color: root.selectedPointIndex >= 0 ? root.primaryText : root.secondaryText
                                font.pixelSize: 12
                                font.bold: root.selectedPointIndex >= 0
                            }
                            Text {
                                visible: root.selectedPointIndex < 0
                                text: "Tap a curve to inspect its X and Y coordinates"
                                color: root.secondaryText
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }
                            RowLayout {
                                visible: root.selectedPointIndex >= 0
                                Layout.fillWidth: true
                                spacing: 10
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text {
                                        text: "X · " + root.plotTypes[root.selectedPlot].xLabel
                                        color: root.secondaryText
                                        font.pixelSize: 9
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        text: root.selectedPointX.toPrecision(6)
                                        color: root.accent
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text {
                                        text: "Y · " + root.plotTypes[root.selectedPlot].yLabel
                                        color: root.secondaryText
                                        font.pixelSize: 9
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        text: root.selectedPointY.toPrecision(6)
                                        color: root.accent
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                            }
                        }
                        ToolButton {
                            visible: root.selectedPointIndex >= 0
                            text: "×"
                            onClicked: {
                                root.selectedPointIndex = -1
                                plotCanvas.requestPaint()
                            }
                            contentItem: Text {
                                text: parent.text
                                color: root.secondaryText
                                font.pixelSize: 20
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
                Text {
                    Layout.fillWidth: true
                    text: "Pinch to zoom · Double tap to reset · Tap a curve to inspect a point"
                    color: root.secondaryText
                    font.pixelSize: 11
                    wrapMode: Text.Wrap
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 18
                    Repeater {
                        model: root.plotY1.length > 0
                            ? [
                                {label: root.plotTypes[root.selectedPlot].first, color: "#38BDF8"},
                                {label: root.plotTypes[root.selectedPlot].second, color: "#F87171"}
                            ]
                            : [{label: root.plotTypes[root.selectedPlot].first, color: "#38BDF8"}]
                        delegate: RowLayout {
                            spacing: 6
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: modelData.color
                            }
                            Text {
                                text: modelData.label
                                color: root.secondaryText
                                font.pixelSize: 11
                            }
                        }
                    }
                }
                Text {
                    Layout.fillWidth: true
                    text: root.plotX.length + " points from the steam calculation backend"
                    color: root.secondaryText
                    font.pixelSize: 11
                }
            }
        }
    }

    footer: TabBar {
                id: navigation
                visible: root.selectedPage !== 3
                currentIndex: root.selectedPage
                onCurrentIndexChanged: root.selectedPage = currentIndex
                implicitHeight: 62

                background: Rectangle {
                    color: "#111D31"
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1
                        color: "#1E293B"
                    }
                }

                // 1. Calculate
                TabButton {
                    id: btnCalc
                    contentItem: Item {
                        implicitHeight: 52
                        Column {
                            anchors.centerIn: parent
                            spacing: 3

                            Item {
                                width: 24
                                height: 24
                                x: (parent.width - width) / 2

                                Image {
                                    id: imgCalc
                                    anchors.fill: parent
                                    source: "assets/img/calculator.svg"
                                    fillMode: Image.PreserveAspectFit
                                    visible: false
                                }
                                ColorOverlay {
                                    anchors.fill: imgCalc
                                    source: imgCalc
                                    color: navigation.currentIndex === 0 ? root.accent : root.secondaryText
                                }
                            }

                            Text {
                                text: "Calculate"
                                font.pixelSize: 10
                                font.weight: navigation.currentIndex === 0 ? Font.DemiBold : Font.Normal
                                color: navigation.currentIndex === 0 ? root.accent : root.secondaryText
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    background: Rectangle {
                        color: "transparent"
                    }
                }

                // 2. Results
                TabButton {
                    id: btnResults
                    contentItem: Item {
                        implicitHeight: 52
                        Column {
                            anchors.centerIn: parent
                            spacing: 3

                            Item {
                                width: 24
                                height: 24
                                x: (parent.width - width) / 2

                                Image {
                                    id: imgResults
                                    anchors.fill: parent
                                    source: "assets/img/table.svg"
                                    fillMode: Image.PreserveAspectFit
                                    visible: false
                                }
                                ColorOverlay {
                                    anchors.fill: imgResults
                                    source: imgResults
                                    color: navigation.currentIndex === 1 ? root.accent : root.secondaryText
                                }
                            }

                            Text {
                                text: "Results"
                                font.pixelSize: 10
                                font.weight: navigation.currentIndex === 1 ? Font.DemiBold : Font.Normal
                                color: navigation.currentIndex === 1 ? root.accent : root.secondaryText
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    background: Rectangle {
                        color: "transparent"
                    }
                }

                // 3. Tables
                TabButton {
                    id: btnTables
                    contentItem: Item {
                        implicitHeight: 52
                        Column {
                            anchors.centerIn: parent
                            spacing: 3

                            Item {
                                width: 24
                                height: 24
                                x: (parent.width - width) / 2

                                Image {
                                    id: imgTables
                                    anchors.fill: parent
                                    source: "assets/img/table.svg"
                                    fillMode: Image.PreserveAspectFit
                                    visible: false
                                }
                                ColorOverlay {
                                    anchors.fill: imgTables
                                    source: imgTables
                                    color: navigation.currentIndex === 2 ? root.accent : root.secondaryText
                                }
                            }

                            Text {
                                text: "Tables"
                                font.pixelSize: 10
                                font.weight: navigation.currentIndex === 2 ? Font.DemiBold : Font.Normal
                                color: navigation.currentIndex === 2 ? root.accent : root.secondaryText
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    background: Rectangle {
                        color: "transparent"
                    }
                }

                // 4. Plotter
                TabButton {
                    id: btnPlotter
                    contentItem: Item {
                        implicitHeight: 52
                        Column {
                            anchors.centerIn: parent
                            spacing: 3

                            Item {
                                width: 24
                                height: 24
                                x: (parent.width - width) / 2

                                Image {
                                    id: imgPlotter
                                    anchors.fill: parent
                                    source: "assets/img/plotter.svg"
                                    fillMode: Image.PreserveAspectFit
                                    visible: false
                                }
                                ColorOverlay {
                                    anchors.fill: imgPlotter
                                    source: imgPlotter
                                    color: navigation.currentIndex === 3 ? root.accent : root.secondaryText
                                }
                            }

                            Text {
                                text: "Plotter"
                                font.pixelSize: 10
                                font.weight: navigation.currentIndex === 3 ? Font.DemiBold : Font.Normal
                                color: navigation.currentIndex === 3 ? root.accent : root.secondaryText
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }

}
