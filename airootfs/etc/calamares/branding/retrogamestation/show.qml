import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    width: 960
    height: 640

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        
        // Gradient overlay
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#001122" }
                GradientStop { position: 0.5; color: "#000811" }
                GradientStop { position: 1.0; color: "#000000" }
            }
            opacity: 0.8
        }
        
        // Center glow
        Rectangle {
            anchors.centerIn: parent
            width: 600
            height: 400
            radius: 200
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00A8FF"; opacity: 0.15 }
                GradientStop { position: 0.5; color: "#0066AA"; opacity: 0.08 }
                GradientStop { position: 1.0; color: "#000000"; opacity: 0 }
            }
            opacity: 0.5
        }
        
        // Scanlines
        Image {
            anchors.fill: parent
            source: "qrc:/scanlines.png"
            fillMode: Image.Tile
            opacity: 0.03
            sourceSize: Qt.size(4, 4)
        }
    }

    // Slideshow
    ListView {
        id: slideshow
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        currentIndex: 0
        model: slideModel
        
        delegate: SlideDelegate {}
    }

    // Auto-advance timer
    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: {
            if (slideshow.currentIndex < slideshow.count - 1) {
                slideshow.currentIndex++
            } else {
                slideshow.currentIndex = 0
            }
        }
    }

    // Slide indicators (dots)
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12
        margin: 32
        
        Repeater {
            model: slideModel.count
            delegate: Rectangle {
                width: 10
                height: 10
                radius: 5
                color: index === slideshow.currentIndex ? "#00A8FF" : "#333333"
                border.color: index === slideshow.currentIndex ? "#00CCFF" : "transparent"
                border.width: 2
                Behavior on color { ColorAnimation { duration: 300 } }
            }
        }
    }

    // Slide model
    ListModel {
        id: slideModel
        ListElement {
            title: "Estação de Jogo Híbrida"
            subtitle: "Gamescope + Steam Deck Experience"
            body: "Inicialize direto no Gamescope com Steam Big Picture.\nSuporte nativo a FSR, controles, MangoHUD e GOverlay.\nDesempenho de console, liberdade de PC."
            icon: "gamepad"
            accentColor: "#00A8FF"
        }
        ListElement {
            title: "Laboratório Retrodev"
            subtitle: "PS2 • GameCube • N64 • Dreamcast • Saturn • Switch • 3DS • Vita • PSP • PS1 • GBA/NDS"
            body: "Toolchains pré-configurados: PS2SDK, devkitPro (ARM/PPC),\nlibdragon (N64), VitaSDK, libnx (Switch), KOS (Dreamcast).\nGhidra, Radare2/Cutter, Frida, pwntools prontos para uso."
            icon: "code"
            accentColor: "#00CC88"
        }
        ListElement {
            title: "Atalhos Rápidos"
            subtitle: "Troca instantânea entre modos"
            body: "Super + Q  ou  F1  → Alterna Console ↔ Desktop\n\nModo Console: Gamescope + Steam (imersão total)\nModo Desktop: KDE Plasma (produtividade)\nModo Híbrido: Ambos disponíveis, troca a quente"
            icon: "keyboard"
            accentColor: "#FFAA00"
        }
    }

    // Slide delegate
    Component {
        id: SlideDelegate
        Item {
            width: slideshow.width
            height: slideshow.height
            
            // Icon area
            Rectangle {
                id: iconBg
                width: 160
                height: 160
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 60
                radius: 80
                border.color: slideModel.get(index).accentColor
                border.width: 2
                color: "#0A0E17"
                opacity: 0.9
                
                Image {
                    anchors.centerIn: parent
                    width: 80
                    height: 80
                    source: "qrc:/icons/" + slideModel.get(index).icon + ".svg"
                    fillMode: Image.PreserveAspectFit
                    color: slideModel.get(index).accentColor
                }
            }
            
            // Title
            Text {
                anchors.top: iconBg.bottom
                anchors.topMargin: 32
                anchors.horizontalCenter: parent.horizontalCenter
                text: slideModel.get(index).title
                font.family: "DejaVu Sans"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#FFFFFF"
                letterSpacing: 1
            }
            
            // Subtitle
            Text {
                anchors.top: parent.verticalCenter
                anchors.topMargin: -40
                anchors.horizontalCenter: parent.horizontalCenter
                text: slideModel.get(index).subtitle
                font.family: "DejaVu Sans"
                font.pixelSize: 16
                color: slideModel.get(index).accentColor
                letterSpacing: 0.5
            }
            
            // Body
            Text {
                anchors.top: parent.verticalCenter
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: 700
                text: slideModel.get(index).body
                font.family: "DejaVu Sans"
                font.pixelSize: 15
                color: "#CCCCCC"
                lineHeight: 1.7
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }
    }
}