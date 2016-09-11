/*****************************************************************************
 * helper.cpp
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

#include "helper.h"
#include "QDebug"

Helper::Helper(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager();
}

void Helper::saveImage(QString url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onDownloadFinished(QNetworkReply*)));

    manager->get(request);
}

void Helper::onDownloadFinished(QNetworkReply *reply)
{
    disconnect(manager, SIGNAL(finished(QNetworkReply*)),this,SLOT(onDownloadFinished(QNetworkReply*)));

    QStringList pieces = reply->url().toString().split( "/" );
    QString imageName = pieces[4];

    QDir dir(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation) + "/Teilr");
    if(!dir.exists()) {
        dir.mkpath(".");
    }

    QFile file;
    file.setFileName(dir.absolutePath() + "/" + imageName);
    file.open(QIODevice::WriteOnly);
    if (file.isOpen()) {
        file.write(reply->readAll());
    }
    file.close();
}

