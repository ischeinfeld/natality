# Maternal Smoking's Impact on Infant Birth Weight:
## A Causal Inference Case Study

This repository presents a case study in applying causal forests, a recently
developed causal inference method, along with the method of sufficient
representation for categorical variables, to estimate the effect of smoking
during pregnancy on infant birth weight. In addition to comparing estimates for
the average treatment effect to those found in the literature, we consider the
average treatment effect on the treated, and attempt to identify treatment
heterogeneity across covariates.

The dataset preparation, training, and analysis code can be found in the
following three Rmarkdown notebooks.

[*Notebook: Dataset preparation*](https://ischeinfeld.github.io/natality/natality_data.html)<br/>
[*Notebook: Training causal forests*](https://ischeinfeld.github.io/natality/natality_train.html)<br/>
[*Notebook: Analysis of average and individual effects*](https://ischeinfeld.github.io/natality/natality_interpret.html)

## Setting

### Smoking during pregnancy and birth weight

Low birthweight is an important risk factor for perinatal morbidity and
mortality, and maternal smoking during pregnancy (SDP) is known to be one of
the most signficant modifiable causes. While the effect of SDP on birth weight
is well known, the chemical and biological linkages are not well understood. 
[[Jaddoe](https://doi.org/10.1111/j.1365-3016.2007.00916.x),
 [Juarez](https://doi.org/10.1371/journal.pone.0061734), 
 [Lumley](https://doi.org/10.1002/14651858.CD001055.pub3),
 [Kataoka](https://doi.org/10.1186/s12884-018-1694-4)]

Estimating the causal effect of SDP on birth weight is complicated by the fact
that both SDP and infant birth weight are potentially impacted by numerous
biological and environmental factors. Most studies attempt to control for
confounding in some way, for example using regression models with a set of
covariates.
[[Jaddoe](https://doi.org/10.1111/j.1365-3016.2007.00916.x),
 [Kataoka](https://doi.org/10.1186/s12884-018-1694-4)]
Jaddoe et al., for example, control for maternal age, height, ethnicity, parity
and infant gender, all of which are known to effect birth weight. 

Other approaches have been used to attempt to estimate the causal effect as
well. For example, Juarez and Merlo conduct both a regression-based analysis
and a quasi-experimental sibling analysis using mother-specific multilevel
linear regression on pairs of births where the mother's SDP status changed.
Their sibling analysis showed a similar but somewhat smaller magnitude effect
compared to their regression analysis, which could indicate that the latter
did not sufficiently control for confounding. 
[[Juarez](https://doi.org/10.1371/journal.pone.0061734)]
While this approach should control for genetic confounders, the assumption that
environmental factors remain fixed for mothers between births is especially
suspect since their change in smoking status could be associated with a
changing environment.

Some randomized experimental studies also provide evidence for SDP's effect on
birth weight, although since SDP itself cannot be randomized these studies
usually randomize interventions intended to prevent SDP.
[[Lumley](https://doi.org/10.1002/14651858.CD001055.pub3)]

### Dataset

[*Notebook: Dataset preparation*](https://ischeinfeld.github.io/natality/natality_data.html)

We use the [Vital Statistics Natality Birth
Data](https://www.nber.org/research/data/vital-statistics-natality-birth-data)
dataset, which provides demographic and health data for births in the United
States. Since 1985, this includes data corresponding to 100% of birth
certificates.

> "Demographic data include variables such as date of birth, age and educational
> attainment of parents, marital status, live-birth order, race, sex, and
> geographic area. Health data include items such as birth weight, gestation,
> prenatal care, attendant at birth, and Apgar score. Geographic data includes
> state, county, [], and metropolitan and nonmetropolitan counties."
> [Vital Statistics Natality Birth Data](https://www.nber.org/research/data/vital-statistics-natality-birth-data)

The breadth of variables available could make controlling for confounding more
reasonable than where less data is available, with the current analysis taking
into account 45 covariates in addition to treatment and outcome. However, it
must be noted that confounders such as genetics would remain uncontrolled for.

A brief discussion of the plausability of the assumptions required by the methods 
applied in this case study is given in the methods section. A full argument is
outside the scope of this case study, and in fact there may be good reasons not
to believe that the necessary assumptions hold. However, the approach is mostly
a technical extension of the regression-based approaches we compare with
insofar as it requires similar assumptions about the data.

### Sample

Following Juarez and Merlo, for our primary analysis we consider the effect on
birth weight of heavy smoking (defined as reporting smoking > 9 cigarettes per
day) compared to not smoking at all. This means we omit light smokers from our
datasets. We also train models for other definitions of treatment.

For computational efficiency, we uniformly sample 100,000 singleton births with
reported cigarettes per day and birth weight. We keep NA values in covariates,
treating them as special values in the subsequent analysis as motivated by an
assumption described below.

## Methods
[*Notebook: Training causal forests*](https://ischeinfeld.github.io/natality/natality_train.html)

### Causal forests

We apply causal forests, as described
[here](https://projecteuclid.org/euclid.aos/1547197251) and as implemented by
the [grf](https://github.com/grf-labs/grf) package. Causal forests are a
non-parametric method for the estimation of heterogenous treatment effects in
observational studies. They require two primary assumptions: unconfoundedness
and overlap.

Unconfoundedness requires that, conditioned on observed covariates, treatment
and potential outcomes are independent. Even with expert knowledge, it can be
difficult to argue for unconfoundedness. Here we will be content to note that
we are controlling for many demographic variables and a large set of variables
arguably picked as medically relevant to childbirth. We acknowledge that we
cannot control for genetics, and as such our results should be interpreted
skeptically. 

Overlap requires that there is a minimum probability that each member of the
population under study is treated and not treated, i.e. that treatment
probabilities (propensities) are uniformly bounded away from 0 and 1. While
this assumption is easier to argue for than unconfoundedness (it seems
plausible that no covariates make smoking during pregnancy impossible or
guaranteed), our model does estimate very low smoking probabilites for some
members of our dataset. This can make estimating treatment effects challenging
for those very unlikely to smoke.

### Missing values

As is the case with many real datasets, the US Natality data contains a
significant number of missing values across many different variables. For this
case study, we choose to assume unconfoundedness despite missignness, i.e. that
missing attributes do to break the unconfoundedness assumption described above.

This is not the only way to handle missing values in causal inference, for a
discussion see this [paper.](https://arxiv.org/abs/1910.10624). Here it is an
expedient choice since tree-based estimators such as causal forests can easily
treat missing values and the proofs for their consistency apply without
modification under unconfoundedness despite missingness.

Whether this assumption is reasonable for our data is a difficult question. Let
us consider, for example, two types of missingness mechanisms we could find in
our dataset. First, assume a covariate is only ommitted when it considered
medically irrelevant. It might be reasonable to assume that the potential
outcomes are independent of its true value conditioned on the recorded value
and whether it is missing. This condition, termed conditional independence of
outcome in the paper above, implies unconfoundedness despite missingness.
Second, consider a covariate which is ommitted due to variation in reporting
practices between hospitals. If this variable was important for controlling
confounding, it may not be reasonable that unconfoundedness holds despite
missingness.

It turns out that a large proportion of missingness in our data can be
explained by regional variations in reporting. This could suggest that an
imputation-based approach might be more suitable. However, where this reporting
difference is systematic it would be impossible to properly impute missing
values, since there would not be any data from which to estimate the
conditional distribution.

### Group variable encoding

Many of the variables in the US Natality data are high-dimensional categorical
variables, for example US state. Causal forests, like many other machine
learning algorithms, require real-valued variable vectors as inputs. While this
is often achieved by using a one-hot encoding, where each category is mapped to
a separate dimension, this can be highly inefficient when the number of
categories is large. In this study, we apply the method of sufficient
representation described in this [paper](), as implemented in the package
[sufrep](https://github.com/grf-labs/sufrep). This approach is suitable where a
categorical variable only effects the estimation target via some unobserved
latent variable. This seems reasonable, for example, in the case of a variable
representing US states, where one could assume that the probability of smoking
and its effects both only depended on state through some state properties such
as demographics, healthcare quality, or smoking laws.

## Results Summary
[*Notebook: Analysis of average and individual effects*](https://ischeinfeld.github.io/natality/natality_interpret.html)

### Average effects

The causal forest gives an average treatment effect (ATE) estimate for heavy
smoking of -193g (std 10.6), compared with -230g given by the naive
difference-in-means estimator. A similar treatment effect considered by Juarez
and Merlo (smoking > 9 cigarettes a day duiring both the first and third
trimester) yielded estimates of the ATE of -303g using a regression analysis
and -226g using a sibling study. Note that their data differs in collection
methods, population (the study took place in Sweden), and the granularity of
treatment (they have separate data for the first and third trimesters).

Since estimated treatment probabilities go very low (<1%) due to the fact that
smoking is quite uncommon during pregnancy, treatment effects for some controls
may not be well identified. For this reason, it can be helpful to look at the
average treatment effect on the treated (ATT). The point estimate of the ATT
here is -214g (std 6.2), which is larger in magnitude than the ATE above, with
a smaller standard error. This would seem to indicate that smoking mothers are
predisposed to more severe effects of smoking on birth weight than mothers who
do not smoke would be if they did.

### Effect heterogeneity

The causal forest calibration is good enough that we can be confident it
is picking up at least some significant heterogeneity in the signal.

The distribution of predicted conditional average treatment effects (CATE)
is concentrated mostly in the (-300g, -100g) range, which seems reasonable
given the expected effect sizes.

![CATE](images/CATE.png)

Two variables with significant linear associations with the predicted CATE are
parity (number of to-term pregnancies) and mother's age. Groupwise ATE
estimates are as follows. The greater effect of environmental tobacco smoke
on birth weight in older mothers has already been shown. 
[[Ahluwalia](https://doi.org/10.1093/oxfordjournals.aje.a009190)]

| age     | n     | estimate  | std.err  | 
| ------- | ----- | --------- | -------- | 
| [10,21] | 20243 | -155.3205 | 18.30547 |
| (21,25] | 21009 | -155.9506 | 16.90007 |
| (25,29] | 21423 | -178.7270 | 26.40490 |
| (29,33] | 20239 | -242.4721 | 28.97829 |
| (33,54] | 17086 | -247.6665 | 26.47239 |

| parity |  n     | estimate  | std.err  | 
| ------ | ------ | --------- | -------- |
| 1      | 40632  | -187.2538 | 10.77753 |
| 2      | 32612  | -202.6679 | 10.91414 |
| 3      | 16500  | -234.6373 | 13.88215 |
| 4      | 6128   | -258.3118 | 22.62397 |
| 5      | 2151   | -286.6694 | 37.00665 |

Other variables also show significant relationships, for example previous
births over 4000g, eclampsia, and pregnancy-associated hypertension. However,
the counts of births with these risk factors to smoking mothers is so low that
these estimates are not trustworth given the data size. This is reflected in
their group-level ATE estimates having very large standard errors for the
positive case.

## Next Steps

The next logical step in the analysis are to improve variable selection,
primarily to allow for larger training samples (since the forest estimators are
primarily RAM limited on my laptop). This would allow both better ATE and CATE
estimates, as well as more power for the heterogeneity analysis for highly
imbalanced covariates.

## Citations

<div class="csl-bib-body" style="line-height: 1.35; margin-left: 2em; text-indent:-2em;">
  <div class="csl-entry">Ahluwalia, I. B., L. Grummer-Strawn, and K. S. Scanlon. “Exposure to Environmental Tobacco Smoke and Birth Outcome: Increased Effects on Pregnant Women Aged 30 Years or Older.” <i>American Journal of Epidemiology</i> 146, no. 1 (July 1, 1997): 42–47. <a href="https://doi.org/10.1093/oxfordjournals.aje.a009190">https://doi.org/10.1093/oxfordjournals.aje.a009190</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_id=info%3Adoi%2F10.1093%2Foxfordjournals.aje.a009190&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Exposure%20to%20Environmental%20Tobacco%20Smoke%20and%20Birth%20Outcome%3A%20Increased%20Effects%20on%20Pregnant%20Women%20Aged%2030%20Years%20or%20Older&amp;rft.jtitle=American%20Journal%20of%20Epidemiology&amp;rft.stitle=American%20Journal%20of%20Epidemiology&amp;rft.volume=146&amp;rft.issue=1&amp;rft.aufirst=I.%20B.&amp;rft.aulast=Ahluwalia&amp;rft.au=I.%20B.%20Ahluwalia&amp;rft.au=L.%20Grummer-Strawn&amp;rft.au=K.%20S.%20Scanlon&amp;rft.date=1997-07-01&amp;rft.pages=42-47&amp;rft.spage=42&amp;rft.epage=47&amp;rft.issn=0002-9262%2C%201476-6256&amp;rft.language=en"></span>
  <div class="csl-entry">Athey, Susan, Julie Tibshirani, and Stefan Wager. “Generalized Random Forests.” <i>ArXiv:1610.01271 [Econ, Stat]</i>, April 5, 2018. <a href="http://arxiv.org/abs/1610.01271">http://arxiv.org/abs/1610.01271</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Generalized%20Random%20Forests&amp;rft.jtitle=arXiv%3A1610.01271%20%5Becon%2C%20stat%5D&amp;rft.aufirst=Susan&amp;rft.aulast=Athey&amp;rft.au=Susan%20Athey&amp;rft.au=Julie%20Tibshirani&amp;rft.au=Stefan%20Wager&amp;rft.date=2018-04-05"></span>
  <div class="csl-entry">Jaddoe, Vincent W. V., Ernst-Jan W. M. Troe, Albert Hofman, Johan P. Mackenbach, Henriette A. Moll, Eric A. P. Steegers, and Jacqueline C. M. Witteman. “Active and Passive Maternal Smoking during Pregnancy and the Risks of Low Birthweight and Preterm Birth: The Generation R Study.” <i>Paediatric and Perinatal Epidemiology</i> 22, no. 2 (March 2008): 162–71. <a href="https://doi.org/10.1111/j.1365-3016.2007.00916.x">https://doi.org/10.1111/j.1365-3016.2007.00916.x</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_id=info%3Adoi%2F10.1111%2Fj.1365-3016.2007.00916.x&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Active%20and%20passive%20maternal%20smoking%20during%20pregnancy%20and%20the%20risks%20of%20low%20birthweight%20and%20preterm%20birth%3A%20the%20Generation%20R%20Study&amp;rft.jtitle=Paediatric%20and%20Perinatal%20Epidemiology&amp;rft.stitle=Paediatr%20Perinat%20Epidemiol&amp;rft.volume=22&amp;rft.issue=2&amp;rft.aufirst=Vincent%20W.%20V.&amp;rft.aulast=Jaddoe&amp;rft.au=Vincent%20W.%20V.%20Jaddoe&amp;rft.au=Ernst-Jan%20W.%20M.%20Troe&amp;rft.au=Albert%20Hofman&amp;rft.au=Johan%20P.%20Mackenbach&amp;rft.au=Henriette%20A.%20Moll&amp;rft.au=Eric%20A.%20P.%20Steegers&amp;rft.au=Jacqueline%20C.%20M.%20Witteman&amp;rft.date=2008-03&amp;rft.pages=162-171&amp;rft.spage=162&amp;rft.epage=171&amp;rft.issn=0269-5022%2C%201365-3016&amp;rft.language=en"></span>
  <div class="csl-entry">Johannemann, Jonathan, Vitor Hadad, Susan Athey, and Stefan Wager. “Sufficient Representations for Categorical Variables.” <i>ArXiv:1908.09874 [Cs, Stat]</i>, February 15, 2020. <a href="http://arxiv.org/abs/1908.09874">http://arxiv.org/abs/1908.09874</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Sufficient%20Representations%20for%20Categorical%20Variables&amp;rft.jtitle=arXiv%3A1908.09874%20%5Bcs%2C%20stat%5D&amp;rft.aufirst=Jonathan&amp;rft.aulast=Johannemann&amp;rft.au=Jonathan%20Johannemann&amp;rft.au=Vitor%20Hadad&amp;rft.au=Susan%20Athey&amp;rft.au=Stefan%20Wager&amp;rft.date=2020-02-15"></span>
  <div class="csl-entry">Juárez, Sol Pía, and Juan Merlo. “Revisiting the Effect of Maternal Smoking during Pregnancy on Offspring Birthweight: A Quasi-Experimental Sibling Analysis in Sweden.” Edited by Claire Thorne. <i>PLoS ONE</i> 8, no. 4 (April 17, 2013): e61734. <a href="https://doi.org/10.1371/journal.pone.0061734">https://doi.org/10.1371/journal.pone.0061734</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_id=info%3Adoi%2F10.1371%2Fjournal.pone.0061734&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Revisiting%20the%20Effect%20of%20Maternal%20Smoking%20during%20Pregnancy%20on%20Offspring%20Birthweight%3A%20A%20Quasi-Experimental%20Sibling%20Analysis%20in%20Sweden&amp;rft.jtitle=PLoS%20ONE&amp;rft.stitle=PLoS%20ONE&amp;rft.volume=8&amp;rft.issue=4&amp;rft.aufirst=Sol%20P%C3%ADa&amp;rft.aulast=Ju%C3%A1rez&amp;rft.au=Sol%20P%C3%ADa%20Ju%C3%A1rez&amp;rft.au=Juan%20Merlo&amp;rft.au=Claire%20Thorne&amp;rft.date=2013-04-17&amp;rft.pages=e61734&amp;rft.issn=1932-6203&amp;rft.language=en"></span>
  <div class="csl-entry">Kataoka, Mariana Caricati, Ana Paula Pinho Carvalheira, Anna Paula Ferrari, Maíra Barreto Malta, Maria Antonieta de Barros Leite Carvalhaes, and Cristina Maria Garcia de Lima Parada. “Smoking during Pregnancy and Harm Reduction in Birth Weight: A Cross-Sectional Study.” <i>BMC Pregnancy and Childbirth</i> 18, no. 1 (December 2018): 67. <a href="https://doi.org/10.1186/s12884-018-1694-4">https://doi.org/10.1186/s12884-018-1694-4</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_id=info%3Adoi%2F10.1186%2Fs12884-018-1694-4&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Smoking%20during%20pregnancy%20and%20harm%20reduction%20in%20birth%20weight%3A%20a%20cross-sectional%20study&amp;rft.jtitle=BMC%20Pregnancy%20and%20Childbirth&amp;rft.stitle=BMC%20Pregnancy%20Childbirth&amp;rft.volume=18&amp;rft.issue=1&amp;rft.aufirst=Mariana%20Caricati&amp;rft.aulast=Kataoka&amp;rft.au=Mariana%20Caricati%20Kataoka&amp;rft.au=Ana%20Paula%20Pinho%20Carvalheira&amp;rft.au=Anna%20Paula%20Ferrari&amp;rft.au=Ma%C3%ADra%20Barreto%20Malta&amp;rft.au=Maria%20Antonieta%20de%20Barros%20Leite%20Carvalhaes&amp;rft.au=Cristina%20Maria%20Garcia%20de%20Lima%20Parada&amp;rft.date=2018-12&amp;rft.pages=67&amp;rft.issn=1471-2393&amp;rft.language=en"></span>
  <div class="csl-entry">Lumley, Judith, Catherine Chamberlain, Therese Dowswell, Sandy Oliver, Laura Oakley, and Lyndsey Watson. “Interventions for Promoting Smoking Cessation during Pregnancy.” In <i>Cochrane Database of Systematic Reviews</i>, edited by The Cochrane Collaboration, CD001055.pub3. Chichester, UK: John Wiley &amp; Sons, Ltd, 2009. <a href="https://doi.org/10.1002/14651858.CD001055.pub3">https://doi.org/10.1002/14651858.CD001055.pub3</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rft.genre=bookitem&amp;rft.atitle=Interventions%20for%20promoting%20smoking%20cessation%20during%20pregnancy&amp;rft.place=Chichester%2C%20UK&amp;rft.publisher=John%20Wiley%20%26%20Sons%2C%20Ltd&amp;rft.aufirst=Judith&amp;rft.aulast=Lumley&amp;rft.au=undefined&amp;rft.au=Judith%20Lumley&amp;rft.au=Catherine%20Chamberlain&amp;rft.au=Therese%20Dowswell&amp;rft.au=Sandy%20Oliver&amp;rft.au=Laura%20Oakley&amp;rft.au=Lyndsey%20Watson&amp;rft.date=2009-07-08&amp;rft.pages=CD001055.pub3&amp;rft.language=en"></span>
  <div class="csl-entry">Mayer, Imke, Erik Sverdrup, Tobias Gauss, Jean-Denis Moyer, Stefan Wager, and Julie Josse. “Doubly Robust Treatment Effect Estimation with Missing Attributes.” <i>ArXiv:1910.10624 [Stat]</i>, May 22, 2020. <a href="http://arxiv.org/abs/1910.10624">http://arxiv.org/abs/1910.10624</a>.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Doubly%20robust%20treatment%20effect%20estimation%20with%20missing%20attributes&amp;rft.jtitle=arXiv%3A1910.10624%20%5Bstat%5D&amp;rft.aufirst=Imke&amp;rft.aulast=Mayer&amp;rft.au=Imke%20Mayer&amp;rft.au=Erik%20Sverdrup&amp;rft.au=Tobias%20Gauss&amp;rft.au=Jean-Denis%20Moyer&amp;rft.au=Stefan%20Wager&amp;rft.au=Julie%20Josse&amp;rft.date=2020-05-22"></span>
  <div class="csl-entry">National Center for Health Statistics. “Data File Documentations, Natality, 2002.” National Center for Health Statistics, Hyattsville, Maryland., 2002.</div>
  <span class="Z3988" title="url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Adc&amp;rft.type=document&amp;rft.title=Data%20File%20Documentations%2C%20Natality%2C%202002&amp;rft.publisher=National%20Center%20for%20Health%20Statistics%2C%20Hyattsville%2C%20Maryland.&amp;rft.au=undefined&amp;rft.date=2002"></span>
</div>

