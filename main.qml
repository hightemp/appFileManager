import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
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

    StackView {
        id: mainStackView
        initialItem: fileManagerPage
        anchors.fill: parent

        FileManagerPage { id: fileManagerPage }
    }
}
