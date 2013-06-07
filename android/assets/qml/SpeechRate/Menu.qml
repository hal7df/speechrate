import QtQuick 1.1

Grid {
    id: menu
    flow: Grid.TopToBottom
    visible: false
    opacity: 0
    property alias items: menu.rows

    states: State {
        name: "active"; when: visible === true
        PropertyChanges { target: menu; opacity: 1 }
    }

    transitions: Transition {
        from: ""; to: "active"; reversible: true
        NumberAnimation { properties: "opacity"; duration: 500; easing.type: Easing.OutQuad }
    }

    function open()
    {
        visible = true;
    }

    function close()
    {
        visible = false;
    }

    function toggle()
    {
        if (visible)
            visible = false
        else
            visible = true;
    }
}
