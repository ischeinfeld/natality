# Maternal Smoking's Impact on Infant Birth Weight:
## A Causal Inference Case Study

This repository makes up a case study in using some recently developed
causal inference methods to estimate the effect of smoking
during pregnancy on infant birth weight. 

The dataset preparation, training, and analysis code can be found in
the following three Rmarkdown notebooks.

[*Notebook: Dataset preparation*](https://ischeinfeld.github.io/natality/natality_data.html)
[*Notebook: Training causal forests*](https://ischeinfeld.github.io/natality/natality_train.html)
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
[*Notebook: Training causal forests*](https://ischeinfeld.github.io/natality/natality_train.html)

### Causal forests

TODO introduce [grf](https://github.com/grf-labs/grf).

### Missing values

TODO introduce [missing values](https://arxiv.org/abs/1910.10624).

### Group variable encoding

TODO introduce [sufrep](https://github.com/grf-labs/sufrep).

## Results
[*Notebook: Analysis of average and individual effects*](https://ischeinfeld.github.io/natality/natality_interpret.html)

### Average effects

TODO add summary.

### Effect heterogeneity

TODO add summary.

## Next Steps

TODO add.
- variable selection
- increase data size 

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
