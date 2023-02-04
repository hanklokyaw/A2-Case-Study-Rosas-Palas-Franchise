-- percent work fine

USE H_Accounting;

-- drop store procedure if the table with same name exist
DROP PROCEDURE IF EXISTS H_Accounting.hkyaw_tmp;
DELIMITER $$

-- create store procedure with one paramenter
CREATE PROCEDURE H_Accounting.hkyaw_tmp(varCalendarYear SMALLINT)

-- main store procedure execute
BEGIN

-- create variables for calculations and values storage
-- variables for income statement start
DECLARE varTotalRevenues DOUBLE DEFAULT 0;
DECLARE varTotalCOGS DOUBLE DEFAULT 0;
DECLARE varTotalSellingExpense DOUBLE DEFAULT 0;
DECLARE varTotalOtherExpense DOUBLE DEFAULT 0;
DECLARE varTotalOtherIncome DOUBLE DEFAULT 0;
DECLARE varTotalIncomeTax DOUBLE DEFAULT 0;
DECLARE varTotalRevenuesLastYear DOUBLE DEFAULT 0;
DECLARE varTotalCOGSLastYear DOUBLE DEFAULT 0;
DECLARE varTotalSellingExpenseLastYear DOUBLE DEFAULT 0;
DECLARE varTotalOtherExpenseLastYear DOUBLE DEFAULT 0;
DECLARE varTotalOtherIncomeLastYear DOUBLE DEFAULT 0;
DECLARE varTotalIncomeTaxLastYear DOUBLE DEFAULT 0;
DECLARE varTotalCurrentAssets DOUBLE DEFAULT 0;
DECLARE varTotalFixedAssets DOUBLE DEFAULT 0;
DECLARE varTotalDeferredAssets DOUBLE DEFAULT 0;
DECLARE varTotalCurrentLiabilities DOUBLE DEFAULT 0;
DECLARE varTotalLongTermLiabilities DOUBLE DEFAULT 0;
DECLARE varTotalDeferredLiabilities DOUBLE DEFAULT 0;
DECLARE varTotalEquity DOUBLE DEFAULT 0;
DECLARE varTotalCurrentAssetsLastYear DOUBLE DEFAULT 0;
DECLARE varTotalFixedAssetsLastYear DOUBLE DEFAULT 0;
DECLARE varTotalDeferredAssetsLastYear DOUBLE DEFAULT 0;
DECLARE varTotalCurrentLiabilitiesLastYear DOUBLE DEFAULT 0;
DECLARE varTotalLongTermLiabilitiesLastYear DOUBLE DEFAULT 0;
DECLARE varTotalDeferredLiabilitiesLastYear DOUBLE DEFAULT 0;
DECLARE varTotalEquityLastYear DOUBLE DEFAULT 0;
DECLARE varGrossProfitCurrentYear DOUBLE DEFAULT 0;
DECLARE varOperationProfitCurrentYear DOUBLE DEFAULT 0;
DECLARE varEarningBeforeTaxCurrentYear DOUBLE DEFAULT 0;
DECLARE varNetIncomeCurrentYear DOUBLE DEFAULT 0;
DECLARE varGrossProfitLastYear DOUBLE DEFAULT 0;
DECLARE varOperationProfitLastYear DOUBLE DEFAULT 0;
DECLARE varEarningBeforeTaxLastYear DOUBLE DEFAULT 0;
DECLARE varNetIncomeLastYear DOUBLE DEFAULT 0;
DECLARE varRevenuesChangedPercent DOUBLE DEFAULT 0;
DECLARE varCOGSChangedPercent DOUBLE DEFAULT 0;
DECLARE varGrossProfitChangedPercent DOUBLE DEFAULT 0;
DECLARE varSellingExpenseChangedPercent DOUBLE DEFAULT 0;
DECLARE varOperationProfitChangedPercent DOUBLE DEFAULT 0;
DECLARE varOtherExpenseChangedPercent DOUBLE DEFAULT 0;
DECLARE varOtherIncomeChangedPercent DOUBLE DEFAULT 0;
DECLARE varEarningBeforeTaxChangedPercent DOUBLE DEFAULT 0;
DECLARE varIncomeTaxChangedPercent DOUBLE DEFAULT 0;
DECLARE varNetIncomeChangedPercent DOUBLE DEFAULT 0;
-- income statemenet variables end

-- balancesheet variables start
DECLARE varTotalAssetsCurrentYear DOUBLE DEFAULT 0;
DECLARE varTotalLiabilitiesCurrentYear DOUBLE DEFAULT 0;
DECLARE varLiabilitiesEquityCurrentYear DOUBLE DEFAULT 0;
DECLARE varTotalAssetsLastYear DOUBLE DEFAULT 0;
DECLARE varTotalLiabilitiesLastYear DOUBLE DEFAULT 0;
DECLARE varLiabilitiesEquityLastYear DOUBLE DEFAULT 0;
DECLARE varCurrentAssetsChangedPercent DOUBLE DEFAULT 0;
DECLARE varFixedAssetsChangedPercent DOUBLE DEFAULT 0;
DECLARE varDeferredAssetsChangedPercent DOUBLE DEFAULT 0;
DECLARE varTotalAssetsChangedPercent DOUBLE DEFAULT 0;
DECLARE varCurrentliabilitiesChangedPercent DOUBLE DEFAULT 0;
DECLARE varLongTermLiabilitiesChangedPercent DOUBLE DEFAULT 0;
DECLARE varDefferedLiabilitiesChangedPercent DOUBLE DEFAULT 0;
DECLARE varTotalLiabilitiesChangedPercent DOUBLE DEFAULT 0;
DECLARE varTotalEquityChangedPercent DOUBLE DEFAULT 0;
DECLARE varLiabilitiesEquityChangedPercent DOUBLE DEFAULT 0;
-- balance sheet variables end

