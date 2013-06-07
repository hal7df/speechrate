import QtQuick 1.1

Rectangle {
    id: buttonContainer
    gradient: unclicked
    states: State {
        name: "pressed"; when: button.pressed
        PropertyChanges { target: buttonContainer; gradient: buttonClicked }
    }

    signal clicked

    MouseArea {
        id: button
        anchors.fill: parent
        onClicked: parent.onClicked
    }

    Gradient {
        id: unclicked
        GradientStop { position: 0.0; color: "#000000" }
        GradientStop { position: 1.0; color: "#696969" }
    }
    Gradient {
        id: buttonClicked
        GradientStop { position: 0.0; color: "#696969" }
        GradientStop { position: 1.0; color: "#000000" }
    }
}
