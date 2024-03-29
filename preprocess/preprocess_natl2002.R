################################################################
# This file provides preprocessing code to load natl2002.csv.
# Note that not all available variables are read in.
# The following variables have their levels modified:
#   monpre - new scale is numeric, number of months of prenatal care
#   dmar - collapsed puerto rico 2 and 3 to match US coding
################################################################

# Some columns use 0-padded integers and some do not. I'm not
# sure why, but we the following two functions generate the levels 
# for either type.
#   Unpadded: c("0", "1", "2", "3", "99")
#   Padded: c("0", "1", "2") or c("00", "01", "02", "03", "99")

# Levels for unpadded ints
lev_unpadded <- function(ints) {
  as.character(ints)
}

# Levels for padded ints
lev_padded <- function(ints) {
  n_char <- nchar(paste(max(ints)))
  levs <- as.character(ints)
  str_pad(levs, n_char, side = "left", pad = "0")
}

# Recode binary factors
fct_cond <- function(f) {
  fact <- f %>% 
    fct_relevel("2", "1")
  
  case_when(fact == "1" ~ TRUE,
            fact == "2" ~ FALSE)
}

preprocess_natl <- function(natl_raw) {
  natl_raw %>%
    transmute(datayear = as.integer(datayear),
              rectype = factor(rectype, levels = lev_padded(1:2)),
              restatus = factor(restatus, levels = lev_padded(1:4)),
              pldel = factor(pldel, levels = lev_padded(1:5)),
              pldel3 = factor(pldel3, levels = lev_padded(1:2)),
              birattnd = factor(birattnd, levels = lev_padded(1:5)),
              regnocc = factor(regnocc, levels = lev_padded(1:4)),
              divocc = factor(divocc, levels = lev_padded(1:9)),
              stresexp = factor(stresexp, levels = lev_padded(c(1:58,60,62:63))),
              cntocpop = factor(cntocpop, ordered = TRUE, levels = lev_padded(0:3)),
              regnres = factor(regnres, levels = lev_padded(1:4)),
              divres = factor(divres, levels = lev_padded(1:9)),
              stnatexp = factor(stnatexp, levels = lev_padded(c(1:55,62:63))),
              citrspop = factor(citrspop, ordered = TRUE, levels = lev_padded(c(0:3,9))),
              metrores = factor(metrores, levels = lev_padded(1:2)) %>% fct_cond(),
              cntrspop = factor(cntrspop, ordered = TRUE, levels = lev_padded(c(0:5,9))),
              dmage = as.integer(dmage),
              ormoth = factor(ormoth, levels = lev_padded(0:5)),
              mrace = factor(mrace, levels = lev_unpadded(c(0:8,18,28,38,48,58,68,78))),
              mrace3 = factor(mrace3, levels = lev_padded(1:3)),
              dmeduc = as.integer(dmeduc) %>% na_if(99),
              dmar = as.integer(dmar) %>% na_if(9) %>% pmin(2) %>% factor(levels = lev_padded(1:2)) %>% fct_cond(),
              mplbir = factor(mplbir, levels = lev_padded(c(1:54,61:62))),
              adequacy = factor(adequacy, ordered = TRUE, levels = lev_padded(1:3)),
              nlbnl = as.integer(nlbnl) %>% na_if(99),
              nlbnd = as.integer(nlbnd) %>% na_if(99),
              noterm = as.integer(noterm) %>% na_if(99),
              dlivord = as.integer(dlivord) %>% na_if(99),
              dtotord = as.integer(dtotord) %>% na_if(99),
              monpre = 10 - (as.integer(monpre) %>% na_if(0) %>% replace_na(10) %>% na_if(99)), # hack to fix ordering
              mpre5 = factor(mpre5, ordered = TRUE, levels = lev_padded(1:4)),
              nprevis = as.integer(nprevis) %>% na_if(99),
              dfage = as.integer(dfage) %>% na_if(99),
              orfath = factor(orfath, levels = lev_padded(0:5)),
              frace = factor(frace, levels = lev_unpadded(c(0:8,18,28,38,48,58,68,78))),
              frace4 = factor(frace4, levels = lev_padded(1:3)),
              dgestat = as.integer(dgestat) %>% na_if(99),
              csex = factor(csex, levels = lev_padded(c(1,2))),
              dbirwt = as.integer(dbirwt) %>% na_if(9999),
              dplural = as.integer(dplural),
              fmaps = as.integer(fmaps) %>% na_if(99),
              delmeth5 = factor(delmeth5, levels = lev_padded(1:4)),
              # medical risk factors
              anemia = factor(anemia, levels = lev_padded(1:2)) %>% fct_cond(),
              cardiac = factor(cardiac, levels = lev_padded(1:2)) %>% fct_cond(),
              lung = factor(lung, levels = lev_padded(1:2)) %>% fct_cond(),
              diabetes = factor(diabetes, levels = lev_padded(1:2)) %>% fct_cond(),
              herpes = factor(herpes, levels = lev_padded(1:2)) %>% fct_cond(),
              hydra = factor(hydra, levels = lev_padded(1:2)) %>% fct_cond(),
              hemo = factor(hemo, levels = lev_padded(1:2)) %>% fct_cond(),
              chyper = factor(chyper, levels = lev_padded(1:2)) %>% fct_cond(),
              phyper = factor(phyper, levels = lev_padded(1:2)) %>% fct_cond(),
              eclamp = factor(eclamp, levels = lev_padded(1:2)) %>% fct_cond(),
              incervix = factor(incervix, levels = lev_padded(1:2)) %>% fct_cond(),
              pre4000 = factor(pre4000, levels = lev_padded(1:2)) %>% fct_cond(),
              preterm = factor(preterm, levels = lev_padded(1:2)) %>% fct_cond(),
              renal = factor(renal, levels = lev_padded(1:2)) %>% fct_cond(),
              rh = factor(rh, levels = lev_padded(1:2)) %>% fct_cond(),
              uterine = factor(uterine, levels = lev_padded(1:2)) %>% fct_cond(),
              othermr = factor(othermr, levels = lev_padded(1:2)) %>% fct_cond(),
              # other risk factors
              tobacco = factor(tobacco, levels = lev_padded(1:2)) %>% fct_cond(),
              cigar = as.integer(cigar) %>% na_if(99),
              cigar10 = (as.integer(cigar) %>% na_if(99)) >= 10,
              alcohol = factor(alcohol, levels = lev_padded(1:2)) %>% fct_cond(),
              drink = as.integer(drink) %>% na_if(99),
              wtgain = as.integer(wtgain) %>% na_if(99),
              # obstetric procedures
              amnio = factor(amnio, levels = lev_padded(1:2)) %>% fct_cond(),
              monitor = factor(monitor, levels = lev_padded(1:2)) %>% fct_cond(),
              induct = factor(induct, levels = lev_padded(1:2)) %>% fct_cond(),
              stimula = factor(stimula, levels = lev_padded(1:2)) %>% fct_cond(),
              tocol = factor(tocol, levels = lev_padded(1:2)) %>% fct_cond(),
              ultras = factor(ultras, levels = lev_padded(1:2)) %>% fct_cond(),
              otherob = factor(otherob, levels = lev_padded(1:2)) %>% fct_cond(),
              # labor complications
              febrile = factor(febrile, levels = lev_padded(1:2)) %>% fct_cond(),
              meconium = factor(meconium, levels = lev_padded(1:2)) %>% fct_cond(),
              rupture = factor(rupture, levels = lev_padded(1:2)) %>% fct_cond(),
              abruptio = factor(abruptio, levels = lev_padded(1:2)) %>% fct_cond(),
              preplace = factor(preplace, levels = lev_padded(1:2)) %>% fct_cond(),
              excebld = factor(excebld, levels = lev_padded(1:2)) %>% fct_cond(),
              seizure = factor(seizure, levels = lev_padded(1:2)) %>% fct_cond(),
              precip = factor(precip, levels = lev_padded(1:2)) %>% fct_cond(),
              prolong = factor(prolong, levels = lev_padded(1:2)) %>% fct_cond(),
              dysfunc = factor(dysfunc, levels = lev_padded(1:2)) %>% fct_cond(),
              breech = factor(breech, levels = lev_padded(1:2)) %>% fct_cond(),
              cephalo = factor(cephalo, levels = lev_padded(1:2)) %>% fct_cond(),
              cord = factor(cord, levels = lev_padded(1:2)) %>% fct_cond(),
              anesthe = factor(anesthe, levels = lev_padded(1:2)) %>% fct_cond(),
              distress = factor(distress, levels = lev_padded(1:2)) %>% fct_cond(),
              otherlb = factor(otherlb, levels = lev_padded(1:2)) %>% fct_cond(),
              # newborn
              nanemia = factor(nanemia, levels = lev_padded(1:2)) %>% fct_cond(),
              injury = factor(injury, levels = lev_padded(1:2)) %>% fct_cond(),
              alcosyn = factor(alcosyn, levels = lev_padded(1:2)) %>% fct_cond(),
              hyaline = factor(hyaline, levels = lev_padded(1:2)) %>% fct_cond(),
              meconsyn = factor(meconsyn, levels = lev_padded(1:2)) %>% fct_cond(),
              venl30 = factor(venl30, levels = lev_padded(1:2)) %>% fct_cond(),
              ven30m = factor(ven30m, levels = lev_padded(1:2)) %>% fct_cond(),
              nseiz = factor(nseiz, levels = lev_padded(1:2)) %>% fct_cond(),
              otherab = factor(otherab, levels = lev_padded(1:2)) %>% fct_cond(),
              # congenital anomalies
              anen = factor(anen, levels = lev_padded(1:2)) %>% fct_cond(),
              spina = factor(spina, levels = lev_padded(1:2)) %>% fct_cond(),
              hydro = factor(hydro, levels = lev_padded(1:2)) %>% fct_cond(),
              microce = factor(microce, levels = lev_padded(1:2)) %>% fct_cond(),
              nervous = factor(nervous, levels = lev_padded(1:2)) %>% fct_cond(),
              heart = factor(heart, levels = lev_padded(1:2)) %>% fct_cond(),
              circul = factor(circul, levels = lev_padded(1:2)) %>% fct_cond(),
              rectal = factor(rectal, levels = lev_padded(1:2)) %>% fct_cond(),
              tracheo = factor(tracheo, levels = lev_padded(1:2)) %>% fct_cond(),
              omphalo = factor(omphalo, levels = lev_padded(1:2)) %>% fct_cond(),
              gastro = factor(gastro, levels = lev_padded(1:2)) %>% fct_cond(),
              genital = factor(genital, levels = lev_padded(1:2)) %>% fct_cond(),
              renalage = factor(renalage, levels = lev_padded(1:2)) %>% fct_cond(),
              urogen = factor(urogen, levels = lev_padded(1:2)) %>% fct_cond(),
              cleftlp = factor(cleftlp, levels = lev_padded(1:2)) %>% fct_cond(),
              adactyly = factor(adactyly, levels = lev_padded(1:2)) %>% fct_cond(),
              clubfoot = factor(clubfoot, levels = lev_padded(1:2)) %>% fct_cond(),
              hernia = factor(hernia, levels = lev_padded(1:2)) %>% fct_cond(),
              musculo = factor(musculo, levels = lev_padded(1:2)) %>% fct_cond(),
              downs = factor(downs, levels = lev_padded(1:2)) %>% fct_cond(),
              chromo = factor(chromo, levels = lev_padded(1:2)) %>% fct_cond(),
              othercon = factor(othercon, levels = lev_padded(1:2)) %>% fct_cond())
}