# Technical Assignment

## Overview

This repository contains solutions for the three questions in the technical assignment.

The solutions cover:

1. Python web scraping
2. SQL and database queries
3. Unix shell scripting

The project is organized into separate folders for each question.

## Project Structure

```text
technical-assignment/
├── README.md
├── question1/
│   └── scraper.py
├── question2/
│   └── queries.sql
└── question3/
    └── companies.sh
```

---

# Question 1 – MD Computers Product Scraper

## Description

The first solution is a Python web scraper that searches the MD Computers website using a product name or keyword entered by the user.

It retrieves the search results and extracts:

- Product name
- Selling price

The results are displayed in the terminal.

The program also handles an empty search term and request failures.

## Prerequisites

- Python 3
- Internet connection

## Dependencies

The script uses the following Python packages:

- `requests`
- `beautifulsoup4`

Install them with:

```bash
pip install requests beautifulsoup4
```

The `urllib.parse` module used by the script is part of Python's standard library and does not require a separate installation.

## Running the Script

From the project root directory, run:

```bash
python question1/scraper.py
```

The program will ask for a search term:

```text
Enter the product you want to search: RTX 4060
```

It then displays the matching products and their selling prices.

## Assumptions and Limitations

- An internet connection is required.
- The scraper depends on the current HTML structure of the MD Computers website.
- If the website changes its HTML structure or CSS classes, the selectors in the script may need to be updated.
- The results depend on the products currently returned by the website for the supplied search term.

---

# Question 2 – SQL and Database

## Description

The second solution contains SQL queries for the public Rfam MySQL database.

The queries answer the following:

- **A:** Count the number of Acacia plant types in the `taxonomy` table.
- **B:** Find the wheat type with the longest DNA sequence using the `taxonomy` and `rfamseq` tables.
- **C:** Find Rfam families whose maximum DNA sequence length is greater than 1,000,000, sort them by sequence length, and return page 9 with 15 results per page.

## Prerequisites

- MySQL Workbench or another MySQL-compatible client
- Internet connection
- Access to the Rfam public MySQL database

## Database Connection

The queries are intended for the Rfam public read-only database.

```text
Host: mysql-rfam-public.ebi.ac.uk
Port: 4497
Database: Rfam
User: rfamro
```

Rfam database documentation:

https://docs.rfam.org/en/latest/database.html

## Running the Queries

The queries are stored in:

```text
question2/queries.sql
```

Open `queries.sql` in MySQL Workbench after connecting to the Rfam public database and execute the queries individually.

## Testing

Questions A and B were successfully tested against the Rfam public database.

Question C was also tested. However, the public Rfam MySQL server returned:

```text
Error Code: 2013 - Lost connection to MySQL server during query
```

after approximately 30 seconds.

The query is still included in `queries.sql` because it represents the required solution for Question C.

## Assumptions and Limitations

- The queries assume the Rfam database schema described in the Rfam documentation.
- The database is accessed as a public read-only database.
- Question C performs a relatively large join and aggregation over the Rfam data. The query timed out on the public server during testing, so its successful execution could not be confirmed on that server.

---

# Question 3 – Unix Shell Scripting

## Description

The third solution is a Bash shell script that accepts the S&P 500 companies CSV URL as a command-line argument.

The script:

- Downloads the CSV dataset.
- Handles the CSV header.
- Extracts company name, headquarters location, and founding year.
- Sorts the records by founding year.
- Displays the results in a readable table.
- Handles a missing URL argument.
- Handles failure to retrieve the dataset.

The URL is supplied by the user and is not hard-coded in the script.

## Prerequisites

- Bash
- `curl`
- `awk`
- `sort`

The script can be run on Unix/Linux systems. On Windows, Git Bash or WSL can be used.

## Running the Script

From the project root directory, run:

```bash
./question3/companies.sh "https://raw.githubusercontent.com/datasets/s-and-p-500-companies/refs/heads/main/data/constituents.csv"
```

Example output:

```text
Company                                       Headquarters                        Founded
-------                                       ------------                        -------
...
```

The records are displayed in ascending order of founding year.

## Error Handling

If no URL is supplied:

```bash
./question3/companies.sh
```

the script displays:

```text
Usage: ./companies.sh "CSV_URL"
```

If the supplied URL cannot be retrieved, the script displays an error message and exits.

## Testing

The script was tested with:

- A valid S&P 500 CSV URL
- No URL argument
- An invalid URL

The valid URL successfully downloaded and processed the dataset.

The missing-argument case displayed the expected usage message, and the invalid-URL case correctly reported that the dataset could not be retrieved.

## Assumptions and Limitations

- The supplied CSV is expected to contain the `Security`, `Headquarters Location`, and `Founded` columns.
- The script includes quote-aware CSV parsing so that fields containing commas, such as headquarters locations, are handled correctly.
- Some `Founded` values contain multiple years. The script uses the first valid four-digit year found in the field for sorting.
- An internet connection is required to retrieve the dataset.

---

# General Notes

The solutions were kept intentionally straightforward and use tools appropriate for each question.

The project avoids unnecessary frameworks or data-science libraries and includes comments where they help explain the implementation or assumptions.

All three solutions were tested during development, including basic error cases where applicable.
