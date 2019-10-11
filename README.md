
# ALFAA replication package

This repository contains data and codes for the prototype based on the framework ALFAA (Active Learning Fingerprint-based Anti Aliasing) to correct developer identity errors in version control data. The details of this framework can be found at https://arxiv.org/abs/1901.03363

### Key Pieces of Data

* clean version of best data (golden dataset) used for training

* full data on OS developers
  - d2v data
  - tz data
  - file similarity

* full data on developers in nine OSS ecosystems (Chris) 
  - files similarity
  - tz ?
  - d2v ?

### Code  

The code to produce the models on golden dataset

* skinny model (no fps)
* full model  (three fps)

The utility codes

* code for transitive closure

* code to match developers that someone provides an input (skinny model)

### Models

* skinny

* full (three fps)

 


