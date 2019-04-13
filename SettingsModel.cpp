#include "SettingsModel.h"

SettingsModel::SettingsModel(QObject *parent) : QObject(parent)
{
    qDebug() << __PRETTY_FUNCTION__;
    this->poJsonObject = new QJsonObject();
}

SettingsModel::~SettingsModel()
{
    qDebug() << __PRETTY_FUNCTION__;
    delete this->poJsonObject;
}

void SettingsModel::fnSetDefaultStringValue(QVariant sName, QVariant oValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName << oValue;
    this->fnUpdateStringValue(sName, this->fnGetStringValue(sName, oValue));
}

void SettingsModel::fnUpdateStringValue(QVariant sName, QVariant oValue, QVariant sDefaultValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName << oValue;
    QString sResult = oValue.toString();
    (*this->poJsonObject)[sName.toString()] = sResult.isEmpty() ? sDefaultValue.toString() : sResult;
}

QVariant SettingsModel::fnGetStringValue(QVariant sName, QVariant sDefaultValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName;

    QJsonValue oJsonValue = (*this->poJsonObject)[sName.toString()];

    if (oJsonValue.isUndefined() || oJsonValue.isNull()) {
        return sDefaultValue;
    }

    return oJsonValue.toString();
}

void SettingsModel::fnSetDefaultIntValue(QVariant sName, QVariant oValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName << oValue;
    this->fnUpdateIntValue(sName, this->fnGetIntValue(sName, oValue));
}

void SettingsModel::fnUpdateIntValue(QVariant sName, QVariant oValue, QVariant sDefaultValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName << oValue;
    (*this->poJsonObject)[sName.toString()] = oValue.isNull() && !sDefaultValue.isNull() ? sDefaultValue.toInt() : oValue.toInt();
}

QVariant SettingsModel::fnGetIntValue(QVariant sName, QVariant iDefaultValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName;
    QJsonValue oJsonValue = (*this->poJsonObject)[sName.toString()];

    if (oJsonValue.isUndefined() || oJsonValue.isNull()) {
        return iDefaultValue;
    }

    return oJsonValue.toInt();
}

void SettingsModel::fnSetDefaultBoolValue(QVariant sName, QVariant oValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName << oValue;
    this->fnUpdateBoolValue(sName, this->fnGetBoolValue(sName, oValue));
}

void SettingsModel::fnUpdateBoolValue(QVariant sName, QVariant oValue, QVariant bDefaultValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName << oValue;
    (*this->poJsonObject)[sName.toString()] = oValue.isNull() && !bDefaultValue.isNull() ? bDefaultValue.toBool() : oValue.toBool();
}

QVariant SettingsModel::fnGetBoolValue(QVariant sName, QVariant bDefaultValue)
{
    qDebug() << __PRETTY_FUNCTION__ << sName;

    QJsonValue oJsonValue = (*this->poJsonObject)[sName.toString()];

    if (oJsonValue.isUndefined() || oJsonValue.isNull()) {
        return bDefaultValue;
    }

    return oJsonValue.toBool();
}

void SettingsModel::fnUpdateJsonArrayValue(QVariant sName, QJsonArray oValue)
{
    qDebug() << __PRETTY_FUNCTION__;
    (*this->poJsonObject)[sName.toString()] = oValue;
}

QJsonArray SettingsModel::fnGetJsonArrayValue(QVariant sName)
{
    qDebug() << __PRETTY_FUNCTION__;
    return (*this->poJsonObject)[sName.toString()].toArray();
}

void SettingsModel::fnSetFilePath(QString aFilePath)
{
    qDebug() << __PRETTY_FUNCTION__;
    this->sFilePath = aFilePath;
}

QVariant SettingsModel::fnGetFilePath()
{
    qDebug() << __PRETTY_FUNCTION__;
    return this->sFilePath;
}

QVariant SettingsModel::fnLoad()
{
    qDebug() << __PRETTY_FUNCTION__;
    if (this->poJsonObject != nullptr) {
        delete this->poJsonObject;
    }

    this->poJsonObject = new QJsonObject;

    if (!this->fnFileExists()) {
        return 0;
    }

    QFile oFileObj(this->sFilePath);

    if (!oFileObj.open(QIODevice::ReadOnly)) {
        return -1;
    }

    QByteArray oByteArray = oFileObj.readAll();

    qDebug() << oByteArray;

    QJsonDocument oJsonDocument = QJsonDocument::fromJson(oByteArray);

    oFileObj.close();

    if (!oJsonDocument.isObject()) {
        return -2;
    }

    *this->poJsonObject = oJsonDocument.object();

    return 1;
}

QVariant SettingsModel::fnSave()
{
    qDebug() << __PRETTY_FUNCTION__;

    QFile oFileObj(this->sFilePath);

    if (!oFileObj.open(QIODevice::WriteOnly)) {
        return -1;
    }

    QJsonDocument oJsonDocument(*this->poJsonObject);

    QByteArray oByteArray = oJsonDocument.toJson();

    qDebug() << oByteArray;

    oFileObj.write(oByteArray);

    oFileObj.close();

    return 1;
}

bool SettingsModel::fnFileExists()
{
    qDebug() << __PRETTY_FUNCTION__;
    QFileInfo oFileInfo(this->sFilePath);

    return oFileInfo.exists() && oFileInfo.isFile();
}
