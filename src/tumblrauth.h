/*****************************************************************************
 * tumblrauth.h
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

#ifndef TUMBLRAUTH_H
#define TUMBLRAUTH_H

#include <QObject>
#include "privatekeys.h"
#include "oauth/kqoauthmanager.h"
#include "oauth/kqoauthrequest.h"
#include <QSettings>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

class TumblrAuth : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool authenticated READ authenticated WRITE setAuthenticated NOTIFY onAuthenticatedChanged)

public:
    explicit TumblrAuth(QObject *parent = 0);
    bool authenticated() const;
    void setAuthenticated(bool);
    void getAccess();
    Q_INVOKABLE void logout();

signals:
    void openBrowser(QString dest);
    void loginComplete(bool);
    void onAuthenticatedChanged();

public slots:
    void onTemporaryTokenReceived(QString temporaryToken, QString temporaryTokenSecret);
    void onAuthorizationReceived(QString token, QString verifier);
    void onAccessTokenReceived(QString token, QString tokenSecret);
    void onAuthorizedRequestDone();
    void onRequestReady(QByteArray);
    void onAuthorizationPageRequested(QUrl);

private:
    KQOAuthManager *oauthManager;
    KQOAuthRequest *oauthRequest;
    QSettings *settings;
    QString *consumerKey;
    QString *consumerSecret;
    QString *oauthToken;
    QString *oauthTokenSecret;
    QString *apiBase;
    bool isAuthenticated;

};

#endif // TUMBLRAUTH_H