-- cash flow statement start
DECLARE varDepreciationCurrentYear DOUBLE DEFAULT 0;
DECLARE varDepreciationLastYear DOUBLE DEFAULT 0;
DECLARE varDepreciationChangedPercent DOUBLE DEFAULT 0;
DECLARE varAccountReceivableCurrentYear DOUBLE DEFAULT 0;
DECLARE varAccountReceivableLastYear DOUBLE DEFAULT 0;
DECLARE varAccountReceivableChangedPercent DOUBLE DEFAULT 0;
DECLARE varAccountPayableCurrentYear DOUBLE DEFAULT 0;
DECLARE varAccountPayableLastYear DOUBLE DEFAULT 0;
DECLARE varAccountPayableChangedPercent DOUBLE DEFAULT 0;
DECLARE varAccountPayableDeferredIncomeCurrentYear DOUBLE DEFAULT 0;
DECLARE varAccountPayableDeferredIncomeLastYear DOUBLE DEFAULT 0;
DECLARE varAccountPayableDeferredIncomeChangedPercent DOUBLE DEFAULT 0;
DECLARE varAccountPayableDebtorCurrentYear DOUBLE DEFAULT 0;
DECLARE varAccountPayableDebtorLastYear DOUBLE DEFAULT 0;
DECLARE varAccountPayableDebtorChangedPercent DOUBLE DEFAULT 0;
DECLARE varNetCashFromOperatingCurrentYear DOUBLE DEFAULT 0;
DECLARE varNetCashFromOperatingLastYear DOUBLE DEFAULT 0;
DECLARE varNetCashFromOperatingDebtorChangedPercent DOUBLE DEFAULT 0;
DECLARE varEquipmentCurrentYear DOUBLE DEFAULT 0;
DECLARE varEquipmentLastYear DOUBLE DEFAULT 0;
DECLARE varEquipmentChangedPercent DOUBLE DEFAULT 0;
DECLARE varNetCashFromInvestingCurrentYear DOUBLE DEFAULT 0;
DECLARE varNetCashFromInvestingLastYear DOUBLE DEFAULT 0;
DECLARE varNetCashFromInvestingDebtorChangedPercent DOUBLE DEFAULT 0;
DECLARE varLoanCurrentYear DOUBLE DEFAULT 0;
DECLARE varLoanLastYear DOUBLE DEFAULT 0;
DECLARE varLoanChangedPercent DOUBLE DEFAULT 0;
DECLARE varEquityCurrentYear DOUBLE DEFAULT 0;
DECLARE varEquityLastYear DOUBLE DEFAULT 0;
DECLARE varEquityChangedPercent DOUBLE DEFAULT 0;
DECLARE varNetCashFromFinancingCurrentYear DOUBLE DEFAULT 0;
DECLARE varNetCashFromFinancingLastYear DOUBLE DEFAULT 0;
DECLARE varNetCashFromFinancingDebtorChangedPercent DOUBLE DEFAULT 0;
DECLARE varCashFlowCurrentYear DOUBLE DEFAULT 0;
DECLARE varCashFlowLastYear DOUBLE DEFAULT 0;
DECLARE varCashFlowChangedPercent DOUBLE DEFAULT 0;
-- cash flow statement end


-- HERE STARTS THE QUERIES TO GET THE P&L FOR CURRENT YEAR START
-- Sum all revenue and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) INTO varTotalRevenues
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "REV"
AND YEAR(je.entry_date) = varCalendarYear
;

-- Sum all cost of goods sold and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalCOGS
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "COGS"
AND YEAR(je.entry_date) = varCalendarYear
;

-- Sum all selling expenses and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalSellingExpense
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "SEXP"
AND YEAR(je.entry_date) = varCalendarYear
;

-- Sum all other expenses and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalOtherExpense
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "OEXP"
AND YEAR(je.entry_date) = varCalendarYear
;

-- Sum all other incomes and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) INTO varTotalOtherIncome
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "OI"
AND YEAR(je.entry_date) = varCalendarYear
;
 
-- Sum all income tax and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalIncomeTax
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "INCTAX"
AND YEAR(je.entry_date) = varCalendarYear
; 
-- P&L FOR CURRENT YEAR QUERIES END


-- HERE STARTS THE QUERIES TO GET THE P&L FOR LAST YEAR

-- Sum all revenue from last year and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) INTO varTotalRevenuesLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "REV"
AND YEAR(je.entry_date) = varCalendarYear - 1
;

-- Sum all cost of good sold from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalCOGSLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "COGS"
AND YEAR(je.entry_date) = varCalendarYear - 1
;
 
