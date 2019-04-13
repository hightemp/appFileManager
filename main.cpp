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
#include "SettingsModel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QtQuickControlsApplication oApplication(argc, argv);

    oApplication.setWindowIcon(QIcon(":/images/folder.svg"));

    QString sConfigFileName = ".appFileManager.cfg";
    QString sConfigFilePath = QDir::homePath() + "/" + sConfigFileName;

    SettingsModel oSettingsModel;
    oSettingsModel.fnSetFilePath(sConfigFilePath);

    if (!oSettingsModel.fnFileExists()) {
        oSettingsModel.fnSave();
    }

    oSettingsModel.fnLoad();

    QQmlApplicationEngine oEngine;
    oEngine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (oEngine.rootObjects().isEmpty())
        return -1;

    oEngine.rootContext()->setContextProperty("oSettingsModel", &oSettingsModel);

    QFont oFixedFont = QFontDatabase::systemFont(QFontDatabase::FixedFont);
    //QFont oFixedFont("Monospace");
    //oFixedFont.setStyleHint(QFont::TypeWriter);
    oFixedFont.setPixelSize(10);
    oEngine.rootContext()->setContextProperty("oFixedFont", oFixedFont);

    FilesListModel oFilesListModel;
    FilesListFilterProxyModel oFilesListFilterProxyModel;

    oFilesListFilterProxyModel.setSourceModel(&oFilesListModel);

    oEngine.rootContext()->setContextProperty("oFilesListModel", &oFilesListModel);
    oEngine.rootContext()->setContextProperty("oFilesListFilterProxyModel", &oFilesListFilterProxyModel);

    #ifdef Q_OS_ANDROID
        oEngine.rootContext()->setContextProperty("sOSType", "Mobile");
    #else
        #ifdef Q_OS_IOS
            oEngine.rootContext()->setContextProperty("sOSType", "Mobile");
        #else
            oEngine.rootContext()->setContextProperty("sOSType", "Desktop");
        #endif
    #endif

    QMetaObject::invokeMethod(oEngine.rootObjects()[0], "fnStart");

    return oApplication.exec();
}
