BEGIN {
    FS="[{}]"
}

{
    gsub(/\\&/, "\\&")
    gsub(/~/, "\\&nbsp;")
    gsub(/``|''/, "\"")
}

/begin.document/ {
    print ""
    print "## Alternative Formats"
    print ""
    print "* [PDF](/cv/cv.pdf){:rel=\"alternate\" type=\"text/pdf\"}"
}

/\\name/ {
    print "Name:"
    print ":  " $2
}

/\\address/ {
    print ""
    gsub(/: /, ":\n:  ", $2)
    print $2
}

/\\section/ {
    print ""
    print "## " $2
}

/begin.experience/ {
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

/Summary/ {
    summary = 1
    next
}

/^%/ {
    summary = 0
}

summary # print summary if we're in that section
