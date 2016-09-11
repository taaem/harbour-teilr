/*****************************************************************************
 * TextDelegate.qml
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
            PostHeader{}
            Label {
                width: parent.width
                id: bodyItem
                text: viewModel.get(index).body
                wrapMode: Text.Wrap
                textFormat: Text.StyledText
                onLinkActivated: Qt.openUrlExternally(url)
                linkColor: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
            }


            PostFooter{}

            Separator{
                width: parent.width
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
