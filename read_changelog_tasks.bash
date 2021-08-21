#!/bin/bash

# Input reading

while [ $# -gt 0 ]; do

    [ "$1" == '--tag' ]  && tag="$2"
    [ "$1" == '--path' ] && path="$2"
    
    shift

done

# Input validations

bad_usage=false

if [ -z "$tag" ] 
then
    echo "--tag param is required"
    bad_usage=true
elif ! [[ "$tag" =~ ^[0-9\.]+$ ]]
then
    echo "--tag must be a number"
    bad_usage=true
fi

if [ -z "$path" ]
then
    echo "--path param is required" 
    bad_usage=true 
fi

[ $bad_usage = true ]  && echo "usage: read_changelog_tasks --path __ --tag __" && exit 1

[ ! -f "$path" ]       && echo "The file $path was not found"                   && exit 1


# Input parsing

read_tasks () {

    TAG_START_PATTERN="^#{2}" # example (line 2):                ## 1.0

    while read -r line; do
        if [ "$is_tag_section" ]
        then
            started_another_tag=$(echo "$line" | grep -E "$TAG_START_PATTERN [0-9]*")
            [ "$started_another_tag" ] && break;

            echo "$line" | grep -Eoi "#[A-Za-z]+\-[0-9]*"
        fi


        if [ ! "$is_tag_section" ]
        then
            is_tag_section=$(echo "$line" | grep -E "$TAG_START_PATTERN $tag")
        fi
    done < "$path"  | uniq 

}

output=$( read_tasks )

echo "$output"

[ -z "$output" ] && echo "The tag $tag was not found" && exit 1

exit 0