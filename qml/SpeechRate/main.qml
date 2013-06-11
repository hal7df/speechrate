import QtQuick 1.1
Rectangle {
    id: root
    color: "#141414"
    height: 800
    width: 480

    function getFrequency(/*int*/ count, /*string*/ measuredEvent)
    {
        var totTime;
        var frequency;
        if (unitSelect.timeUnit === "sec")
        {
            totTime = clockOutput.seconds+(clockOutput.minutes*60)+(clockOutput.hours*3600);
            if (totTime !== 0)
            {
                frequency = (count/totTime);
                frequency.toFixed(3);
                return frequency+" "+measuredEvent+"/sec";
            }
            else
                return "";
        }
        else if (unitSelect.timeUnit === "min")
        {
            totTime = (clockOutput.seconds/60)+clockOutput.minutes+(clockOutput.hours*60);
            if (totTime !== 0)
            {
                frequency = (count/totTime);
                frequency.toFixed(3);
                return frequency+" "+measuredEvent+"/min";
            }
            else
                return "";
        }
        else if (unitSelect.timeUnit == "hr")
        {
            totTime = (clockOutput.seconds/3600)+(clockOutput.minutes/60)+clockOutput.hours;
            if (totTime !== 0)
            {
                frequency = (count/totTime);
                frequency.toFixed(3);
                return frequency+" "+measuredEvent+"/hr";
            }
            else
                return "";
        }
    }

    Rectangle {
        id: statusBar
        height: 75
        color: "#00000000"
        anchors { top: parent.top; left: parent.left; right: parent.right }
        border.color: "#2b2b2b"
        border.width: 1

        Text {
            id: appLabel
            text: clock.running ? "Active" : "Idle"
            color: "#ffffff"
            font.pointSize: 24
            anchors.centerIn: parent
        }

        IconWidget {
            id: editButton
            anchors { top: parent.top; bottom: parent.bottom; left: parent.left }
            source: "images/edit.png"
            toggle: true
        }

        IconWidget {
            id: addCounter
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
            source: "images/add.png"
            disabled: trackerRepeater.count === 4 ? true : false
            onClicked: {
                if (counts < 4)
                    counts++;
            }

            property int counts: 1
        }

        IconWidget {
            id: subtractCounter
            anchors { top: parent.top; bottom: parent.bottom; right: addCounter.left }
            source: "images/delete.png"
            disabled: trackerRepeater.count === 1 ? true : false
            onClicked: {
                if (addCounter.counts > 1)
                    addCounter.counts--;
            }
        }
    }

    Grid {
        id: eventTracker
        columns: 2
        rows: 2
        spacing: 10
        anchors { top: statusBar.bottom; topMargin: 5; bottom: toolbar.top; bottomMargin: 5; right: parent.right; left: parent.left }

        Repeater {
            id: trackerRepeater
            model: addCounter.counts

            Item {
                width: (root.width/2)-5
                height: (eventTracker.height/2)-5

                Button {
                    id: counterDelegate
                    anchors.fill: parent
                    visible: !editButton.toggled
                    text: textDelegate.text+": "+eventCount+"\n"+root.getFrequency(eventCount,textDelegate.text)
                    font.pointSize: 36
                    onClicked: eventCount++

                    Component.onCompleted: resetCount.connect(reset.clicked)

                    property int eventCount: 0
                    signal resetCount

                    onResetCount: eventCount = 0


                }
                TextInput {
                    id: textDelegate
                    visible: editButton.toggled
                    text: "Event"
                    font.pointSize: 36
                    color: "#ffffff"
                    anchors.centerIn: counterDelegate
                }
            }
        }
    }

    Rectangle {
        id: toolbar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 75
        color: "#00000000"
        border { color: "#2b2b2b"; width: 1 }

        IconWidget {
            id: clockControl
            anchors { bottom: parent.bottom; top: parent.top; topMargin: 1; right: clockOutput.left; rightMargin: 20 }
            source: "images/start.png"
            onClicked: startStop();

            function startStop()
            {
                if (clock.running === true)
                {
                    clock.stop();
                    clockControl.source = "images/start.png";
                }
                else
                {
                    clock.start();
                    clockControl.source = "images/stop.png";
                }
            }
        }

        IconWidget {
            id: reset
            anchors { bottom: parent.bottom; top: parent.top; topMargin: 1; left: parent.left }
            source: "images/clear.png"
            onClicked: resetAll()

            function resetAll()
            {
                clock.restart();
                clock.stop();
                clockControl.source = "images/start.png";
                clockOutput.seconds = 0;
                clockOutput.minutes = 0;
                clockOutput.hours = 0;
                clockOutput.text = "00:00:00";
            }
        }


        IconWidget {
            id: menuButton
            anchors { top: parent.top; topMargin: 1; right: parent.right; bottom: parent.bottom }
            z: 1
            source: "images/menu.png"
            onClicked: unitSelect.toggle()
        }

        Text {
            id: clockOutput
            text: "00:00:00"
            color: "#ffffff"
            font.pointSize: 20
            anchors.centerIn: parent
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
    }

    Timer {
        id: clock
        repeat: true
        running: false
        onTriggered: clockOutput.update()
    }

    Menu {
        id: unitSelect
        items: 4
        z: 10
        anchors { bottom: toolbar.top; right: parent.right; rightMargin: 5; left: parent.horizontalCenter }

        property string timeUnit

        MenuItem {
            id: secSelect
            text: "events/sec"
            width: parent.width
            onClicked: {
                parent.timeUnit = "sec";
                unitSelect.close();
            }
        }

        MenuItem {
            id: minSelect
            text: "events/min"
            width: parent.width
            onClicked: {
                parent.timeUnit = "min";
                unitSelect.close();
            }
        }

        MenuItem {
            id: hrSelect
            text: "events/hr"
            width: parent.width
            onClicked: {
                parent.timeUnit = "hr";
                unitSelect.close();
            }
        }

        MenuItem {
            id: closeSelect
            text: "Close"
            width: parent.width
            onClicked: parent.close()
        }
    }
}
