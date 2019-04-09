import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2

Component {
    id: fileManagerPage

    Item {
        id: fileManagerPageItem

        RowLayout {
            id: fileManagerPageTopRowLayout
            spacing: 2
            width: parent.width
            z: Infinity

            Label {
                id: fileManagerPagePathLabel

                visible: true

                padding: 10
                height: fileManagerPagePathTextField.height

                Layout.fillWidth: true
                text: oFilesListModel.fnGetCurrentPath()

                wrapMode: Label.WordWrap

                MouseArea {
                    anchors.fill: parent;

                    onClicked: {
                        fileManagerPagePathLabel.visible = false;
                        fileManagerPagePathTextField.visible = true;
                    }
                }
            }

            TextField {
                id: fileManagerPagePathTextField

                visible: false

                Layout.fillWidth: true
                text: oFilesListModel.fnGetCurrentPath()
                selectByMouse: true

                anchors {

                }

                Keys.onEnterPressed: fnOnPressEnter
                Keys.onReturnPressed: fnOnPressEnter

                function fnOnPressEnter()
                {
                    Qt.inputMethod.hide();
                    fileManagerPagePathTextField.visible = false;
                    oFilesListModel.fnSetPath(fileManagerPagePathTextField.text);
                    oFilesListModel.fnUpdate();
                    fileManagerPagePathLabel.visible = true;
                    fileManagerPagePathLabel.text = oFilesListModel.fnGetCurrentPath();
                }
            }

        }

        RowLayout {
            id: fileManagerPageFilterRowLayout

            anchors {
                top: fileManagerPageTopRowLayout.bottom
                right: parent.right
                left: parent.left
            }

            //spacing: 10
            //anchors.margins: 10

            TextField {
                id: fileManagerPageFilterTextField

                Layout.fillWidth: true

                selectByMouse: true
                placeholderText: "Filter"

                onTextChanged: {
                    oFilesListFilterProxyModel.setFilterFixedString(text);
                }
            }
        }

        ScrollView {
            id: fileManagerPageScrollView
            anchors {
                right: parent.right
                top: fileManagerPageFilterRowLayout.bottom
                left: parent.left
                bottom: fileManagerPageBottomColumnLayout.top
            }

            clip: true

            padding: {
                top: 2
                bottom: 2
            }

            ListView {
                id: fileManagerPageListView
                width: parent.width
                orientation: ListView.Vertical
                model: oFilesListFilterProxyModel
                focus: true

                property variant columnWidths: fnCalcColumnWidths(model, list)

                FontMetrics {
                    id: fileManagerPageFontMetrics

                    font.pixelSize: 10
                }

                highlightFollowsCurrentItem: true
                highlight: Rectangle {
                    opacity: 0.5
                    color: "skyblue"
                    width: ListView.view ? ListView.view.width : 0
                    height: 20+fileManagerPageFontMetrics.height
                    y: ListView.view && ListView.view.currentItem ? ListView.view.currentItem.y : 0
                    //z: Infinity
                }

                function fnCalcColumnWidths(model, parent)
                {
                    for (var i = 0; i < model.count; ++i) {
                        var data = model.get(i)
                        for (var key in data) {
                            if (!columns[key]) {
                                columns[key] = 0
                            }

                            var textElement = Qt.createQmlObject(
                                'import Qt 4.7;\n'+
                                'Text { text: "' + data[key] + '"}',
                                parent,
                                "calcColumnWidths"
                            );

                            columns[key] = Math.max(textElement.width, columns[key])

                            textElement.destroy()
                        }
                    }

                    return columns
                }

                function fnUpdateColumnsWidth()
                {
                    columnWidths = fnCalcColumnWidths(model, list);
                }

                delegate: Item {
                    id: fileManagerPageDelegate

                    property var view: ListView.view
                    property bool isCurrent: ListView.isCurrentItem

                    width: view.width
                    height: 20+fileManagerPageFontMetrics.height

                    opacity: isHidden ? 0.5 : 1;

                    RowLayout {
                        id: row
                        width: parent.width
                        spacing: 0

                        Image {
                            id: icon
                            source: isDir ? "qrc:/images/folder.svg" : "qrc:/images/none.svg"
                            width: 20+fileManagerPageFontMetrics.height
                            height: 20+fileManagerPageFontMetrics.height

                            anchors {
                            }
                        }

                        Label {
                            //Layout.fillWidth: true
                            //Layout.minimumWidth: parent.width
                            //       - fileManagerPageListView.columnWidths['fileSize'] - 20
                            //       - fileManagerPageListView.columnWidths['fileUpdateTime'] - 20

                            padding: 10

                            anchors {
                            }

                            font.pixelSize: fileManagerPageFontMetrics.font.pixelSize

                            renderType: Text.NativeRendering
                            font.bold: isExecutable
                            text: fileName
                        }

                        Label {
                            Layout.fillWidth: true
                        }

                        Label {
                            //width: fileManagerPageListView.columnWidths['fileSize'] + 20

                            padding: 10

                            font.pixelSize: fileManagerPageFontMetrics.font.pixelSize

                            text: fileSize
                        }

                        Label {
                            //width: fileManagerPageListView.columnWidths['fileUpdateTime'] + 20

                            padding: 10

                            font.pixelSize: fileManagerPageFontMetrics.font.pixelSize

                            text: fileUpdateTime
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        z: 5

                        onClicked: {
                            view.currentIndex = model.index;console.log(view.currentIndex, view)
                            /*
                            if (!model.isDir) {

                            }
                            */
                        }

                        onDoubleClicked: {
                            view.currentIndex = model.index;

                            if (model.isDir) {
                                oFilesListModel.fnOpenDir(model.index);
                                fileManagerPagePathLabel.text = oFilesListModel.fnGetCurrentPath();
                                fileManagerPagePathTextField.text = oFilesListModel.fnGetCurrentPath();
                            } else {

                            }

                            oFilesListModel.fnUpdate();
                            fileManagerPageListView.fnUpdateColumnsWidth();
                        }
                    }
                }
            }
        }

        ColumnLayout {
            id: fileManagerPageBottomColumnLayout

            anchors {
                right: parent.right
                bottom: parent.bottom
                left: parent.left
            }

            RowLayout {
                Layout.fillHeight: true

                ComboBox {
                    id: fileManagerPageSortingTypeComboBox

                    Layout.fillWidth: true

                    model: [
                        "Name",
                        "Time",
                        "Size",
                        "Type",
                        "Dirs first"
                    ]

                    currentIndex: 4

                    onCurrentIndexChanged: {
                        oFilesListModel.fnSetSortType(currentIndex);
                    }
                }

                Button {
                    id: fileManagerPageDeleteButton

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/edit-delete"

                        width: 32
                        height: 32
                    }

                    onClicked: {
                        fileManagerPageDeleteItemDialog.open();
                    }
                }

                Button {
                    id: fileManagerPageRefreshButton

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/view-refresh"

                        width: 32
                        height: 32
                    }

                    onClicked: {
                        oFilesListModel.fnUpdate();
                        fileManagerPageListView.fnUpdateColumnsWidth();
                    }
                }

                Button {
                    id: fileManagerPageUpButton

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/go-up.svg"

                        width: 32
                        height: 32
                    }

                    onClicked: {
                        oFilesListModel.fnUp();
                        fileManagerPagePathLabel.text = oFilesListModel.fnGetCurrentPath();
                        fileManagerPagePathTextField.text = oFilesListModel.fnGetCurrentPath();
                        oFilesListModel.fnUpdate();
                        fileManagerPageListView.fnUpdateColumnsWidth();
                    }
                }
            }
        }

        MessageDialog {
            id: fileManagerPageDeleteItemDialog
            title: qsTr("Delete item?")
            standardButtons: Dialog.No | Dialog.Yes
            text: "Delete item?"

            onYes: {
                if (!oFilesListModel.fnRemove(fileManagerPageListView.currentIndex)) {
                    fileManagerPageErrorDialog.text = "Can't delete file"
                    fileManagerPageErrorDialog.open();
                }
            }
        }

        MessageDialog {
            id: fileManagerPageErrorDialog
            title: qsTr("Error")
            standardButtons: Dialog.Ok
            text: ""
        }
    }

}
