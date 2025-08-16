
## RA ブートキャンプ 事前課題Ⅰ
## 課題1

## パッケージ読み込み
library(readxl)
library(purrr)
library(dplyr)
library(stringr)

## フォルダパス
absent_dir   <- "data/raw/不登校生徒数"
save_dir     <- "data/original"



## データ読み込み
#---------------------------------
# 生徒数データ
#---------------------------------

df_students <- read_excel("data/raw/生徒数/生徒数.xlsx") %>%
  rename(
    prefecture = 都道府県,
    year = 年度,
    total_students = 生徒数
  ) %>% 
  mutate(year = as.integer(year))

saveRDS(df_students, file.path(save_dir, "students_count.rds"))

#---------------------------------
# 不登校生徒数データ
#---------------------------------

absent_files <- list.files(absent_dir, pattern = "\\.xlsx$", full.names = TRUE)

list_absent <- map(absent_files, function(f) {

  df <- read_excel(f) %>%
    rename(
      prefecture = 都道府県,
      absent_n = 不登校生徒数
    ) 
  return(df)
})

saveRDS(list_absent, file.path(save_dir, "absent_students_list.rds"))
