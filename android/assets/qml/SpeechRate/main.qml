import QtQuick 1.1
Rectangle {

    id: root
    color: "#222222"
    height: 800
    width: 480

    Keys.onMenuPressed: unitSelect.toggle()

    /** EVENT FREQUENCY **/
    function getFrequency()
    {
        var totTime;
        var frequency;
        var count;
        var x;

        /** SECONDS **/
        if (unitSelect.timeUnit === "sec")
            totTime = clockOutput.seconds+(clockOutput.minutes*60)+(clockOutput.hours*3600);

        /** MINUTES **/
        else if (unitSelect.timeUnit === "min")
            totTime = (clockOutput.seconds/60)+clockOutput.minutes+(clockOutput.hours*60);

        /** HOURS **/
        else if (unitSelect.timeUnit === "hr")
            totTime = (clockOutput.seconds/3600)+(clockOutput.minutes/60)+clockOutput.hours;

        if (totTime !== 0)
        {
            for (x=0; x < trackerRepeater.count; x++)
            {
                count = trackerModel.get(x).num;
                trackerModel.setProperty(x,"frequency",(count/totTime));
            }
        }
        else
            trackerRepeater.itemAt(x).frequency = 0.0;
    }

    /** TOP STATUS BAR **/
    Rectangle {
        id: statusBar
        height: parent.height/10
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
            source: "edit"
            toggle: true
        }

        IconWidget {
            id: directionButton
            anchors { top: parent.top; bottom: parent.bottom; left: editButton.right; leftMargin: 5 }
            source: reverseCountDirection ? "down" : "up"
            onClicked: reverseCountDirection ? reverseCountDirection = false : reverseCountDirection = true

            property bool reverseCountDirection: false
        }

        IconWidget {
            id: addCounter
            anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
            source: "new"
            disabled: trackerRepeater.count === 4 ? true : false
            onClicked: {
                if (counts < 4)
                {
                    trackerModel.append({"name": "Events", "num": 0, "frequency": 0.0});
                    counts++;
                }
            }

            property int counts: 1
        }

        IconWidget {
            id: subtractCounter
            anchors { top: parent.top; bottom: parent.bottom; right: addCounter.left }
            source: "delete"
            disabled: trackerRepeater.count === 1 ? true : false
            onClicked: {
                if (addCounter.counts > 1)
                    trackerModel.remove(trackerModel.count-1);
                    addCounter.counts--;
            }
        }
    }

    /** COUNTER GRID **/
    Grid {
        id: eventTracker
        x: 0
        y: 80
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        columns: 2
        rows: 2
        spacing: 10
        anchors { top: statusBar.bottom; topMargin: 5; bottom: toolbar.top; bottomMargin: 5; right: parent.right; left: parent.left }

        ListModel {
            id: trackerModel
            ListElement {
                name: "Events"
                num: 0
                frequency: 0
            }
        }

        function changeCount (index,negative)
        {
            var currentCount = trackerModel.get(index).num
            if (negative)
                trackerModel.setProperty(index,"num",currentCount-1);
            else
                trackerModel.setProperty(index,"num",currentCount+1);

        }

        function changeName (index,nName)
        {
            trackerModel.setProperty(index,"name",nName);
        }

        Repeater {
            id: trackerRepeater
            model: trackerModel

            Item {
                width: (root.width/2)-5
                height: (eventTracker.height/2)-5

                property alias text: textDelegate.text

                signal countChange (int counterIndex, bool negative)

                onCountChange: eventTracker.changeCount(counterIndex,negative)

                Button {
                    id: counterDelegate
                    anchors.fill: parent
                    visible: !editButton.toggled
                    text: name+": "+num+"\n"+frequency.toFixed(3)+"\n"+name+"/"+unitSelect.timeUnit
                    font.pointSize: 24
                    onClicked: parent.countChange(index,directionButton.reverseCountDirection)
                }
                TextInput {
                    id: textDelegate
                    visible: editButton.toggled
                    text: name
                    font.pointSize: 36
                    color: "#ffffff"
                    anchors.centerIn: counterDelegate

                    onTextChanged: eventTracker.changeName(index,text);
                }
            }
        }
    }

    Rectangle {
        id: toolbar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: parent.height/10
        color: "#00000000"
        border { color: "#2b2b2b"; width: 1 }

        IconWidget {
            id: clockControl
            anchors { bottom: parent.bottom; top: parent.top; topMargin: 1; right: clockOutput.left; rightMargin: 20 }
            source: "start"
            onClicked: startStop();

            function startStop()
            {
                if (clock.running === true)
                {
                    clock.stop();
                    clockControl.source = "start";
                }
                else
                {
                    clock.start();
                    clockControl.source = "stop";
                }
            }
        }

        IconWidget {
            id: reset
            anchors { bottom: parent.bottom; top: parent.top; topMargin: 1; left: parent.left }
            source: "clear"
            onClicked: resetAll()

            function resetAll()
            {
                //Reset Clock
                clock.restart();
                clock.stop();
                clockControl.source = "start";
                clockOutput.seconds = 0;
                clockOutput.minutes = 0;
                clockOutput.hours = 0;
                clockOutput.text = "00:00:00";

                //Reset Counters
                for (var x=0; x<trackerModel.count; x++)
                {
                    trackerModel.setProperty(x,"num",0);
                    trackerModel.setProperty(x,"frequency",0.0);
                }
            }
        }


        IconWidget {
            id: menuButton
            anchors { top: parent.top; topMargin: 1; right: parent.right; bottom: parent.bottom }
            z: 1
            source: "menu"
            toggle: true
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

                root.getFrequency();

            }
        }
    }

    Timer {
        id: clock
        repeat: true
        running: false
        onTriggered: {
            clockOutput.update();
            parent.getFrequency();
        }
    }

    Menu {
        id: unitSelect
        items: 4
        z: 10
        anchors { bottom: toolbar.top; right: parent.right; rightMargin: 5; left: parent.horizontalCenter }

        property string timeUnit: "min"

        MenuItem {
            id: secSelect
            text: "events/sec"
            width: parent.width
            onClicked: {
                parent.timeUnit = "sec";
                menuButton.toggled = false;
                unitSelect.close();
            }
        }

        MenuItem {
            id: minSelect
            text: "events/min"
            width: parent.width
            onClicked: {
                parent.timeUnit = "min";
                menuButton.toggled = false;
                unitSelect.close();
            }
        }

        MenuItem {
            id: hrSelect
            text: "events/hr"
            width: parent.width
            onClicked: {
                parent.timeUnit = "hr";
                menuButton.toggled = false;
                unitSelect.close();
            }
        }

        MenuItem {
            id: closeSelect
            text: "Close"
            width: parent.width
            onClicked: {
                menuButton.toggled = false;
                parent.close()
            }
        }
    }
}
