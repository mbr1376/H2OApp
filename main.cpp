#include <QApplication>
#include <QQmlApplicationEngine>
#include  "plot.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<Plot>("Plots", 1,0 ,"PlotCpp");

    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/qt/qml/H2OApp/Theme.qml")), "App.Theme", 1, 0, "Theme");


    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("H2OApp", "Main");

    return app.exec();
}
