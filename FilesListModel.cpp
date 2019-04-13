#include "FilesListModel.h"

FilesListModel::FilesListModel(QObject *poParent) : QAbstractListModel (poParent)
{
    qDebug() << __FUNCTION__;

    this->oCurrentPath = QDir(QDir::root());
    this->fnUpdate();
}

FilesListModel::~FilesListModel()
{

}

QHash<int, QByteArray> FilesListModel::roleNames() const
{
    qDebug() << __FUNCTION__;

    return {
        { FileNameRole, "fileName" },
        { FileSizeRole, "fileSize" },
        { FileCreateTimeRole, "fileCreateTime" },
        { FileUpdateTimeRole, "fileUpdateTime" },
        { FileOwnerRole, "fileOwner" },
        { FileGroupRole, "fileGroup" },
        { FilePermissionsRole, "filePermissions" },
        { IsDirRole, "isDir" },
        { IsHiddenRole, "isHidden" },
        { IsExecutableRole, "isExecutable" },
        { IsSymLinkRole, "isSymLink" }
    };
}

QVariant FilesListModel::data(const QModelIndex &oIndex, int iRole) const
{
    qDebug() << __FUNCTION__;

    if (!oIndex.isValid())
        return QVariant();

    if (oIndex.row() >= this->oFileInfoList.size())
        return QVariant();

    if (iRole == FileNameRole) {
        return this->oFileInfoList[oIndex.row()].fileName();
    }

    if (iRole == FileSizeRole) {
        return this->fnFormatSize(this->oFileInfoList[oIndex.row()].size());
    }

    if (iRole == FileCreateTimeRole) {
        return this->oFileInfoList[oIndex.row()].birthTime().toString("hh:mm:ss<br>dd.MM.yyyy");
    }

    if (iRole == FileUpdateTimeRole) {
        return this->oFileInfoList[oIndex.row()].lastModified().toString("hh:mm:ss<br>dd.MM.yyyy");
    }

    if (iRole == FileOwnerRole) {
        return this->oFileInfoList[oIndex.row()].owner();
    }

    if (iRole == FileGroupRole) {
        return this->oFileInfoList[oIndex.row()].group();
    }

    if (iRole == FilePermissionsRole) {
        QFile::Permissions oPermissions = this->oFileInfoList[oIndex.row()].permissions();
        QString sResult = "";

        sResult += oPermissions & QFileDevice::ReadUser ? "r" : "-";
        sResult += oPermissions & QFileDevice::WriteUser ? "w" : "-";
        sResult += oPermissions & QFileDevice::ExeUser ? "x" : "-";
        sResult += oPermissions & QFileDevice::ReadGroup ? "r" : "-";
        sResult += oPermissions & QFileDevice::WriteGroup ? "w" : "-";
        sResult += oPermissions & QFileDevice::ExeGroup ? "x" : "-";
        sResult += oPermissions & QFileDevice::ReadOther ? "r" : "-";
        sResult += oPermissions & QFileDevice::WriteOther ? "w" : "-";
        sResult += oPermissions & QFileDevice::ExeOther ? "x" : "-";

        return sResult;
    }

    if (iRole == IsDirRole) {
        return this->oFileInfoList[oIndex.row()].isDir();
    }

    if (iRole == IsHiddenRole) {
        return this->oFileInfoList[oIndex.row()].isHidden();
    }

    if (iRole == IsExecutableRole) {
        return this->oFileInfoList[oIndex.row()].isExecutable();
    }

    if (iRole == IsSymLinkRole) {
        return this->oFileInfoList[oIndex.row()].isSymLink();
    }

    return QVariant();
}

bool FilesListModel::setData(const QModelIndex &oIndex, const QVariant &oValue, int iRole)
{
    qDebug() << __FUNCTION__;

    return false;
}

QVariant FilesListModel::headerData(int iSection, Qt::Orientation oOrientation, int iRole) const
{
    qDebug() << __FUNCTION__;

    if (iRole != Qt::DisplayRole)
         return QVariant();

     if (oOrientation == Qt::Horizontal)
         return QString("Column %1").arg(iSection);
     else
         return QString("Row %1").arg(iSection);
}

Qt::ItemFlags FilesListModel::flags(const QModelIndex &oIndex) const
{
    qDebug() << __FUNCTION__;

    if (!oIndex.isValid())
        return Qt::ItemIsEnabled;

    return QAbstractItemModel::flags(oIndex) | Qt::ItemIsEditable;
}

bool FilesListModel::insertRows(int iPosition, int iRows, const QModelIndex &oParent)
{
    qDebug() << __FUNCTION__;

    return false;
}

bool FilesListModel::removeRows(int iPosition, int iRows, const QModelIndex &oParent)
{
    qDebug() << __FUNCTION__;

    if (iRows==0) {
        return true;
    }

    beginRemoveRows(QModelIndex(), iPosition, iPosition+iRows-1);

    endRemoveRows();

    return true;
}

