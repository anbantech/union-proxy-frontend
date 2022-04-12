#!/bin/bash

GetKey() {
    section=$(echo $2 | cut -d '.' -f 1)
    key=$(echo $2 | cut -d '.' -f 2)
    sed -n "/\[$section\]/,/\[.*\]/{
     /^\[.*\]/d
     /^[ \t]*$/d
     /^$/d
     /^#.*$/d
     s/^[ \t]*$key[ \t]*=[ \t]*\(.*\)[ \t]*/\1/p
    }" $1
}

# global
fe_image=$(GetKey "build_scripts/data.ini" "global.fe_image")
fe_tag=$(GetKey "build_scripts/data.ini" "global.fe_tag")

npm install

npm run build

docker build -t $fe_image:$fe_tag .

docker save -o $fe_image-$fe_tag.tar $fe_image:$fe_tag

mv $fe_image-$fe_tag.tar build_scripts/
