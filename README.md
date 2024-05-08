

<p align="center">
  <img src="https://jhustata.github.io/intermediate/_images/bd7156ffdc732b3095dad1da740b099ae999597c4cb8154a81a988a589e43517.png" width="400"/>
</p>

<p align="center">
         <a href="data.md"> Data</a>&nbsp | <a href="https://ai.meta.com/blog/"> Code</a>&nbsp | <a href="https://llama.meta.com/"> Parameters</a>&nbsp | <a href="https://llama.meta.com/get-started/"> Inferences</a>&nbsp | <a href="https://llama.meta.com/get-started/"> Updates</a>&nbsp | <a href="https://llama.meta.com/get-started/"> Transparency</a>&nbsp
<br>

---


# Hypothetical Case
- Federal Government
   - DHHS
      - CDC
         - NCHS
            - RDC
               - NHANES
               - Mortality-linkage
               - ESRD-linkage    

## Data
- On local Dell Computers running on Windows OS
- There is an intranet, but no internet connection
- Filepath to data of interest to you is identical to what you see [here](https://ftp.cdc.gov/pub/)
   - `HEALTH_STATISTICS > NCHS > datalinkage > linked_mortality (outpatient for thesis) > NHANES_1999_2000_MORT_2019_PUBLIC.dat`
- You are granted access to only one directory on the computer: `Muzaale_2275`
- In this directory you'll create three subdirectories:
   - `Data`
      - Restricted access
      - You can't take any form of these data away from the RDC/NCHS campus 
   - `Code`
      - This is your input that you email to the RDC/NCHS analyst
      - Be sensitive to `os` and incorporate nuance and ambiguity e.g. `if c(os) == "Windows" import delimited \users\xxx\xxx`
   - `Parameters`
      - A case of "dimensionality reduction"
      - No human subjects at this dimension
      - So no privacy, confidentiality or HIPAA risks 

## Code   
- `https://ftp.cdc.gov/pub/HEALTH_STATISTICS/NCHS/datalinkage/linked_mortality/Stata_ReadInProgramAllSurveys.do`
- Merge with NHANES survey

## Parameters
- Self-reported health
- Age
- Sex
- Race
- Ethnicity
  
## Inferences
- 95%CI
- p-values

## Updates
- Expand from 1999 to 2005

## Transparency
- Show all your work in one `.do` file script
- Have donors as a parallel?
