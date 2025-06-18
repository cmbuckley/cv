BEGIN {
    "date +%Y" | getline currentYear
    summary = ""
}

# from _config.yml
/experience_from/ {
    experienceFrom = $2
}

/\\ExperienceYears/ {
    gsub(/\\ExperienceYears\{\}/, currentYear - experienceFrom)
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
