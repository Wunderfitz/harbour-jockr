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
import harbour.jockr 1.0
import "models"
import "delegates"


Page {
    id: page
    property string title
    property string nsId

    SilicaGridView {
        id: grid
        header: PageHeader { title: page.title }
        cellWidth: width / 3
        cellHeight: cellWidth
        cacheBuffer: grid.height
        anchors.fill: parent
        model: peopleGetPhotosModel

        PullDownMenu {
            busy: peopleGetPhotosModel.loading
            MenuItem {
                //enabled: peopleGetPhotosModel.page > 1
                visible: peopleGetPhotosModel.page > 1
                text: qsTr("Previous page")
                onClicked: { peopleGetPhotosModelChangePage(--peopleGetPhotosModel.page); peopleGetPhotosModelTimer.start() }
            }
            MenuItem {
                text: qsTr("Update")
                onClicked: { peopleGetPhotosModelUpdate(); peopleGetPhotosModelTimer.start() }
            }
        }

        PushUpMenu {
            busy: peopleGetPhotosModel.loading
            MenuItem {
                enabled: peopleGetPhotosModel.pages > peopleGetPhotosModel.page && peopleGetPhotosModel.count >= GValue.per_page
                text: qsTr("Next page")
                onClicked: {
                    peopleGetPhotosModelChangePage(++peopleGetPhotosModel.page)
                    peopleGetPhotosModel.xml = ""
                    peopleGetPhotosModelTimer.start()
                }
            }
        }

        delegate: JockrImage {
            width: grid.cellWidth
            height: grid.cellHeight
            source: "https://farm" + farm + ".staticflickr.com/" + server + "/" + id + "_" + secret + "_q.jpg"
            onClick: pageStack.push(Qt.resolvedUrl("FlickrSlideView.qml"), {currentIndex: index, model: grid.model} )
        }

        ScrollDecorator {}

        ViewPlaceholder {
            enabled: grid.count == 0
            text: peopleGetPhotosModel.strStatus
        }
    }
}

