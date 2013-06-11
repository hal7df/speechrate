import QtQuick 1.1

Rectangle {
    id: buttonContainer
    gradient: unclicked
    radius: 7
    states: State {
        name: "pressed"; when: button.pressed
        PropertyChanges { target: buttonContainer; gradient: buttonClicked }
    }

    signal clicked
    property alias text: label.text
    property alias font: label.font

    Text {
        id: label
        color: "#ffffff"
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        id: button
        anchors.fill: parent
        Component.onCompleted: clicked.connect(buttonContainer.clicked);
    }

    Gradient {
        id: unclicked
        GradientStop { position: 1.0; color: "#000000" }
        GradientStop { position: 0.0; color: "#696969" }
    }
    Gradient {
        id: buttonClicked
        GradientStop { position: 1.0; color: "#696969" }
        GradientStop { position: 0.0; color: "#000000" }
    }
}
