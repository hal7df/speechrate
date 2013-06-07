import QtQuick 1.1

Rectangle {
    id: menuItem
    width: menuText.paintedWidth + 10
    height: 50
    border { color: "#2b2b2b"; width: 1 }
    color: "#141414"

    property alias text: menuText.text

    Text {
        id: menuText
        color: "#ffffff"
        text: "Unnamed Menu Entry"
        anchors.centerIn: parent
        font.pointSize: 24
    }
}
