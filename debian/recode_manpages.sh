#!/bin/sh

set -e

PACKAGE=$1
[ -z "$PACKAGE" ] && {
    echo "Usage: $0 <package>"
    exit 1
}

# Upstream man pages are UTF-8encoded.
# The man pages need to be recoded according to the encodings used in Debian.
# (defined in src/encodings.c in man-db)

# I've not found the encoding for zh_CN and zh_TW.
# It should be the default falback ISO-8859-1.
# However, the encoding of these pages seems wrong.

echo "/     ISO-8859-1
      cs    ISO-8859-2
      de    ISO-8859-1
      es    ISO-8859-1
      fi    ISO-8859-1
      fr    ISO-8859-1
      hu    ISO-8859-2
      id    ISO-8859-1
      it    ISO-8859-1
      ja    EUC-JP
      ko    EUC-KR
      pl    ISO-8859-2
      pt_BR ISO-8859-1
      ru    KOI8-R
      sv    ISO-8859-1
      tr    ISO-8859-9
      zh_CN GB18030
      zh_TW BIG5" |
while read lang encoding
do
    echo "recoding lang: $lang to $encoding"
    for page in debian/$PACKAGE/usr/share/man/$lang/man[1-8]/*
    do
        if [ -f $page ]
        then
            echo "recoding $page"
            iconv -t $encoding -f UTF8 < $page > $page.recoded
            mv $page.recoded $page
        fi
    done
done

