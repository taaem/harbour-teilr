/*****************************************************************************
 * GifImage.qml
 *
 * Created: 11.09.2016 2016 by taaem
 *
 * Copyright 2016 taaem. All rights reserved.
 *
 * This file may be distributed under the terms of GNU Public License version
 * 2 (GPL v2) as defined by the Free Software Foundation (FSF). A copy of the
 * license should have been included with this file, or the project in which
 * this file belongs to. You may also find the details of GPL v2 at:
 * http://www.gnu.org/licenses/gpl-2.0.txt
 *
 * If you have any questions regarding the use of this file, feel free to
 * contact the author of this file, or the owner of the project in which
 * this file belongs to.
*****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0


Item{
    width: parent.width
    height: childrenRect.height
    Column{
        width: alt_sizes.get(0).width
        Item{
            id: paItem
            width: img.status == Image.Ready ? 0 : alt_sizes.get(0).width
            height: img.status == Image.Ready ? 0 : alt_sizes.get(0).width
            anchors.horizontalCenter: parent.horizontalCenter
            Component.onCompleted: Qt.createQmlObject("import QtQuick 2.0;import Sailfish.Silica 1.0;BusyIndicator{
                   id: loadingInd
                   anchors.centerIn: parent
                   running: if(img.status == Image.Ready){false}else{true}

               }", paItem, "load")

        }
        AnimatedImage {
            anchors.horizontalCenter: parent.horizontalCenter
            id: img
            asynchronous: true

            onStatusChanged: if (img.status == Image.Ready) paItem.children[0].destroy()

            // tumblr
            source:  alt_sizes.get(0).url
            width: alt_sizes.get(0).width

            //sourceSize.width:parent.width
            //sourceSize.height: alt_sizes.get(2).height

            fillMode: Image.PreserveAspectFit

            MouseArea {
                anchors.fill: parent
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/ImagePage.qml"),
                                                 {model: photoRep.model} )
            }
            Label{
                id:cap
                text: app.secLinkStyle + caption
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(url)
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
            }
        }
    }
}