-- Sum all selling expense from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalSellingExpenseLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "SEXP"
AND YEAR(je.entry_date) = varCalendarYear - 1
;

-- Sum all other expense last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalOtherExpenseLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "OEXP"
AND YEAR(je.entry_date) = varCalendarYear - 1
;

-- Sum all other income from last year and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) INTO varTotalOtherIncomeLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "OI"
AND YEAR(je.entry_date) = varCalendarYear - 1
;

-- Sum all income tax from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) INTO varTotalIncomeTaxLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.profit_loss_section_id
WHERE ss.statement_section_code = "INCTAX"
AND YEAR(je.entry_date) = varCalendarYear - 1;
-- QUERIES FOR P&L FOR LAST YEAR END
 
-- HERE BEGINS THE QUERIES FOR BALANCE SHEET FOR CURRENT YEAR
-- Sum all current year current assets and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varTotalCurrentAssets
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 61
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all current year Fixed assets and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varTotalFixedAssets
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 62
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all current year Deferred assets and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varTotalDeferredAssets
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 63
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all current year Current Liabilities and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalCurrentLiabilities
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 64
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all current year Long Term Liabilities and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalLongTermLiabilities
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 65
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all current year Deferred liabilities and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalDeferredLiabilities
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 66
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
 -- Sum all current year Equity and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalEquity
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 67
AND ((CASE 
	  WHEN varCalendarYear = 2014 THEN YEAR(je.entry_date) = 2014
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date) = 2019
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 OR YEAR(je.entry_date)= 2020
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- END OF CURRENT YEAR BALANCE SHEET QUERIES

-- HERE BEGINS THE QUERIES FOR BALANCE SHEET FOR LAST YEAR
-- Sum all current assets from last year and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varTotalCurrentAssetsLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 61
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;


-- Sum all Fixed assets from last year and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varTotalFixedAssetsLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 62
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all Deferred assets from last year and store in defined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varTotalDeferredAssetsLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 63
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all Current Liabilities from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalCurrentLiabilitiesLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 64
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all Long Term Liabilities from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalLongTermLiabilitiesLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 65
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- Sum all Deferred liabilities from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalDeferredLiabilitiesLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 66
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
 -- Sum all Equity from last year and store in defined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varTotalEquityLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id = 
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id = 
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON 
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 67
AND ((CASE 
	  WHEN varCalendarYear = 2015 THEN YEAR(je.entry_date) = 2014 
	  WHEN varCalendarYear = 2016 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 
      WHEN varCalendarYear = 2017 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 
      WHEN varCalendarYear = 2018 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 
	  WHEN varCalendarYear = 2019 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 
      WHEN varCalendarYear = 2020 THEN YEAR(je.entry_date) = 2014 OR YEAR(je.entry_date) = 2015 OR YEAR(je.entry_date) = 2016 OR YEAR(je.entry_date) = 2017 OR YEAR(je.entry_date) = 2018 OR YEAR(je.entry_date)= 2019 
        END ))
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1
;
-- LAST YEAR BALANCE SHEET QUERIES END


-- HERE BEGINS ALL QUERIES FOR CASH FLOW STATEMENT

-- current year depreciation query store in predefined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0)  INTO varDepreciationCurrentYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%171%'
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
;

-- last year depreciation query and store in predefined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0)  INTO varDepreciationLastYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%171%'
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
;

-- account receivable current year query and store in predefined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varAccountReceivableCurrentYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%105%'
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
AND journal_type_id = 13;

-- account receivable last year query and store in predefined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varAccountReceivableLastYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%105%'
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
AND journal_type_id = 13;

-- account payable Current Year query and store in predefined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varAccountPayableCurrentYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE balance_sheet_section_id = 64
AND journal_entry NOT LIKE '%loan%'
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
;

-- account payable Last Year  query and store in predefined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varAccountPayableLastYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE balance_sheet_section_id = 64
AND journal_entry NOT LIKE '%loan%'
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
;

-- account payable (deferred income) query and store in predefined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varAccountPayableDeferredIncomeCurrentYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%206%'
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
;

-- account payable (deferred income) last year query and store in predefined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varAccountPayableDeferredIncomeLastYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%206%'
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
;

-- account payable debtor current year  query and store in predefined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varAccountPayableDebtorCurrentYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%107%'
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
;

-- account payable debtor Last year query and store in predefined variable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varAccountPayableDebtorLastYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%107%'
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
;

-- equipment current year query and store in predefined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varEquipmentCurrentYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%15%'
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
AND balance_sheet_section_id = 62;

-- equipment last year query and store in predefined variable
SELECT IFNULL(SUM(jeli.debit),0) - IFNULL(SUM(jeli.credit),0) INTO varEquipmentLastYear
FROM journal_entry AS je
INNER JOIN journal_entry_line_item AS jeli
USING (journal_entry_id)
INNER JOIN account AS ac
USING (account_id)
WHERE account_code LIKE '%15%'
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
AND balance_sheet_section_id = 62;
-- END CASH FLOW STATEMENT QUERIES

-- cash flow for financial operation
-- query for current year sum of loan payable and store in predefined vaiable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varLoanCurrentYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 64
AND YEAR(je.entry_date) = varCalendarYear
AND je.journal_entry LIKE '%loan%'
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1;

