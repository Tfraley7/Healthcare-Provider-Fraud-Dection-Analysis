CREATE TABLE InpatientClaim (
    BeneID VARCHAR(15),
    ClaimID VARCHAR(15),
    ClaimStartDt DATE,
    ClaimEndDt DATE,
    Provider VARCHAR(15),
    InscClaimAmtReimbursed INTEGER,
    AttendingPhysician VARCHAR(15),
    OperatingPhysician VARCHAR(15),
    OtherPhysician VARCHAR(15),
    AdmissionDt DATE,
    ClmAdmitDiagnosisCode VARCHAR(10),
    DeductibleAmtPaid INTEGER NULL,
    DischargeDt DATE,
    DiagnosisGroupCode VARCHAR(15),
    ClmDiagnosisCode_1 VARCHAR(10),
    ClmDiagnosisCode_2 VARCHAR(10),
    ClmDiagnosisCode_3 VARCHAR(10),
    ClmDiagnosisCode_4 VARCHAR(10),
    ClmDiagnosisCode_5 VARCHAR(10),
    ClmDiagnosisCode_6 VARCHAR(10),
    ClmDiagnosisCode_7 VARCHAR(10),
    ClmDiagnosisCode_8 VARCHAR(10),
    ClmDiagnosisCode_9 VARCHAR(10),
    ClmDiagnosisCode_10 VARCHAR(10),
    ClmProcedureCode_1 VARCHAR(10),
    ClmProcedureCode_2 VARCHAR(10),
    ClmProcedureCode_3 VARCHAR(10),
    ClmProcedureCode_4 VARCHAR(10),
    ClmProcedureCode_5 VARCHAR(10),
    ClmProcedureCode_6 VARCHAR(10)
);

CREATE TABLE OutpatientClaim(
    BeneID VARCHAR(15),
    ClaimID VARCHAR(20),
    ClaimStartDt DATE,
    ClaimEndDt DATE,
    Provider VARCHAR(15),
    InscClaimAmtReimbursed INTEGER,
    AttendingPhysician VARCHAR(30) NULL,
    OperatingPhysician VARCHAR(30) NULL,
    OtherPhysician VARCHAR(30) NULL,
    ClmDiagnosisCode_1 VARCHAR(10) NULL,
    ClmDiagnosisCode_2 VARCHAR(10) NULL,
    ClmDiagnosisCode_3 VARCHAR(10) NULL,
    ClmDiagnosisCode_4 VARCHAR(10) NULL,
    ClmDiagnosisCode_5 VARCHAR(10) NULL,
    ClmDiagnosisCode_6 VARCHAR(10) NULL,
    ClmDiagnosisCode_7 VARCHAR(10) NULL,
    ClmDiagnosisCode_8 VARCHAR(10) NULL,
    ClmDiagnosisCode_9 VARCHAR(10) NULL,
    ClmDiagnosisCode_10 VARCHAR(10) NULL,
    ClmProcedureCode_1 VARCHAR(10) NULL,
    ClmProcedureCode_2 VARCHAR(10) NULL,
    ClmProcedureCode_3 VARCHAR(10) NULL,
    ClmProcedureCode_4 VARCHAR(10) NULL,
    ClmProcedureCode_5 VARCHAR(10) NULL,
    ClmProcedureCode_6 VARCHAR(10) NULL,
    DeductibleAmtPaid INTEGER,
    ClmAdmitDiagnosisCode VARCHAR(10) NULL,
    PRIMARY KEY (ClaimID),
    FOREIGN KEY (BeneID) REFERENCES Beneficiary(BeneID)
);




