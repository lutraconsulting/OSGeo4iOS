OSGeo4iOS
=========

<b> Quick and dirty solution to build iOS binaries for OSGeo tools </b>

This provides a set of scripts to build opensource geo tools for iOS (iPhone and iPad) and it is highly *Experimental*
Only works on MacOS systems, since you need XCode to compile binaries for iOS. The build system is maintained for QGIS 3.x 
releases.

Tested with iPhoneOS12.0.sdk, Qt 5.11.2 and arm64, min SDK 12.0 on iPad running iOS 12.x

Known bugs
----------

check issue tracker. So far only working with memory data provider in qgis.

Dependencies instructions
-------------------------
- [Qt5 5.11.2] Install iOS arch support (if you want SDK 10.0 + and arm64 only)
- Install XCode and accept ToC

If you want armv7 and different SDK, you may try to build QT yourself (not tested)

To build QGIS, you need relatively new version of bison (3.x). MacOS ships with bison 2.x
so it is required to install one newer and add to PATH
- `brew install bison`

detto for flex. You may need to add them to PATH so cmake can pick them

Build instructions
-----------
Create a file config.conf in the root folder by copying the config.conf.default
file and edit it accordingly to your needs.

You may want to clone qgis/QGIS locally and point the config.conf file to your local 
repository, if you are working on qgis/QGIS development. 

```sh
cd iOSGeo 
cp config.conf.default config.conf
# nano config.conf
./distribute.sh -dqgis
```

Now all libraries should be in stage/<architecture> folder for linking.

If you work with your local QGIS repository, you need to apply c++11 patch manually,
but do not push that upstream!


Application distribution instructions
-------------------------------------

You need to package the stage libraries to the device and modify rpath to point 
to the base

MUST READ: http://doc.qt.io/qt-5/platform-notes-ios.html

all libraries are STATIC, due to some limitation for iOS platform (distribution on AppStore, Qt
distribution for iOS, etc.)

Debugging
---------

debugging from XCode, since from QtCreator now working
https://bugreports.qt.io/browse/QTCREATORBUG-15812

Interesting reading
-------------------

https://forum.qt.io/topic/75452/problem-with-custom-plugin-for-qtquick-on-ios

https://github.com/benlau/quickios

acknowledgements
----------------

iOS toolchain
https://github.com/cristeab/ios-cmake.git

framework from 
https://github.com/opengisch/OSGeo4A

distribute.sh 
see LICENSE-for-distribute-sh
