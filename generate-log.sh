#!/bin/sh -ex

cd `dirname $0`
xcodebuild -target CoreData-Mac -configuration Debug SYMROOT=build
./build/Debug/CoreData-Mac -com.apple.CoreData.SQLDebug 1 &> CoreData-Mac.log
