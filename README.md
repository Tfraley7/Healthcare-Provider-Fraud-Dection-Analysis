# Healthcare-Provider-Fraud-Dection-Analysis
Analyzing healthcare fraud with PostgreSQL, Pandas, and ML

<br/>
<p align="center">
  <img width="460" height="200" src="Images/Medical.jpeg">
</p>
<br/>

## Introduction

</br>

In the healthcare industry, fraud detection is a crucial aspect of maintaining cost efficiency and high-quality patient care. To address this, a machine learning model was developed to detect fraud in medical claims using a dataset from Kaggle (https://www.kaggle.com/datasets/rohitrox/healthcare-provider-fraud-detection-analysis). This analysis covers the data exploration phase, data cleaning, and model development, with the goal of creating an educational, easily understandable, and inspiring report for recruiters and data scientists.

</br>

## Analysis

</br>

The analysis begins by examining the data provided in CSV files. The data contains three tables: InpatientClaim, OutpatientClaim, and Beneficiary. These tables store information about inpatient and outpatient claims and the beneficiaries, respectively.
During the data exploration phase, SQL queries were performed to answer questions such as:

* Which providers have the highest number of claims?
* What types of procedures are most commonly claimed?
* Which providers have the highest average claim amount?
* Are there any correlations between the different features in the dataset?

The CSV files were then combined and loaded into a pandas DataFrame for further processing.

Machine Learning Model

Before building the machine learning model, the data was preprocessed and cleaned. This included:

* Converting date columns to datetime format
* Handling missing values (NaN) by filling them with appropriate values or replacing them with 'Unknown'
* Checking for duplicate records and removing them if necessary

After cleaning the data, flags were created in the inpatient and outpatient datasets to distinguish between the two types of claims. The inpatient and outpatient datasets were then concatenated to create a unified 'train_claims' dataset.

The 'train_claims' dataset was merged with the 'train_beneficiary' dataset to create a comprehensive 'train_data' dataset. Next, the length of stay for each claim and the total number of chronic conditions for each beneficiary were calculated. These new features can be useful for the machine learning model.

<br/>
<p align="center">
  <img width="460" height="200" src="Images/Correlation.PNG">
</p>
</br>
<br/>
<p align="center">
  <img width="460" height="200" src="Images/Highest_AVG_Claims.PNG">
</p>
<br/>
<br/>
<p align="center">
  <img width="460" height="200" src="Images/Common_Claims.PNG">
</p>
<br/>
<br/>
<p align="center">
  <img width="460" height="200" src="Images/Highest_Claims.PNG">
</p>
<br/>
<br/>

## Preprocessing

</br>

Before training the model, the data was preprocessed as follows:

1. Renamed the 'PotentialFraud' column to 'Fraud' and mapped its values to binary labels (1 for 'Yes' and 0 for 'No').
2. Removed the 'DOD', 'BeneID', and 'ClaimID' columns as they are not relevant to the model.
3. Calculated the claim duration and created a new 'ClaimDuration' column.
4. Created a new 'NumUniquePhysicians' column, which represents the number of unique physicians involved in a claim.
5. Calculated the patient age at the time of the claim and created a new 'PatientAge' column.
6. Removed the 'AdmissionDt' and 'DischargeDt' columns, as they are no longer needed after calculating the claim duration.
7. Split the dataset into features (X) and target (y) variables.

Categorical and numerical columns were then defined and preprocessed separately. For categorical columns, OneHotEncoder and PCA were used to reduce the dimensionality. For numerical columns, the data was standardized using StandardScaler. The results were combined using FeatureUnion.

</br>

## Model Training

The dataset was split into training (80%) and testing (20%) sets. All categorical columns were converted to string data types for both X_train and X_test. A pipeline with the preprocessor and a RandomForestClassifier was built. The pipeline was fit on the training data and predicted the fraud labels on the test set.

</br>

## Evaluation

</br>

The model's performance was evaluated using a classification report and a confusion matrix. The results are as follows:

* Accuracy: 87%
* Precision (Fraud): 0.91
* Recall (Fraud): 0.74
* F1-score (Fraud

The confusion matrix:

* True negatives (TN): 66,199
* False positives (FP): 3,002
* False negatives (FN): 11,069
* True positives (TP): 31,373

</br>

## Conclusion

Our machine learning model demonstrates promising performance in detecting fraudulent medical claims using the given dataset. The RandomForestClassifier achieved an accuracy of 87%, with a precision of 0.91 and a recall of 0.74 for fraud detection. This report has covered the data exploration, preprocessing, model training, and evaluation processes. This model could serve well as a valuable resource for recruiters and data scientists interested in healthcare fraud detection.
