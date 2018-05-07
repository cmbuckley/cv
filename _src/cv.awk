BEGIN {
    FS="[{}]"

    print "---"
    print "layout: page"
    print "title: Curriculum Vitae"
    print "description: Chris Buckley's CV"
    print "og_type: webste"
    print "---"
}

{
    gsub(/\\&/, "\\&")
    gsub(/~/, "\\&nbsp;")
    gsub(/``|''/, "\"")
}

/begin.document/ {
    print "### Alternative Formats"
    print ""
    print "* [PDF](/cv/cv.pdf)"
}

/\\name/ {
    print "### " $2
    print ""
}

/\\address/ {
    print $2
    print ""
}

/\\section/ {
    print ""
    print "### " $2
}

/begin.experience/ {
    print ""

    if ($4) {
        print "#### " $4 ": " $6
        print ""
    }

    if ($8) {
        if ($10) {
            print "##### " $8 ", " $10
        } else {
            print "##### " $8
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
