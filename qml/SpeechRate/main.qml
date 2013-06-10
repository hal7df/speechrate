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
                editAccept.visible = true;
            }
        }
    }

    TextInput {
        id: editItem
        text: "Events"
        color: "#ffffff"
        font.pointSize: 36
        visible: false
        anchors { top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter }
    }

    Button {
        id: editAccept
        anchors { left: editItem.right; leftMargin: 30; top: parent.top; topMargin: 10; bottom: likeCount.bottom }
        width: 100
        text: "OK"
        z: 9
        visible: false
        onClicked: normalMode()

        function normalMode ()
        {
            likeCount.visible = true;
            editItem.visible = false;
            editAccept.visible = false;
        }
    }

    Button {
        id: plusOneButton
        anchors { right: parent.right; left: parent.left; top: likeCount.bottom; topMargin: 10; bottom: calcOutput.top; bottomMargin: 10 }
        text: "+1"
        font.pointSize: 36
        onClicked: likeCount.likeNum++
    }

    IconWidget {
        id: clockControl
        anchors { bottom: parent.bottom; top: reset.top; right: clockOutput.left; rightMargin: 20 }
        source: "images/start.png"
        onClicked: startStop();

        function startStop()
        {
            if (clock.running === true)
            {
                clock.stop();
                clockControl.source = "images/start.png";
                calcOutput.visible = true;
            }
            else
            {
                clock.start();
                clockControl.source = "images/stop.png";
                calcOutput.visible = false;
            }
        }
    }

    IconWidget {
        id: reset
        anchors { bottom: parent.bottom; top: clockOutput.top; topMargin: -20; left: parent.left }
        source: "images/clear.png"
        onClicked: resetAll()

        function resetAll()
        {
            clock.restart();
            clock.stop();
            clockControl.source = "images/start.png";
            calcOutput.visible = false;
            clockOutput.seconds = 0;
            clockOutput.minutes = 0;
            clockOutput.hours = 0;
            clockOutput.text = "00:00:00";
            likeCount.likeNum = 0;
        }
    }

    Timer {
        id: clock
        repeat: true
        running: false
        onTriggered: clockOutput.update()
    }

    Text {
        id: clockOutput
        text: "00:00:00"
        color: "#ffffff"
        font.pointSize: 20
        anchors { bottom: parent.bottom; bottomMargin: 15; horizontalCenter: parent.horizontalCenter }
        width: paintedWidth

        property int seconds: 0
        property int minutes: 0
        property int hours: 0

        //Update the output

        function update()
        {
            var secPrefix;
            var minPrefix;
            var hrPrefix;

            //Determine how to increase the timer
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

            //Check that there are less than 10 seconds
            if (clockOutput.seconds < 10)
                secPrefix = "0";
            else
                secPrefix = "";

            //Check that there are less than 10 minutes
            if (clockOutput.minutes < 10)
                minPrefix = "0";
            else
                minPrefix = "";

            //Check that there are less than 10 hours
            if (clockOutput.hours < 10)
                hrPrefix = "0";
            else
                hrPrefix = "";

            clockOutput.text = hrPrefix+clockOutput.hours+":"+minPrefix+clockOutput.minutes+":"+secPrefix+clockOutput.seconds;
        }
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
        anchors { bottom: menuButton.top; right: parent.right; rightMargin: 5 }

        MenuItem {
            id: secSelect
            text: editItem.text+"/sec"
            width: minSelect.width
            onClicked: {
                calcOutput.timeUnit = "sec";
                unitSelect.close();
            }
        }

        MenuItem {
            id: minSelect
            text: editItem.text+"/min"
            onClicked: {
                calcOutput.timeUnit = "min";
                unitSelect.close();
            }
        }

        MenuItem {
            id: hrSelect
            text: editItem.text+"/hr"
            width: minSelect.width
            onClicked: {
                calcOutput.timeUnit = "hr";
                unitSelect.close();
            }
        }

        MenuItem {
            id: closeSelect
            text: "Close"
            width: minSelect.width
            onClicked: unitSelect.close()
        }
    }

    IconWidget {
        id: menuButton
        anchors { top: reset.top; right: parent.right; bottom: parent.bottom }
        z: 1
        source: "images/menu.png"
        onClicked: unitSelect.toggle()
    }
}