-- query for last year sum of loan payable and store in predefined vaiable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varLoanLastYear
FROM H_Accounting.journal_entry_line_item AS jeli
INNER JOIN H_Accounting.`account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN H_Accounting.journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 64
AND YEAR(je.entry_date) = varCalendarYear - 1
AND je.journal_entry LIKE '%loan%'
AND is_balance_sheet_section = 1
AND cancelled = 0
AND debit_credit_balanced = 1;

-- query for current year sum of equity and store in predefined vaiable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varEquityCurrentYear
FROM journal_entry_line_item AS jeli
INNER JOIN `account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 67
AND YEAR(je.entry_date) = varCalendarYear
AND cancelled = 0
;

-- query for last year sum of lequity and store in predefined vaiable
SELECT IFNULL(SUM(jeli.credit),0) - IFNULL(SUM(jeli.debit),0) INTO varEquityLastYear
FROM journal_entry_line_item AS jeli
INNER JOIN `account` AS ac ON ac.account_id =
jeli.account_id
INNER JOIN journal_entry  AS je ON je.journal_entry_id =
jeli.journal_entry_id
INNER JOIN H_Accounting.statement_section AS ss ON
ss.statement_section_id = ac.balance_sheet_section_id
WHERE ss.statement_section_id = 67
AND YEAR(je.entry_date) = varCalendarYear - 1
AND cancelled = 0
;
-- END ALL QUERIES FOR CASH FLOW STATEMENT

-- Use a begin end function to execute calculations
BEGIN

-- calculation for variables using SET function
-- income statement variables calculation start
SET varTotalRevenues = varTotalRevenues/ 1000;
SET varTotalCOGS = varTotalCOGS / 1000;
SET varTotalSellingExpense = varTotalSellingExpense / 1000;
SET varTotalOtherExpense = varTotalOtherExpense / 1000;
SET varTotalOtherIncome = varTotalOtherIncome / 1000;
SET varTotalIncomeTax = varTotalIncomeTax / 1000;
SET varTotalRevenuesLastYear = varTotalRevenuesLastYear/ 1000;
SET varTotalCOGSLastYear = varTotalCOGSLastYear  / 1000;
SET varTotalSellingExpenseLastYear = varTotalSellingExpenseLastYear / 1000;
SET varTotalOtherExpenseLastYear = varTotalOtherExpenseLastYear / 1000;
SET varTotalOtherIncomeLastYear = varTotalOtherIncomeLastYear / 1000;
SET varTotalIncomeTaxLastYear = varTotalIncomeTaxLastYear / 1000;
SET varGrossProfitCurrentYear = varTotalRevenues - varTotalCOGS;
SET varOperationProfitCurrentYear = varGrossProfitCurrentYear - varTotalSellingExpense;
SET varEarningBeforeTaxCurrentYear = varOperationProfitCurrentYear - varTotalOtherExpense + varTotalOtherIncome;
SET varNetIncomeCurrentYear = varEarningBeforeTaxCurrentYear - varTotalIncomeTax;
SET varGrossProfitLastYear = varTotalRevenuesLastYear - varTotalCOGSLastYear;
SET varOperationProfitLastYear =  varGrossProfitLastYear - varTotalSellingExpenseLastYear;
SET varEarningBeforeTaxLastYear = varOperationProfitLastYear - varTotalOtherExpenseLastYear + varTotalOtherIncomeLastYear;
SET varNetIncomeLastYear = varEarningBeforeTaxLastYear - varTotalIncomeTaxLastYear;
SET varRevenuesChangedPercent = ((varTotalRevenues-varTotalRevenuesLastYear) / NULLIF(varTotalRevenuesLastYear,0)) * 100;
SET varCOGSChangedPercent = ((varTotalCOGS-varTotalCOGSLastYear) / NULLIF(varTotalCOGSLastYear,0)) * 100;
SET varGrossProfitChangedPercent = (( varGrossProfitCurrentYear - varGrossProfitLastYear) / NULLIF(varGrossProfitLastYear,0)) * 100;
SET varSellingExpenseChangedPercent =  ((varTotalSellingExpense-varTotalSellingExpenseLastYear) / NULLIF(varTotalSellingExpenseLastYear,0)) * 100;
SET varOperationProfitChangedPercent = ((varOperationProfitCurrentYear-varOperationProfitLastYear) / NULLIF(varOperationProfitLastYear,0)) * 100;
SET varOtherExpenseChangedPercent = ((varTotalOtherExpense-varTotalOtherExpenseLastYear) / NULLIF(varTotalOtherExpenseLastYear,0)) * 100;
SET varOtherIncomeChangedPercent = ((varTotalOtherIncome-varTotalOtherIncomeLastYear) / NULLIF(varTotalOtherIncomeLastYear,0)) * 100;
SET varEarningBeforeTaxChangedPercent =  (varEarningBeforeTaxCurrentYear - varEarningBeforeTaxLastYear) / NULLIF(varEarningBeforeTaxLastYear,0)* 100;
SET varIncomeTaxChangedPercent = ((varTotalIncomeTax- varTotalIncomeTaxLastYear) / NULLIF(varTotalIncomeTaxLastYear,0)) * 100;
SET varNetIncomeChangedPercent = ((varNetIncomeCurrentYear - ABS(varNetIncomeLastYear)) / NULLIF(ABS(varNetIncomeLastYear),0)) * 100;
-- income statement variables calculation end

