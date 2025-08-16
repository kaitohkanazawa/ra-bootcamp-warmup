
## RA ブートキャンプ 事前課題Ⅰ
## 課題1

## パッケージ読み込み
library(dplyr)
library(purrr)
library(readr)

# フォルダパス
save_dir <- "data/cleaned"

#---------------------------------
# データ読み込み
#---------------------------------
## 不登校データ
list_absent <- readRDS("data/original/absent_students_list.rds")
df_absent <- data.frame()

## 生徒数データ
df_students <- readRDS("data/original/students_count.rds")

#---------------------------------
# クリーニング
#---------------------------------

for (i in 1:length(list_absent)) {
  df <- list_absent[[i]] %>% 
    select(-blank) %>% 
    mutate(prefecture = as.character(prefecture),
           absent_n = as.integer(absent_n),
           year = as.integer(2012+i))
  df_absent <- df_absent %>% 
    bind_rows(df)
}

## データ結合
df_panel <- df_students %>%
  left_join(df_absent, by = c("year", "prefecture")) %>%
  mutate(absent_rate = absent_n / total_students)

## 保存
saveRDS(df_panel, file.path(save_dir, "students_absence_panel.rds"))

