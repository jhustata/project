// Clear previous settings
cls 

qui {
    // 0. settings
    noi di "What is your work directory?" _request(workdir)
    cd $workdir
    capture mkdir demo

    // 1. data
    global repo "https://github.com/jhustata/project/raw/main/"
    global nhanes "https://wwwn.cdc.gov/Nchs/Nhanes/"

    // 2. code
    do ${repo}followup.do
    save demo/followup, replace 
    import sasxport5 "${nhanes}1999-2000/DEMO.XPT", clear
    merge 1:1 seqn using demo/followup, nogen
    save demo/survey_followup, replace 

    // 3. parameters
    import sasxport5 "${nhanes}1999-2000/HUQ.XPT", clear
    tab huq010 
    merge 1:1 seqn using demo/survey_followup, nogen keep(matched)
    rm demo/followup.dta
    rm demo/survey_followup.dta
    gen years = permth_int / 12
    stset years, fail(mortstat)
    replace huq010 = . if huq010 == 9
    label define huq 1 "Excellent" 2 "Very Good" 3 "Good" 4 "Fair" 5 "Poor"
    label values huq010 huq 
    levelsof huq010, local(numlevels)
    
    local i = 1
    foreach l of numlist `numlevels' {
        local vallab: value label huq010 
        local catlab: label `vallab' `l'
        global legend`i' = "`catlab'"
        local i = `i' + 1
    }
    
    save demo/nhanes, replace 

    // 4. Kaplan-Meier survival analysis
    #delimit ;
    sts graph,  
        by(huq010)  
        fail  
        per(100) 
        ylab(0(20)80, format(%2.0f))  
        xlab(0(5)20)  
        tmax(20)  
        ti("Self-Reported Health and 20-Year Mortality, %")  
		yti("")
		xti("Years")
        legend(order(5 4 3 2 1)  
               lab(1 "$legend1")  
               lab(2 "$legend2")  
               lab(3 "$legend3") 
               lab(4 "$legend4")  
               lab(5 "$legend5")  
               ring(0) pos(11)) 
    ;
    #delimit cr
    graph export demo/nonpara.png, replace 

    // 5. Cox proportional hazards model
    stcox i.huq010, basesurv(s0)
    sort _t s0
    list _t s0 in 1/20
    keep _t s0
    save demo/s0, replace 
}
