/*****************************************************************************
 * LinkDelegate.qml
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

ListItem {
        id: listItem
        menu: if(page.own){contextMenu}
        //menu: contextMenu
        contentHeight: main.height + Theme.paddingMedium
        ListView.onRemove: animateRemoval(listItem)

        function remove() {
            remorseAction("Deleting", function() { view.model.remove(index) })
        }

        Column{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium
            id: main
            width: parent.width
            spacing: Theme.paddingMedium
            PostHeader{}


            PostPhoto{}
            Label {
                width: parent.width
                id: urlItem
                text: publisher
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                font.pixelSize: Theme.fontSizeSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                MouseArea{
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(url)
                }
            }
            Label {
                width: parent.width
                id: excerptItem
                text: if(model.excerpt != undefined){app.secLinkStyle + model.excerpt}
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(url)
                font.pixelSize: Theme.fontSizeSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
            }
            Component{
                id: authorComponent
                Label {
                    anchors.right: parent.right
                    width: parent.width
                    id: authorItem
                    text: if(link_author){app.secLinkStyle + link_author}else{ "" }
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText
                    font.pixelSize: Theme.fontSizeSmall
                    color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                }
            }
            Loader{
                source: if(model.link_author != undefined){authorComponent}
            }
            Label {
                anchors.right: parent.right
                width: parent.width
                id: bodyItem
                text: app.secLinkStyle + viewModel.get(index).description
                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(url)
                textFormat: Text.RichText
                font.pixelSize: Theme.fontSizeSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
            }
            /*
            Row{
                spacing: Theme.paddingSmall
                Repeater{
                    id: tagRepeater
                    model: tags
                    Label{
                        text: tagRepeater.model.get(index)
                        color: Theme.secondaryColor
                    }
                }
            }
            */
            PostFooter{}

            Separator{
                height: Theme.paddingSmall
                color: Theme.highlightColor
            }
        }


        Component {
            id: contextMenu
            ContextMenu {
                MenuItem {
                    text: "Remove"
                }
                onClicked:{
                    blog.removePost(model.post_url, model.id)
                }
            }
        }
        onClicked:{
            pageStack.push(Qt.resolvedUrl("../pages/BlogPage.qml"),{blogUrl: model.post_url, followed: model.followed})
        }
}
