#!/bin/sh -ex

cd `dirname $0`

if [ ! -d SQLite ]
then
  rm -rf sqlite-amalgamation-3071000.zip sqlite-amalgamation-3071000
  curl -O http://sqlite.org/sqlite-amalgamation-3071000.zip
  unzip sqlite-amalgamation-3071000.zip
  mv sqlite-amalgamation-3071000 SQLite
  rm sqlite-amalgamation-3071000.zip
fi

if [ ! -d LevelDB ]
then
  rm -rf LevelDB-tmp
  git clone https://code.google.com/p/leveldb LevelDB-tmp
  cd LevelDB-tmp
  git checkout 9013f13b1512f6ab8c04518e8f036e58be271eba
  cd ..
  mv LevelDB-tmp LevelDB
fi

if [ ! -d TokyoCabinet ]
then
  rm -rf tokyocabinet-1.4.47.tar.gz tokyocabinet-1.4.47
  curl -O http://fallabs.com/tokyocabinet/tokyocabinet-1.4.47.tar.gz
  tar xzf tokyocabinet-1.4.47.tar.gz
  mv tokyocabinet-1.4.47 TokyoCabinet
  rm tokyocabinet-1.4.47.tar.gz
fi
