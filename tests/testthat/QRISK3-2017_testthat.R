#Test my QRISK3 pacakge using testthat

rm(list=ls())

library("testthat")
#comment when normal version
#only used for devlopment
# library("QRISK3")

context("Test QRISK3 algorithem")

test_that("testing main function of QRISK3_2017 using 2017 data", {
  data(QRISK3_2017_test)
  test_all <- QRISK3_2017_test
  #Use
  test_all_rst <- QRISK3_2017(data=test_all, patid="ID", gender="gender", age="age",
                              atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy", regular_steroid_tablets="b_corticosteroids",
                              erectile_disfunction="b_impotence2", migraine="b_migraine", rheumatoid_arthritis="b_ra",
                              chronic_kidney_disease="b_renal", severe_mental_illness="b_semi", systemic_lupus_erythematosis="b_sle",
                              blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1", diabetes2="b_type2", weight="weight", height="height",
                              ethiniciy="ethrisk", heart_attack_relative="fh_cvd", cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
                              std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town")

  test_all_rst$"QRISK_C_algorithm_score" <- test_all$"QRISK_C_algorithm_score"
  test_all_rst$"diff" <- test_all_rst$"QRISK3_2017_1digit" - test_all_rst$"QRISK_C_algorithm_score"
  test_all_rst$"diff"
  expect_equal(test_all_rst$"QRISK3_2017_1digit", test_all_rst$"QRISK_C_algorithm_score")
  print("Test main function of QRISK3_2017 succeed")
})

test_that("testing main function of QRISK3_2017 using 2019 data", {
  data(QRISK3_2019_test)
  test_all <- QRISK3_2019_test
  #Use
  test_all_rst <- QRISK3_2017(data=test_all, patid="ID", gender="gender", age="age",
                              atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy", regular_steroid_tablets="b_corticosteroids",
                              erectile_disfunction="b_impotence2", migraine="b_migraine", rheumatoid_arthritis="b_ra",
                              chronic_kidney_disease="b_renal", severe_mental_illness="b_semi", systemic_lupus_erythematosis="b_sle",
                              blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1", diabetes2="b_type2", weight="weight", height="height",
                              ethiniciy="ethrisk", heart_attack_relative="fh_cvd", cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
                              std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town")

  test_all_rst$"QRISK_C_algorithm_score" <- test_all$"QRISK_C_algorithm_score"
  test_all_rst$"diff" <- test_all_rst$"QRISK3_2017_1digit" - test_all_rst$"QRISK_C_algorithm_score"
  test_all_rst$"diff"
  expect_equal(test_all_rst$"QRISK3_2017_1digit", test_all_rst$"QRISK_C_algorithm_score")
  print("Test main function of QRISK3_2017 succeed")
})

test_that("Test for numeric of variable", {
  data(QRISK3_2017_test)
  test_all <- QRISK3_2017_test
  test_all_num <- test_all
  test_all_num$b_AF <- as.character(test_all$b_AF)
  test_all_num$b_renal <- as.character(test_all$b_renal)
  expect_error(test_all_rst <- QRISK3_2017(data=test_all_num, patid="ID", gender="gender", age="age",
                              atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy", regular_steroid_tablets="b_corticosteroids",
                              erectile_disfunction="b_impotence2", migraine="b_migraine", rheumatoid_arthritis="b_ra",
                              chronic_kidney_disease="b_renal", severe_mental_illness="b_semi", systemic_lupus_erythematosis="b_sle",
                              blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1", diabetes2="b_type2", weight="weight", height="height",
                              ethiniciy="ethrisk", heart_attack_relative="fh_cvd", cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
                              std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town"))

  print("Test function of numeric of variable of QRISK3_2017 succeed")
})

test_that("Test for missing of variable", {
  data(QRISK3_2017_test)
  test_all <- QRISK3_2017_test
  test_all_num <- test_all
  test_all_num$b_AF[test_all_num$b_AF == 1] <- NA
  test_all_num$b_renal[test_all_num$b_renal == 1] <- NA
  expect_error(test_all_rst <- QRISK3_2017(data=test_all_num, patid="ID", gender="gender", age="age",
                              atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy", regular_steroid_tablets="b_corticosteroids",
                              erectile_disfunction="b_impotence2", migraine="b_migraine", rheumatoid_arthritis="b_ra",
                              chronic_kidney_disease="b_renal", severe_mental_illness="b_semi", systemic_lupus_erythematosis="b_sle",
                              blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1", diabetes2="b_type2", weight="weight", height="height",
                              ethiniciy="ethrisk", heart_attack_relative="fh_cvd", cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
                              std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town"))

  print("Test for missing of variable of QRISK3_2017 succeed")
})

test_that("Test for age upper limit", {
  data(QRISK3_2017_test)
  test_all <- QRISK3_2017_test
  test_all$age <- test_all$age + 100
  expect_error(test_all_rst <- QRISK3_2017(data=test_all, patid="ID", gender="gender", age="age",
                              atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy", regular_steroid_tablets="b_corticosteroids",
                              erectile_disfunction="b_impotence2", migraine="b_migraine", rheumatoid_arthritis="b_ra",
                              chronic_kidney_disease="b_renal", severe_mental_illness="b_semi", systemic_lupus_erythematosis="b_sle",
                              blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1", diabetes2="b_type2", weight="weight", height="height",
                              ethiniciy="ethrisk", heart_attack_relative="fh_cvd", cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
                              std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town"))

  print("Test for age upper limit succeed")
})

test_that("Test for age lower limit", {
  data(QRISK3_2017_test)
  test_all <- QRISK3_2017_test
  test_all$age <- test_all$age - 100
  expect_error(test_all_rst <- QRISK3_2017(data=test_all, patid="ID", gender="gender", age="age",
                              atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy", regular_steroid_tablets="b_corticosteroids",
                              erectile_disfunction="b_impotence2", migraine="b_migraine", rheumatoid_arthritis="b_ra",
                              chronic_kidney_disease="b_renal", severe_mental_illness="b_semi", systemic_lupus_erythematosis="b_sle",
                              blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1", diabetes2="b_type2", weight="weight", height="height",
                              ethiniciy="ethrisk", heart_attack_relative="fh_cvd", cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
                              std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town"))

  print("Test for age lower limit succeed")
})
