import QtQuick 2.6
import QtQuick.Window 2.2
import QtMultimedia 5.6
Window {
    id: window
    visible: false
    width: 800
    height: 390
    title: cfg.getVersion()
    onXChanged: cfg.setX(x)
    onYChanged: cfg.setY(y)
    onWidthChanged: cfg.setWidth(width)
    onHeightChanged: cfg.setHeight(height)
    property Dict dict: Dict{}
    //flags: Q_OS_WIN ? Qt.Dialog:Qt.WindowStaysOnTopHint
    //flags: Qt.Dialog
    signal signalBtnqueryClick(string word)
    signal signalBtnaddwordClick(string type,string id)
    //slot
    function addWordRet(retstr){
       dict.addWordRet(retstr);
    }
    function showYoudaoWord(wordinfo){
        dict.setYoudaoWordinfo(wordinfo);
        mainForm.text_youdao.text = dict.youdaoWordinfo;
        mainForm.rectangle_youdao.visible = true;
    }
    function showShanbayWord(wordstr){
        dict.setShanbayWordinfo(wordstr);
        mainForm.text_shanbay.text = dict.shanbayWordinfo;
        mainForm.text_en.text = dict.def_en_info ;
        mainForm.rectangle_shanbay.visible = mainForm.rectangle_en.visible = true;
    }
    ///////////////////////////////
    Audio {
            id: playSound0
        }
    Audio {
            id: playSound1
        }

    Flickable {
        id: view
        anchors.fill: parent
        contentWidth: mainForm.width
        contentHeight: mainForm.height

        MainForm {
            id: mainForm
            width:  window.width //text_def.width + 20
            //height: text_def.height + 100
            btn_query.onClicked: {
                winInfo.hide();
                //rectangle_shanbay.visible = rectangle_youdao.visible = rectangle_en.visible =false;
                signalBtnqueryClick(textWord.text);
            }
            btn_addword.onClicked: dict.addWord();

            btn_sound0.onClicked: {
                playSound0.play();
            }
            btn_sound1.onClicked: {
                playSound1.play();
            }
            Keys.onPressed: {
                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                    if(textWord.focus) {
                        signalBtnqueryClick(textWord.text);
                        return;
                    }
                }
            }
            Component.onCompleted: {
                textWord.forceActiveFocus();
            }
        }
        // Only show the scrollbars when the view is moving.
        states: State {
            name: "ShowBars"
            when: view.movingVertically || view.movingHorizontally
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 400 }
        }
    }

    // Attach scrollbars to the right and bottom edges of the view.
    ScrollBar {
        id: verticalScrollBar
        width: 12; height: view.height-12
        anchors.right: view.right
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio
    }

    ScrollBar {
        id: horizontalScrollBar
        width: view.width-12; height: 12
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
    }
    WinInfo{
        id: winInfo
        visible: false
    }
    Component.onCompleted: {
        //setX(Screen.width / 2 - width / 2);
        //setY(Screen.height / 2 - height / 2);
        setX(cfg.getX()==0?Screen.width / 2 - width / 2:cfg.getX());
        setY(cfg.getY()==0?Screen.height / 2 - height / 2:cfg.getY());

        setWidth(cfg.getWidth()==0?width:cfg.getWidth());
        setHeight(cfg.getHeight()==0?height:cfg.getHeight());
        mainForm.word_name.text = "";
        //mainForm.text_shanbay.text = mainForm.text_youdao.text = mainForm.text_en.text = "";
        mainForm.btn_addword.visible = false;
        mainForm.pronu_us.visible = false;
        mainForm.btn_sound0.visible = mainForm.btn_sound1.visible = false;
        //console.log("main window"+configs.value("getscreentext"));
    }
    onClosing:{
        //console.log("main windows is closing");
        visible = false;
        close.accepted = false;
    }
}
