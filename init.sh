#!/bin/bash

GIT_REPO=ocr-istex
git clone --depth 1 https://github.com/eonm-pro/${GIT_REPO}.git
chown -R onyxia:users ${GIT_REPO}/

REQUIREMENTS_FILE=${GIT_REPO}/requirements.txt
[ -f $REQUIREMENTS_FILE ] && pip install -r $REQUIREMENTS_FILE

mkdir -p data

mc cp $ISTEX_SEARCH_METADATA ./data/istex-search-metadata.db
mc cp $OCR_FULLTEXT_DATA ./data/ocr-fulltext.db
mc cp $OCR_DETECTOR_DATA ./data/ocr-detector.db
