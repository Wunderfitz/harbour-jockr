/*
Copyright (c) <2013>, Jolla Ltd.
Contact: Vesa-Matti Hartikainen <vesa-matti.hartikainen@jollamobile.com>

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer. Redistributions in binary
    form must reproduce the above copyright notice, this list of conditions and
    the following disclaimer in the documentation and/or other materials
    provided with the distribution. Neither the name of the Jolla Ltd. nor
    the names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import harbour.jockr 1.0
import "models"
import "delegates"

Page {
    id: page
    property string title

    SilicaGridView {
        id: grid
        anchors.fill: parent
        clip: true

        header: PageHeader { title: page.title }

        function updateModelPosition() {
            console.debug("onPositionChanged")
            //positionSource.active && positionSource.stop()
            console.debug("positionSource stopped, latitude:" + positionSource.position.coordinate.latitude + " longitude:" + positionSource.position.coordinate.longitude)
            if (positionSource.position.coordinate.latitude && positionSource.position.coordinate.longitude) {
                console.debug("try to update model with position")
                photoGetRecentModelUpdatePosition("lat:" + positionSource.position.coordinate.latitude + ":lon:" + positionSource.position.coordinate.longitude)
            }
        }

        PositionSource {
            id: positionSource
            active: true
//            onPositionChanged: {
//                if (setPosition) {
//                    console.log("position is changed !!!")
//                    updateModelPosition()
//                    setPosition = false
//                    console.log("position changed is completed")
//                }
//            }
        }

        PullDownMenu {
            busy: photoGetRecentModel.loading
            MenuItem {
                text: qsTr("Search by position")
                onClicked: { grid.updateModelPosition(); photoGetRecentModelTimer.start() }
            }
            MenuItem {
                enabled: false
                text: qsTr("Search")
            }
            MenuItem {
                //enabled: photoGetRecentModel.page > 1
                visible: photoGetRecentModel.page > 1
                text: qsTr("Previous page")
                onClicked: { photoGetRecentModelChangePage(--photoGetRecentModel.page); photoGetRecentModelTimer.start() }
            }
            MenuItem {
                text: qsTr("Newly published")
                onClicked: { photoGetRecentModelUpdate(); photoGetRecentModelTimer.start() }
            }
        }

        PushUpMenu {
            busy: photoGetRecentModel.loading
            MenuItem {
                enabled: photoGetRecentModel.pages > photoGetRecentModel.page && photoGetRecentModel.count >= GValue.per_page
                text: qsTr("Next page")
                onClicked: {
                    photoGetRecentModelChangePage(++photoGetRecentModel.page)
                    photoGetRecentModel.xml = ""
                    photoGetRecentModelTimer.start()
                }
            }
        }

        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        model: photoGetRecentModel

        delegate: JockrImage {
            width: grid.cellWidth
            height: grid.cellHeight
            source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
            onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
        }

        ScrollDecorator {}

        ViewPlaceholder {
            enabled: grid.count == 0
            text: photoGetRecentModel.xml !== "" ? qsTr("No items") : qsTr("Loading")
        }
    }
}
