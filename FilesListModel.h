#ifndef FILESLISTMODEL_H
#define FILESLISTMODEL_H

#include <QAbstractItemModel>
#include <QException>
#include <QDebug>
#include <QDir>
#include <QDateTime>

class FilesListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(FilesListModelRoles)

public:
    QDir oCurrentPath;
    QFileInfoList oFileInfoList;
    int iSortType = QDir::DirsFirst;

    bool bShowHidden;
    bool bShowSystem;

public:

    enum FilesListModelRoles {
        FileNameRole = Qt::UserRole + 1,
        FileSizeRole,
        FileCreateTimeRole,
        FileUpdateTimeRole,
        FileOwnerRole,
        FileGroupRole,
        FilePermissionsRole,
        IsDirRole,
        IsHiddenRole,
        IsExecutableRole,
        IsSymLinkRole
    };

    enum FilesListModelSort {
        NameSort = QDir::Name,
        TimeSort = QDir::Time,
        SizeSort = QDir::Size,
        TypeSort = QDir::Type,
        DirsFirstSort = QDir::DirsFirst
    };

    explicit FilesListModel(QObject *poParent = nullptr);
    ~FilesListModel() override;

    QHash<int,QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &oIndex, int iRole) const override;
    bool setData(const QModelIndex &oIndex, const QVariant &oValue, int iRole = Qt::EditRole) override;
    QVariant headerData(int iSection, Qt::Orientation oOrientation, int iRole = Qt::DisplayRole) const override;
    Qt::ItemFlags flags(const QModelIndex &oIndex) const override;
    bool insertRows(int iPosition, int iRows, const QModelIndex &oParent = QModelIndex()) override;
    bool removeRows(int iPosition, int iRows, const QModelIndex &oParent = QModelIndex()) override;
    QModelIndex index(int iRow, int iColumn, const QModelIndex &oParent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &oChild) const override;
    int rowCount(const QModelIndex &oParent = QModelIndex()) const override;
    int columnCount(const QModelIndex &oParent = QModelIndex()) const override;
    bool hasChildren(const QModelIndex &oParent) const override;

public slots:
    void fnShowHidden(bool bValue);
    void fnShowSystem(bool bValue);
    void fnOpenDir(int iIndex);
    void fnSetPath(QString sPath);
    QString fnGetCurrentPath();
    void fnUp();
    void fnUpdate();
    bool fnRemove(int iIndex);
    bool fnRemoveFile(const QString &sFilePath);
    bool fnRemoveDir(const QString &sDirPath);
    void fnSetSortType(int iSortTypeIndex);
    QString fnFormatSize(qint64 iSize) const;
};

#endif // FILESLISTMODEL_H
