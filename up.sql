SET preserve_insertion_order = false;
SET memory_limit = '8GB';

CREATE OR REPLACE TEMP TABLE src AS
FROM read_json(
    '/home/mathis/istex-search-metadata-ocr.jsonl.gz',
    format        = 'newline_delimited',
    compression   = 'gzip',
    ignore_errors = true,
    columns = {
        'arkIstex':        'VARCHAR',
        'genre':           'VARCHAR',
        'language':        'VARCHAR',
        'publicationDate': 'VARCHAR',
        'accessCondition': 'VARCHAR',
        'corpusName':      'VARCHAR',
        'hostTitle':       'VARCHAR',
        'pdfWordCount':    'BIGINT',
        'pdfCharCount':    'BIGINT',
        'pdfVersion':      'VARCHAR',
        'pdfPageCount':    'INTEGER',
        'pdfPageSize':     'VARCHAR',
        'pdfWordsPerPage': 'INTEGER',
        'pdfText':         'BOOLEAN',
        'metadata':        'STRUCT(path VARCHAR, original BOOLEAN, mime VARCHAR)[]',
        'fulltext':        'STRUCT(path VARCHAR, original BOOLEAN, mime VARCHAR)[]'
    }
);

CREATE OR REPLACE TABLE records AS
SELECT
    arkIstex,
    corpusName,
    genre,
    language,
    publicationDate,
    accessCondition,
    hostTitle,
    pdfWordCount,
    pdfCharCount,
    pdfVersion,
    pdfPageCount,
    pdfPageSize,
    pdfWordsPerPage,
    pdfText
FROM src;

CREATE OR REPLACE TABLE metadata AS
SELECT
    arkIstex,
    split(m.path, '/')[-1] AS path,
    m.original,
    m.mime
FROM src,
UNNEST(metadata) AS t(m);

CREATE OR REPLACE TABLE fulltext AS
SELECT
    arkIstex,
    split(f.path, '/')[-1] AS path,
    f.original,
    f.mime
FROM src,
UNNEST(fulltext) AS t(f);

DROP TABLE src;