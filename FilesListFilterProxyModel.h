#ifndef FILESLISTFILTERPROXYMODEL_H
#define FILESLISTFILTERPROXYMODEL_H

#include <QModelIndex>
#include <QSortFilterProxyModel>
#include "FilesListModel.h"

class FilesListFilterProxyModel : public QSortFilterProxyModel
{
public:
    bool filterAcceptsRow(int iSourceRow, const QModelIndex &oSourceParent) const override;
};

#endif // FILESLISTFILTERPROXYMODEL_H
