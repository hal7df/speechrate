import QtQuick 1.1

Rectangle {
    id: iconWidget
    color: "#141414"
    width: height
    states: State {
        name: "activated"; when: button.pressed === true
        PropertyChanges { target: iconWidget; color: "#0091ff" }
    }

    property alias source: image.source
    signal clicked

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    MouseArea {
        id: button
        anchors.fill: parent
        Component.onCompleted: clicked.connect(iconWidget.clicked);
    }
}
