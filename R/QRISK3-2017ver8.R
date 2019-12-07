# PROGRAM NAME:       QRISK3.sas                                                                                                                                                                          ;
# PROGRAM LOCATION:                       ;
# PROGRAM PURPOSE:        To create QRISK3 according to the online free algorithm (https://qrisk.org/three/src.php)                                                                         
# QRISK3 calculator copyright to ClinRisk Ltd.                                                                                                      

# Metadata;
#   age=64;
#   gender=1; /*1:women 2:men*/
#   b_AF=1;  /*Atrial fibrillation?*/
#   b_atypicalantipsy=1; /*On atypical antipsychotic medication?*/
#   b_corticosteroids=1; /*Are you on regular steroid tablets?*/
#   b_impotence2 =1; /*A diagnosis of or treatment for erectile disfunction?*/
#   b_migraine=1; /*Do you have migraines?*/
#   b_ra=0; /*Rheumatoid arthritis?*/
#   b_renal=0; /*Chronic kidney disease (stage 3, 4 or 5)?*/
#   b_semi=0; /*Severe mental illness?*/
#   b_sle=0; /*Systemic lupus erythematosis (SLE)?*/
#   b_treatedhyp=1; /*On blood pressure treatment?*/
#   b_type1=1; /*Diabetes status: type 1*/
#   b_type2=0; /*Diabetes status: type 2*/
#   weight=80; (kg)
#   height=178; (cm)
#   ethrisk=1; /*risk of ethic group*/
#   fh_cvd=1; /*Angina or heart attack in a 1st degree relative < 60?*/
#   rati=4; /*1 - 11, Cholesterol/HDL ratio:*/
#   sbp=180; /*Systolic blood pressure (mmHg)*/
#   sbps5=20; /*Standard deviation of at least two most recent systolic blood pressure readings (mmHg)*/
#   smoke_cat=1;
#   **This is differnt from original C program because index of SAS and R vector starts from 1;
#   /*     value='1' non-smoker*/
#   /*     value='2' >ex-smoker*/
#   /*     value='3' >light smoker (less than 10)*/
#   /*     value='4' >moderate smoker (10 to 19)*/
#   /*     value='5' >heavy smoker (20 or over)*/
#   surv=10; /*10 year risk*/
#   town=0; /*town deprivation score*/
#   bmi= weight / ((height/100)**2);

#The documentation for R package used by Roxygen2

#' Cardiovascular Disease 10-year Risk Calculation (QRISK3 2017)
#'
#' This function allows you to calculate 10-year individual CVD risk using QRISK3-2017.
#' 
#' @param data         Specifiy your data.
#' @param patid        Specifiy the patient identifier.
#' @param gender       1: women 0: men.
#' @param age          Specify the age of the patient in year (e.g. 64 years-old)
#' @param atrial_fibrillation         Atrial fibrillation? (0: No, 1:Yes)
#' @param atypical_antipsy         On atypical antipsychotic medication? (0: No, 1:Yes)
#' @param regular_steroid_tablets         On regular steroid tablets? (0: No, 1:Yes)
#' @param erectile_disfunction         A diagnosis of or treatment for erectile disfunction? (0: No, 1:Yes)
#' @param migraine         Do patients have migraines? (0: No, 1:Yes)
#' @param rheumatoid_arthritis         Rheumatoid arthritis? (0: No, 1:Yes)
#' @param chronic_kidney_disease         Chronic kidney disease (stage 3, 4 or 5)? (0: No, 1:Yes)
#' @param severe_mental_illness         Severe mental illness? (0: No, 1:Yes)
#' @param systemic_lupus_erythematosis         Systemic lupus erythematosis (SLE)? (0: No, 1:Yes)
#' @param blood_pressure_treatment         On blood pressure treatment? (0: No, 1:Yes)
#' @param diabetes1         Diabetes status: type 1? (0: No, 1:Yes)
#' @param diabetes2         Diabetes status: type 2? (0: No, 1:Yes)
#' @param weight         Weight of patients (kg)
#' @param height         Height of patients (cm)
#' @param ethiniciy         Ethic group must be coded as the same as QRISK3 \cr
#' 
#' 1 White or not stated \cr
#' 2 Indian \cr
#' 3 Pakistani \cr
#' 4 Bangladeshi \cr
#' 5 Other Asian \cr
#' 6 Black Caribbean \cr
#' 7 Black African \cr
#' 8 Chinese \cr
#' 9 Other ethnic group \cr
#' 
#' @param heart_attack_relative         Angina or heart attack in a 1st degree relative < 60? (0: No, 1:Yes)
#' @param cholesterol_HDL_ratio         Cholesterol/HDL ratio? (range from 1 to 11, e.g. 4)
#' @param systolic_blood_pressure         Systolic blood pressure (mmHg, e.g. 180 mmHg)
#' @param std_systolic_blood_pressure         Standard deviation of at least two most recent systolic blood pressure readings (mmHg)
#' @param smoke         Smoke status must be coded as the same as QRISK3 \cr
#' 
#'     1 non-smoker \cr
#'     2 ex-smoker \cr
#'     3 light smoker (less than 10) \cr
#'     4 moderate smoker (10 to 19) \cr
#'     5 heavy smoker (20 or over) \cr
#' 
#' @param townsend         Townsend deprivation scores
#' @keywords QRISK3_2017
#' @return Return a dataset with three columns: patient identifier, caculated QRISK3 score,  caculated QRISK3 score with only 1 digit

