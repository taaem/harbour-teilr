/*****************************************************************************
 * PostPhoto.qml
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
    Flow{
        height: childrenRect.height
        width: parent.width
        spacing: Theme.paddingMedium

        Repeater{
            id: photoRep
            model: photos
            delegate:Loader{
                height: childrenRect.height
                width:{
                    if(photos.count < 3 && photos.count >1){
                        parent.width / photos.count - Theme.paddingMedium
                    }else if(photos.count > 3){
                        parent.width / 3 - Theme.paddingMedium
                    }else{
                        parent.width
                    }
                }
                //anchors.margins: Theme.paddingSmall
                sourceComponent: if(alt_sizes.get(0).url.indexOf("gif") > -1){
                    Qt.createComponent("../components/GifImage.qml")
                }else{
                    Qt.createComponent("../components/Image.qml")
                }
            }


        }
    }
}

