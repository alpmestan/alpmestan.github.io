#!/usr/bin/env bash

# set -euo pipefail

usage() {
  echo "usage: $0 <pages directory> <dest.md>"
}

dir="${1:-}"
dest="${2:-}"
if [ "$dir" = "" ] || [ "$dest" = "" ]; then
  2>&1 usage
  exit 1
fi

rm -f $dest
touch $dest

echo "---" >> $dest
echo "title: Posts" >> $dest
echo "---" >> $dest

for f in $(find $dir -name '*.md'); do
    draft=$(grep "draft: true" $f | sed 's/draft: //g');
    if [ "$draft" != "true" ]; then
        t=$(grep title $f | sed 's/title: //g');
        rf=$(echo $f | sed s/src// | sed s/md/html/);
        d=$(grep date $f | sed 's/date: //g');
        echo "- [$t]($rf) - $d" >> $dest ;
    fi
done
