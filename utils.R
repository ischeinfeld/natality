difference_in_means <- function(dataset, Yvar, Wvar) {
  # Filter treatment / control observations, pulls outcome variable as a vector
  y1 <- dataset %>% dplyr::filter(get(Wvar) == 1) %>% dplyr::pull(get(Yvar))
  y0 <- dataset %>% dplyr::filter(get(Wvar) == 0) %>% dplyr::pull(get(Yvar))
  
  n1 <- sum(as.integer(dplyr::pull(dataset, get(Wvar))))     # Number of obs in treatment
  n0 <- sum(1 - as.integer(dplyr::pull(dataset, get(Wvar)))) # Number of obs in control
  
  # Difference in means is ATE
  tauhat <- mean(y1) - mean(y0)
  
  # 95% Confidence intervals
  se_hat <- sqrt( var(y0)/(n0-1) + var(y1)/(n1-1) )
  lower_ci <- tauhat - 1.96 * se_hat
  upper_ci <- tauhat + 1.96 * se_hat
  
  return(c(ATE = tauhat, lower_ci = lower_ci, upper_ci = upper_ci))
}

ate_condmean_ols <- function(dataset, Yvar, Wvar) {
  df_mod_centered = data.frame(scale(dataset, center = TRUE, scale = FALSE))
  
  lm.interact = lm(as.formula(paste(Yvar, "~ . * ", Wvar)),
                   data = df_mod_centered)
  tau.hat = as.numeric(coef(lm.interact)[Wvar])
  se.hat = as.numeric(sqrt(vcovHC(lm.interact)[Wvar, Wvar]))
  c(ATE=tau.hat, lower_ci = tau.hat - 1.96 * se.hat, upper_ci = tau.hat + 1.96 * se.hat)
}

ipw <- function(dataset, Yvar, Wvar, p) {
  W <- dataset[[Wvar]]
  Y <- dataset[[Yvar]]
  G <- ((W - p) * Y) / (p * (1 - p))
  tau.hat <- mean(G)
  se.hat <- sqrt(var(G) / (length(G) - 1))
  c(ATE=tau.hat, lower_ci = tau.hat - 1.96 * se.hat, upper_ci = tau.hat + 1.96 * se.hat)
}

prop_score_ols <- function(dataset, Yvar, Wvar, p) {
  W <- dataset[[Wvar]]
  Y <- dataset[[Yvar]]
  # Computing weights
  weights <- (W / p) + ((1 - W) / (1 - p))
  # OLS
  lm.fit <- lm(Y ~ W, data = dataset, weights = weights)
  tau.hat = as.numeric(coef(lm.fit)["W"])
  se.hat = as.numeric(sqrt(vcovHC(lm.fit)["W", "W"]))
  c(ATE=tau.hat, lower_ci = tau.hat - 1.96 * se.hat, upper_ci = tau.hat + 1.96 * se.hat)
}

aipw_ols <- function(dataset, Yvar, Wvar, p) {
  ols.fit <-  lm(as.formula(paste(Yvar, "~ . * ", Wvar)), data = dataset)
  
  dataset.treatall <- dataset
  dataset.treatall <- dataset.treatall %>%
    mutate(!!Wvar := 1)
  treated_pred = predict(ols.fit, dataset.treatall)
  
  dataset.treatnone = dataset
  dataset.treatall <- dataset.treatnone %>%
    mutate(!!Wvar := 0)
  control_pred = predict(ols.fit, dataset.treatnone)
  
  actual_pred = predict(ols.fit, dataset)
  
  G <- treated_pred - control_pred +
    ((dataset[[Wvar]] - p) * (dataset[[Yvar]] - actual_pred)) / (p * (1 - p))
  tau.hat <- mean(G)
  se.hat <- sqrt(var(G) / (length(G) - 1))
  c(ATE=tau.hat, lower_ci = tau.hat - 1.96 * se.hat, upper_ci = tau.hat + 1.96 * se.hat)
}

cal_plot <- function(val, pred, name, bins = 4, lim = c(0,1)){
  val_pred <- tibble(val = val, pred = pred) %>% sample_n(10000)
  # The calibration plot        
  g1 <- mutate(val_pred, bin = ntile(pred, bins)) %>%
    # Bin prediction into 10ths
    group_by(bin) %>%
    mutate(n = n(), # Get ests and CIs
           bin_pred = mean(pred),
           bin_prob = mean(val),
           se = sqrt((bin_prob * (1 - bin_prob)) / n),
           ul = bin_prob + 1.96 * se,
           ll = bin_prob - 1.96 * se) %>%
    ungroup() %>%
    ggplot(aes(x = bin_pred, y = bin_prob, ymin = ll, ymax = ul)) +
    geom_point(color = "black") +
    scale_y_continuous(limits = lim, breaks = seq(0, 1, by = 0.1)) +
    scale_x_continuous(limits = lim, breaks = seq(0, 1, by = 0.1)) +
    geom_abline(color = "grey") + # 45 degree line indicating perfect calibration
    
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed",
                color = "grey", formula = y~-1 + x, fullrange=TRUE, na.rm = TRUE) +
    
    # loess fit through estimates
    xlab("") +
    ylab("Observed Probability") +
    theme_minimal() +
    ggtitle(name)
  
  # The distribution plot        
  g2 <- ggplot(val_pred %>% sample_n(1000), aes(x = pred)) +
    geom_histogram(fill = "black", bins = 50, na.rm = TRUE) +
    scale_x_continuous(limits = lim, breaks = seq(0, 1, by = 0.1)) +
    xlab("Predicted Probability") +
    ylab("") +
    theme_minimal() +
    scale_y_continuous(breaks = c(0, 40), oob = scales::squish) +
    theme(panel.grid.minor = element_blank())
  
  # Combine them    
  grid.arrange(g1, g2, respect = TRUE, heights = c(1, 0.25), ncol = 1)
}
