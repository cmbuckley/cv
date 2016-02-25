BEGIN {
    FS="[{}]"

    print "---"
    print "layout: page"
    print "---"
}

{
    gsub(/\\&/, "\\&")
    gsub(/~/, " ")
    gsub(/``|''/, "\"")
}

/\\title/ {
    print "# " $2
    print ""
}

/\\name/ {
    print "## " $2
    print ""
}

/\\address/ {
    print $2
    print ""
}

/begin.rSection/ {
    print ""
    print "## " $4
}

/begin.rSubsection/ {
    print ""

    if ($4) {
        print "### " $4 ": " $6
        print ""
    }

    if ($8) {
        if ($10) {
            print "#### " $8 ", " $10
        } else {
            print "#### " $8
        }

        print ""
    }
}

/\\item/ {
    gsub(/\\item /, "")
    print "* " $1
}
