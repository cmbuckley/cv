BEGIN {
    summary = ""
}

/section.Summary/ {
    capture = 1
    next
}

/section/ {
    capture = 0
}

# concatenate summary text
capture {
    if ($0 !~ "^%") {
        summary = summary $0 " "
    }
}

END {
    gsub(/\..*$/, ".", summary) # first sentence only
    print summary
}
