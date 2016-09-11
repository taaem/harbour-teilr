/*****************************************************************************
 * harbour-teilr.qml
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
import "pages"
import harbour.teilr.Service 1.0


ApplicationWindow
{
    id: app
    property string secLinkStyle: "<style>a:link { color: " + Theme.secondaryHighlightColor + "; }</style>"
    property string priLinkStyle: "<style>a:link { color: " + Theme.highlightColor + "; }</style>"

    property string tumblrName
    property ListModel allBlogs: ListModel{}
    property ListModel allFollowedBlogs: ListModel{}
    property int following
    property int likes

    initialPage: if(auth.authenticated){Qt.resolvedUrl("pages/DashboardPage.qml")}else{Qt.resolvedUrl("pages/StartupPage.qml")} //Component { StartupPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    Authentication{
        id: auth
        onOpenBrowser: {
            pageStack.clear()
            pageStack.push(Qt.resolvedUrl("pages/AuthPage.qml"), {url: dest})
        }
        onAuthenticatedChanged:{
            if(authenticated){
                pageStack.clear()
                pageStack.push((Qt.resolvedUrl("pages/DashboardPage.qml")))
                metaTumblr.getTokens();
            }else{
                pageStack.clear()
                pageStack.push("pages/StartupPage.qml")
            }
        }
        /*
        Component.onCompleted: {
            if(authenticated){
                pageStack.push(Qt.resolvedUrl("pages/DashboardPage.qml"))
            }
        }
        */

    }
    Tumblr{
        id: metaTumblr


    }
}


