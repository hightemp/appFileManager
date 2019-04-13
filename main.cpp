#ifdef QT_WIDGETS_LIB
    #include <QtWidgets/QApplication>
#else
    #include <QtGui/QGuiApplication>
#endif

QT_BEGIN_NAMESPACE

#ifdef QT_WIDGETS_LIB
    #define QtQuickControlsApplication QApplication
#else
    #define QtQuickControlsApplication QGuiApplication
#endif

QT_END_NAMESPACE

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QtSvg>
#include <QDir>
#include <QIcon>

#include "FilesListModel.h"
#include "FilesListFilterProxyModel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QtQuickControlsApplication oApplication(argc, argv);

    oApplication.setWindowIcon(QIcon(":/images/folder.svg"));

    QQmlApplicationEngine oEngine;
    oEngine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (oEngine.rootObjects().isEmpty())
        return -1;

    FilesListModel oFilesListModel;
    FilesListFilterProxyModel oFilesListFilterProxyModel;

    oFilesListFilterProxyModel.setSourceModel(&oFilesListModel);

    QFont oFixedFont = QFontDatabase::systemFont(QFontDatabase::FixedFont);
    //QFont oFixedFont("Monospace");
    //oFixedFont.setStyleHint(QFont::TypeWriter);
    oFixedFont.setPixelSize(10);
    oEngine.rootContext()->setContextProperty("oFixedFont", oFixedFont);

    oEngine.rootContext()->setContextProperty("oFilesListModel", &oFilesListModel);
    oEngine.rootContext()->setContextProperty("oFilesListFilterProxyModel", &oFilesListFilterProxyModel);

    return oApplication.exec();
}
