cmake_minimum_required(VERSION 3.16)

project(H2OApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Charts)

qt_standard_project_setup(REQUIRES 6.5)

set_source_files_properties(
    qml/Main.qml
    PROPERTIES QT_RESOURCE_ALIAS Main.qml
)
set_source_files_properties(
    qml/theme/Theme.qml
    PROPERTIES QT_RESOURCE_ALIAS Theme.qml
)
set_source_files_properties(
    qml/screens/Plot.qml
    PROPERTIES QT_RESOURCE_ALIAS Plot.qml
)
set_source_files_properties(
    qml/screens/FrmLiquidVapor.qml
    PROPERTIES QT_RESOURCE_ALIAS FrmLiquidVapor.qml
)
set_source_files_properties(
    qml/components/Chart.qml
    PROPERTIES QT_RESOURCE_ALIAS Chart.qml
)
set_source_files_properties(
    qml/components/ItemPlot.qml
    PROPERTIES QT_RESOURCE_ALIAS ItemPlot.qml
)
set_source_files_properties(
    qml/components/InputForm.qml
    PROPERTIES QT_RESOURCE_ALIAS InputForm.qml
)
set_source_files_properties(
    qml/components/FormTable.qml
    PROPERTIES QT_RESOURCE_ALIAS FormTable.qml
)
set_source_files_properties(
    qml/components/CustomDelayButton.qml
    PROPERTIES QT_RESOURCE_ALIAS CustomDelayButton.qml
)
set_source_files_properties(
    assets/img/back.png
    PROPERTIES QT_RESOURCE_ALIAS img/back.png
)
set_source_files_properties(
    assets/img/Compressed.png
    PROPERTIES QT_RESOURCE_ALIAS img/Compressed.png
)

qt_add_executable(appH2OApp
    src/main.cpp
)

qt_add_qml_module(appH2OApp
    URI H2OApp
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/screens/Plot.qml
        qml/screens/FrmLiquidVapor.qml
        qml/components/Chart.qml
        qml/components/ItemPlot.qml
        qml/components/InputForm.qml
        qml/components/FormTable.qml
        qml/components/CustomDelayButton.qml
        qml/theme/Theme.qml
    SOURCES
        src/calculator/convermatlabtoc.h
        src/calculator/convermatlabtoc.cpp
        src/calculator/SteamCalculator.h
        src/calculator/SteamCalculator.cpp
        src/plot/plot.h
        src/plot/plot.cpp
    RESOURCES
        assets/img/water_drop.svg
        assets/img/splash.png
        RESOURCES assets/img/calculator.svg assets/img/table.svg assets/img/plotter.svg assets/img/settings.svg
)

target_include_directories(appH2OApp PRIVATE
    src/calculator
    src/plot
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appH2OApp PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appH2OApp
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appH2OApp
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Charts
)

include(GNUInstallDirs)
install(TARGETS appH2OApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