CREATE TABLE Beneficiary (
  BeneID VARCHAR(15) PRIMARY KEY,
  DOB DATE,
  DOD VARCHAR(10),
  Gender VARCHAR(1),
  Race VARCHAR(20),
  RenalDiseaseIndicator VARCHAR(1),
  State VARCHAR(2),
  County VARCHAR(20),
  NoOfMonths_PartACov INTEGER,
  NoOfMonths_PartBCov INTEGER,
  ChronicCond_Alzheimer INTEGER,
  ChronicCond_Heartfailure INTEGER,
  ChronicCond_KidneyDisease INTEGER,
  ChronicCond_Cancer INTEGER,
  ChronicCond_ObstrPulmonary INTEGER,
  ChronicCond_Depression INTEGER,
  ChronicCond_Diabetes INTEGER,
  ChronicCond_IschemicHeart INTEGER,
  ChronicCond_Osteoporasis INTEGER,
  ChronicCond_rheumatoidarthritis INTEGER,
  ChronicCond_stroke INTEGER,
  IPAnnualReimbursementAmt INTEGER,
  IPAnnualDeductibleAmt INTEGER,
  OPAnnualReimbursementAmt INTEGER,
  OPAnnualDeductibleAmt INTEGER
);

-- Which providerss have the highest number of claims?
SELECT Provider, COUNT(*) AS ClaimCount
FROM(
	SELECT Provider FROM inpatientclaim
	UNION ALL
	Select Provider FROM OutpatientClaim
) AS Claims
GROUP BY Provider
ORDER BY ClaimCount DESC;

-- What types of procedures are most commonly claimed?

SELECT ClmProcedureCode, COUNT(*) AS ClaimCount
FROM (
  SELECT ClmProcedureCode_1 AS ClmProcedureCode FROM OutpatientClaim WHERE ClmProcedureCode_1 IS NOT NULL
  UNION ALL
  SELECT ClmProcedureCode_2 AS ClmProcedureCode FROM OutpatientClaim WHERE ClmProcedureCode_2 IS NOT NULL
  UNION ALL
  SELECT ClmProcedureCode_3 AS ClmProcedureCode FROM OutpatientClaim WHERE ClmProcedureCode_3 IS NOT NULL
  UNION ALL
  SELECT ClmProcedureCode_4 AS ClmProcedureCode FROM OutpatientClaim WHERE ClmProcedureCode_4 IS NOT NULL
  UNION ALL
  SELECT ClmProcedureCode_5 AS ClmProcedureCode FROM OutpatientClaim WHERE ClmProcedureCode_5 IS NOT NULL
  UNION ALL
  SELECT ClmProcedureCode_6 AS ClmProcedureCode FROM OutpatientClaim WHERE ClmProcedureCode_6 IS NOT NULL
) AS AllProcedures
GROUP BY ClmProcedureCode
ORDER BY ClaimCount DESC;

-- Which providers have the highest average claim amount?

SELECT Provider, AVG(InscClaimAmtReimbursed) AS AvgClaimAmount
FROM (
  SELECT Provider, InscClaimAmtReimbursed FROM inpatientclaim
  UNION ALL
  SELECT Provider, InscClaimAmtReimbursed FROM outpatientclaim
) AS Claims
GROUP BY Provider
ORDER BY AvgClaimAmount DESC;

--Are there any correlations between the different features in the dataset? 

SELECT corr(InscClaimAmtReimbursed, DeductibleAmtPaid) AS Correlation
FROM(
	SELECT InscClaimAmtReimbursed, DeductibleAmtPaid FROM inpatientclaim
	UNION ALL
	SELECT InscClaimAmtReimbursed, DeductibleAmtPaid FROM outpatientclaim
) AS Claims;

-- Combine all CSVs to be uploaded into pandas

COPY (
    SELECT *
    FROM inpatientclaim
    JOIN outpatientclaim
    ON inpatientclaim.Provider = outpatientclaim.Provider
    JOIN beneficiary -- include beneficiaryclaim in the FROM clause
    ON inpatientclaim.BeneID = beneficiary.BeneID
    AND outpatientclaim.BeneID = beneficiary.BeneID
    JOIN beneficiary
    ON beneficiary.BeneID = beneficiary.BeneID -- update join condition
) TO '/Users/tyronefraley/Desktop/Private work/Healthcare-Provider-Fraud-Dection-Analysis/train_data.csv' WITH (FORMAT CSV, HEADER);
