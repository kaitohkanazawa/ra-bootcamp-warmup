
## RA ブートキャンプ 事前課題Ⅰ
## 課題2

## パッケージ読み込み
library(dplyr)
library(purrr)
library(readr)
library(stringr)
library(zipangu)


# フォルダパス
save_dir <- "data/cleaned"

#---------------------------------
# データ読み込み
#---------------------------------
## 学級数データ
list_class <- readRDS("data/original/class_list.rds")
df_class <- data.frame()

#---------------------------------
# クリーニング
#---------------------------------
## リスト整理
list_class_cleaned <- map(list_class, function(df) {
  
  df <- df %>% 
    select(-total) %>%
    mutate(pref_no = rep(1:47)) #都道府県に番号振り
  
  for (i in 2:length(df)) {
    df[, i] <- as.numeric(df[, i])
  }
  
  df_colname <- df %>% 
    colnames() %>% 
    str_replace_all("学級", "") %>% #列名の統一
    str_replace_all("以上", "〜") %>% 
    str_replace_all("\r\n", "") %>% 
    str_replace_all("\n", "")
  df_colname[1] <- convert_jyear(df_colname[1]) #和暦→西暦
  colnames(df) <- df_colname
   
  return(df)
}) %>% 
  set_names(map_chr(., ~ colnames(.x)[1])) #データフレーム名



## リスト内データを1つに結合
list_class_for_combine <- map(list_class_cleaned, function(df) {
  
  class_year <- colnames(df)[1]
  df <- df %>% 
    mutate(year = class_year)
  
  colnames(df)[1] <- "prefecture"
  
  return(df)
})
df_class <- bind_rows(list_class_for_combine) 



## long型に変形
df_class_long <- df_class %>%
  pivot_longer(
    cols = -c(prefecture, year, pref_no),
    names_to = "class",
    values_to = "school_count"
  ) %>% 
  select(2, 1, 3, 4, 5) 



## 学級数 × 学校数 
df_class_summary <- df_class_long %>%
  mutate(nums = str_extract_all(class, "\\d+"), #一時的に作成
         class_num = map_dbl(nums, ~ {
           vals <- as.numeric(.x)
           if (length(vals) == 1) {
             vals
             } else {
               mean(vals)
               }
           }),
         class_times_school = class_num * school_count) %>%
  select(-nums) %>% 
  group_by(year, prefecture) %>%
  mutate(total_class = sum(class_times_school, na.rm = TRUE))

## 保存 
saveRDS(summary_df, file = "data/cleaned/classrooms_summary.rds")

