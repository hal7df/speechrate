// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
Rectangle {
    id: root
    color: "#141414"
    height: 800
    width: 480

    Text {
        id: likeCount
        text: editItem.text+": "+likeNum
        font.pointSize: 36
        visible: true
        color: "#ffffff"
        anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }

        property int likeNum: 0

        MouseArea {
            id:textSwitcher
            anchors.fill: parent
            onClicked: enableEdit()

            function enableEdit ()
            {
                likeCount.visible = false;
                editItem.visible = true;
                editAcceptContainer.visible = true;
            }
        }
    }

    TextInput {
        id: editItem
        text: "Events"
        color: "#ffffff"
        font.pointSize: 24
        visible: false
        anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }
    }

    Rectangle {
        id: editAcceptContainer
        anchors { left: editItem.right; leftMargin: 30; verticalCenter: editItem.verticalCenter }
        height: 50
        width: 100
        radius: 7
        z: 9
        gradient: normalButton
        visible: false
        states: State {
            name: "accepted"; when: editAccept.pressed === true
            PropertyChanges { target: editAcceptContainer; gradient: buttonPressed }
        }

        Text {
            id: eALabel
            text: "OK"
            color: "#ffffff"
            font.pointSize: 16
            anchors.centerIn: parent
        }

        MouseArea {
            id: editAccept
            anchors.fill: parent
            onClicked: normalMode()

            function normalMode ()
            {
                likeCount.visible = true;
                editItem.visible = false;
                editAcceptContainer.visible = false;
            }
        }
    }

    Rectangle {
        id: plusOneButton
        anchors { right: parent.horizontalCenter; rightMargin: 10; left: parent.left; top: likeCount.bottom; topMargin: 10; bottom: parent.verticalCenter }
        radius: 7
        gradient: normalButton
        states: State {
            name: "activated"; when: plusOne.pressed === true
            PropertyChanges { target: plusOneButton; gradient: buttonPressed }
        }

        Text {
            id: pOBLabel
            text: "+1"
            color: "#ffffff"
            font.pointSize: 24
            anchors.centerIn: parent
        }

        MouseArea {
            id: plusOne
            onClicked: increment()
            anchors.fill: parent

            function increment ()
            {
                likeCount.likeNum++;
            }
        }
    }

    Gradient {
        id: buttonPressed
        GradientStop{ position: 0.0; color: "#000000" }
        GradientStop{ position: 1.0; color: "#696969" }
    }

    Gradient {
        id: normalButton
        GradientStop{ position: 0.0; color: "#696969" }
        GradientStop{ position: 1.0; color: "#000000" }
    }

    Rectangle {
        id: clockControlContainer
        anchors { right: parent.right; left: parent.horizontalCenter; leftMargin: 10; top: likeCount.bottom; topMargin: 10; bottom: parent.verticalCenter }
        radius: 7
        gradient: normalButton
        states: State {
            name: "clockControlActivated"; when: clockControl.pressed === true
            PropertyChanges { target: clockControlContainer; gradient: buttonPressed }
        }

        MouseArea {
            id:clockControl
            onClicked:parent.startStop()
            anchors.fill: parent
        }

        Text {
            id: clockControlLabel
            text: "Start"
            color: "#ffffff"
            font.pointSize: 24
            anchors.centerIn: parent
        }

        function startStop()
        {
            if (clock.running === true)
            {
                clock.stop();
                clockControlLabel.text = "Start";
                calcOutput.visible = true;
            }
            else
            {
                clock.start();
                clockControlLabel.text = "Stop";
                calcOutput.visible = false;
            }
        }

        function update()
        {
            if (clockOutput.seconds < 59)
                clockOutput.seconds++;
            else
            {
                if (clockOutput.seconds == 59 && clockOutput.minutes < 59)
                {
                    clockOutput.seconds = 0;
                    clockOutput.minutes++;
                }
                else if (clockOutput.minutes == 59)
                {
                    clockOutput.seconds = 0;
                    clockOutput.minutes = 0;
                    clockOutput.hours++;
                }
            }

            clockOutput.text = clockOutput.hours+":"+clockOutput.minutes+":"+clockOutput.seconds;
        }
    }

    Rectangle {
        id: resetContainer
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.verticalCenter; topMargin: 5; left: parent.left; right: parent.right; bottom: calcOutput.top; bottomMargin: 10 }
        radius: 7
        gradient: Gradient {
            GradientStop{ position: 0.0; color: "#696969" }
            GradientStop{ position: 1.0; color: "#000000" }
        }
        states: State {
            name: "resetButtonActivated"; when: resetButton.pressed === true
            PropertyChanges { target: resetContainer; gradient: buttonPressed }
        }

        MouseArea {
            id: resetButton
            anchors.fill: parent
            onClicked: resetAll()

            function resetAll()
            {
                clock.restart();
                clock.stop();
                clockOutput.seconds = 0;
                clockOutput.minutes = 0;
                clockOutput.hours = 0;
                clockOutput.text = "0:0:0";
                likeCount.likeNum = 0;
            }
        }

        Text {
            id: resetLabel
            text: "Reset"
            color: "#ffffff"
            font.pointSize: 16
            anchors.centerIn: parent
        }
    }

    Timer {
        id: clock
        repeat: true
        running: false
        onTriggered: clockControlContainer.update()
    }

    Text {
        id: clockOutput
        text: "0:0:0"
        color: "#ffffff"
        font.pointSize: 20
        anchors { bottom: parent.bottom; bottomMargin: 15; horizontalCenter: parent.horizontalCenter }

        property int seconds: 0
        property int minutes: 0
        property int hours: 0
    }

    Text {
        id: calcOutput
        text: getFrequency()
        visible: false
        color: "#ffffff"
        font.pointSize: 20
        anchors { bottom: clockOutput.top; bottomMargin: 15; horizontalCenter: parent.horizontalCenter }

        property string timeUnit: "min"

        function getFrequency()
        {
            var totTime;
            var frequency
            if (calcOutput.timeUnit == "sec")
            {
                totTime = clockOutput.seconds+(clockOutput.minutes*60)+(clockOutput.hours*3600);
                if (totTime !== 0)
                {
                    frequency = (likeCount.likeNum/totTime)
                    frequency.toFixed(3);
                    return frequency+" "+editItem.text+"/sec";
                }
                else
                    return "Undefined";
            }
            else if (calcOutput.timeUnit == "min")
            {
                totTime = (clockOutput.seconds/60)+clockOutput.minutes+(clockOutput.hours*60);
                if (totTime !== 0)
                {
                    frequency = (likeCount.likeNum/totTime)
                    frequency.toFixed(3);
                    return frequency+" "+editItem.text+"/min";
                }
                else
                    return "Undefined";
            }
            else if (calcOutput.timeUnit == "hr")
            {
                totTime = (clockOutput.seconds/3600)+(clockOutput.minutes/60)+clockOutput.hours;
                if (totTime !== 0)
                {
                    frequency = (likeCount.likeNum/totTime)
                    frequency.toFixed(3);
                    return frequency+" "+editItem.text+"/hr";
                }
                else
                    return "Undefined";
            }
        }
    }

    Menu {
        id: unitSelect
        items: 4
        z: 10
        anchors { top: menuButtonContainer.bottom; right: parent.right }

        MenuItem {
            id: secSelect
            text: editItem.text+"/sec"
            width: minSelect.width
            states: State {
                name: "secSelected"; when: secUnitButton.pressed === true
                PropertyChanges { target: secSelect; color: "#2b2b2b" }
            }

            MouseArea {
                id:secUnitButton
                anchors.fill: parent
                onClicked: {
                    calcOutput.timeUnit = "sec";
                    unitSelect.close();
                }
            }
        }
        MenuItem {
            id: minSelect
            text: editItem.text+"/min"
            states: State {
                name: "minSelected"; when: minUnitButton.pressed === true
                PropertyChanges { target: minSelect; color: "#2b2b2b" }
            }

            MouseArea {
                id:minUnitButton
                anchors.fill: parent
                onClicked: {
                    calcOutput.timeUnit = "min";
                    unitSelect.close();
                }
            }
        }
        MenuItem {
            id: hrSelect
            text: editItem.text+"/hr"
            width: minSelect.width
            states: State {
                name: "hrSelected"; when: hrUnitButton.pressed === true
                PropertyChanges { target: hrSelect; color: "#2b2b2b" }
            }

            MouseArea {
                id:hrUnitButton
                anchors.fill: parent
                onClicked: {
                    calcOutput.timeUnit = "hr";
                    unitSelect.close();
                }
            }
        }
        MenuItem {
            id: closeSelect
            text: "Close"
            width: minSelect.width
            states: State {
                name: "closeSelected"; when: exitButton.pressed === true
                PropertyChanges { target: closeSelect; color: "#2b2b2b" }
            }

            MouseArea {
                id:exitButton
                anchors.fill: parent
                onClicked: unitSelect.close()
            }
        }
    }

    Rectangle {
        id: menuButtonContainer
        color: "#141414"
        anchors { top: parent.top; right: parent.right }
        width: 75
        height: 75
        z: 1
        states: State {
            name: "menuOpen"; when: menuButton.pressed === true
            PropertyChanges { target: menuButtonContainer; color: "#0091ff" }
        }

        Image {
            id: mBIcon
            source: "images/menu.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        MouseArea {
            id: menuButton
            anchors.fill: parent
            onClicked: unitSelect.toggle()
        }
    }
}
