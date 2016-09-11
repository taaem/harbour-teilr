/*****************************************************************************
 * DashboardPage.qml
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
import harbour.teilr.Service 1.0
import "../delegates"


Page {
    id: page
    property bool sinBlog: false
    property bool busy
    property int index: 0
    SilicaListView {
        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: "My Blogs"
                onClicked: pageStack.push(Qt.resolvedUrl("MyBlogPage.qml"))
            }

            MenuItem{
                text: qsTr("Search")
                onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
            }
            MenuItem {
                text: "Reload"
                onClicked: {
                    dashboard.getDashboard(20, index, "", 0, true, true)
                    viewModel.clear()
                    page.busy = true
                }
            }
        }
        PushUpMenu {
            MenuItem {
                text: qsTr("Load more")
                onClicked: {
                    index = index + 20
                    dashboard.getDashboard(20, index, "", 0, true, true)
                }
            }
        }
        id: dashListView
        model: ListModel{
            id: viewModel
        }
        spacing: Theme.paddingMedium
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Your Tumblr Dashboard")
        }
//        footer:Button{
//            visible: dashListView.count > 0
//            text: qsTr("Load More")
//            anchors.horizontalCenter: parent.horizontalCenter
//            onClicked: {
//                index = index + 20
//                dashboard.getDashboard(20, index, "", 0, true, true)
//            }
//        }


        delegate: PostDelegate{}
        VerticalScrollDecorator {}
        BusyIndicator{
            running: page.busy
            anchors.centerIn: parent
        }
    }

    Tumblr{
        id: dashboard
        Component.onCompleted: {
            page.busy = true
            getUserInfo()
        }
        onGotDashboard: {
            append(element)
            page.busy = false
        }
        onGotUserInfo:{
            getDashboard(20, index, "", 0, true, true)
            app.tumblrName = info.name
            app.following = info.following
            app.likes = info.likes

            for(var index in info.blogs){
                app.allBlogs.append(info.blogs[index])
            }

        }
    }
    function append(element){
        dashListView.model.append(element)
    }
}

