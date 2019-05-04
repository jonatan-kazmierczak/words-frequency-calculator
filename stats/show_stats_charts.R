#
# Reads and shows statistics collected by collect_statistics.sh
#
# Authors: Yves Mauron and Jonatan Kazmierczak
#

require(dplyr)
require(ggplot2)
require(reshape2)

import_csv <- function(path) {
  file <- read.csv(file = path, header = F) %>% 
      group_by(V1) %>% # group by column Implementation
      summarise_all(median) # change summary here
  # set colnames
  colnames(file) <- c('Implementation', 'Total_Processing', 'extractWords', 'countWords', 'mostFrequentWords')
  # return file
  return(file)
}

bar_chart <- function(df = NULL, title, colors) {
  if (is.null(df)) {
    stop("please provide a data.frame")
  }
  
  df_copy <- df
  df_copy$Implementation <- NULL
  
  #transpose data.frame
  df_plot <- t(df_copy)
  # name data 
  colnames(df_plot) <- df$Implementation
  # melt data frame
  df_plot <- melt(df_plot)
  
  #plot
  p <- ggplot(df_plot, aes(x = Var1, y = value, fill = Var2)) +
    geom_bar(stat = 'identity', position = "dodge") +
    geom_text(aes(label = value), position = position_dodge(width = 0.9), vjust = -0.25) +
    ylab(label = 'Time [ms]') +
    xlab(label = title) +
    scale_fill_manual(values = colors) +
    theme(
      legend.title = element_blank()
    )
  
  return(p)
}


title = "execution of Java bytecode with JIT-compiled code (Tier 3 / C1)"
title_jit = "execution of JIT-compiled code (Tier 4 / C2)"
title_graal = "execution of JIT-compiled code (Tier 4 / Graal)"
title_aot = "execution of AOT-compiled code (SVM)"
title_comp = "execution of CalculatorJ8"

colors     = c("DarkGreen", "DarkBlue", "DarkViolet", "Orange", "Turquoise")
colors_aot = c("Green", "Blue", "MediumOrchid", "Gold", "Turquoise")
colors_jit = c("LawnGreen", "RoyalBlue", "Orchid", "Yellow", "Turquoise")


cat("\n", title, "\n")
df_c1 <- rbind(
  import_csv("j2.csv"),
  #import_csv("j5.csv"),
  import_csv("j7.csv"),
  import_csv("j8.csv"),
  import_csv("j8prl.csv"),
  import_csv("cpp.csv")
)
df_c1

cat("\n", title_jit, "\n")
df_c2 <- rbind(
  import_csv("j2jit.csv"),
  #import_csv("j5jit.csv"),
  import_csv("j7jit.csv"),
  import_csv("j8jit.csv"),
  import_csv("j8prljit.csv"),
  import_csv("cpp.csv")
)
df_c2

cat("\n", title_graal, "\n")
df_graal <- rbind(
  import_csv("j2graal.csv"),
  #import_csv("j5graal.csv"),
  import_csv("j7graal.csv"),
  import_csv("j8graal.csv"),
  import_csv("j8prlgraal.csv"),
  import_csv("cpp.csv")
)
df_graal

cat("\n", title_aot, "\n")
df_aot <- rbind(
  import_csv("j2aot.csv"),
  #import_csv("j5aot.csv"),
  import_csv("j7aot.csv"),
  import_csv("j8aot.csv"),
  import_csv("j8prlaot.csv"),
  import_csv("cpp.csv")
)
df_aot

cat("\n", title_comp, "\n")
df_j8 <- rbind(
  import_csv("j8.csv"),
  import_csv("j8aot.csv"),
  import_csv("j8jit.csv"),
  import_csv("j8graal.csv"),
  import_csv("cpp.csv")
)
df_j8$Implementation <- c("CalculatorJ8 (bytecode+C1)", "CalculatorJ8 (AOT)", "CalculatorJ8 (C2)", "CalculatorJ8 (Graal)", "CPP")
df_j8


bar_chart(df_c1, title, colors)
bar_chart(df_aot, title_aot, colors_aot)
bar_chart(df_c2, title_jit, colors_jit)
bar_chart(df_graal, title_graal, colors_jit)

bar_chart(df_j8, title_comp, colors)
