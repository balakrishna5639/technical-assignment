#!/usr/bin/env bash

# companies.sh
# Fetches S&P 500 company data and displays
# company name, location, and founding year.
#
# Usage:
# ./companies.sh "CSV_URL"


# Check that exactly one URL was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 \"CSV_URL\"" >&2
    exit 1
fi

csv_url="$1"
temp_file=$(mktemp)

# Download the CSV file
if ! curl -fsSL "$csv_url" -o "$temp_file"; then
    echo "Error: Failed to retrieve the dataset." >&2
    rm -f "$temp_file"
    exit 2
fi

# Extract the required fields and sort by founding year.
awk '

# Split a CSV row while handling commas inside quoted fields.
function csv_split(line, fields,    i, ch, in_quotes, field, count) {
    count = 0
    field = ""
    in_quotes = 0

    for (i = 1; i <= length(line); i++) {
        ch = substr(line, i, 1)

        if (ch == "\"") {
            in_quotes = !in_quotes
        }
        else if (ch == "," && !in_quotes) {
            fields[++count] = field
            field = ""
        }
        else {
            field = field ch
        }
    }

    fields[++count] = field
    return count
}

# Get the first four-digit year from the Founded field.
function get_year(value,    parts, i, year) {
    split(value, parts, /[^0-9]+/)

    for (i = 1; i <= length(parts); i++) {
        if (length(parts[i]) == 4) {
            year = parts[i] + 0

            if (year >= 1700 && year <= 2100) {
                return year
            }
        }
    }

    return 9999
}

# Skip the CSV header
NR == 1 {
    next
}

{
    csv_split($0, fields)

    company = fields[2]
    location = fields[5]
    founded = fields[8]

    year = get_year(founded)

    print year "\t" company "\t" location "\t" founded
}

' "$temp_file" |
sort -n -k1,1 |
awk -F'\t' '

BEGIN {
    printf "%-45s %-35s %s\n", "Company", "Headquarters", "Founded"
    printf "%-45s %-35s %s\n", "-------", "------------", "-------"
}

{
    printf "%-45s %-35s %s\n", $2, $3, $4
}

'

# Remove the temporary downloaded file
rm -f "$temp_file"