-- balance sheet variables calculation start
SET varTotalCurrentAssets= varTotalCurrentAssets / 1000;
SET varTotalCurrentAssetsLastYear = varTotalCurrentAssetsLastYear / 1000;
SET varTotalAssetsCurrentYear = varTotalCurrentAssets + varTotalFixedAssets + varTotalDeferredAssets;
SET varTotalCurrentLiabilities = varTotalCurrentLiabilities / 1000;
SET varTotalCurrentLiabilitiesLastYear = varTotalCurrentLiabilitiesLastYear / 1000;
SET varTotalLongTermLiabilities = varTotalLongTermLiabilities / 1000;
SET varTotalLongTermLiabilitiesLastYear = varTotalLongTermLiabilitiesLastYear / 1000;
SET varTotalDeferredLiabilities = varTotalDeferredLiabilities / 1000;
SET varTotalDeferredLiabilitiesLastYear = varTotalDeferredLiabilitiesLastYear / 1000;
SET varTotalLiabilitiesCurrentYear = varTotalCurrentLiabilities + varTotalLongTermLiabilities + varTotalDeferredLiabilities;
SET varTotalEquity = varTotalEquity / 1000;
SET varTotalEquityLastYear = varTotalEquityLastYear / 1000;
SET varLiabilitiesEquityCurrentYear = varTotalLiabilitiesCurrentYear + varTotalEquity;
SET varTotalAssetsLastYear = varTotalCurrentAssetsLastYear + varTotalFixedAssetsLastYear + varTotalDeferredAssetsLastYear;
SET varTotalLiabilitiesLastYear = varTotalCurrentLiabilitiesLastYear + varTotalLongTermLiabilitiesLastYear + varTotalDeferredLiabilitiesLastYear;
SET varLiabilitiesEquityLastYear = varTotalLiabilitiesLastYear + varTotalEquityLastYear;
SET varCurrentAssetsChangedPercent = (varTotalCurrentAssets - varTotalCurrentAssetsLastYear) / NULLIF(varTotalCurrentAssetsLastYear, 0) * 100;
SET varFixedAssetsChangedPercent = (varTotalFixedAssets - varTotalFixedAssetsLastYear) / NULLIF(varTotalFixedAssetsLastYear, 0) * 100;
SET varDeferredAssetsChangedPercent = (varTotalDeferredAssets - varTotalDeferredAssetsLastYear) / NULLIF(varTotalDeferredAssetsLastYear, 0) * 100;
SET varTotalAssetsChangedPercent = (varTotalAssetsCurrentYear -  varTotalAssetsLastYear) /  NULLIF(varTotalAssetsLastYear, 0) * 100;
SET varCurrentliabilitiesChangedPercent = (varTotalCurrentLiabilities - varTotalCurrentLiabilitiesLastYear) / NULLIF(varTotalCurrentLiabilitiesLastYear, 0) * 100;
SET varLongTermLiabilitiesChangedPercent = (varTotalLongTermLiabilities - varTotalLongTermLiabilitiesLastYear) / NULLIF(varTotalLongTermLiabilitiesLastYear, 0) * 100;
SET varDefferedLiabilitiesChangedPercent = (varTotalDeferredLiabilities - varTotalDeferredLiabilitiesLastYear) / NULLIF(varTotalDeferredLiabilitiesLastYear, 0) * 100;
SET varTotalLiabilitiesChangedPercent = (varTotalLiabilitiesCurrentYear - varTotalLiabilitiesLastYear) / NULLIF(varTotalLiabilitiesLastYear, 0) * 100;
SET varTotalEquityChangedPercent = (varTotalEquity - ABS(varTotalEquityLastYear)) / NULLIF(ABS(varTotalEquityLastYear),  0) * 100;
SET varLiabilitiesEquityChangedPercent = (varLiabilitiesEquityCurrentYear - varLiabilitiesEquityLastYear) /  NULLIF(varLiabilitiesEquityLastYear, 0) * 100;
-- balance sheet variables calculation end

