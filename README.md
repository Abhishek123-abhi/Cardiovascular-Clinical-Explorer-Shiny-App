# Cardiovascular Clinical Explorer

## Overview

The **Cardiovascular Clinical Explorer** is an interactive R Shiny dashboard developed to explore cardiovascular risk factors using demographic, clinical, and lifestyle variables.

The application demonstrates clinical data exploration, risk stratification, and statistical visualization while maintaining a simple and interpretable structure suitable for healthcare analytics and clinical data review.

This project focuses on question-driven analysis rather than isolated visualizations and demonstrates how interactive tools can support exploratory clinical data analysis.

---

## Project Objectives

This project was designed to answer the following clinical questions:

- What is the overall cardiovascular risk distribution in the population?
- Do smokers show higher cardiovascular risk compared to non-smokers?
- How does blood pressure status affect cardiovascular risk?
- Is there a relationship between age and cholesterol levels?
- Do overweight individuals show different cholesterol patterns?
- How do clinical variables interact with calculated cardiovascular risk?

---

## Dataset Description

The dataset contains cardiovascular indicators commonly used in exploratory cardiovascular risk assessment.

| Variable | Description |
|----------|-------------|
| AgeAtStart | Patient age |
| Sex | Gender |
| Cholesterol | Cholesterol measurement |
| Chol_Status | Cholesterol category |
| Systolic | Systolic blood pressure |
| Diastolic | Diastolic blood pressure |
| BP_Status | Blood pressure category |
| Smoking_Status | Smoking behavior |
| Weight_Status | Weight category |

---

## Risk Model

A simple cardiovascular risk score was developed using major clinical risk indicators:

| Risk Factor | Score |
|-------------|-------|
| High BP | +1 |
| High Cholesterol | +1 |
| Smoking | +1 |
| Overweight | +1 |

### Risk Category Definition

| Risk Score | Risk Category |
|------------|---------------|
| 0 | Low |
| 1–2 | Moderate |
| 3–4 | High |

This simplified model demonstrates basic cardiovascular risk stratification logic for exploratory analysis purposes.

---

## Application Features

### Population Filtering

Users can interactively filter the dataset based on:

- Gender
- Smoking status
- Blood pressure status
- Weight category
- Age range

This enables subgroup exploration similar to population stratification performed during clinical data review.

---

### Statistical Summary

The application provides descriptive statistics for key clinical variables including:

- Number of observations
- Mean
- Standard deviation
- Median
- Minimum
- Maximum

This reflects baseline descriptive summaries commonly used in clinical datasets.

---

### Risk Dashboard

The dashboard visualizes:

- Overall cardiovascular risk distribution
- Risk distribution by smoking status
- Risk distribution by blood pressure status

These visualizations help identify patterns in cardiovascular risk factors.

---

### Clinical Relationship Explorer

An interactive scatter plot allows users to:

- Select X and Y variables
- Choose grouping variable for color
- Select bubble size variable
- Explore relationships between clinical measurements

This supports exploratory analysis of relationships between cardiovascular indicators.

---

## Key Insights

Based on exploratory analysis of the dataset:

- Most patients fall into the **moderate cardiovascular risk category**.
- A substantial proportion of patients fall into the **high risk category**, indicating notable cardiovascular risk burden.
- Higher smoking intensity is associated with a greater proportion of high cardiovascular risk scores.
- Patients with high blood pressure show substantially higher cardiovascular risk compared to normal or optimal BP groups.
- A modest positive relationship exists between age and cholesterol levels.
- Overweight individuals show higher average cholesterol levels compared to normal weight individuals.
- Male patients show a higher proportion of high cardiovascular risk compared to female patients.

These findings represent descriptive patterns observed in the dataset and do not imply causation.

---

## Technologies Used

- R
- Shiny
- dplyr
- ggplot2
- shinythemes
- psych

---

## How to Run the Application

### Install required packages

```r
install.packages("shiny")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("shinythemes")
install.packages("psych")
