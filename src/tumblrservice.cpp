/*****************************************************************************
 * tumblrservice.cpp
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

#include "tumblrservice.h"

TumblrService::TumblrService(QObject *parent) :
    QObject(parent)
{
    // Set Credentials
    apiBase = new QString("http://api.tumblr.com/v2/");
    consumerKey = new QString(cKey);
    consumerSecret = new QString(cSecret);
    settings = new QSettings(this);
    oauthRequest = new KQOAuthRequest;

    manager = new QNetworkAccessManager(this);

    oauthManager = new KQOAuthManager(this);
    connect(oauthManager, SIGNAL(authorizedRequestDone()),this, SLOT(onAuthorizedRequestDone()));

    // Get the tokens
    oauthToken = new QString(settings->value("account/accessToken").toString());
    oauthTokenSecret = new QString(settings->value("account/accessTokenSecret").toString());

}
void TumblrService::addAuth(KQOAuthRequest* req) {
    // Add the tokens to the request
    req->setConsumerKey(*consumerKey);
    req->setConsumerSecretKey(*consumerSecret);
    req->setToken(*oauthToken);
    req->setTokenSecret(*oauthTokenSecret);
}

bool TumblrService::checkMetaRes(QJsonObject obj)
{
    // Check the Response for a success
    if(obj["status"].toInt() == 200 && obj["msg"].toString() == "OK")
    {
        return true;
    }else{
        return false;
    }
}

void TumblrService::getDashboard(int limit, int offset, QString type, long sinceId, bool reblogInfo, bool notesInfo)
{
    // Build the Request
    oauthRequest = new KQOAuthRequest(this);
    oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "user/dashboard"));
    addAuth(oauthRequest);
    oauthRequest->setHttpMethod(KQOAuthRequest::GET);

    KQOAuthParameters params;
    params.insert("limit", QString::number(limit));
    params.insert("offset", QString::number(offset));

    if(type != NULL && type.length() > 0) {
        params.insert("type", type);
    }
    if(sinceId > 0) {
        params.insert("since_id", QString::number(sinceId));
    }

    oauthRequest->setAdditionalParameters(params);

    oauthManager->executeRequest(oauthRequest);
    connect(oauthManager, SIGNAL(requestReady(QByteArray)),this, SLOT(onDashboardRequestReady(QByteArray)));
    connect(oauthManager, SIGNAL(authorizedRequestDone()),this, SLOT(onAuthorizedRequestDone()));
}

void TumblrService::getBlog(int limit, int offset, QString blogUrl, QStringList type, long sinceId, bool reblogInfo, bool notesInfo)
{
    // Everything that belongs to a blog
    getBlogInfo(blogUrl);
    getBlogAvatar(blogUrl);
    getBlogPosts(limit, offset, blogUrl, type, sinceId, reblogInfo, notesInfo);
}

// Get the Info about a single Blog
void TumblrService::getBlogInfo(QString blog_url)
{
    b_manager = new QNetworkAccessManager(this);

    QNetworkRequest req;

    getBaseName(&blog_url);

    QUrl url = QUrl(*apiBase + "blog/" + blog_url + "/info" + "?api_key=" + *consumerKey);
    req.setUrl(url);

    connect(b_manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onGotBlogInfo(QNetworkReply*)));
    b_manager->get(req);
}

// Get the Avatar Image of a single Blog
void TumblrService::getBlogAvatar(QString blog_url)
{
    c_manager = new QNetworkAccessManager(this);

    QNetworkRequest req;

    getBaseName(&blog_url);

    // use 128x128 icons
    QUrl url = QUrl(*apiBase + "blog/" + blog_url + "/avatar" + "/128");

    emit gotBlogAvatar(url);
    //req.setUrl(url);

    //connect(c_manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onGotBlogAvatar(QNetworkReply*)));
    //c_manager->get(req);
}

// Follow a blog
void TumblrService::followBlog(bool d, QString url)
{
    getBaseName(&url);

    oauthRequest = new KQOAuthRequest(this);
    if(d == true){
        oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "user/follow"));
    }else{
        oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "user/unfollow"));
    }

    addAuth(oauthRequest);
    oauthRequest->setHttpMethod(KQOAuthRequest::POST);

    KQOAuthParameters params;
    params.insert("url", url);

    oauthRequest->setAdditionalParameters(params);

    oauthManager->executeRequest(oauthRequest);
    connect(oauthManager, SIGNAL(requestReady(QByteArray)),this, SLOT(onFollowedBlog(QByteArray)));
    connect(oauthManager, SIGNAL(authorizedRequestDone()),this, SLOT(onAuthorizedRequestDone()));

}

void TumblrService::getBlogPosts(int limit, int offset, QString blog_url, QStringList type, long sinceId, bool reblogInfo, bool notesInfo)
{
    a_manager = new QNetworkAccessManager(this);

    QNetworkRequest req;


    getBaseName(&blog_url);
    QUrl url = QUrl(*apiBase + "blog/" + blog_url + "/posts" + "?api_key=" + *consumerKey + "&offset=" + QString::number(offset));
    req.setUrl(url);

    connect(a_manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onGotBlogPosts(QNetworkReply*)));
    a_manager->get(req);
}

void TumblrService::reblogPost(QString id, QString key,QString blog, QString comment)
{
    QStringList pieces = blog.split( "/" );
    QString baseName = pieces.value( pieces.length() - 2);

    oauthRequest = new KQOAuthRequest(this);
    oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "blog/" + baseName+ "/post/reblog"));
    addAuth(oauthRequest);
    oauthRequest->setHttpMethod(KQOAuthRequest::POST);


    KQOAuthParameters params;
    params.insert("id", id);
    params.insert("reblog_key",key);
    if(comment.length()>0)
    {
        params.insert("comment", comment);
    }

    oauthRequest->setAdditionalParameters(params);

    oauthManager->executeRequest(oauthRequest);
    connect(oauthManager, SIGNAL(requestReady(QByteArray)),this, SLOT(onReblogged(QByteArray)));
    connect(oauthManager, SIGNAL(authorizedRequestDone()),this, SLOT(onAuthorizedRequestDone()));

}

void TumblrService::likePost(bool d,QString id, QString key, QString blog)
{
    oauthRequest = new KQOAuthRequest(this);
    if(d == true){
        oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "user/unlike"));
    }else{
        oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "user/like"));
    }
    addAuth(oauthRequest);
    oauthRequest->setHttpMethod(KQOAuthRequest::POST);


    KQOAuthParameters params;
    params.insert("id", id);
    params.insert("reblog_key",key);

    oauthRequest->setAdditionalParameters(params);

    oauthManager->executeRequest(oauthRequest);
    connect(oauthManager, SIGNAL(requestReady(QByteArray)),this, SLOT(onLiked(QByteArray)));
    connect(oauthManager, SIGNAL(authorizedRequestDone()),this, SLOT(onAuthorizedRequestDone()));
}

void TumblrService::getTokens()
{
    // Get the tokens
    oauthToken = new QString(settings->value("account/accessToken").toString());
    oauthTokenSecret = new QString(settings->value("account/accessTokenSecret").toString());
    qDebug()<<*oauthToken;
}

void TumblrService::getUserInfo()
{
    oauthRequest = new KQOAuthRequest(this);
    oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "user/info"));
    addAuth(oauthRequest);
    oauthRequest->setHttpMethod(KQOAuthRequest::GET);

    oauthManager->executeRequest(oauthRequest);
    connect(oauthManager, SIGNAL(requestReady(QByteArray)),this, SLOT(onUserInfo(QByteArray)));

}

void TumblrService::searchTag(QString tag)
{
    manager = new QNetworkAccessManager(this);

    QNetworkRequest req;

    QUrl url = QUrl(*apiBase + "tagged"+ "?api_key=" + *consumerKey + "&tag=" + tag);
    req.setUrl(url);

    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onSearchTagReceived(QNetworkReply*)));
    manager->get(req);
}

void TumblrService::removePost(QString url, QString id)
{
    QStringList pieces = url.split( "/" );
    QString baseName = pieces[2];

    oauthRequest->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(*apiBase + "blog/" + baseName + "/post/delete"));

    addAuth(oauthRequest);
    oauthRequest->setHttpMethod(KQOAuthRequest::POST);

    KQOAuthParameters params;
    params.insert("id", id);

    oauthRequest->setAdditionalParameters(params);

    oauthManager->executeRequest(oauthRequest);
    connect(oauthManager, SIGNAL(requestReady(QByteArray)),this, SLOT(onRemovedPost(QByteArray)));
    connect(oauthManager, SIGNAL(authorizedRequestDone()),this, SLOT(onAuthorizedRequestDone()));
}


void TumblrService::onDashboardRequestReady(QByteArray byteArray)
{
    disconnect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onDashboardRequestReady(QByteArray)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(byteArray, &err);

    // Check if response is valid
    if(doc.isObject())
    {
        QJsonObject rootObj = doc.object();
        QJsonObject metaObj = rootObj["meta"].toObject();
        if(checkMetaRes(metaObj))
        {
            QJsonObject resObj = rootObj["response"].toObject();
            QJsonArray postsArr = resObj["posts"].toArray();

            foreach (QJsonValue post, postsArr) {
               QVariantMap map = post.toObject().toVariantMap();
               emit gotDashboard(map);
            }

        }
    }
}

void TumblrService::onGotBlogPosts(QNetworkReply *reply)
{
    disconnect(a_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onGotBlogPosts(QNetworkReply*)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll(), &err);
    reply->deleteLater();
    if(doc.isObject())
    {
        QJsonObject rootObj = doc.object();
        QJsonObject metaObj = rootObj["meta"].toObject();
        if(checkMetaRes(metaObj))
        {
            QJsonObject resObj = rootObj["response"].toObject();
            QJsonArray postsArr = resObj["posts"].toArray();

            foreach (QJsonValue post, postsArr) {
               QVariantMap map = post.toObject().toVariantMap();
               emit gotBlogPosts(map);
            }

        }
    }
}

void TumblrService::onGotBlogInfo(QNetworkReply *reply)
{
    reply->deleteLater();
    disconnect(b_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onGotBlogInfo(QNetworkReply*)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll(), &err);
    if(doc.isObject())
    {
        QJsonObject rootObj = doc.object();
        QJsonObject metaObj = rootObj["meta"].toObject();
        if(checkMetaRes(metaObj))
        {
            QJsonObject resObj = rootObj["response"].toObject();
            QJsonObject userinf = resObj["blog"].toObject();
            QVariantMap map = userinf.toVariantMap();
            emit gotBlogInfo(map);
        }
    }
}

void TumblrService::onGotBlogAvatar(QNetworkReply *reply)
{
    qDebug()<<"Got Avatar";
    //reply->deleteLater();
    disconnect(c_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onGotBlogInfo(QNetworkReply*)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll(), &err);
    qDebug()<<reply->header(QNetworkRequest::ContentTypeHeader);
    emit gotBlogAvatar(reply->url());
    if(doc.isObject())
    {
        QJsonObject rootObj = doc.object();
        QJsonObject metaObj = rootObj["meta"].toObject();
        QJsonObject urlObj = rootObj["response"].toObject();
        QVariant url = urlObj["avatar_url"].toString();

        emit gotBlogAvatar(url);

    }
}

void TumblrService::onReblogged(QByteArray reply)
{
    Q_UNUSED(reply);
    disconnect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onReblogged(QByteArray)));
}

void TumblrService::onLiked(QByteArray reply)
{
    disconnect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onLiked(QByteArray)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(reply, &err);
    qDebug()<<doc;
}

void TumblrService::onUserInfo(QByteArray byteArray)
{
    disconnect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onUserInfo(QByteArray)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(byteArray, &err);

    if(doc.isObject())
    {
        QJsonObject rootObj = doc.object();
        QJsonObject metaObj = rootObj["meta"].toObject();
        if(checkMetaRes(metaObj))
        {
            QJsonObject resObj = rootObj["response"].toObject();
            QJsonObject userinf = resObj["user"].toObject();
            QVariantMap map = userinf.toVariantMap();
            emit gotUserInfo(map);
        }
    }
}

void TumblrService::onFollowedBlog(QByteArray reply)
{

}

void TumblrService::onSearchTagReceived(QNetworkReply *reply)
{
    disconnect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(onSearchTagReceived(QNetworkReply*)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll(), &err);

    if(doc.isObject())
    {
        QJsonObject rootObj = doc.object();
        QJsonObject metaObj = rootObj["meta"].toObject();
        if(checkMetaRes(metaObj))
        {
            QJsonArray resArr = rootObj["response"].toArray();

            foreach (QJsonValue post, resArr) {
               QVariantMap map = post.toObject().toVariantMap();
               emit gotSearch(map);
            }

        }
    }

}

void TumblrService::onRemovedPost(QByteArray reply)
{
    disconnect(oauthManager, SIGNAL(requestReady(QByteArray)), this, SLOT(onRemovedPost(QByteArray)));
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(reply, &err);


    emit removedPost();

}

void TumblrService::onAuthorizedRequestDone()
{

}

void TumblrService::getBaseName(QString *blog_url)
{
    QStringList pieces = blog_url->split( "/" );
    *blog_url = pieces[2];
}