-- cash flow statement variables calculation start
SET varDepreciationCurrentYear = varDepreciationCurrentYear / 1000;
SET varDepreciationLastYear = varDepreciationLastYear / 1000;
SET varDepreciationChangedPercent = (varDepreciationCurrentYear - varDepreciationLastYear) / NULLIF(varDepreciationLastYear, 0) * 100;
SET varAccountReceivableCurrentYear = varAccountReceivableCurrentYear/ 1000;
SET varAccountReceivableLastYear =varAccountReceivableLastYear / 1000;
SET varAccountReceivableChangedPercent = (varAccountReceivableCurrentYear - varAccountReceivableLastYear) / NULLIF(varAccountReceivableLastYear, 0) * 100;
-- note account payable are a consolidation of three variables>>  account payable = account payable + deferred income + debtor
SET varAccountPayableCurrentYear = (varAccountPayableCurrentYear + varAccountPayableDeferredIncomeCurrentYear +  varAccountPayableDebtorCurrentYear) / 1000;
SET varAccountPayableLastYear = (varAccountPayableLastYear + varAccountPayableDeferredIncomeLastYear + varAccountPayableDebtorLastYear) / 1000;
SET varAccountPayableChangedPercent = (varAccountPayableCurrentYear - varAccountPayableLastYear) / NULLIF(varAccountPayableLastYear, 0) * 100;
-- deferred income combine with account payable, so disabled the following variables
-- SET varAccountPayableDeferredIncomeCurrentYear = varAccountPayableDeferredIncomeCurrentYear / 1000;
-- SET varAccountPayableDeferredIncomeLastYear = varAccountPayableDeferredIncomeLastYear / 1000;
-- SET varAccountPayableDeferredIncomeChangedPercent = (varAccountPayableDeferredIncomeCurrentYear - varAccountPayableDeferredIncomeCurrentYear) / NULLIF(varAccountPayableDeferredIncomeCurrentYear, 0) * 100;
-- SET varAccountPayableDebtorCurrentYear = varAccountPayableDebtorCurrentYear / 1000;
-- SET varAccountPayableDebtorLastYear = varAccountPayableDebtorLastYear / 1000;
-- SET varAccountPayableDebtorChangedPercent = (varAccountPayableDebtorCurrentYear - varAccountPayableDebtorLastYear) / NULLIF(varAccountPayableDebtorLastYear, 0) * 100;
SET varNetCashFromOperatingCurrentYear = (varNetIncomeCurrentYear + varDepreciationCurrentYear - (varAccountReceivableCurrentYear - varAccountPayableCurrentYear));
SET varNetCashFromOperatingLastYear = (varNetIncomeLastYear + varDepreciationLastYear - (varAccountReceivableLastYear - varAccountPayableLastYear)) ;
SET varNetCashFromOperatingDebtorChangedPercent = (varNetCashFromOperatingCurrentYear - varNetCashFromOperatingLastYear) / NULLIF(ABS(varNetCashFromOperatingLastYear), 0) * 100;
SET varEquipmentCurrentYear = varEquipmentCurrentYear / 1000;
SET varEquipmentLastYear = varEquipmentLastYear / 1000;
SET varEquipmentChangedPercent = (varEquipmentCurrentYear - varEquipmentLastYear) / NULLIF(ABS(varEquipmentLastYear), 0) * 100;
SET varNetCashFromInvestingCurrentYear = - varEquipmentCurrentYear;
SET varNetCashFromInvestingLastYear = - varEquipmentLastYear;
SET varNetCashFromInvestingDebtorChangedPercent = ABS(varEquipmentChangedPercent);
SET varLoanCurrentYear = varLoanCurrentYear / 1000;
SET varLoanLastYear = varLoanLastYear / 1000;
SET varLoanChangedPercent = (varLoanCurrentYear - varLoanLastYear) / NULLIF(ABS(varLoanLastYear), 0) * 100;
SET varEquityCurrentYear = varEquityCurrentYear / 1000;
SET varEquityLastYear = varEquityLastYear / 1000;
SET varEquityChangedPercent = (varEquityCurrentYear - varEquityLastYear) / NULLIF(ABS(varEquityLastYear), 0) * 100;
SET varNetCashFromFinancingCurrentYear = varLoanCurrentYear + varEquityCurrentYear;
SET varNetCashFromFinancingLastYear = varLoanLastYear + varEquityLastYear;
SET varNetCashFromFinancingDebtorChangedPercent = (varNetCashFromFinancingCurrentYear - varNetCashFromFinancingLastYear) / NULLIF(ABS(varNetCashFromFinancingLastYear), 0) * 100;
SET varCashFlowCurrentYear = varNetCashFromOperatingCurrentYear + varNetCashFromInvestingCurrentYear + varNetCashFromFinancingCurrentYear;
SET varCashFlowLastYear = varNetCashFromOperatingLastYear + varNetCashFromInvestingLastYear + varNetCashFromFinancingLastYear;
SET varCashFlowChangedPercent = (varCashFlowCurrentYear - varCashFlowLastYear) / NULLIF(ABS(varCashFlowLastYear), 0) * 100;
-- cash flow statement variables calculation end

END;
 
-- check there the table with the same name exist, if so replace the existing ones
DROP TABLE IF EXISTS H_Accounting.hkyaw_tmp;
  
-- create a new table with necessary columns for income statement, balance sheet, and cash flow statement 
CREATE TABLE H_Accounting.hkyaw_tmp
(profit_loss_line_number INT, 
 label VARCHAR(50), 
     varAmount VARCHAR(50), 
     varAmountLastYear VARCHAR(50), 
     varPercentChange VARCHAR(50),
     seperator CHAR(5),
     balanceSheetLineNumber INT,
     blLabel VARCHAR(50), 
     blAmount VARCHAR(50),
     blAmountLastYear VARCHAR(50), 
     blPercentChange VARCHAR(50),
     seperator2 CHAR(5),
     cashFlowLineNumber INT,
     cfLabel VARCHAR(50), 
     cfAmount VARCHAR(50),
     cfAmountLastYear VARCHAR(50), 
     cfPercentChange VARCHAR(50)
);
  
