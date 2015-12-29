#!/bin/bash
set -o errexit
set -o nounset

printerName="$1"
pdfFile="$2"
bookletSheets="$3"
bookletStart="$4"

function interactOdds() {
    booklet="$1"
    pageStart=$(( 2*bookletSheets*(booklet-1) + 1 ))
    pageEnd=$(( 2*bookletSheets*booklet ))

    lpr "$pdfFile" -P"$printerName" \
        -o page-ranges="$pageStart-$pageEnd" \
        -o page-set=odd \
        -o media=a4     \
        -o landscape    \


    echo -n "Printed: booklet $booklet odd pages  ($pageStart-$pageEnd). What to do next? [ro, q] "
    read userAnswer

    case "$userAnswer" in
         "") interactEvens $booklet ;;
       "ro") interactEvens $booklet ;;
        "q") exit ;;
          *) print "Bullshit entered. Quitting." && exit ;;
    esac
}

function interactEvens() {
    booklet="$1"
    pageStart=$(( 2*bookletSheets*(booklet-1) + 1 ))
    pageEnd=$(( 2*bookletSheets*booklet ))

    lpr "$pdfFile" -P"$printerName" \
        -o page-ranges="$pageStart-$pageEnd" \
        -o page-set=even       \
        -o outputorder=reverse \
        -o media=a4            \
        -o landscape           \

    echo -n "Printed: booklet $booklet even pages ($pageStart-$pageEnd). What to do next? [ro, re, q] "
    read userAnswer

    case "$userAnswer" in
         "") interactOdds $((booklet+1)) ;;
       "ro") interactOdds $booklet   ;;
       "re") interactEvens $booklet  ;;
        "q") exit ;;
          *) print "Bullshit entered. Quitting." && exit ;;
    esac
}

interactOdds "$bookletStart"

