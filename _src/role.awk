BEGIN {
    FS="[{}]"
    # columns to extract
    map["role"] = 4
    map["company"] = 8
}

# We only want to extract current role
/--Present/ {
    gsub(/\\/, "", $0)
    print $(map[col])
    exit
}
