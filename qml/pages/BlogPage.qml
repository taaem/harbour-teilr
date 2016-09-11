/*****************************************************************************
 * BlogPage.qml
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
    property bool sinBlog: true
    property string blogUrl
    property bool busy
    property bool own
    property bool followed
    property int index: 0
    SilicaListView {
        PullDownMenu {
            MenuItem {
                text: "Reload"
                onClicked: {
                    blog.getBlogPosts(20, index,blogUrl , [], 0, true, true)
                    viewModel.clear()
                    page.busy = true
                }
            }
            MenuItem{
                text: (page.followed)? qsTr("Unfollow") : qsTr("Follow")
                visible: !page.own
                onClicked: {
                    if(page.own !== true){
                        if(page.followed){
                            blog.followBlog(false,blogUrl)
                            page.followed = false
                        }else{
                            blog.followBlog(true,blogUrl)
                            page.followed = true
                        }
                    }
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
        id: blogListView
        model: ListModel{
            id: viewModel
        }
        spacing: Theme.paddingMedium
        anchors.fill: parent
        header:PageHeader{
            width: parent.width
            height: childrenRect.height
            onChildrenRectChanged: blogListView.scrollToTop()
            Column{
                width: parent.width
                spacing: Theme.paddingLarge
                Label{
                    text: blog.title
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: Theme.fontSizeHuge
                    width: parent.width - Theme.paddingSmall
                    color: Theme.highlightColor
                }
                Image {
                    height: 128
                    id: blogAvatar
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: blog.avatar
                    sourceSize.width: parent.width / 2
                }

                Label{
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingMedium
                    text: blog.description
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    onLinkActivated: Qt.openUrlExternally(url)
                    linkColor: Theme.secondaryHighlightColor
                    textFormat: Text.RichText
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width - Theme.paddingSmall
                    color: Theme.secondaryColor
                }
            }
        }


        delegate: PostDelegate{}
        VerticalScrollDecorator {}
        BusyIndicator{
            running: page.busy
            anchors.centerIn: parent
        }
    }
    Tumblr{
        id: blog
        property string title
        property string name
        property string url
        property string description
        property string avatar
        property bool ask

        onGotBlogPosts: {
            append(blog)
            page.busy = false
        }
        onGotBlogInfo:{
            title = info.title
            name = info.name
            url = info.url
            description = info.description
            ask = info.ask
        }
        onGotBlogAvatar: {
            avatar = avatarUrl
        }
        onRemovedPost: {
            blog.getBlogPosts(20, index,blogUrl , [], 0, true, true)
            viewModel.clear()
            page.busy = true
        }
    }
    function append(element){
        blogListView.model.append(element)
    }
    onBlogUrlChanged: {
        blog.getBlog(20, index,blogUrl , [], 0, true, true)
        page.busy = true
    }
}

