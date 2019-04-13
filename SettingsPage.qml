import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Component {
    id: settingsPage

    Item {
        id: settingsPageItem

        ScrollView {
            id: settingsPageScrollView
            anchors {
                right: parent.right
                top: parent.top
                left: parent.left
                bottom: settingsPageBottomColumnLayout.top
            }

            clip: true

            padding: 10

            ColumnLayout {
                spacing: 5
                anchors.fill: parent
                //anchors.margins: 10

                CheckBox {
                    id: settingsPageShowOwner
                    text: "Show owner"
                    checked: oSettingsModel.fnGetBoolValue("bShowOwner")
                }

                CheckBox {
                    id: settingsPageShowPermissions
                    text: "Show permissions"
                    checked: oSettingsModel.fnGetBoolValue("bShowPermissions")
                }

                CheckBox {
                    id: settingsPageShowSize
                    text: "Show size"
                    checked: oSettingsModel.fnGetBoolValue("bShowSize")
                }

                CheckBox {
                    id: settingsPageShowCreationTime
                    text: "Show creation time"
                    checked: oSettingsModel.fnGetBoolValue("bShowCreationTime")
                }

                CheckBox {
                    id: settingsPageShowModificationTime
                    text: "Show modification time"
                    checked: oSettingsModel.fnGetBoolValue("bShowModificationTime")
                }
            }
        }

        ColumnLayout {
            id: settingsPageBottomColumnLayout

            anchors {
                right: parent.right
                bottom: parent.bottom
                left: parent.left
            }

            RowLayout {
                Layout.fillHeight: true

                Button {
                    id: settingsPageBackButton

                    Layout.fillWidth: true

                    text: "Back"

                    onClicked: {
                        mainStackView.pop();
                    }
                }

                Button {
                    id: settingsPageSaveButton

                    Layout.fillWidth: true

                    text: "Save"

                    onClicked: {
                        oSettingsModel.fnUpdateBoolValue("bShowOwner", settingsPageShowOwner.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowPermissions", settingsPageShowPermissions.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowSize", settingsPageShowSize.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowCreationTime", settingsPageShowCreationTime.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowModificationTime", settingsPageShowModificationTime.checked);

                        oSettingsModel.fnSave();
                        oFilesListModel.fnUpdate();

                        mainStackView.pop();
                    }
                }
            }
        }
    }
}
