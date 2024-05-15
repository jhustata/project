
# Research Pearl
- At the invitation of Henry Zhao, one of the students at the Welch Center
- He's also been enrolled in the Stata I & II classes I've taught this Spring
- The Stata II class has focused on remote work directories on GitHub:
   - For version control of documents that will be iteratively improved
   - Seamless collaboration with team members who are local (Hopkins) and remote (Anywhere)
   - Open and Transparent methods that are very easy for others to emulate, critique, and improve
- I believe its because of some of these reasons that he invited me to this research pearl
- So without further [ado](https://muzaale.github.io/center/intro.html) (pun very much intended) ...

```stata
global repo https://github.com/jhustata/project/raw/main/
do ${repo}welchcenter.do
```

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


