{
    gsub(/\\&/, "\\&")
    gsub(/~/, " ")
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
}

/begin.rSection/ {
    print ""
    print "## " $4
}

/begin.rSubsection/ {
    if ($4) print "### " $4 ": " $6
    if ($8) {
        if ($10) {
            print "#### " $8 ", " $10
        } else {
            print "#### " $8
        }
    }
}

/\\item/ {
    gsub(/\\item /, "")
    print "* " $1
}
