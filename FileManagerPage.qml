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
                text: oFilesListModel ? oFilesListModel.fnGetCurrentPath() : ''

                wrapMode: Label.WordWrap

                MouseArea {
                    anchors.fill: parent;

                    onClicked: {
                        fileManagerPagePathLabel.visible = false;
                        fileManagerPagePathTextField.visible = true;
                        fileManagerPagePathTextField.focus = true;
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

                Keys.onEnterPressed: { fnOnPressEnter() }
                Keys.onReturnPressed: { fnOnPressEnter() }

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
                //width: parent.width
                Layout.maximumWidth: parent.width
                orientation: ListView.Vertical
                model: oFilesListFilterProxyModel
                focus: true

                FontMetrics {
                    id: fileManagerPageFontMetrics

                    font: oFixedFont

                    //font.pixelSize: 10
                }

                highlightFollowsCurrentItem: false
                highlight: Rectangle {
                    opacity: 0.5
                    color: "skyblue"
                    width: ListView.view ? ListView.view.width : 0
                    height: ListView.view && ListView.view.currentItem ? ListView.view.currentItem.height : 0//20+fileManagerPageFontMetrics.height
                    y: ListView.view && ListView.view.currentItem ? ListView.view.currentItem.y : 0
                    //z: Infinity
                }

                delegate: Item {
                    id: fileManagerPageDelegate

                    property var view: ListView.view
                    property bool isCurrent: ListView.isCurrentItem

                    width: view.width
                    height: 0
                            +Math.max(fileManagerPageFileNameLabel.height, fileManagerPageFileOwnerLabel.height)
                            //+fileManagerPageFontMetrics.height

                    opacity: isHidden ? 0.5 : 1;

                    RowLayout {
                        id: row

                        spacing: 0
                        Layout.alignment: Qt.AlignVCenter
                        anchors.fill: parent

                        Image {
                            id: icon
                            source: isDir ? "qrc:/images/folder.svg" : "qrc:/images/none.svg"
                            width: 20+fileManagerPageFontMetrics.height

                            anchors {
                            }
                        }

                        Label {
                            id: fileManagerPageFileNameLabel

                            Layout.fillWidth: true
                            Layout.minimumWidth: 50

                            anchors {
                                left: icon.right
                                leftMargin: 5
                            }

                            //font.pixelSize: fileManagerPageFontMetrics.font.pixelSize
                            font: oFixedFont

                            renderType: Text.NativeRendering
                            //font.bold: isExecutable
                            color: isSymLink ? "blue" : "black"
                            text: (isExecutable ? "<b>" : "")+fileName+(isExecutable ? "</b>" : "")
                            wrapMode: "WrapAnywhere"
                        }

                        TextMetrics {
                            id: fileManagerPageFileOwnerTextMetrics
                            font: oFixedFont
                            elide: Text.ElideMiddle
                            elideWidth: 100
                            text: "wwwwwwwww"
                        }

                        Label {
                            id: fileManagerPageFileOwnerLabel
                            Layout.minimumWidth: fileManagerPageFileOwnerTextMetrics.width+10
                            Layout.maximumWidth: fileManagerPageFileOwnerTextMetrics.width+10
                            padding: 10

                            //font.pixelSize: fileManagerPageFontMetrics.font.pixelSize
                            font: oFixedFont

                            text: fileOwner+"<br>"+fileGroup
                            horizontalAlignment: Text.AlignRight
                            wrapMode: "WrapAnywhere"

                            anchors {
                            }
                        }

                        TextMetrics {
                            id: fileManagerPageFilePermissionsTextMetrics
                            font: oFixedFont
                            elide: Text.ElideMiddle
                            elideWidth: 100
                            text: "rwxrwxrwx"
                        }

                        Label {
                            Layout.minimumWidth: fileManagerPageFilePermissionsTextMetrics.width+10
                            Layout.maximumWidth: fileManagerPageFilePermissionsTextMetrics.width+10
                            padding: 10

                            //font.pixelSize: fileManagerPageFontMetrics.font.pixelSize
                            font: oFixedFont

                            text: filePermissions
                            horizontalAlignment: Text.AlignRight

                            anchors {
                            }
                        }

                        TextMetrics {
                            id: fileManagerPageFileSizeTextMetrics
                            font: oFixedFont
                            elide: Text.ElideMiddle
                            elideWidth: 100
                            text: "9999,99 TB"
                        }

                        Label {
                            Layout.minimumWidth: fileManagerPageFileSizeTextMetrics.width+10
                            Layout.maximumWidth: fileManagerPageFileSizeTextMetrics.width+10
                            padding: 10

                            //font.pixelSize: fileManagerPageFontMetrics.font.pixelSize
                            font: oFixedFont

                            text: fileSize
                            horizontalAlignment: Text.AlignRight

                            anchors {
                            }
                        }

                        TextMetrics {
                            id: fileManagerPageFileUpdateTimeTextMetrics
                            font: oFixedFont
                            elide: Text.ElideMiddle
                            elideWidth: 100
                            text: "99.99.9999"
                        }

                        Label {
                            Layout.minimumWidth: fileManagerPageFileUpdateTimeTextMetrics.width+10
                            Layout.maximumWidth: fileManagerPageFileUpdateTimeTextMetrics.width+10
                            padding: 10

                            //font.pixelSize: fileManagerPageFontMetrics.font.pixelSize
                            font: oFixedFont

                            text: fileUpdateTime
                            horizontalAlignment: Text.AlignRight

                            anchors {
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        z: 5

                        onClicked: {
                            view.currentIndex = model.index;console.log(view.currentIndex, view)
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

            property int iIconSize: 24

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
                    //Layout.minimumWidth: fileManagerPageBottomColumnLayout.width/2

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
                    //id: fileManagerPageDeleteButton

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/edit-copy"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    //id: fileManagerPageDeleteButton

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/edit-paste"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    id: fileManagerPageDeleteButton

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/edit-delete"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
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

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
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

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
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

            RowLayout {
                Layout.fillHeight: true

                Button {
                    //id: fileManagerPage

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/document-preview-archive"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    //id: fileManagerPage

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/view-preview"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    //id: fileManagerPage

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/editor"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    //id: fileManagerPage

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/folder-new"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    //id: fileManagerPage

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/archive-insert"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

                    }
                }

                Button {
                    //id: fileManagerPage

                    Layout.fillWidth: true

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/images/games-config-options"

                        width: fileManagerPageBottomColumnLayout.iIconSize
                        height: fileManagerPageBottomColumnLayout.iIconSize
                    }

                    onClicked: {

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
