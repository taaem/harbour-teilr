/*****************************************************************************
 * PostFooter.qml
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

Item{
    width: parent.width
    height: childrenRect.height
    Column{
        width: parent.width
        Row{
            id: row
            spacing: Theme.paddingMedium
            height: Theme.itemSizeLarge
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            Rectangle{
                height: parent.height
                width: height
                color:"transparent"
                Image {
                    anchors.centerIn: parent
                    id: commentIcon
                    anchors.verticalCenter: parent.verticalCenter
                    height: Theme.iconSizeSmall
                    width: height
                    source: "image://theme/icon-s-retweet"

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/CommentPage.qml"), {
                                           key: reblog_key,
                                           id: id
                                       })
                    }
                }
            }
            Rectangle{
                id: rectLike
                height: parent.height
                width: height
                color:(model.liked)? Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity) : "transparent"
                Image {
                    anchors.centerIn: parent
                    id: likeIcon
                    anchors.verticalCenter: parent.verticalCenter
                    height: Theme.iconSizeSmall
                    width: height
                    source: "image://theme/icon-s-like"

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(model.liked){
                            metaTumblr.likePost(true, model.id, model.reblog_key, model.post_url)
                            rectLike.color = "transparent"
                        }else{
                            metaTumblr.likePost(false, model.id, model.reblog_key, model.post_url)
                            rectLike.color = Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                        }
                    }
                }
            }

            Loader{
                sourceComponent: if(model.source_title != undefined){ sourceTitle }

            }
            Component{
                id: sourceTitle
                Label{
                    id: source
                    font.italic: true
                    font.pixelSize: Theme.fontSizeSmall
                    text: source_title
                    //Component.onCompleted: source.anchors.verticalCenter = row.verticalCenter
                    //anchors.verticalCenter: row.verticalCenter

                    color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryHighlightColor

                    MouseArea{
                        anchors.fill: parent
                        onClicked: pageStack.push(Qt.resolvedUrl("../pages/BlogPage.qml"), {blogUrl: source_url})
                    }
                }
            }
        }
        Separator{
            width: parent.width
            color: Theme.highlightColor
        }

    }
        /* TODO
        Row{
            spacing: Theme.paddingSmall
            Repeater{
                id: tagRepeater
                model: tags
                Label{
                    text: model
                    color: Theme.secondaryColor
                }
            }
        }

        Reader{
            id: reader
        }

        Component.onCompleted: {
            for(var i = 0; i < tags.count; i++){
                //console.log("Tag: " + reader.properties(tagRepeater.model.get(0), false))
            }
        }
        */
}
