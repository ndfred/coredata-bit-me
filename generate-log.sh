#!/bin/sh -ex

cd `dirname $0`
xcodebuild -target CoreData-Mac SYMROOT=build
./build/Release/CoreData-Mac -com.apple.CoreData.SQLDebug 1 &> CoreData-Mac.log
