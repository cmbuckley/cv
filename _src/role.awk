BEGIN {
    FS="[{}]"
}

/{experience}/ {
    gsub(/\\/, "", $0)
    print $col
    exit
}
