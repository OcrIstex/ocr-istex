#!/bin/bash

GIT_REPO=ocr-istex
git clone --depth 1 https://github.com/eonm-pro/${GIT_REPO}.git
chown -R onyxia:users ${GIT_REPO}/

REQUIREMENTS_FILE=${GIT_REPO}/requirements.txt
[ -f $REQUIREMENTS_FILE ] && pip install -r $REQUIREMENTS_FILE


mkdir -p data
mc cp s3/eonm/diffusion/istex-search-metadata-small.db ./data/istex-search-metadata-small.db

# Open the relevant notebook when starting Jupyter Lab
# echo "c.LabApp.default_url = '/lab/tree/${GIT_REPO}/OCR dans Istex.ipynb'" >> /home/onyxia/.jupyter/jupyter_server_config.py
