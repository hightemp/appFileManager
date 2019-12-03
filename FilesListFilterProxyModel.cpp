#include "FilesListFilterProxyModel.h"

#include <QDebug>

bool FilesListFilterProxyModel::filterAcceptsRow(int iSourceRow, const QModelIndex &oSourceParent) const
{
    qDebug() << __PRETTY_FUNCTION__ << this->filterRegExp();

    QModelIndex iIndex = this->sourceModel()->index(iSourceRow, 0, oSourceParent);

    return this->sourceModel()->data(iIndex, FilesListModel::FileNameRole).toString().contains(this->filterRegExp());
}
