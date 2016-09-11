/*****************************************************************************
 * SearchPage.qml
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
    property int index: 0

    property string tag

    SilicaListView{
        width: parent.width
        id: result
        anchors.fill: parent

        header: PageHeader{
            width: parent.width
            height: childrenRect.height
            Column{
                width: parent.width
                Label{
                    text: qsTr("Search")
                    horizontalAlignment: Text.AlignRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: Theme.fontSizeHuge
                    width: parent.width - Theme.paddingSmall
                    color: Theme.highlightColor
                }

                TextField{
                    id: searchField
                    placeholderText: qsTr("Tag")
                    width: parent.width
                    EnterKey.enabled: text.length > 0
                    EnterKey.onClicked: {
                        viewModel.clear()
                        searcher.searchTag(text)
                        page.tag = text
                    }

                    Component.onCompleted: searchField.forceActiveFocus()
                }
            }
        }

        model: ListModel{
            id: viewModel
        }
        delegate: PostDelegate{}
    }


    Tumblr{
        id: searcher

        onGotSearch: {
            append(post)
        }
    }
    function append(element){
        viewModel.append(element)
    }
}

