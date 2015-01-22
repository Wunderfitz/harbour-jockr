import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../functions.js" as Flib

Item {
    id: jockrPhoto
    property bool pinchPhoto: false
    property alias source: photo.source
    property string pId
    property string pSecret
    property alias pTitle: pageHeader.title
    property bool favoritePic: false

    Component.onCompleted: {
        favoritePic = Flib.isFavorite(pId)
    }

    PageHeader {
        id: pageHeader
        visible: !pinchPhoto
    }

    Image {
        id: photo
        fillMode: Image.PreserveAspectFit
        //sourceSize.height: window.height * 2
        asynchronous: true
        anchors.fill: parent
/*
        MouseArea {
            id: jockrMouseArea
            anchors.fill: parent
            onClicked: {
               listView.interactive = false
               //photo.anchors.center = parent
               photo.height = window.height
               photo.width = window.width
               pinchPhoto = true
               enable = false
            }
        }

        PinchArea {
            id: jockrPinchArea
            anchors.fill: parent
            enabled: pinchPhoto
            pinch.target: photo
            pinch.minimumScale: 0.1
            pinch.maximumScale: 4
            /*
            onPinchStarted: {
                //pinchPhoto = true
                //listView.interactive = false
                //photo.anchors.fill = parent
            }
            onPinchFinished: {
                if (photo.scale === 1.0) {

                    listView.interactive = true
                    photo.anchors.center = parent
                } else {
                    //pinchPhoto = true
                    listView.interactive = false
                    photo.anchors.fill = parent
                }
            }
            */
   /*
            MouseArea {
                id: dragArea
                hoverEnabled: true
                anchors.fill: parent
                drag.target: jockrPhoto
                enabled: pinchPhoto
                onClicked: {
                    console.debug("jockrPhoto MouseArea DoubleClicked ...")
                    listView.interactive = true
                    //photo.anchors.fill = parent
                    //photo.height = window.height
                    jockrMouseArea.enabled = true
                    pinchPhoto = false
                }
            }
        }
    */
    }

    Row {
        id: rowButtons
        height: pageHeader.height

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing: Theme.paddingLarge

        IconButton {
            id: favoritesIcon
            visible: !pinchPhoto
            icon.source: favoritePic ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
//            onClicked: if (favoritePic) {
//                           listView.removeToFavorite(pId)
//                           favoritePic = false
//                       } else {
//                           listView.addToFavorite(pId)
//                           favoritePic = true
//                       }
        }

        IconButton {
            id: commentsIcon
            visible: !pinchPhoto
            icon.source: "image://theme/icon-m-chat"
            onClicked: listView.getComments(pId)
        }

//        IconButton {
//            id: shareIcon
//            visible: !pinchPhoto
//            icon.source: "image://theme/icon-m-share"
//        }

        IconButton {
            id: infoIcon
            visible: !pinchPhoto
            icon.source: "image://theme/icon-m-about"
            onClicked: listView.getInfo(pId, pSecret)
        }
    }
}