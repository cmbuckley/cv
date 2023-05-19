BEGIN {
    FS="[{}]"
}

/{experience(plain)?}/ {
    gsub(/\\/, "", $0)
    print $col
    exit
}
