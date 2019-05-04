#
# Reads and shows statistics collected by collect_statistics.sh
#
# Authors: Yves Mauron and Jonatan Kazmierczak
#

require(dplyr)

import_csv <- function(path) {
  file <- read.csv(file = path, header = F) %>% 
      group_by(V1) %>% # group by column Implementation
      summarise_all(median) # change summary here
  # set colnames
  colnames(file) <- c('Implementation', 'Total_Processing', 'extractWords', 'countWords', 'mostFrequentWords')
  # return file
  return(file)
}


cat("\nexecution of Java bytecode with JIT−compiled code (Tier 3 / C1)")
df_c1 <- rbind(
  import_csv("j2.csv"),
  #import_csv("j5.csv"),
  import_csv("j7.csv"),
  import_csv("j8.csv"),
  import_csv("j8prl.csv"),
  import_csv("cpp.csv")
)
df_c1

cat("\nexecution of JIT−compiled code (Tier 3+4 / C1+C2)")
df_c2 <- rbind(
  import_csv("j2jit.csv"),
  #import_csv("j5jit.csv"),
  import_csv("j7jit.csv"),
  import_csv("j8jit.csv"),
  import_csv("j8prljit.csv"),
  import_csv("cpp.csv")
)
df_c2

cat("\nexecution of JIT−compiled code (Tier 3+4 / C1+Graal)")
df_graal <- rbind(
  import_csv("j2graal.csv"),
  #import_csv("j5graal.csv"),
  import_csv("j7graal.csv"),
  import_csv("j8graal.csv"),
  import_csv("j8prlgraal.csv"),
  import_csv("cpp.csv")
)
df_graal

cat("\nexecution of AOT−compiled code (GraalVM)")
df_aot <- rbind(
  import_csv("j2aot.csv"),
  #import_csv("j5aot.csv"),
  import_csv("j7aot.csv"),
  import_csv("j8aot.csv"),
  import_csv("j8prlaot.csv"),
  import_csv("cpp.csv")
)
df_aot