-- insert table title, and units
  INSERT INTO H_Accounting.hkyaw_tmp
   (profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, 
    balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
    cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES (1, '', "In '000s of USD", "In '000s of USD","In %", "  ||  ", 
		1, '', "In '000s of USD", "In '000s of USD","In %","  ||  ",
        1, '', "In '000s of USD", "In '000s of USD","In %");

-- insert empty line
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, 
 balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
 cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (2, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
	 	 2, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ",
		 2, '----------------------------------------', '--------------------', '--------------------', '--------------');
    
    
-- insert total revenue record, current assets, and net income variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, 
 balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
 cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (3, 'Total Revenues', format(varTotalRevenues, 2), format(varTotalRevenuesLastYear, 2), CONCAT(format(varRevenuesChangedPercent, 2),'%'), "  ||  ", 
		 3,'Current Assets', format(varTotalCurrentAssets, 2), format(varTotalCurrentAssetsLastYear, 2), CONCAT(format(varCurrentAssetsChangedPercent,2),'%'), "  ||  ", 
         3,'Net Income', format(varNetIncomeCurrentYear, 2), format(varNetIncomeLastYear, 2), CONCAT(format(varNetIncomeChangedPercent,2),'%'));


 -- insert total cost of good sold, fixed assets, and depreciation variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (4, 'Total Cost of Good Sold', format(varTotalCOGS, 2), format(varTotalCOGSLastYear, 2), CONCAT(format(varCOGSChangedPercent, 2),'%'), "  ||  ", 
		 4, 'Fixed Assets', format(varTotalFixedAssets / 1000, 2), format(varTotalFixedAssetsLastYear / 1000, 2), CONCAT(format(varFixedAssetsChangedPercent,2),'%'), "  ||  ", 
         4,'Depreciation', format(varDepreciationCurrentYear, 2), format(varDepreciationLastYear, 2), CONCAT(format(varDepreciationChangedPercent,2),'%'));

    
-- insert deferred assets, account receivable variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (5, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
		 5, 'Deferred Assets', format(varTotalDeferredAssets / 1000, 2), format(varTotalDeferredAssetsLastYear / 1000, 2),  CONCAT(format(varDeferredAssetsChangedPercent,2),'%'), "  ||  ", 
         5,'Account Receivable', format(varAccountReceivableCurrentYear, 2), format(varAccountReceivableLastYear, 2), CONCAT(format(varAccountReceivableChangedPercent,2),'%'));
    
    
-- insert gross profit, and account payable variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (6, '   Gross Profit', format(varGrossProfitCurrentYear,2), format(varGrossProfitLastYear,2), CONCAT(format(varGrossProfitChangedPercent,2),'%'),"  ||  ", 
		 6, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
         6,'Account Payable', format(varAccountPayableCurrentYear, 2), format(varAccountPayableLastYear, 2), CONCAT(format(varAccountPayableChangedPercent,2),'%'));
    
    
 -- insert total selling expense record, total assets varialbes 
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (7, 'Selling Expense', format(varTotalSellingExpense, 2), format(varTotalSellingExpenseLastYear, 2), CONCAT(format(varSellingExpenseChangedPercent,2),'%'), "  ||  ",
		 7,'   Total Assets', format(varTotalAssetsCurrentYear, 2), format(varTotalAssetsLastYear, 2), CONCAT(format(varTotalAssetsChangedPercent,2),'%'), "  ||  ", 
         7,'----------------------------------------', '--------------------', '--------------------', '--------------');
    
    
 -- operation cash flow variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (8, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
		 8, '====================', '==========', '==========', '=======', "  ||  ", 
         8, '   Net Cash Flow From Operation', format(varNetCashFromOperatingCurrentYear, 2), format(varNetCashFromOperatingLastYear, 2), CONCAT(format(varNetCashFromOperatingDebtorChangedPercent,2),'%'));



-- insert operating profit variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (9, '   Operating Profit', format(varOperationProfitCurrentYear,2), format(varOperationProfitLastYear,2), CONCAT(format(varOperationProfitChangedPercent,2),'%'),"  ||  ", 
		 9, '', '', '', '', "  ||  ", 
         9, '----------------------------------------', '--------------------', '--------------------', '--------------');
 
 
 -- insert total other expense, current liabilities, and equipments variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (10, 'Total Other Expense', format(varTotalOtherExpense,2), format(varTotalOtherExpenseLastYear,2), CONCAT(format(varOtherExpenseChangedPercent,2),'%'), "  ||  ", 
		 10, 'Current Liabilities',  format(varTotalCurrentLiabilities, 2),  format(varTotalCurrentLiabilitiesLastYear, 2), CONCAT(format(varCurrentliabilitiesChangedPercent,2),'%'), "  ||  ", 
         10, 'Equipments', format(varEquipmentCurrentYear, 2), format(varEquipmentLastYear, 2), CONCAT(format(varEquipmentChangedPercent,2),'%'));
    
    
-- insert total other income, long term liabilities variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (11, 'Total Other Income', format(varTotalOtherIncome,2), format(varTotalOtherIncomeLastYear,2), CONCAT(format(varOtherIncomeChangedPercent,2),'%'),"  ||  ", 
		 11, 'Long Term Liabilities', format(varTotalLongTermLiabilities, 2), format(varTotalLongTermLiabilitiesLastYear, 2), CONCAT(format(varLongTermLiabilitiesChangedPercent,2),'%'), "  ||  ", 
         11, '----------------------------------------', '--------------------', '--------------------', '--------------');
 

 
-- insert defferred liabilities, net cash flow for investing variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (12, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
		 12, 'Deferred Liabilities', format(varTotalDeferredLiabilities, 2), format(varTotalDeferredLiabilitiesLastYear, 2), CONCAT(format(varDefferedLiabilitiesChangedPercent,2),'%'), "  ||  ", 
         12, '   Net Cash Flow From Investing', format(varNetCashFromInvestingCurrentYear, 2), format(varNetCashFromInvestingLastYear, 2), CONCAT(format(varNetCashFromInvestingDebtorChangedPercent,2),'%'));



-- insert earning before tax variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (13, '   Earning Before Tax', format(varEarningBeforeTaxCurrentYear,2), format(varOperationProfitLastYear,2), CONCAT(format(varEarningBeforeTaxChangedPercent,2),'%'), "  ||  ", 
		 13, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
         13, '----------------------------------------', '--------------------', '--------------------', '--------------');
 
 
 
 -- insert total income tax record, total liabilities, and equity variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (14, 'Total Income Tax', format(varTotalIncomeTax,2), format(varTotalIncomeTaxLastYear,2), CONCAT(format(varIncomeTaxChangedPercent,2),'%'),"  ||  ", 
		 14, '   Total Liabilities', format(varTotalLiabilitiesCurrentYear, 2), format(varTotalLiabilitiesLastYear, 2), CONCAT(format(varTotalLiabilitiesChangedPercent,2),'%'), "  ||  ", 
         14, 'Equity', format(varEquityCurrentYear, 2), format(varEquityLastYear, 2), CONCAT(format(varEquityChangedPercent,2),'%'));
    
    
-- iinsert loan pyable variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (15, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
		 15,  '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
         15, 'Loan Payable', format(varLoanCurrentYear, 2), format(varLoanLastYear, 2), CONCAT(format(varLoanChangedPercent,2),'%'));
    
    
    
-- insert net profit variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount, varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (16, '   Net Profit', format(varNetIncomeCurrentYear,2), format(varNetIncomeLastYear,2), CONCAT(format(varNetIncomeChangedPercent,2),'%'),  "  ||  ", 
		 16, '', '', '', '', "  ||  ", 
         16, '----------------------------------------', '--------------------', '--------------------', '--------------');


-- insert total quity, and financing cash flow variables
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (17, '====================', '==========', '==========', '=======', "  ||  ", 
		 17, 'Total Equity', format(varTotalEquity, 2), format(varTotalEquityLastYear, 2), CONCAT(format(varTotalEquityChangedPercent,2),'%'), "  ||  ", 
         17, '   Net Cash Flow From Financing', format(varNetCashFromFinancingCurrentYear, 2), format(varNetCashFromFinancingLastYear, 2), CONCAT(format(varNetCashFromFinancingDebtorChangedPercent,2),'%'));

-- insert horizontal seperation lines 
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (18, '', '-', '', '', "  ||  ", 
		 18, '----------------------------------------', '--------------------', '--------------------', '--------------', "  ||  ", 
         18, '----------------------------------------', '--------------------', '--------------------', '--------------');
    
-- insert liabilities + equity variables    
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (19, '', '-', '', '', "  ||  ", 
		 19, '   LIABILITIES + EQUITY', format(varLiabilitiesEquityCurrentYear, 2), format(varLiabilitiesEquityLastYear, 2), CONCAT(format(varLiabilitiesEquityChangedPercent,2),'%'), "  ||  ", 
         19, '   CURRENT YEAR CASH FLOW', format(varCashFlowCurrentYear, 2), format(varCashFlowLastYear, 2), CONCAT(format(varCashFlowChangedPercent,2),'%'));


 -- insert horizontal seperation line
INSERT INTO H_Accounting.hkyaw_tmp
(profit_loss_line_number, label, varAmount,  varAmountLastYear, varPercentChange, seperator, balanceSheetLineNumber, blLabel, blAmount, blAmountLastYear, blPercentChange, seperator2, 
cashFlowLineNumber, cfLabel, cfAmount, cfAmountLastYear, cfPercentChange)
VALUES  (20, '', '', '', '', "  ||  ", 
		 20, '====================', '==========', '==========', '=======', "  ||  ", 
         20, '====================', '==========', '==========', '=======');


    
END $$
-- END OF MAIN EXECUTION


DELIMITER ;
# THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;
CALL H_Accounting.hkyaw_tmp (2019);

-- named column titles
SELECT 'NO.', 'PROFIT AND LOSS STATEMENT', 'CURRENT YEAR', 'LAST YEAR', '% CHANGE', '  ||  ', 
	   'NO.', 'BALANCE SHEET STATEMENT', 'CURRENT YEAR', 'LAST YEAR', '% CHANGE', '  ||  ',  
       'NO.', 'CASH FLOW STATEMENT', 'CURRENT YEAR', 'LAST YEAR', '% CHANGE'
UNION ALL
SELECT	* FROM H_Accounting.hkyaw_tmp;
