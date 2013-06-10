import QtQuick 1.1

Rectangle {
    id: menuItem
    width: menuText.paintedWidth + 10
    height: 50
    border { color: "#2b2b2b"; width: 1 }
    color: "#141414"
    states: State {
        name: "selected"; when: menuButton.pressed
        PropertyChanges { target: menuItem; color: "#0091ff"}
    }

    signal clicked
    property alias text: menuText.text

    Text {
        id: menuText
        color: "#ffffff"
        text: "Unnamed Menu Entry"
        anchors.centerIn: parent
        font.pointSize: 24
    }

    MouseArea {
        id: menuButton
        anchors.fill: parent
        Component.onCompleted: clicked.connect(menuItem.clicked);
    }
}
