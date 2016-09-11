/*****************************************************************************
 * tumblrauth.cpp
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


#include "tumblrauth.h"
#include <QDebug>

TumblrAuth::TumblrAuth(QObject *parent) :
    QObject(parent)
{
    apiBase = new QString("http://api.tumblr.com/v2/");
    consumerKey = new QString(cKey);
    consumerSecret = new QString(cSecret);
    settings = new QSettings(this);
    oauthRequest = new KQOAuthRequest;
    oauthManager = new KQOAuthManager(this);

    if(settings->value("account/accessToken").toString().count() == 0)
    {
        getAccess();
    }else{
        oauthToken = new QString(settings->value("account/accessToken").toString());
        oauthTokenSecret = new QString(settings->value("account/accessTokenSecret").toString());
        setAuthenticated(true);
    }
}

bool TumblrAuth::authenticated() const
{
    return isAuthenticated;
}

void TumblrAuth::setAuthenticated(bool val)
{
    isAuthenticated = val;
    emit onAuthenticatedChanged();
}

void TumblrAuth::onTemporaryTokenReceived(QString token, QString tokenSecret)
{
    //qDebug() << "Temporary token received: " << token << tokenSecret;

    QUrl userAuthURL("http://www.tumblr.com/oauth/authorize");

    if( oauthManager->lastError() == KQOAuthManager::NoError) {
        //Debug() << "Asking for user's permission to access protected resources. Opening URL: " << userAuthURL;
        oauthManager->getUserAuthorization(userAuthURL);
    }

}

void TumblrAuth::onAuthorizationReceived(QString token, QString verifier) {
    //qDebug() << "User authorization received: " << token << verifier;

    oauthManager->getUserAccessTokens(QUrl("http://www.tumblr.com/oauth/access_token"));
    if( oauthManager->lastError() != KQOAuthManager::NoError) {
        qDebug()<<"Login not complete";
    }
}

void TumblrAuth::onAccessTokenReceived(QString token, QString tokenSecret) {
    //qDebug() << "Access token received: " << token << tokenSecret;

    disconnect(oauthManager, SIGNAL(accessTokenReceived(QString,QString)), this, SLOT(onAccessTokenReceived(QString,QString)));

    // Store the OAuth Tokens
    settings->setValue("account/accessToken", token);
    settings->setValue("account/accessTokenSecret", tokenSecret);
    oauthToken = new QString(settings->value("account/accessToken").toString());
    oauthTokenSecret = new QString(settings->value("account/accessTokenSecret").toString());

    // Check if something went wrong
    if(token == NULL) {
        emit loginComplete(false);
        return;
    }else{
        setAuthenticated(true);
        oauthManager->deleteLater();
        oauthRequest->deleteLater();
        //delete oauthManager;
        //delete oauthRequest;
        //qDebug() << "Access tokens now stored.";
        emit loginComplete(token.length() > 0);
    }
}

void TumblrAuth::onAuthorizedRequestDone() {
    //qDebug() << "Request sent to Tumblr!";
}

void TumblrAuth::onRequestReady(QByteArray response) {
    //qDebug() << "Response from the service: " << response;
    disconnect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onRequestReady(QByteArray)));
}
void TumblrAuth::onAuthorizationPageRequested(QUrl dest)
{
    // Request the User to open the Browser
    emit openBrowser(dest.toString());
}


void TumblrAuth::getAccess()
{
    // Connect all signals from KQOAuthManager
    connect(oauthManager, SIGNAL(temporaryTokenReceived(QString,QString)), this, SLOT(onTemporaryTokenReceived(QString, QString)));
    connect(oauthManager, SIGNAL(authorizationReceived(QString,QString)), this, SLOT( onAuthorizationReceived(QString, QString)));
    connect(oauthManager, SIGNAL(accessTokenReceived(QString,QString)), this, SLOT(onAccessTokenReceived(QString,QString)));
    connect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onRequestReady(QByteArray)));
    connect(oauthManager, SIGNAL(authorizationPageRequested(QUrl)), this, SLOT(onAuthorizationPageRequested(QUrl)));

    // Set all the stuff
    oauthRequest->initRequest(KQOAuthRequest::TemporaryCredentials, QUrl("http://www.tumblr.com/oauth/request_token"));
    oauthRequest->setConsumerKey(*consumerKey);
    oauthRequest->setConsumerSecretKey(*consumerSecret);
    oauthManager->setHandleUserAuthorization(true);
    oauthRequest->setCallbackUrl(QUrl("127.0.0.1:8888"));
    oauthManager->setHandleAuthorizationPageOpening(false);
    oauthManager->executeRequest(oauthRequest);

}

void TumblrAuth::logout()
{
    // Remove all local data
    settings->setValue("account/accessToken", "");
    settings->setValue("account/accessTokenSecret", "");
    setAuthenticated(false);
}



