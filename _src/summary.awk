BEGIN {
    "date +%Y" | getline currentYear
    summary = ""
}

# replace dynamic year with static number
match($0, /\\ExperienceYears\{[0-9]+\}/) {
    experienceFrom = substr($0, RSTART + 17, RLENGTH - 18)
    gsub(/\\ExperienceYears\{[0-9]+\}/, currentYear - experienceFrom)
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
