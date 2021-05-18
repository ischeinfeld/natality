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