#' @examples
#' data(QRISK3_2019_test)
#' test_all <- QRISK3_2019_test
#' 
#' test_all_rst <- QRISK3_2017(data=test_all, patid="ID", gender="gender", age="age",
#' atrial_fibrillation="b_AF", atypical_antipsy="b_atypicalantipsy",
#' regular_steroid_tablets="b_corticosteroids", erectile_disfunction="b_impotence2",
#' migraine="b_migraine", rheumatoid_arthritis="b_ra", 
#' chronic_kidney_disease="b_renal", severe_mental_illness="b_semi",
#' systemic_lupus_erythematosis="b_sle",
#' blood_pressure_treatment="b_treatedhyp", diabetes1="b_type1",
#' diabetes2="b_type2", weight="weight", height="height",
#' ethiniciy="ethrisk", heart_attack_relative="fh_cvd", 
#' cholesterol_HDL_ratio="rati", systolic_blood_pressure="sbp",
#' std_systolic_blood_pressure="sbps5", smoke="smoke_cat", townsend="town")
#' 
#' test_all_rst$"QRISK_C_algorithm_score" <- test_all$"QRISK_C_algorithm_score"
#' test_all_rst$"diff" <- test_all_rst$"QRISK3_2017_1digit" - test_all_rst$"QRISK_C_algorithm_score"
#' print(test_all_rst$"diff")
#' print(identical(test_all_rst$"QRISK3_2017_1digit", test_all_rst$"QRISK_C_algorithm_score"))
#' 
# This tells my function would be accessbale by users
#' @export

