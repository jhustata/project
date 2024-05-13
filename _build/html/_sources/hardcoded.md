# 6 Nested, Hierarchical, Multilevel, Longitudinal Data

<Details>
   <Summary>Debugging</Summary>

Before diving into nested data, let's visit the concept of [debugging](https://jhustata.github.io/basic/lab5.html#settings) with a simple example from Lab 5 last week.

There’s no perfect time to introduce this topic, but many of you have likely experienced the frustration of encountering an error when running a script—whether it's your own or one shared with you—and not being able to pinpoint the issue.
</Details>

<Details>
   <Summary>Hardcoding</Summary>

Let's briefly [revisit Week 5](https://jhustata.github.io/basic/chapter5.html): Review of Weeks 1 - 4

View the script we used to guide our review:
```stata
cat https://github.com/jhustata/basic/raw/main/review.do
```

Run the script to see its output:
```stata
do https://github.com/jhustata/basic/raw/main/review.do
```

This script creates output into a `.log` file. But HW5 asks you to additionally direct output into a `.xlsx` file. How may we adapt the script to this purpose? Yes, this is the key question of HW5. Many of you may have missed a tip for [HW3](https://jhustata.github.io/basic/chapter3.html#common-mistakes-from-hw1) that recommended "hardcoding" as a template -- a starting place. You may then gradually replace the hardcoded stuff with appropriate macros.

Hardcoding as a firststep. In this example:
1. We use the `ds` command, `not(type string)` option, and `levelsof`. These were only briefly mentioned in class, but were further discussed in [Lab 5 Section 2.2](https://jhustata.github.io/basic/lab5.html#foreach-n-of-numlist)
2. Nested loops and conditional code-blocks (e.g. `if r(r) == 2`) can be very empowering!
3. Gradually **update** your `.do` file script to replace hardcoded stuff (e.g. `catlab`), or stuff that isn't publication worthy (e.g. `v`, which in this example is a variable name) with more appropriate macros or variable labels
4. The HW5 solution will walk you through such a process
5. Copy and paste your `.do` file script into a program. And adapt it to a more general purpose, beyond any specific dataset or variables

```stata
qui {
	cls
	use ${repo}transplants, clear
    ds, not(type string)  
	global threshold 9  
	putexcel set levelsof, replace 
	local row=2
    foreach v of varlist `r(varlist)' {
	    levelsof `v', local(numlevels)
	    if r(r) == 2 {  
			putexcel A`row' = ("`v'") B`row' = ("per")
			local row = `row' + 1
	    }
	    else if inrange(`r(r)', 3, $threshold) {  
			putexcel A`row' = ("`v', %") B`row' = ("")
			foreach l of numlist `numlevels' {
				local row = `row' + 1
                putexcel A`row' = ("    catlab") B`row' = ("per")
			}	
	    }
	    else {  
			putexcel A`row' = ("`v'") B`row' = ("m_iqr")
			local row = `row' + 1
	    }
		
    }
	
}
```
##### GPT-4 Session:

**User:** help add comments/annotation [paste the above script into ChatGPTs prompt]

**ChatGPT:** Sure, I can help you add comments and annotations to your Stata code to make it more understandable. Here’s your code with comments explaining each part:

```stata
qui {  // Quietly execute the following block of code
    cls  // Clear the screen
    use ${repo}transplants, clear  // Load dataset from specified repository and clear any previous data in memory
    ds, not(type string)  // List all variables that are not of string type
    global threshold 9  // Set a global threshold value of 9
    putexcel set levelsof, replace  // Set the Excel file for output with the name 'levelsof', replace if exists
    local row=2  // Initialize row variable for Excel output starting at row 2

    foreach v of varlist `r(varlist)' {  // Loop over the variables listed by the previous 'ds' command
        levelsof `v', local(numlevels)  // Get the levels of each variable and store them in local 'numlevels'
        if r(r) == 2 {  // If there are exactly two levels for the variable
            putexcel A`row' = ("`v'") B`row' = ("per")  // Write variable name in column A and 'per' in column B of Excel
            local row = `row' + 1  // Increment the Excel row counter
        }
        else if inrange(`r(r)', 3, $threshold) {  // If the number of levels is between 3 and the threshold
            putexcel A`row' = ("`v', %") B`row' = ("")  // Write variable name with a percent sign in column A, leave column B empty
            foreach l of numlist `numlevels' {  // Loop through each level of the variable
                local row = `row' + 1  // Increment row before writing
                putexcel A`row' = ("    catlab") B`row' = ("per")  // Indent 'catlab' in column A, write 'per' in column B
            }   
        }
        else {  // If the number of levels exceeds the threshold
            putexcel A`row' = ("`v'") B`row' = ("m_iqr")  // Write variable name in column A and 'm_iqr' in column B
            local row = `row' + 1  // Increment the row counter
        }
    }
}
```

In this script, you're using a combination of `putexcel` commands and conditional logic to format and export information about variable levels from Stata to an Excel file. This can be very useful for data review and verification processes.

</Details>

## 6.1 `isid`
Enough with `levelsof`. While this powerful command investigates levels within a variable, this weeks focus will shift towards levels within a dataset:
- Visits
- Patient
- Hospital
- Region

#### `i.i.d.`
Classical statistics assumes each observation is [independently sampled and identically distributed](https://en.wikipedia.org/wiki/Independent_and_identically_distributed_random_variables#:~:text=In%20probability%20theory%20and%20statistics,i.i.d.%2C%20iid%2C%20or%20IID.)

Nested, multilevel, longitudinal, or hierarchical data (these terms are variations on a theme) violate this assumption. And we are going to discuss how to manipulate data to generate group-level statistics, which are often of interest in a **public** health setting. 

Individual-level variables are more important to **clinical** medicine, which also deals with hierarchical data over time. A patient or care provider is concerned, not about their status 20 years ago, or last year, but today, and, more important, [tomorrow and tomorrow and tomorrow](https://en.wikipedia.org/wiki/Tomorrow_and_tomorrow_and_tomorrow)! Some would call that a "time-series". The unit of analysis becomes the person-time rather than the person.

The topic is beyond the scope of this class, as mentioned at the outset in our [philosophy](https://jhustata.github.io/basic/chapter1.html#know-be-reverent). But we'll give you tools with which to recognize hierarchical data and manipulate them to suit your analytic purposes.

## 6.2 `collapse`
All analyses are an attempt at [dimentionality reduction](https://en.wikipedia.org/wiki/Dimensionality_reduction#:~:text=Dimensionality%20reduction%2C%20or%20dimension%20reduction,close%20to%20its%20intrinsic%20dimension.). When you describe "the average age", or "median blood pressre", or "count (i.e., `N`)" you are reducing the dimensions of your data (i.e., `c(N)` & `c(k)`) to one or a few numbers. 

That one or those few numbers are then used as "representative" of the group. One way to think of such a "group mean" or "group average" is to think of the negative connotations that come with "a group stereotype". Individuals from that group may consider it an injustice to be defined by the "group-average" rather than their own average. 

But even an individual may consider it an injustice to be defined by their past, when that represented but a stage in their ever-evolving persona. 

It is within this spirit that I hope you appreciate just how an observation or individual can be nested within a larger group of observations.

[White coat hypertension](https://www.ahajournals.org/doi/full/10.1161/HYPERTENSIONAHA.113.01275?utm_version=158565909) is a classical example. It may fit the [ICD-10-CM Diagnosis Code R03. 0: Elevated blood-pressure reading, without diagnosis of hypertension](https://www.icd10data.com/ICD10CM/Codes/R00-R99/R00-R09/R03-/R03.0#:~:text=2024%20ICD%2D10%2DCM%20Diagnosis,reading%2C%20without%20diagnosis%20of%20hypertension). Yet there is no consensus as to the importance of that specific `person-time`

So always ask yourself whenever you are doing an analysis: is this hierchical data? Or was it initially hierarchical, but was collapsed for convenience of analysis? 

Human beings have a powerful, incurable urge for dimentionality reduction. Your task is to take into consideration the biases introduced by this process, the variances eroded by homogenious statistics, and the threats to valid statistical, clinical, and public health inferences.

## 6.3 `egen`
## 6.4 `preserve`, `restore`
## 6.5 `merge`
## 6.6 `reshape`
## 6.8 Lab
## 6.9 Homework

For your Jupyter Book notes on nested, hierarchical, multilevel, and longitudinal data, I suggest adding detailed explanations and practical examples to deepen students' understanding. Below is an expanded version of your existing notes with added content, structured annotations, and explanations tailored for each section. This should make it easier for your students to follow along and grasp the complex concepts presented.

```markdown
# Week 6: Nested, Hierarchical, Multilevel, Longitudinal Data

## Introduction to Debugging
<details>
<summary>Click to expand!</summary>

Before diving into nested data, let's revisit the concept of debugging with a simple example from Lab 5 last week.

There’s no perfect time to introduce this topic, but many of you have likely experienced the frustration of encountering an error when running a script—whether it's your own or one shared with you—and not being able to pinpoint the issue. Understanding debugging early on will aid in handling complex data structures more efficiently.

Refer to the detailed debugging steps here: [Lab 5 Debugging Section](https://jhustata.github.io/basic/lab5.html#settings)

</details>

## Revisiting Hardcoding
<details>
<summary>Click to expand!</summary>

Last week, we reviewed the basics from Weeks 1 to 4. Let's look at the script we used and discuss how it can be adapted for different outputs, moving from `.log` files to `.xlsx` files.

Review the script here: [Week 5 Review](https://jhustata.github.io/basic/chapter5.html)

```stata
cat https://github.com/jhustata/basic/raw/main/review.do
do https://github.com/jhustata/basic/raw/main/review.do
```

Hardcoding can be a useful starting point, but it's essential to evolve your scripts to be dynamic and adaptable to different datasets and requirements. This involves using macros and avoiding fixed variable names or parameters wherever possible.

Example adaptations for homework and further discussion are included in HW5, which emphasizes replacing hardcoded components with flexible code suited for publication-quality outputs.

</details>

## 6.1 Understanding `isid`
Moving away from `levelsof`, we focus on understanding how data is structured within datasets. This week's themes revolve around different levels of data:
- Visits
- Patient
- Hospital
- Region

The `isid` command is crucial for ensuring data integrity and understanding the unique identifiers across these levels.

## Independently and Identically Distributed Data (i.i.d.)
Classical statistics often assumes each observation is independently and identically distributed (i.i.d.). However, nested and multilevel data often violate this assumption, necessitating different analytical approaches.

Explore the i.i.d. assumption in detail here: [i.i.d. in Statistics](https://en.wikipedia.org/wiki/Independent_and_identically_distributed_random_variables)

## 6.2 The Concept of `collapse`
When you describe aggregates like the average age or median blood pressure, you're reducing the dimensionality of your data. This simplification, while useful, can sometimes obscure the nuances of individual data points or subgroups.

The `collapse` command in Stata helps in reducing data dimensions to essential summaries, but it's crucial to be aware of the biases this might introduce, especially in hierarchical data settings.

## 6.3 Use of `egen`
The `egen` command is incredibly powerful for creating complex summaries and transformations across grouped data. We'll explore several practical examples of `egen` to handle multilevel data efficiently.

## 6.4 Data Integrity with `preserve` and `restore`
Understanding how to safely manipulate datasets without losing original data is critical. The `preserve` and `restore` commands allow for temporary changes to the data, ensuring that the original structure and content are not permanently altered.

## 6.5 Combining Data with `merge`
Merging datasets is a common task in data analysis, especially when dealing with longitudinal or multilevel data. We will cover best practices and common pitfalls in merging datasets from different sources or time points.

## 6.6 Flexible Data Structures with `reshape`
The `reshape` command allows for switching between wide and long formats, which is particularly useful in longitudinal studies where time-point data may need to be restructured for analysis.

## 6.8 Lab Session
This week's lab will involve hands-on exercises using real datasets to apply the concepts learned about nested and hierarchical data.

## 6.9 Homework
Homework will focus on practical applications of `merge`, `collapse`, and `reshape`, challenging students to manipulate and analyze a provided dataset with hierarchical structures.


