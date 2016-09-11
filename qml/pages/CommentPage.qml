/*****************************************************************************
 * CommentPage.qml
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

Dialog {
    id: commentPage
    property string key
    property string title : "Add Comment"
    property string id
    property alias comment: nameField.text

    SilicaFlickable{
        anchors.fill: parent
        Column{
            anchors.fill: parent
            DialogHeader{}
            Label{
                id: titleItem
                text: commentPage.title
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeLarge
                width: parent.width - Theme.paddingSmall
                color: Theme.primaryColor
            }
            ComboBox {
                id: blogBox
                width: parent.width
                label: "Blog to Post on"
                menu: ContextMenu {
                    Repeater{
                        model: app.allBlogs
                        MenuItem{
                            text: name
                        }
                    }
                }
            }
            TextField{
                id: nameField
                width: parent.width
                placeholderText: "Add your Comment!"

            }


        }
    }
    onDone: {
        var url = app.allBlogs.get(blogBox.currentIndex).url
        metaTumblr.reblogPost(id, key,url,comment)

        console.log(key + " " + id + " " + url + " " + comment)
    }
}


