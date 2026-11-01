cmake_minimum_required(VERSION 3.16)

project(H2OApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 Charts)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appH2OApp
    main.cpp
)

qt_add_qml_module(appH2OApp
    URI H2OApp
    VERSION 1.0
    QML_FILES
        Main.qml
        Plot.qml
        ItemPlot.qml
        Chart.qml
        FrmLiquidVapor.qml
        InputForm.qml
        CustomDelayButton.qml
        FormTable.qml
        Theme.qml
    SOURCES
        convermatlabtoc.h
        convermatlabtoc.cpp
        plot.h
        plot.cpp
        SteamCalculator.h
        SteamCalculator.cpp
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
