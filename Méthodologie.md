# Méthodologie (inconsistante)

## Extraction des documents ElasticSearch

## Post traitement des données

```sh
zcat istex-search-metadata.jsonl.gz | jq ' -c
._source | { 
    arkIstex,
    genre: .genre[0],
    language: .language[0],
    publicationDate,
    accessCondition: .accessCondition.value,
    corpusName,
    metadata: .docObject.metadata | map({path, original, mime}),
    fulltext: .docObject.fulltext | map({path, original, mime}),
    hostTitle: .host.title
} + (.qualityIndicators | { pdfWordCount,  pdfCharCount, pdfVersion, pdfPageCount, pdfPageSize, pdfWordsPerPage, pdfText})' | gz > istex-search-metadata-ocr.jsonl.gz
```

## Identification des documents OCRs

Seuls des faisseaux d'indices permettent d'identifier les documents OCR

* Extraction de caractéristiques d'abord (et algo après pour affiner et pondérer la reconnaissance),
* possibilité de reprendre un traitement,
* reproductibilité du traitement (par exemple pour l'aléatoire sur le choix des pages)
* Problème de la taille a analyser (32 million de documents)

##  Vérifier le fonctionnement

Doit marcher sur le bouquet uk-parliement-19th

### Indices clés de présence d'un fichier PDF OCR

Sélection aléatoires des pages basées sur un graine (seed). 

Critère principaux :
* Présence d'image
* Présence d'une couche de texte transparente/invisible sur la page

Si ces critères ne sont pas remplis l'analyse du document s'arrête

*

