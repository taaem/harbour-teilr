TARGET = harbour-teilr

CONFIG += sailfishapp kqoauth

SOURCES += src/harbour-teilr.cpp \
    src/tumblrauth.cpp \
    src/tumblrservice.cpp \
    src/helper.cpp

OTHER_FILES += qml/harbour-teilr.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-teilr.spec \
    rpm/harbour-teilr.yaml \
    translations/*.ts \
    harbour-teilr.desktop \
    qml/pages/AuthPage.qml \
    qml/pages/DashboardPage.qml \
    qml/pages/StartupPage.qml \
    qml/delegates/PostDelegate.qml \
    qml/delegates/TextDelegate.qml \
    qml/delegates/AnswerDelegate.qml \
    qml/delegates/QuoteDelegate.qml \
    qml/delegates/LinkDelegate.qml \
    qml/delegates/PhotoDelegate.qml \
    qml/pages/ImagePage.qml \
    qml/delegates/PostHeader.qml \
    qml/delegates/PostPhoto.qml \
    qml/components/GifImage.qml \
    qml/components/Image.qml \
    qml/delegates/PostFooter.qml \
    qml/pages/BlogPage.qml \
    qml/pages/CommentPage.qml \
    qml/delegates/VideoDelegate.qml \
    qml/pages/SearchPage.qml \
    qml/pages/AboutPage.qml \
    harbour-teilr.png \
    qml/images/harbour-teilr.png \
    qml/pages/MyBlogPage.qml

CONFIG += sailfishapp_i18n
CONFIG += sailfishapp_i18n_idbased

TRANSLATIONS += translations/harbour-teilr-de.ts

HEADERS += \
    src/tumblrauth.h \
    src/tumblrservice.h \
    src/privatekeys.h \
    src/helper.h

DEPLOYMENT_PATH = /usr/share/$${TARGET}
lib.files += \
    /usr/lib/libkqoauth.so \
    /usr/lib/libkqoauth.so.0 \
    /usr/lib/libkqoauth.so.0.97 \
    /usr/lib/libkqoauth.so.0.97.0
lib.path = $$DEPLOYMENT_PATH/lib
INSTALLS += lib

DISTFILES += \
    rpm/harbour-teilr.changes
