/*****************************************************************************
 * PostDelegate.qml
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

Component{
    Loader{
        height: childrenRect.height
        width: parent.width
        anchors.margins: Theme.paddingSmall
        sourceComponent: {
            switch(type){
            case "text": Qt.createComponent("TextDelegate.qml");break;
            case "answer": Qt.createComponent("AnswerDelegate.qml");break;
            case "quote": Qt.createComponent("QuoteDelegate.qml");break;
            case "photo": Qt.createComponent("PhotoDelegate.qml");break;
            case "link": Qt.createComponent("LinkDelegate.qml");break;
            }
        }
    }
}
