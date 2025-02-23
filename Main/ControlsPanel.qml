/*
    Copyright (C) 2019 Joshua Wade

    This file is part of Anthem.

    Anthem is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation, either version 3 of
    the License, or (at your option) any later version.

    Anthem is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with Anthem. If not, see
                        <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.13
import QtGraphicalEffects 1.13
import QtQuick.Dialogs 1.2

import "BasicComponents"
import "Global"

Panel {
    height: 44
    Item {
        id: controlPanelSpacer
        anchors.fill: parent
        anchors.margins: 6

        // Float left

        Button {
            id: btnLogo
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.height // makes it square :)
            isToggleButton: true

            imageSource: "Images/Logo.svg"
            imageWidth: 14
            imageHeight: 12

            hoverMessage: btnLogo.pressed ? "Stop engine for this tab" : "Start engine for this tab"
        }

        Button {
            id: btnFile
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: btnLogo.right
            anchors.leftMargin: 2
            width: parent.height

            textContent: "File"

            hasMenuIndicator: true

            onPress: fileMenu.open()

            Menu {
                id: fileMenu
                y: parent.height

                MenuItem {
                    text: 'New project'
                    onTriggered: Anthem.newProject()
                }
                MenuItem {
                    text: 'Open...'
                    onTriggered: loadFileDialog.open()
                }
                MenuSeparator {}
                MenuItem {
                    text: 'Save'
                    onTriggered: save()
                }
                MenuItem {
                    text: 'Save as...'
                    onTriggered: saveFileDialog.open()
                }
                MenuSeparator {}
                MenuItem {
                    text: 'Exit'
                }
            }
        }

        Button {
            id: btnSave
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: btnFile.right
            anchors.leftMargin: 20
            width: parent.height
            hoverMessage: "Save project"

            imageSource: "Images/Save.svg"
            imageWidth: 16
            imageHeight: 16

            onPress: save()
        }

        Button {
            id: btnUndo
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: btnSave.right
            anchors.leftMargin: 2
            width: parent.height
            hoverMessage: "Undo"

            imageSource: "Images/Undo.svg"
            imageWidth: 15
            imageHeight: 15

            onPress: {
                Anthem.undo();
            }
        }

        Button {
            id: btnRedo
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: btnUndo.right
            anchors.leftMargin: 2
            width: parent.height
            hoverMessage: "Redo"

            imageSource: "Images/Redo.svg"
            imageWidth: 15
            imageHeight: 15

            onPress: {
                Anthem.redo();
            }
        }



        // Float middle
        Item {
            /*
              This item is used to center a group of contorls in its parent.

              In a perfect world, I would have the item adapt to the width of its
                content and then center itself in the parent, but I don't know how
                to do the former and I'm on a plane right now so I'm going to have
                to settle for hard-coding the width.

              -- Joshua Wade, Jun 11, 2019
              */

            id: centerPositioner
            width: 498
            height: parent.height
            anchors.centerIn: parent

            Button {
                id: btnMetronomeToggle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.height
                hoverMessage: "Toggle metronome"

                isToggleButton: true

                imageSource: "Images/Metronome.svg"
                imageWidth: 13
                imageHeight: 16
            }

            Button {
                id: idk
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: btnMetronomeToggle.right
                anchors.leftMargin: 3
                width: 21
            }

            ButtonGroup {
                id: playbackControlsGroup
                anchors.top: parent.top
                anchors.left: idk.right
                anchors.bottom: parent.bottom
                fixedWidth: false
                anchors.leftMargin: 3

                defaultImageWidth: 12
                defaultImageHeight: 12
                defaultButtonWidth: 32
                defaultButtonHeight: 32

                model: ListModel {
                    ListElement {
                        isToggleButton: true
                        imageSource: "Images/Play.svg"
                    }

                    ListElement {
                        isToggleButton: true
                        hoverMessage: "Record"
                        imageSource: "Images/Record.svg"
                    }

                    ListElement {
                        hoverMessage: "Record immediately"
                        imageSource: "Images/Play and Record.svg"
                        imageWidth: 16
                        imageHeight: 16
                    }

                    ListElement {
                        hoverMessage: "Stop"
                        imageSource: "Images/Stop.svg"
                    }
                }
            }

            Button {
                id: btnLoop
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: playbackControlsGroup.right
                anchors.leftMargin: 3
                width: parent.height
                hoverMessage: "Toggle loop points"

                isToggleButton: true

                imageSource: "Images/Loop.svg"
                imageWidth: 16
                imageHeight: 14
            }

            Rectangle {
                id: tempoAndTimeSignatureBlock
                anchors.left: btnLoop.right
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 61
                radius: 2

                color: Qt.rgba(0, 0, 0, 0.15)
                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.4)

                Item {
                    id: spacer1
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height * 0.5;
                    anchors.rightMargin: 7

                    DigitControl {
                        id: tempoControl
                        anchors.fill: parent
                        anchors.topMargin: 2

                        lowBound: 10
                        highBound: 999
                        step: 0.01
                        smallestIncrement: 0.01
                        decimalPlaces: 2
                        value: 140
                        hoverMessage: "Tempo"
                        units: "BPM"

                        fontPixelSize: 13

                        onValueChanged: {
                            Anthem.setBeatsPerMinute(value, false);
                        }

                        onValueChangeCompleted: {
                            Anthem.setBeatsPerMinute(value, true);
                        }

                        Connections {
                            target: Anthem
                            onBeatsPerMinuteChanged: {
                                tempoControl.value = bpm;
                            }
                        }

                        // This MouseArea changes the step on tempoControl
                        // depending on which digit is clicked.
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                mouse.accepted = false;
                                let distanceFromRight = parent.width - mouseX;
                                if (distanceFromRight <= 8) {
                                    tempoControl.step = 0.01;
                                }
                                else if (distanceFromRight <= 16) {
                                    tempoControl.step = 0.1;
                                }
                                else {
                                    tempoControl.step = 1;
                                }
                            }
                            onReleased: {
                                mouse.accepted = false;
                            }
                            onPositionChanged: {
                                mouse.accepted = false;
                            }
                        }
                    }
                }

                Item {
                    id: spacer2
                    anchors.top: spacer1.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 7

                    DigitControl {
                        id: timeSignatureNumeratorControl
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: timeSignatureSlash.left
                        width: 16
                        hoverMessage: "Time signature numerator"

                        fontPixelSize: 13

                        lowBound: 1
                        highBound: 16
                        value: 4
                        speedMultiplier: 0.5


//                        onValueChanged: {
//                            Anthem.setTimeSignatureNumerator(value);
//                        }

                        onValueChangeCompleted: {
                            Anthem.setTimeSignatureNumerator(value);
                        }

                        Connections {
                            target: Anthem
                            onTimeSignatureNumeratorChanged: {
                                timeSignatureNumeratorControl.value = numerator;
                            }
                        }
                    }

                    Text {
                        id: timeSignatureSlash
                        text: qsTr("/")
                        font.family: Fonts.sourceCodeProSemiBold.name
                        font.weight: Font.Bold
                        font.pixelSize: 13
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: timeSignatureDenominatorControl.left
                        color: "#1ac18f"
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    DigitControl {
                        id: timeSignatureDenominatorControl
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: value === 16 ? 16 : 8
                        hoverMessage: "Time signature denominator"

                        fontPixelSize: 13
                        alignment: Text.AlignLeft

                        value: 4
                        acceptedValues: [1, 2, 4, 8, 16]
                        speedMultiplier: 0.5

//                        onValueChanged: {
//                            Anthem.setTimeSignatureDenominator(value);
//                        }

                        onValueChangeCompleted: {
                            Anthem.setTimeSignatureDenominator(value);
                        }

                        Connections {
                            target: Anthem
                            onTimeSignatureDenominatorChanged: {
                                timeSignatureDenominatorControl.value = denominator;
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: playheadInfoBlock
                anchors.left: tempoAndTimeSignatureBlock.right
                anchors.leftMargin: 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 95
                radius: 2

                color: Qt.rgba(0, 0, 0, 0.15)
                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.4)

                Item {
                    id: spacer3
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height * 0.5;
                    anchors.rightMargin: 7

                    Text {
                        text: qsTr("1.1.1.00")
                        font.family: Fonts.sourceCodeProSemiBold.name
                        font.weight: Font.Bold
                        font.pointSize: 10
                        anchors.fill: parent
                        anchors.topMargin: 2
                        color: "#1ac18f"
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Item {
                    id: spacer4
                    anchors.top: spacer3.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 7

                    Text {
                        text: qsTr("0:00.00")
                        font.family: Fonts.sourceCodeProSemiBold.name
                        font.weight: Font.Bold
                        font.pointSize: 10
                        anchors.fill: parent
                        anchors.bottomMargin: 2
                        color: "#1ac18f"
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Rectangle {
                id: pitchBlock
                anchors.left: playheadInfoBlock.right
                anchors.leftMargin: 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 39
                radius: 2

                color: Qt.rgba(0, 0, 0, 0.15)
                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.4)

                Item {
                    anchors.fill: parent
                    anchors.topMargin: 1
                    anchors.bottomMargin: 1

                    Text {
                        id: pitchLabel
                        text: qsTr("PITCH")
                        font.family: Fonts.notoSansRegular.name
                        font.pointSize: 8
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: parent.height * 0.5
                        color: Qt.rgba(1, 1, 1, 0.65)
                    }

                    DigitControl {
                        id: masterPitchControl
                        anchors.top: pitchLabel.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                        anchors.right: parent.right
                        anchors.rightMargin: 4
                        anchors.bottom: parent.bottom
                        hoverMessage: "Master pitch"
                        units: "semitones"

                        fontFamily: Fonts.notoSansRegular.name

                        highBound: 12
                        lowBound: -12

                        onValueChanged: {
                            Anthem.setMasterPitch(value, false);
                        }

                        onValueChangeCompleted: {
                            Anthem.setMasterPitch(value, true);
                        }

                        Connections {
                            target: Anthem
                            onMasterPitchChanged: {
                                masterPitchControl.value = pitch;
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: cpuAndOutputBlock
                anchors.left: pitchBlock.right
                anchors.leftMargin: 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 58
                radius: 2

                color: Qt.rgba(0, 0, 0, 0.15)
                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.4)

                Item {
                    anchors.fill: parent
                    anchors.margins: 5

                    Item {
                        id: icons
                        width: 9
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left

                        Image {
                            id: cpuIcon
                            source: 'Images/CPU.svg'
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            height: parent.width
                            visible: false
                        }

                        ColorOverlay {
                            anchors.fill: cpuIcon
                            source: cpuIcon
                            color: Qt.rgba(1, 1, 1, 1)
                            opacity: 0.65
                        }

                        Image {
                            id: outputIcon
                            source: 'Images/Output Level.svg'
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: parent.width
                            visible: false
                        }

                        ColorOverlay {
                            anchors.fill: outputIcon
                            source: outputIcon
                            color: Qt.rgba(1, 1, 1, 1)
                            opacity: 0.65
                        }
                    }

                    Item {
                        anchors.left: icons.right
                        anchors.leftMargin: 3
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right

                        SimpleMeter {
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.top: parent.top
                            height: 9

                            value: 0.45
                        }

                        Item {
                            anchors.right: parent.right
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            height: 9

                            SimpleMeter {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 4

                                value: 0.7
                            }

                            SimpleMeter {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 4
                                value: 0.8
                            }
                        }
                    }
                }
            }
        }

        // Float right

        Button {
            id: btnMidiLearn // ?
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.height
            hoverMessage: "Midi learn"

            imageSource: "Images/Knob.svg"
            imageWidth: 16
            imageHeight: 16
        }
    }
}
