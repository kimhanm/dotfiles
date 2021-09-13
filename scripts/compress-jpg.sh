#!/usr/bin/bash

[ -f ./files.txt ] && echo -n "files.txt is already present. Overwrite? [y/n]: "

read yesno
if [ $yesno == y ]; then
  ls -1 | sed -n 's/\.jpeg$//p' > files.txt

  for file in $(cat files.txt); do
    convert -strep -interlace Plane -gaussian-blur 0.5 -quality 70% $file.jpeg $file.jpg;
  done
fi






