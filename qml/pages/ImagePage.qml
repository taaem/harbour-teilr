/*****************************************************************************
 * ImagePage.qml
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

Page {
    id: imagePage
    property ListModel model
    property ListModel parentModel
    property int index

    SilicaFlickable{
        anchors.fill: parent
        PullDownMenu{
            MenuItem{
                text: qsTr("Save")
                onClicked: {
                    helper.saveImage(parentModel.get(view.currentIndex).alt_sizes.get(0).url)
                }
            }
        }
        SlideshowView {
            id: view
            anchors.fill: parent

            model: imagePage.model
            Component.onCompleted: {
                // Move to the clicked image
                // TODO: Fix this to work for more then 3 pics
                for(var i = 0;i<imagePage.index;i++){
                    view.incrementCurrentIndex()
                }
            }
            delegate:Loader{
                id: listItem
                height: childrenRect.height
                width:{
                    if((alt_sizes.get(0).width * 2) > parent.width){
                        parent.width
                    }else{
                        parent.width / 3
                    }
                }
                anchors.margins: Theme.paddingSmall
                sourceComponent: if(alt_sizes.get(0).url.indexOf("gif") > -1){
                    Qt.createComponent("../components/GifImage.qml")
                }else{
                    Qt.createComponent("../components/Image.qml")
                }
            }
        }

    }
}


