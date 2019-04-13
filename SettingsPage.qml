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
                    id: settingsPageShowOwnerCheckBox
                    text: "Show owner"
                    checked: oSettingsModel.fnGetBoolValue("bShowOwner")
                }

                CheckBox {
                    id: settingsPageShowPermissionsCheckBox
                    text: "Show permissions"
                    checked: oSettingsModel.fnGetBoolValue("bShowPermissions")
                }

                CheckBox {
                    id: settingsPageShowSizeCheckBox
                    text: "Show size"
                    checked: oSettingsModel.fnGetBoolValue("bShowSize")
                }

                CheckBox {
                    id: settingsPageShowCreationTimeCheckBox
                    text: "Show creation time"
                    checked: oSettingsModel.fnGetBoolValue("bShowCreationTime")
                }

                CheckBox {
                    id: settingsPageShowModificationTimeCheckBox
                    text: "Show modification time"
                    checked: oSettingsModel.fnGetBoolValue("bShowModificationTime")
                }

                CheckBox {
                    id: settingsPageShowHiddenFilesCheckBox
                    text: "Show hidden files"
                    checked: oSettingsModel.fnGetBoolValue("bShowHiddenFiles")
                }

                CheckBox {
                    id: settingsPageShowSystemFilesCheckBox
                    text: "Show system files"
                    checked: oSettingsModel.fnGetBoolValue("bShowSystemFiles")
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
                        oSettingsModel.fnUpdateBoolValue("bShowOwner", settingsPageShowOwnerCheckBox.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowPermissions", settingsPageShowPermissionsCheckBox.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowSize", settingsPageShowSizeCheckBox.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowCreationTime", settingsPageShowCreationTimeCheckBox.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowModificationTime", settingsPageShowModificationTimeCheckBox.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowHiddenFiles", settingsPageShowHiddenFilesCheckBox.checked);
                        oSettingsModel.fnUpdateBoolValue("bShowSystemFiles", settingsPageShowSystemFilesCheckBox.checked);

                        oFilesListModel.fnShowHidden(settingsPageShowHiddenFilesCheckBox.checked);
                        oFilesListModel.fnShowSystem(settingsPageShowSystemFilesCheckBox.checked);

                        oSettingsModel.fnSave();
                        oFilesListModel.fnUpdate();

                        mainStackView.pop();
                    }
                }
            }
        }
    }
}
