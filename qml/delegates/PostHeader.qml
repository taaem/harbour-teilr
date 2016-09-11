/*****************************************************************************
 * PostHeader.qml
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
        width: parent.width
        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"
            Label{
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingSmall
                id: time
                font.italic: true
                font.pixelSize: Theme.fontSizeSmall
                text: Qt.formatDateTime(new Date(timestamp * 1000), "dd.MM.yy");
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryHighlightColor
            }
            Label {
                anchors.left: parent.left
                anchors.right: time.left
                id: blog
                text: blog_name
                font.pixelSize: Theme.fontSizeMedium
                width: contentWidth + Theme.paddingSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryHighlightColor
            }
        }


        //Loader{
        //    sourceComponent: if(model.title != undefined){titlelabel}
        //}
        Label{
            id: titleItem
            text: ""
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: Theme.fontSizeLarge
            width: parent.width - Theme.paddingSmall
            color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            Component.onCompleted: {
                if(!title){
                    titleItem.opacity = 0
                }else{
                    titleItem.text = title
                }
            }
        }
    }
}
