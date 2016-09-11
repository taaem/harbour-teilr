/*****************************************************************************
 * VideoDelegate.qml
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
// TODO: Fix this
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

ListItem {
        id: listItem
        contentHeight: main.height + Theme.paddingMedium
        ListView.onRemove: animateRemoval(listItem)

        function remove() {
            remorseAction("Deleting", function() { view.model.remove(index) })
        }

        Column{
            id: main
            width: parent.width
            PostHeader{}
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

            Separator{
                height: Theme.paddingSmall
                color: Theme.highlightColor
            }
        }



        onClicked:{
            pageStack.push(Qt.resolvedUrl("../pages/BlogPage.qml"),{blogUrl: model.post_url, followed: model.followed})
        }
}
