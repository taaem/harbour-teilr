/*****************************************************************************
 * harbour-teilr.cpp
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


#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QScopedPointer>
#include <QtQml>
#include <QQuickView>
#include <QCoreApplication>
#include <QGuiApplication>

#include "tumblrauth.h"
#include "tumblrservice.h"
#include "helper.h"


int main(int argc, char *argv[])
{
    Helper helper;
    qmlRegisterType<TumblrAuth>("harbour.teilr.Service", 1, 0, "Authentication");
    qmlRegisterType<TumblrService>("harbour.teilr.Service", 1, 0, "Tumblr");
    QCoreApplication::setOrganizationName("taaem");
    QCoreApplication::setOrganizationDomain("taaem.github.io");
    QCoreApplication::setApplicationName("Teilr");
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->rootContext()->setContextProperty("helper", &helper);
    view->setSource(SailfishApp::pathTo("qml/harbour-teilr.qml"));
    view->show();


    return app->exec();
}

