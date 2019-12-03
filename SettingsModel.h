#ifndef SETTINGSMODEL_H
#define SETTINGSMODEL_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QException>
#include <QDebug>
#include <QFileInfo>
#include <QJsonDocument>

class SettingsModel : public QObject
{
    Q_OBJECT

protected:
    QJsonObject* poJsonObject = nullptr;
    QString sFilePath;

public:
    explicit SettingsModel(QObject *parent = nullptr);
    ~SettingsModel();

signals:

public slots:
    void fnSetDefaultStringValue(QVariant sName, QVariant oValue);
    void fnUpdateStringValue(QVariant sName, QVariant oValue, QVariant sDefaultValue="");
    QVariant fnGetStringValue(QVariant sName, QVariant sDefaultValue="");

    void fnSetDefaultIntValue(QVariant sName, QVariant oValue);
    void fnUpdateIntValue(QVariant sName, QVariant oValue, QVariant sDefaultValue=0);
    QVariant fnGetIntValue(QVariant sName, QVariant iDefaultValue=0);

    void fnSetDefaultBoolValue(QVariant sName, QVariant oValue);
    void fnUpdateBoolValue(QVariant sName, QVariant oValue, QVariant bDefaultValue=false);
    QVariant fnGetBoolValue(QVariant sName, QVariant bDefaultValue=false);

    void fnUpdateJsonArrayValue(QVariant sName, QJsonArray oValue);
    QJsonArray fnGetJsonArrayValue(QVariant sName);
    void fnSetFilePath(QString aFilePath);
    QVariant fnGetFilePath();
    QVariant fnLoad();
    QVariant fnSave();
    bool fnFileExists();
};

#endif // SETTINGSMODEL_H
