/*****************************************************************************
* CoverPage.qml
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

CoverBackground {
    Column{
        anchors.fill: parent
        anchors.topMargin: parent.height / 3
        spacing: Theme.paddingLarge
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            id: label
            text: qsTr("Teilr")
        }
        Image{
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/harbour-teilr.png"
            sourceSize.width: 86
            sourceSize.height: 86
        }
    }



    // TODO!!!
    /*
    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
    }
    */
}


