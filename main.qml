import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

ApplicationWindow {
    id: applicationWindow

    visible: true
    width: 640
    height: 480
    title: qsTr("appFileManager")

    Keys.onReleased: {
        console.log("Keys.onReleased", event.key);
        if (event.key == Qt.Key_Back) {
            console.log("Back button captured - wunderbar !")
            event.accepted = true
            quit();
        }
    }

    onWidthChanged: {
        oSettingsModel.fnUpdateIntValue("applicationWindow.width", applicationWindow.width);
        oSettingsModel.fnSave();
    }

    onHeightChanged: {
        oSettingsModel.fnUpdateIntValue("applicationWindow.height", applicationWindow.height);
        oSettingsModel.fnSave();
    }

    onXChanged: {
        oSettingsModel.fnUpdateIntValue("applicationWindow.x", applicationWindow.x);
        oSettingsModel.fnSave();
    }

    onYChanged: {
        oSettingsModel.fnUpdateIntValue("applicationWindow.y", applicationWindow.y);
        oSettingsModel.fnSave();
    }

    function fnStart()
    {
        console.log('fnStart');

        if (sOSType != "Mobile") {
            oSettingsModel.fnSetDefaultIntValue("applicationWindow.width", 640);
            oSettingsModel.fnSetDefaultIntValue("applicationWindow.height", 480);
            oSettingsModel.fnSetDefaultIntValue("applicationWindow.x", Math.round(Screen.desktopAvailableWidth / 2 - applicationWindow.width / 2));
            oSettingsModel.fnSetDefaultIntValue("applicationWindow.y", Math.round(Screen.desktopAvailableHeight / 2 - applicationWindow.height / 2));

            applicationWindow.setWidth(oSettingsModel.fnGetIntValue("applicationWindow.width"));
            applicationWindow.setHeight(oSettingsModel.fnGetIntValue("applicationWindow.height"));

            applicationWindow.setX(oSettingsModel.fnGetIntValue("applicationWindow.x"));
            applicationWindow.setY(oSettingsModel.fnGetIntValue("applicationWindow.y"));

            oSettingsModel.fnSave();
        }

        oSettingsModel.fnSetDefaultBoolValue("bShowOwner", true);
        oSettingsModel.fnSetDefaultBoolValue("bShowPermissions", true);
        oSettingsModel.fnSetDefaultBoolValue("bShowSize", true);
        oSettingsModel.fnSetDefaultBoolValue("bShowCreationTime", false);
        oSettingsModel.fnSetDefaultBoolValue("bShowModificationTime", true);
        oSettingsModel.fnSetDefaultBoolValue("bShowHiddenFiles", false);
        oSettingsModel.fnSetDefaultBoolValue("bShowSystemFiles", false);

        oFilesListModel.fnShowHidden(oSettingsModel.fnGetBoolValue("bShowHiddenFiles"));
        oFilesListModel.fnShowSystem(oSettingsModel.fnGetBoolValue("bShowSystemFiles"));

        oFilesListModel.fnUpdate();
    }

    StackView {
        id: mainStackView
        initialItem: fileManagerPage
        anchors.fill: parent

        FileManagerPage { id: fileManagerPage }
        SettingsPage { id: settingsPage }
    }
}
