/*****************************************************************************
 * AboutPage.qml
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
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu{

            MenuItem {
                text: qsTr("Logout")
                onClicked: {
                    auth.logout()
                }
            }
        }


        Column {
            id: column
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("About")
            }
            Label {
                text: "Teilr"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label{
                text: "Version 0.1.4"
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
            }
            Label{
                text: "<a href=\"https://github.com/taaem/harbour-teilr\">Source Code</a>"
                onLinkActivated: Qt.openUrlExternally(link)
                linkColor: Theme.secondaryHighlightColor
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium

            }
            Label{
                text: "Credits to <br> <a href=\"https://github.com/kypeli/kQOAuth\">kQOAuth</a>"
                onLinkActivated: Qt.openUrlExternally(link)
                linkColor: Theme.secondaryHighlightColor
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
            }
        }
    }
}


