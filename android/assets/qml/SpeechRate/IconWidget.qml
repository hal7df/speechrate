import QtQuick 1.1

Rectangle {
    id: iconWidget
    color: "#141414"
    width: height
    states: [ State {
        name: "activated"; when: button.pressed && !toggle && !disabled
        PropertyChanges { target: iconWidget; color: "#0091ff" }
    },
        State {
            name: "toggleOn"; when: toggled
            PropertyChanges { target: iconWidget; color: "#0091ff"}
        },
        State {
            name: "greyedOut"; when: disabled
            PropertyChanges { target: iconWidget; opacity: 0.25 }
        }

    ]

    property alias source: image.source
    property bool toggle: false
    property bool toggled: false
    property bool disabled: false
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
        onClicked: {
            if (parent.toggle)
            {
                if (parent.toggled)
                    parent.toggled = false;
                else
                    parent.toggled = true;
            }
        }
    }
}
