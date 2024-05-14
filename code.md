# Stata `.do` files

- [Staight out of Stata!!](dyndoc.html)
- Click [here](https://ftp.cdc.gov/pub/HEALTH_STATISTICS/NCHS/datalinkage/linked_mortality/) for other `.do` file sources
- Download `Stata_ReadInProgramAllSurveys.do`
   - Edit filepath in the `.do` file
   - Review my edits [here](https://github.com/jhustata/project/blob/main/followup.do) for guidance
   - Save edits as `followup.do` and upload to your `username/project` repo
   - Any edits should be saved under the same `followup.do` file name, but use "commit changes" statements for version control
- This script `followup.do` produces mortality followup data
- Merge these outcomes with NHANES survey (i.e., baseline data)

# Stata `.ado` files
- Long-term plan is to automate the above processes using `.ado` scripts with programs that allow the unskilled user to:
   - Reproduce the analyses
   - Expand the parameters in the model
   - Consider interaction terms
   - Variable functional forms (e.g. collapsed categories, spline terms, etc) 