QRISK3_2017 <- function(data, patid, gender, age,
                            atrial_fibrillation, atypical_antipsy, regular_steroid_tablets,
                            erectile_disfunction, migraine, rheumatoid_arthritis, chronic_kidney_disease,
                            severe_mental_illness, systemic_lupus_erythematosis, blood_pressure_treatment, diabetes1, diabetes2,
                            weight, height, ethiniciy, heart_attack_relative, cholesterol_HDL_ratio, systolic_blood_pressure,
                            std_systolic_blood_pressure, smoke, townsend) {

message("\nThis R package was based on open-sourced original QRISK3-2017 algorithm.")
message("<https://qrisk.org/three/src.php> Copyright 2017 ClinRisk Ltd.")

message("\nThe risk score calculated from this R package can only be used for research purpose.")
message("\nPlease refer to QRISK3 website for more information")
message("<https://qrisk.org/three/index.php>")

#For R CMD checking
b_AF <- b_atypicalantipsy <- b_corticosteroids <- b_impotence2 <-  b_migraine <- b_ra <- NULL
b_renal <- b_semi <- b_sle <- b_treatedhyp <- b_type1 <- b_type2 <- bmi <- ethrisk <- fh_cvd <- head <- smoke_cat<- surv <- capture.output<- NULL

varListFull <- c(patid, gender, age, atrial_fibrillation,
                 atypical_antipsy, regular_steroid_tablets, erectile_disfunction,
                 migraine, rheumatoid_arthritis, chronic_kidney_disease, severe_mental_illness, systemic_lupus_erythematosis,
                 blood_pressure_treatment, diabetes1, diabetes2, weight, height,
                 ethiniciy, heart_attack_relative, cholesterol_HDL_ratio, systolic_blood_pressure,
                 std_systolic_blood_pressure, smoke,townsend)

varListNDR <- c(atrial_fibrillation,atypical_antipsy, regular_steroid_tablets, erectile_disfunction,
                migraine, rheumatoid_arthritis, chronic_kidney_disease, severe_mental_illness, systemic_lupus_erythematosis,
                blood_pressure_treatment, diabetes1, diabetes2, weight, height,
                ethiniciy, heart_attack_relative, cholesterol_HDL_ratio, systolic_blood_pressure,
                std_systolic_blood_pressure, smoke,townsend)

varListReplace <- c("b_AF", "b_atypicalantipsy", "b_corticosteroids", "b_impotence2",
                "b_migraine", "b_ra", "b_renal", "b_semi", "b_sle", "b_treatedhyp", "b_type1", "b_type2","weight", "height",
                "Ethincity", "fh_cvd", "rati", "sbp", "sbps5", "smoke", "town")



#get the data
dt <- as.data.frame(data[,varListFull])

#Print message for ethinicity and smoking
#I do not help them code these variables
#as this require them to specify level of variables
#might be easier for them to code variables by themsevles
#create dictionary for ethinicity and smoke
Tom_dic <- function(oriList, codeList, colName) {
  EthincityDic <- cbind.data.frame(oriList, codeList)
  colnames(EthincityDic) <- colName
  return(EthincityDic) 
}

#Ethinicity
EthincityCat <- c("White or not stated", "Indian", "Pakistani", "Bangladeshi", "Other Asian",
"Black Caribbean", "Black African", "Chinese", "Other ethnic group")
EthincityValue <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
EthincityName <- c("Ethiniciy_category", "Ethinicity")
EthincityDic <- Tom_dic(EthincityCat, EthincityValue, EthincityName)

#Smoking
EthincityCat <- c("non-smoker", "ex-smoker", "light smoker (less than 10)",
"moderate smoker (10 to 19)", "heavy smoker (20 or over)")
EthincityValue <- c(1, 2, 3, 4, 5)
EthincityName <- c("Smoke_category", "Smoke")
SmokeDic <- Tom_dic(EthincityCat, EthincityValue, EthincityName)

message("\nImportant: Please double check whether your variables are coded the same as the QRISK3 calculator")
message("\nHeight should have unit as (cm)")
message("Weight should have unit as (kg)")
message("\nEthiniciy should be coded as: ")
message(paste0(capture.output(head(EthincityDic)), collapse = "\n"))
# print(EthincityDic)
message("\nSmoke should be coded as: ")
message(paste0(capture.output(head(SmokeDic)), collapse = "\n"))
# print(SmokeDic)

#Check whether variable is numeric or integer
# print(str(dt))
nonNumList <- varListNDR[!(unlist(lapply(dt[,varListNDR], is.numeric)))]

# print(nonNumList)
if (length(nonNumList) !=0) {
    stop(paste0("Variables including ", paste0(nonNumList, collapse = ", "), ' must be coded as numeric (0/1) variable.')) 
}

#Check missing value 
missList <- varListNDR[sapply(dt[,varListNDR], function(x) any(is.na(x)))]

# print(nonNumList)
if (length(missList) !=0) {
    stop(paste0("Variables including ", paste0(missList, collapse = ", "), ' has missing values.')) 
}

#update Check whether age is between 25 and 84
if (min(dt$age) <25 | max(dt$age) >84) {
    stop(paste0("Age of patients must be between 25 and 84.")) 
}

#Replace the user-defined column names to QRISK3 variable names
for (i in 1:length(varListNDR)) {
colnames(dt)[names(dt)==varListNDR[i]] <- varListReplace[i]}




#Assign coded variables
dt$ethrisk <- dt$Ethincity
dt$smoke_cat <- dt$smoke

#more calcualte with R to calculate BMI 
dt$bmi <- dt$weight/((dt$height/100)**2)

#add survival time
dt$surv <- 10

#Get index (order) of original dataset
dt$order <- as.numeric(rownames(dt))

# print(dt$order[1:10])
  #Female 
    survivor <- c(0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.988876402378082,
                  0,
                  0,
                  0,
                  0,
                  0)
    #survivor[10]

    Iethrisk <- c(0,
                  0.2804031433299542500000000,
                  0.5629899414207539800000000,
                  0.2959000085111651600000000,
                  0.0727853798779825450000000,
                  -0.1707213550885731700000000,
                  -0.3937104331487497100000000,
                  -0.3263249528353027200000000,
                  -0.1712705688324178400000000)
    #Iethrisk[1]

    Ismoke <- c(	0,
                  0.1338683378654626200000000,
                  0.5620085801243853700000000,
                  0.6674959337750254700000000,
                  0.8494817764483084700000000)

    #Ismoke[2]

    #Calculate score
    #female
    fe_rst <- as.data.frame(within(dt[dt$gender==1, ], {
        #Applying the fractional polynomial transforms 
        #(which includes scaling)                      
          
        dage = age
        dage=dage/10
        age_1 = dage^(-2)
        age_2 = dage
        dbmi = bmi
        dbmi=dbmi/10
        bmi_1 = dbmi^(-2)
        bmi_2 = (dbmi^(-2))*log(dbmi)
        
        # Centring the continuous variables 
          
        age_1 = age_1 - 0.053274843841791
        age_2 = age_2 - 4.332503318786621
        bmi_1 = bmi_1 - 0.154946178197861
        bmi_2 = bmi_2 - 0.144462317228317
        rati = rati - 3.476326465606690
        sbp = sbp - 123.130012512207030
        sbps5 = sbps5 - 9.002537727355957
        town = town - 0.392308831214905
        
        # Start of Sum 
          a=0
        
        #The conditional sums 
          
          a =a+ Iethrisk[ethrisk]
        a =a+ Ismoke[smoke_cat]
        
        # Sum from continuous values 
          
          a =a+ age_1 * -8.1388109247726188000000000
        a =a+ age_2 * 0.7973337668969909800000000
        a =a+ bmi_1 * 0.2923609227546005200000000
        a =a+ bmi_2 * -4.1513300213837665000000000
        a =a+ rati * 0.1533803582080255400000000
        a =a+ sbp * 0.0131314884071034240000000
        a =a+ sbps5 * 0.0078894541014586095000000
        a =a+ town * 0.0772237905885901080000000
        
        # Sum from boolean values 
          
          a =a+ b_AF * 1.5923354969269663000000000
        a =a+ b_atypicalantipsy * 0.2523764207011555700000000
        a =a+ b_corticosteroids * 0.5952072530460185100000000
        a =a+ b_migraine * 0.3012672608703450000000000
        a =a+ b_ra * 0.2136480343518194200000000
        a =a+ b_renal * 0.6519456949384583300000000
        a =a+ b_semi * 0.1255530805882017800000000
        a =a+ b_sle * 0.7588093865426769300000000
        a =a+ b_treatedhyp * 0.5093159368342300400000000
        a =a+ b_type1 * 1.7267977510537347000000000
        a =a+ b_type2 * 1.0688773244615468000000000
        a =a+ fh_cvd * 0.4544531902089621300000000
        
        # Sum from interaction terms 
          
          a =a+ age_1 * (smoke_cat==2) * -4.7057161785851891000000000
        a =a+ age_1 * (smoke_cat==3) * -2.7430383403573337000000000
        a =a+ age_1 * (smoke_cat==4) * -0.8660808882939218200000000
        a =a+ age_1 * (smoke_cat==5) * 0.9024156236971064800000000
        a =a+ age_1 * b_AF * 19.9380348895465610000000000
        a =a+ age_1 * b_corticosteroids * -0.9840804523593628100000000
        a =a+ age_1 * b_migraine * 1.7634979587872999000000000
        a =a+ age_1 * b_renal * -3.5874047731694114000000000
        a =a+ age_1 * b_sle * 19.6903037386382920000000000
        a =a+ age_1* b_treatedhyp * 11.8728097339218120000000000
        a =a+ age_1 * b_type1 * -1.2444332714320747000000000
        a =a+ age_1 * b_type2 * 6.8652342000009599000000000
        a =a+ age_1 * bmi_1 * 23.8026234121417420000000000
        a =a+ age_1 * bmi_2 * -71.1849476920870070000000000
        a =a+ age_1 * fh_cvd * 0.9946780794043512700000000
        a =a+ age_1 * sbp * 0.0341318423386154850000000
        a =a+ age_1 * town * -1.0301180802035639000000000
        a =a+ age_2 * (smoke_cat==2) * -0.0755892446431930260000000
        a =a+ age_2 * (smoke_cat==3) * -0.1195119287486707400000000
        a =a+ age_2 * (smoke_cat==4) * -0.1036630639757192300000000
        a =a+ age_2 * (smoke_cat==5) * -0.1399185359171838900000000
        a =a+ age_2 * b_AF * -0.0761826510111625050000000
        a =a+ age_2 * b_corticosteroids * -0.1200536494674247200000000
        a =a+ age_2 * b_migraine * -0.0655869178986998590000000
        a =a+ age_2 * b_renal * -0.2268887308644250700000000
        a =a+ age_2 * b_sle * 0.0773479496790162730000000
        a =a+ age_2* b_treatedhyp * 0.0009685782358817443600000
        a =a+ age_2 * b_type1 * -0.2872406462448894900000000
        a =a+ age_2 * b_type2 * -0.0971122525906954890000000
        a =a+ age_2 * bmi_1 * 0.5236995893366442900000000
        a =a+ age_2 * bmi_2 * 0.0457441901223237590000000
        a =a+ age_2 * fh_cvd * -0.0768850516984230380000000
        a =a+ age_2 * sbp * -0.0015082501423272358000000
        a =a+ age_2 * town * -0.0315934146749623290000000
        
        # Calculate the score itself 
          score = 100.0 * (1 - (survivor[surv])^exp(a))
          score1= round(score,1)}))
 
    #Attention: The three arrays were re-defined here. You must run them together.
    #Female 
    survivor <- c(	0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.977268040180206,
                    0,
                    0,
                    0,
                    0,
                    0)
    #survivor[10]

    Iethrisk <- c(		0,
                    0.2771924876030827900000000,
                    0.4744636071493126800000000,
                    0.5296172991968937100000000,
                    0.0351001591862990170000000,
                    -0.3580789966932791900000000,
                    -0.4005648523216514000000000,
                    -0.4152279288983017300000000,
                    -0.2632134813474996700000000)
    #Iethrisk[1]

    Ismoke <- c(	0,
                0.1912822286338898300000000,
                0.5524158819264555200000000,
                0.6383505302750607200000000,
                0.7898381988185801900000000)

    #Ismoke[2]

    Ma_rst <- as.data.frame(within(dt[dt$gender==0, ], {
      # Applying the fractional polynomial transforms 
      # (which includes scaling)                      
        
        dage = age
        dage=dage/10
        age_1 = dage^(-1)
        age_2 = dage^(3)
        dbmi = bmi
        dbmi=dbmi/10
        bmi_2 = dbmi^(-2)*log(dbmi)
        bmi_1 = dbmi^(-2)
        
        # Centring the continuous variables 
          
          age_1 = age_1 - 0.234766781330109
          age_2 = age_2 - 77.284080505371094
          bmi_1 = bmi_1 - 0.149176135659218
          bmi_2 = bmi_2 - 0.141913309693336
          rati = rati - 4.300998687744141
          sbp = sbp - 128.571578979492190
          sbps5 = sbps5 - 8.756621360778809
          town = town - 0.526304900646210
          
          # Start of Sum 
            a=0
            
            # The conditional sums 
              
              a =a+ Iethrisk[ethrisk]
              a =a+ Ismoke[smoke_cat]
              
              # Sum from continuous values 
                
                a =a+ age_1 * -17.8397816660055750000000000
                a =a+ age_2 * 0.0022964880605765492000000
                a =a+ bmi_1 * 2.4562776660536358000000000
                a =a+ bmi_2 * -8.3011122314711354000000000
                a =a+ rati * 0.1734019685632711100000000
                a =a+ sbp * 0.0129101265425533050000000
                a =a+ sbps5 * 0.0102519142912904560000000
                a =a+ town * 0.0332682012772872950000000
              
                # Sum from boolean values 
                  
                  a =a+ b_AF * 0.8820923692805465700000000
                  a =a+ b_atypicalantipsy * 0.1304687985517351300000000
                  a =a+ b_corticosteroids * 0.4548539975044554300000000
                  a =a+ b_impotence2 * 0.2225185908670538300000000
                  a =a+ b_migraine * 0.2558417807415991300000000
                  a =a+ b_ra * 0.2097065801395656700000000
                  a =a+ b_renal * 0.7185326128827438400000000
                  a =a+ b_semi * 0.1213303988204716400000000
                  a =a+ b_sle * 0.4401572174457522000000000
                  a =a+ b_treatedhyp * 0.5165987108269547400000000
                  a =a+ b_type1 * 1.2343425521675175000000000
                  a =a+ b_type2 * 0.8594207143093222100000000
                  a =a+ fh_cvd * 0.5405546900939015600000000
                  
                  # Sum from interaction terms 
                    
                    a =a+ age_1 * (smoke_cat==2) * -0.2101113393351634600000000
                    a =a+ age_1 * (smoke_cat==3) * 0.7526867644750319100000000
                    a =a+ age_1 * (smoke_cat==4) * 0.9931588755640579100000000
                    a =a+ age_1 * (smoke_cat==5) * 2.1331163414389076000000000
                    a =a+ age_1 * b_AF * 3.4896675530623207000000000
                    a =a+ age_1 * b_corticosteroids * 1.1708133653489108000000000
                    a =a+ age_1 * b_impotence2 * -1.5064009857454310000000000
                    a =a+ age_1 * b_migraine * 2.3491159871402441000000000
                    a =a+ age_1 * b_renal * -0.5065671632722369400000000
                    a =a+ age_1* b_treatedhyp * 6.5114581098532671000000000
                    a =a+ age_1 * b_type1 * 5.3379864878006531000000000
                    a =a+ age_1 * b_type2 * 3.6461817406221311000000000
                    a =a+ age_1 * bmi_1 * 31.0049529560338860000000000
                    a =a+ age_1 * bmi_2 * -111.2915718439164300000000000
                    a =a+ age_1 * fh_cvd * 2.7808628508531887000000000
                    a =a+ age_1 * sbp * 0.0188585244698658530000000
                    a =a+ age_1 * town * -0.1007554870063731000000000
                    a =a+ age_2 * (smoke_cat==2) * -0.0004985487027532612100000
                    a =a+ age_2 * (smoke_cat==3) * -0.0007987563331738541400000
                    a =a+ age_2 * (smoke_cat==4) * -0.0008370618426625129600000
                    a =a+ age_2 * (smoke_cat==5) * -0.0007840031915563728900000
                    a =a+ age_2 * b_AF * -0.0003499560834063604900000
                    a =a+ age_2 * b_corticosteroids * -0.0002496045095297166000000
                    a =a+ age_2 * b_impotence2 * -0.0011058218441227373000000
                    a =a+ age_2 * b_migraine * 0.0001989644604147863100000
                    a =a+ age_2 * b_renal * -0.0018325930166498813000000
                    a =a+ age_2* b_treatedhyp * 0.0006383805310416501300000
                    a =a+ age_2 * b_type1 * 0.0006409780808752897000000
                    a =a+ age_2 * b_type2 * -0.0002469569558886831500000
                    a =a+ age_2 * bmi_1 * 0.0050380102356322029000000
                    a =a+ age_2 * bmi_2 * -0.0130744830025243190000000
                    a =a+ age_2 * fh_cvd * -0.0002479180990739603700000
                    a =a+ age_2 * sbp * -0.0000127187419158845700000
                    a =a+ age_2 * town * -0.0000932996423232728880000
                    
                    # Calculate the score itself 
                    score = 100.0 * (1 - (survivor[surv])^exp(a) )
                    score1= round(score,1)}))

  #  print(survivor)
   dtRst <- rbind.data.frame(fe_rst, Ma_rst)
  #  print(str(dtRst))
   colnames(dtRst)[names(dtRst)=="score"] <- "QRISK3_2017"
   colnames(dtRst)[names(dtRst)=="score1"] <- "QRISK3_2017_1digit"
   dtRstSm <- dtRst[,c(patid,"QRISK3_2017","QRISK3_2017_1digit","order")]
  #  dtRstSm <- dtRst
   dtRstF <- as.data.frame(dtRstSm[order(dtRstSm$order),])
   dtRstF$order <- NULL
   message("\nThe head of result in all patients is:\n")
   message(paste0(capture.output(head(dtRstF)), collapse = "\n"))
  #  print(head(dtRstF))
   return(dtRstF)
 }