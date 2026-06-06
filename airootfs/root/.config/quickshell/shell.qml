import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Scope {
    property string currentTime: "..."
    property string cpuUsage: "..."
    property string ramUsage: "..."
    property string batteryLevel: "..."
    
    property string wifiStatus: "..."
    property string soundVolume: "..."

    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData
                anchors { top: true; left: true; right: true }
                margins { top: 10; left: 10; right: 10 }
                implicitHeight: 36
                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: "#2a2a2a"
                    radius: 12

                    RowLayout {
                        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 15 }
                        spacing: 15
                        Text { color: "#cba6f7"; font.family: "JetBrains Mono Nerd Font"; font.bold: true; text: "  " + cpuUsage }
                        Text { color: "#89b4fa"; font.family: "JetBrains Mono Nerd Font"; font.bold: true; text: "  " + ramUsage }

                        RowLayout {
                            spacing: 8
                            
                            Repeater {
                                model: 5 
                                
                                Text {
                                    property bool isActive: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === (index + 1) : false
                                    
                                    text: isActive ? "●" : "○"
                                    color: isActive ? "#f9e2af" : "#6c7086" 
                                    font.pixelSize: 10

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        color: "#cdd6f4"
                        font.family: "JetBrains Mono Nerd Font"
                        font.bold: true
                        text: currentTime
                    }

                    RowLayout {
                        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 15 }
                        spacing: 15

                        Text { 
                            color: "#a6e3a1"; font.family: "JetBrains Mono Nerd Font"; font.bold: true; text: "󰤨  " + wifiStatus 
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: openWifiTui.running = true
                            }
                        }

                        Text { 
                            color: "#89b4fa"; font.family: "JetBrains Mono Nerd Font"; font.bold: true; text: "󰂯 Bt" 
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: openBluetoothTui.running = true
                            }
                        }

                        Text { 
                            color: "#f9e2af"; font.family: "JetBrains Mono Nerd Font"; font.bold: true; text: "  " + soundVolume 
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: openSoundMixerTui.running = true
                            }
                        }

                        Text { color: "#f38ba8"; font.family: "JetBrains Mono Nerd Font"; font.bold: true; text: "  " + batteryLevel }
                    }                    
                }
            }
        }
    }

    Process {
        id: dateProc
        command: ["date", "+%H:%M  |  %A, %b %d"]
        stdout: StdioCollector { onStreamFinished: currentTime = this.text.trim() }
    }

    Process {
        id: ramProc
        command: ["sh", "-c", "free -h | awk '/^Mem:/ {print $3}'"]
        stdout: StdioCollector { onStreamFinished: ramUsage = this.text.trim() }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"]
        stdout: StdioCollector { onStreamFinished: cpuUsage = this.text.trim() }
    }

    Process {
        id: audioProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{vol=$2*100; if($3==\"[MUTED]\") print \"Muted\"; else print vol\"%\"}'"]
        stdout: StdioCollector { onStreamFinished: soundVolume = this.text.trim() }
    }

    Process {
        id: batteryProc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n 1"]
        stdout: StdioCollector { 
            onStreamFinished: {
                let out = this.text.trim();
                batteryLevel = out === "" ? "N/A" : out + "%";
            }
        }
    }

    Process {
        id: wifiProc
        command: ["sh", "-c", "IFACE=$(ls /sys/class/net | grep -E '^wl' | head -n 1); [ -n \"$IFACE\" ] && iwctl station \"$IFACE\" show 2>/dev/null | awk '/Connected network/ {print $3}'"]
        stdout: StdioCollector { 
            onStreamFinished: {
                let out = this.text.trim();
                wifiStatus = out === "" ? "Offline" : out;
            }
        }
    }

    Process {
        id: openSoundMixerTui
        command: ["sh", "-c", "alacritty -e wiremix &"]
    }

    Process {
        id: openBluetoothTui
        command: ["sh", "-c", "alacritty -e bluetui &"]
    }

    Process {
        id: openWifiTui
        command: ["sh", "-c", "alacritty -e impala &"]
    }
    
    Timer {
        interval: 2500
        running: true
        repeat: true
        onTriggered: {
            dateProc.running = true
            ramProc.running = true
            batteryProc.running = true
            cpuProc.running = true
            audioProc.running = true
            wifiProc.running = true
        }
    }
}
