#!/bin/bash

GIT_REPO=ocr-istex
git clone --depth 1 https://github.com/eonm-pro/${GIT_REPO}.git
chown -R onyxia:users ${GIT_REPO}/

REQUIREMENTS_FILE=${GIT_REPO}/requirements.txt
[ -f $REQUIREMENTS_FILE ] && pip install -r $REQUIREMENTS_FILE

mkdir -p data

mc cp $ISTEX_SEARCH_METADATA ./data/istex-search-metadata.db
mc cp $OCR_FULLTEXT_DATA     ./data/ocr-fulltext.db
mc cp $OCR_DETECTOR_DATA     ./data/ocr-detector.db

duckdb ./data/output.db <<'SQL'
ATTACH '/home/onyxia/work/data/ocr-detector.db'          AS ocr_detector (TYPE SQLITE);
ATTACH '/home/onyxia/work/data/istex-search-metadata.db' AS metadata;

CREATE TABLE data AS (
    SELECT
        DECADE(MAKE_DATE(publicationDate::INT)) AS decade,
        *
    FROM ocr_detector.documents
    JOIN metadata.records ON ark = arkIstex
);
SQL
