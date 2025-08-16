
## RA ブートキャンプ 事前課題Ⅰ
## 課題2

## パッケージ読み込み
library(readxl)
library(purrr)
library(dplyr)
library(stringr)

## フォルダパス
class_dir   <- "data/raw/学級数"
save_dir     <- "data/original"



## データ読み込み
#---------------------------------
# 学級数データ
#---------------------------------

class_files <- list.files(class_dir, pattern = "\\.xlsx$", full.names = TRUE)

list_class <- map(class_files, function(f) {
  df <- read_excel(f, skip = 1) %>%
    rename(total = 計) 
})

saveRDS(list_class, file.path(save_dir, "class_list.rds"))