QModelIndex FilesListModel::index(int iRow, int iColumn, const QModelIndex &oParent) const
{
    qDebug() << __FUNCTION__;

    return createIndex(iRow, iColumn);
}

QModelIndex FilesListModel::parent(const QModelIndex &oChild) const
{
    qDebug() << __FUNCTION__;

    return QModelIndex();
}

int FilesListModel::rowCount(const QModelIndex &oParent) const
{
    int iRows = this->oFileInfoList.size();

    qDebug() << __FUNCTION__ << iRows;

    return iRows;
}

int FilesListModel::columnCount(const QModelIndex &oParent) const
{
    qDebug() << __FUNCTION__;

    Q_UNUSED(oParent);

    return 1;
}

bool FilesListModel::hasChildren(const QModelIndex &oParent) const
{
    qDebug() << __FUNCTION__;

    return false;
}

void FilesListModel::fnOpenDir(int iIndex)
{
    qDebug() << __FUNCTION__;

    if (iIndex<0 || iIndex>=this->oFileInfoList.size()) {
        qDebug() << "iIndex " << iIndex << " out of bounds";
        return;
    }

    this->oCurrentPath.cd(this->oFileInfoList[iIndex].fileName());
}

void FilesListModel::fnSetPath(QString sPath)
{
    qDebug() << __FUNCTION__ << sPath;

    this->oCurrentPath.setPath(sPath);
    //this->oFileInfoList = this->oCurrentPath.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot, QDir::Type | QDir::Name);
}

QString FilesListModel::fnGetCurrentPath()
{
    qDebug() << __FUNCTION__;

    return this->oCurrentPath.path();
}

void FilesListModel::fnUp()
{
    qDebug() << __FUNCTION__;

    this->oCurrentPath.cdUp();
}

void FilesListModel::fnUpdate()
{
    this->oFileInfoList = this->oCurrentPath.entryInfoList(QDir::AllEntries | QDir::Hidden | QDir::System | QDir::NoDotAndDotDot, QDir::SortFlags(FilesListModelSort(this->iSortType)));

    beginResetModel();
    endResetModel();
}

bool FilesListModel::fnRemove(int iIndex)
{
    qDebug() << __FUNCTION__ << iIndex;

    if (iIndex<0 || iIndex>=this->oFileInfoList.size()) {
        qDebug() << "iIndex " << iIndex << " out of bounds";
        return false;
    }


    QFileInfo oFileInfo = this->oFileInfoList.at(iIndex);

    if (oFileInfo.isDir()) {
        if (this->fnRemoveDir(oFileInfo.absoluteFilePath())) {
            beginRemoveRows(QModelIndex(), iIndex, iIndex);
            endRemoveRows();

            return true;
        }
    }

    if (oFileInfo.isFile()) {
        if (this->fnRemoveFile(oFileInfo.absoluteFilePath())) {
            beginRemoveRows(QModelIndex(), iIndex, iIndex);
            endRemoveRows();

            return true;
        }
    }

    return false;
}

bool FilesListModel::fnRemoveFile(const QString &sFilePath)
{
    return QFile::remove(sFilePath);
}

bool FilesListModel::fnRemoveDir(const QString &sDirPath)
{
    qDebug() << __FUNCTION__ << sDirPath;

    QDir oDir(sDirPath);

    bool bResult = true;

    if (oDir.exists()) {
        Q_FOREACH(QFileInfo oCurrentFileInfo, oDir.entryInfoList(QDir::NoDotAndDotDot | QDir::System | QDir::Hidden  | QDir::AllDirs | QDir::Files, QDir::DirsFirst)) {
            if (oCurrentFileInfo.isDir()) {
                bResult = this->fnRemoveDir(oCurrentFileInfo.absoluteFilePath());
            }
            else {
                bResult = QFile::remove(oCurrentFileInfo.absoluteFilePath());
            }

            if (!bResult) {
                qDebug() << "Can't delete:" << oCurrentFileInfo.absoluteFilePath();
                return bResult;
            }
        }
        bResult = QDir().rmdir(sDirPath);
    }

    return bResult;
}

void FilesListModel::fnSetSortType(int iSortTypeIndex)
{
    this->iSortType = iSortTypeIndex;
    this->fnUpdate();
}

QString FilesListModel::fnFormatSize(qint64 iSize) const
{
    double dSize = iSize;

    QStringList oList;
    oList << "KB" << "MB" << "GB" << "TB";

    QStringListIterator oI(oList);
    QString oUnit("B");

    while(dSize >= 1000.0 && oI.hasNext()) {
        oUnit = oI.next();
        dSize /= 1000.0;
    }
    return QString().number(dSize, 'f', 2)+" "+oUnit;
}
