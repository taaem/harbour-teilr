/*****************************************************************************
 * tumblrservice.h
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

#ifndef TUMBLRSERVICE_H
#define TUMBLRSERVICE_H

#include <QObject>
#include "oauth/kqoauthmanager.h"
#include "oauth/kqoauthrequest.h"
#include "privatekeys.h"
#include <QSettings>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>


class TumblrService : public QObject
{
    Q_OBJECT
public:
    explicit TumblrService(QObject *parent = 0);
    void addAuth(KQOAuthRequest*);
    bool checkMetaRes(QJsonObject);
    Q_INVOKABLE void getDashboard(int limit,int offset, QString type,long sinceId,bool reblogInfo, bool notesInfo);
    Q_INVOKABLE void getBlog(int limit,int offset, QString blogUrl, QStringList type,long sinceId,bool reblogInfo, bool notesInfo);
    void getBlogInfo(QString url);
    void getBlogAvatar(QString url);
    Q_INVOKABLE void followBlog(bool d,QString url);
    Q_INVOKABLE void getBlogPosts(int limit,int offset, QString blogUrl, QStringList type,long sinceId,bool reblogInfo, bool notesInfo);
    Q_INVOKABLE void reblogPost(QString id, QString key,QString blog, QString comment = "");
    Q_INVOKABLE void likePost(bool, QString id, QString key,QString blog);
    Q_INVOKABLE void getTokens();
    Q_INVOKABLE void getUserInfo();
    Q_INVOKABLE void searchTag(QString tag);
    Q_INVOKABLE void removePost(QString url, QString id);

signals:
    void gotDashboard(QVariantMap element);
    void gotUserInfo(QVariantMap info);
    void gotBlogPosts(QVariantMap blog);
    void gotBlogInfo(QVariantMap info);
    void gotBlogAvatar(QVariant avatarUrl);
    void gotSearch(QVariantMap post);
    void removedPost();

public slots:
    void onDashboardRequestReady(QByteArray);
    void onGotBlogPosts(QNetworkReply*);
    void onGotBlogInfo(QNetworkReply*);
    void onGotBlogAvatar(QNetworkReply*);
    void onReblogged(QByteArray);
    void onLiked(QByteArray);
    void onUserInfo(QByteArray);
    void onFollowedBlog(QByteArray);
    void onSearchTagReceived(QNetworkReply*);
    void onRemovedPost(QByteArray);
    void onAuthorizedRequestDone();

private:
    void getBaseName(QString*);
    QNetworkAccessManager *a_manager;
    QNetworkAccessManager *b_manager;
    QNetworkAccessManager *c_manager;
    QNetworkAccessManager *manager;
    KQOAuthManager *oauthManager;
    KQOAuthRequest *oauthRequest;
    QSettings *settings;
    QString *consumerKey;
    QString *consumerSecret;
    QString *oauthToken;
    QString *oauthTokenSecret;
    QString *apiBase;

};

#endif // TUMBLRSERVICE_H
