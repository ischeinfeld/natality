# Maternal Smoking's Impact on Infant Birth Weight:
## A Causal Inference Case Study

This repository makes up a case study in using some recently developed
causal inference methods to estimate the effect of smoking
during pregnancy on infant birth weight. 

## Setting

### Smoking during pregnancy and birth weight

Low birthweight is an important risk factor for perinatal morbidity and
mortality, and maternal smoking during pregnancy (SDP) is known to be one of
the most signficant modifiable causes. While the effect of SDP on birth weight
is well known, the chemical and biological linkages are not well understood. 
[jaddoe, juarez, lumley, kataoka]

Estimating the causal effect of SDP on birth weight is complicated by the fact
that both SDP and infant birth weight are potentially impacted by numerous
biological and environmental factors. Most studies attempt to control for
confounding in some way, for example using regression models with a set of
covariates. [jaddoe, kataoka] Jaddoe et al., for example, control for maternal
age, height, ethnicity, parity and infant gender, all of which are known to
effect birth weight. [jaddoe]

Other approaches have been used to attempt to estimate the causal effect as
well. For example, Juarez and Merlo conduct both a regression-based analysis
and a quasi-experimental sibling analysis using mother-specific multilevel
linear regression on pairs of births where the mother's SDP status changed.
Their sibling analysis showed a similar but somewhat smaller magnitude effect
compared to their regression analysis, which could indicate that the latter
did not sufficiently control for confounding. [juarez] While this approach
should control for genetic confounders, the assumption that environmental
factors remain fixed for mothers between births is especially suspect since
their change in smoking status could be associated with a changing environment.

Some randomized experimental studies also provide evidence for SDP's effect on
birth weight, although since SDP itself cannot be randomized these studies
usually randomize interventions intended to prevent SDP. [lumley]

### Dataset

[Dataset preparation](https://ischeinfeld.github.io/natality/natality_data.html)

We use the [Vital Statistics Natality Birth
Data](https://www.nber.org/research/data/vital-statistics-natality-birth-data)
dataset, which provides demographic and health data for births in the United
States. Since 1985, this includes data corresponding to 100% of birth
certificates.

> "Demographic data include variables such as date of birth, age and educational
> attainment of parents, marital status, live-birth order, race, sex, and
> geographic area. Health data include items such as birth weight, gestation,
> prenatal care, attendant at birth, and Apgar score. Geographic data includes
> state, county, [], and metropolitan and nonmetropolitan counties." [natality]

The breadth of variables available could make controlling for confounding more
reasonable than where less data is available, with the current analysis taking
into account 45 covariates in addition to treatment and outcome. However, it
must be noted that confounders such as genetics would remain uncontrolled for.

A full discussion of how reasonable the unconfoundedness despite missingness
assumptions required by the method described below is outside the scope of
this case study. However, the approach is mostly a technical extension of the
commonly used regression-based approaches insofar as it requires similar
assumptions about the data.

### Sample

Following Juarez and Merlo, we consider the effect on birth weight of heavy
smoking (defined as reporting smoking > 9 cigarettes per day) compared to not
smoking at all. This means we omit light smokers from our datasets.

For computational efficiency, we uniformly sample 100,000 singleton births with
reported cigarettes per day and birth weight. We keep NA values in covariates,
treating them as special values in the subsequent analysis.

## Methods
[Training causal forests](https://ischeinfeld.github.io/natality/natality_train.html)

### Causal forests

TODO introduce [grf](https://github.com/grf-labs/grf).

### Missing values

TODO introduce [missing values](https://arxiv.org/abs/1910.10624).

### Group variable encoding

TODO introduce [sufrep](https://github.com/grf-labs/sufrep).

## Results
[Analysis of average and individual effects](https://ischeinfeld.github.io/natality/natality_interpret.html)

### Average effects

TODO add summary.

### Effect heterogeneity

TODO add summary.

## Next Steps

TODO add.
- variable selection
- increase data size 

## Citations

National Center for Health Statistics (2002). Data File Documentations,
Natality, 2002, National Center for Health Statistics, Hyattsville, Maryland.
