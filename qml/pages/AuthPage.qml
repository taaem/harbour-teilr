/*****************************************************************************
 * AuthPage.qml
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
import QtWebKit 3.0


Page {
    id: webViewPage
    property string url


    SilicaWebView {
        id: webView
        anchors.fill: parent

        opacity: 0
        onLoadingChanged: {

            switch (loadRequest.status)
            {
            case WebView.LoadSucceededStatus:
                opacity = 1
                break
            case WebView.LoadFailedStatus:
                opacity = 0
                viewPlaceHolder.errorString = loadRequest.errorString
                break
            default:
                opacity = 0
                break
            }
        }

        FadeAnimation on opacity {}

        PullDownMenu {
            MenuItem {
                text: qsTr("Reload")
                onClicked: webView.reload()
            }
        }


    }
    ViewPlaceholder {
        id: viewPlaceHolder
        property string errorString
        anchors.fill: parent
        anchors.topMargin: Theme.paddingLarge

        enabled: webView.opacity == 0
        text: qsTr("Loading...")
        hintText: ""
    }


    Component.onCompleted: webView.url = webViewPage.url
}



