BEGIN {
    FS="[{}]"
    org="Company"
}

{
    gsub(/\\&/, "\\&")
    gsub(/~/, "\\&nbsp;")
    gsub(/``|''/, "\"")
}

/begin.document/ {
    print ""
    print "[Download as PDF](/cv/cv.pdf){:rel=\"alternate\" type=\"text/pdf\"}"
    print "{:.download}"
}

/\\name/ {
    print "Name:"
    print ":  " $2
}

/\\address/ {
    print ""
    gsub(/: /, ":\n:  ", $2)
    print $2
    print "{:.personal}"
}

/\\section/ {
    print ""
    print "## " $2
}

/section.Qualifications/ {
    org="Institution"
}

/begin.experience/ {
    print ""

    if ($4) {
        print "### " $4

        print org
        print ":  " $8 ($10 && org == "Institution" ? ", " $10 : "")

        if ($10 && org == "Company") {
            print ""
            print "Location"
            print ":  " $10
        }

        print ""
        print "Dates"
        print ":  " $6

        print "{:.meta}"
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
