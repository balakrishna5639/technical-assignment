-- Question 2: SQL and Database


-- A. Count the number of Acacia plant types

SELECT COUNT(DISTINCT species) AS acacia_plant_types
FROM taxonomy
WHERE species LIKE 'Acacia%';


-- B. Find the wheat type with the longest DNA sequence

SELECT
    tx.species AS wheat_type,
    rf.length AS dna_sequence_length
FROM taxonomy AS tx
JOIN rfamseq AS rf
    ON tx.ncbi_id = rf.ncbi_id
WHERE tx.species LIKE 'Triticum%'
  AND rf.mol_type = 'genomic DNA'
ORDER BY rf.length DESC
LIMIT 1;


-- C. Find families with a maximum DNA sequence length
-- greater than 1,000,000 and return page 9.
-- 15 results per page, so page 9 starts at row 121.

SELECT
    f.rfam_id AS family_name,
    f.rfam_acc AS family_accession,
    MAX(rf.length) AS max_dna_sequence_length
FROM family AS f
JOIN full_region AS fr
    ON f.rfam_acc = fr.rfam_acc
JOIN rfamseq AS rf
    ON fr.rfamseq_acc = rf.rfamseq_acc
WHERE rf.mol_type IN (
    'genomic DNA',
    'DNA',
    'ss-DNA',
    'other DNA',
    'unassigned DNA'
)
GROUP BY
    f.rfam_id,
    f.rfam_acc
HAVING MAX(rf.length) > 1000000
ORDER BY max_dna_sequence_length DESC
LIMIT 15 OFFSET 120;