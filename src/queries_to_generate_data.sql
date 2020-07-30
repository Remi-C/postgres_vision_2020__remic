-------------------------------------------------------------------------------
-- Queries for the Postgres Vision 2020 presentation --------------------------

-- About Apple
	-----------------------------
	-- campaign finance: 
	SELECT contribution_name , sum(tran_amount ) as total_donations
	FROM relational_layer_campaign.individual_contribution___clean icc 
	WHERE contribution_name ILIKE 'Apple,%'
	-- 360 people nammed `APPLE` in our db
	GROUP BY contribution_name
	ORDER BY total_donations DESC ; 
	-- 350 contributor
	--		contribution_name       |total_donations|
	--		------------------------|---------------|
	--		APPLE, LARRY            |     $18,658.00|
	--		APPLE, DAVID            |     $15,100.00|
	--		APPLE, JAMES            |     $13,800.00|
	--		APPLE, JAMES G          |     $11,786.00|
	--		APPLE, JIM MR.          |     $10,400.00|
	--		APPLE, EUGENE F         |      $9,600.00|
	--		APPLE, ROBIN GORDON     |      $9,000.00|
	--		APPLE, ROBERT           |      $8,245.00|
	--		APPLE, GARY WINSTON MR. |      $7,877.00|
	--		APPLE, DENISE           |      $7,650.00|
	-- ...
	
SELECT * --city, state, candidate_id, candidate_name
FROM relational_layer_campaign.candidate c 
WHERE candidate_name ILIKE '%Apple%' ; 

	--		city        |state|candidate_id|candidate_name     |
	--		------------|-----|------------|-------------------|
	--		INDEPENDENCE|MO   |H8MO06118   |APPLE, GARY WINSTON|
	--		DUNCAN      |OK   |H4OK04044   |APPLE, ED          |
	--		DUNCAN      |OK   |H4OK04044   |APPLE, ED          |



SELECT *
FROM consolidated_layer_reports.lobbyists l 
WHERE l.lobbyist_consolidated_name ILIKE '%Apple%' ;

----------------------------
Q: You are? | A: John Doe
Q: You like?| A: apple
Q: How much?| A: 5
----------------------------



SELECT *
FROM tiger.place
WHERE name ILIKE '%APPLE %' ; 


SELECT *
FROM relational_layer_campaign.individual_contribution___clean icc 
ORDER BY tran_amount DESC NULLS LAST
LIMIT 100; 

SELECT report_year , max(tran_amount)::numeric::bigint as max_am
FROM relational_layer_campaign.individual_contribution___clean icc 
WHERE tran_type = '10'
GROUP BY report_year
ORDER BY report_year ; 


SELECT *
FROM relational_layer_campaign.committee___clean cc 
WHERE committee_id  = 'C00547349' AND report_year = 2014 

Analyst, OMB Budget Review Division; LA and LD, Sen. Smith
LD, Sen. Collins





SELECT lrrl.*
	, leg.full_name 
	, lob.*
FROM lobbyists_positions__legislators.legislator__rellobbyist___refined_links lrrl 
	INNER JOIN consolidated_layer_bills.legislators as leg  USING (bioguide_id)
	INNER JOIN relational_layer_reports.lobbyists as lob USING (_lobbyist_pk)
ORDER BY lrrl.n_ambiguous_candidate DESC , lrrl.individual_conf  
--WHERE leg.full_name ILIKE 'Kamala%'


Health Policy Advisor, Sen. Frist 95-01Aide, Rep. Harris Fawell, 92

-- President and CEO of Harris Public Interest Consulting, LLC
 
COS, Rep Harris (2005-2007)


SELECT distinct leg.last_name , leg.first_name 
FROM consolidated_layer_bills.legislators leg
	INNER JOIN consolidated_layer_bills.legislators_terms lt USING (bioguide_id)
WHERE leg.last_name ILIKE 'Smith%'
--	AND term_date_interval  && daterange('2005-01-01', '2007-01-01')
	AND leg.birthday > '1940-01-01'
	AND lt.term_type = 's'
	
	
	query lobbyistPerReport {
  reports(first: 10) {
    amount
    reportingYear
    lobbyistsReportsByReportUuid {
      _lobbyist {
        lobbyistConsolidatedName
      }
    }
  }
}


SELECT r.amount , r.reporting_year 
	, lobbyist_consolidated_name 
FROM consolidated_layer_reports.reports as r 
	 JOIN consolidated_layer_reports.lobbyists__reports 
		USING (_report_uuid)
	 JOIN consolidated_layer_reports.lobbyists 
		USING (_lobbyist_uuid) 
ORDER BY _report_uuid ASC
LIMIT 10; 

	

WITH clients_of_interest AS (
	SELECT "_client_uuid" 
	FROM consolidated_layer_reports.clients c 
		NATURAL JOIN lobbying_clients__gvkey.clients__gvkey as c__g  
	WHERE -- client_full_name ILIKE '%EXXON%'
		gvkey = '004503' --'%EXXON%'
)
SELECT _report_uuid, issue_ordi, amount, reporting_year, i.issue_code , i.specific_issue_text 	
, 
FROM clients_of_interest
	INNER JOIN consolidated_layer_reports.reports  as r USING (_client_uuid) 
	INNER JOIN consolidated_layer_reports.issues as i USING (_report_uuid) 
	INNER JOIN lobbying_issues__bill.issue__bill___new ibn  USING (_report_uuid, issue_ordi) 
WHERE i.issue_code = 'ENV'

EXXON : lobbying_activity_report:
'Issues related to regulation of greenhouse gases and climate changes. H.R. 703, the Renewable Fuel Standard Elimination Act....'
'H.R. 1461, Renewable Fuel Standard Elimination Act'
Issues related to regulation of greenhouse gases, climate change, oil spill response and recovery. S. 1195, Renewable Fuel Standard Repeal Act & S. 977, Foreign Fuels Reduction Act, H.R. 1461, Renewable Fuel Standard Elimination Act, H.R. 1462, RFS Reform Act of 2013, issues related to renewable fuel standards.


H.R. 2454, American Clean Energy and Security Act of 2009
H.R. 2868, Chemical Facility Anti-Terrorism Act of 2009, S. 1733, Clean Energy Jobs & American Power Act, S. 2877, CLEAR Act, S.J. Res, 26, Disapproval resolution, S. 3072, Stationary Source Regulations Delay Act
Issues related to domestic access, climate change, carbon taxes and refineries.

S. 697 - Frank Lautenberg Chemical Safety Act for the 21st Century
Provisions in legislation related to the EPA s Ozone Rule

HR 14:  Federal Ocean Acidification Research And Monitoring Act of 2009 (FOARAM Act); Provisions regarding impacts to oil and gas business. HR 146:  Omnibus Public Land Management Act of 2009; Sec. 2002, the establishment of a National Landscape Conservation System and Sec. 3202, the withdrawal of certain land in the Wyoming Range.
HR 232:  Greenhouse Gas Registry Act; Provisions regarding greenhouse gas impacts to oil and gas business, fuels.
HR 391:  To amend the Clean Air Act to provide that greenhouse gases are not subject to the Act, and for other purposes; Provisions regarding impacts to oil and gas business.
HR 469:  Produced Water Utilization Act of 2009; Provisions regarding impacts to oil and gas.
HR 637:  South Orange County Recycled Water Enhancement Act; Provisions regarding access and water used in processes.
HR 1689:  Carbon Capture and Storage Early Deployment Act; Provisions regarding greenhouse gas management.
HR 1760:  Black Carbon Emissions Reduction Act of 2009; Provisions regarding carbon management.
HR 1790:  Forest Carbon Emission Reduction Act; Provisions regarding carbon tax and impacts to oil and gas.
HR 1796:  Residential Carbon Monoxide Poisoning Prevention Act; Provisions regarding phthalate language and other impacts.
HR 1862:  Cap and Dividend Act of 2009; Provisions regarding carbon tax and impacts to oil and gas.
S 173:  Federal Ocean Acidification Research And Monitoring Act of 2009 (FOARAM Act); Provisions regarding the impact of exploration and production.
General discussions and tracking regarding climate principles, carbon tax vs. cap-and trade, and hydraulic fracturing regulations.



SELECT ibn."_report_uuid", ibn.issue_ordi, ibn.congress_session, ibn.bill_id
	, r.amount, r.reporting_year , i.issue_code , i.specific_issue_text , c.client_full_name 
FROM lobbying_issues__bill.issue__bill___new ibn 
	INNER JOIN consolidated_layer_reports.issues as i USING (_report_uuid, issue_ordi) 
	INNER JOIN consolidated_layer_reports.reports  as r USING (_report_uuid) 
	INNER JOIN consolidated_layer_reports.clients as c USING (_client_uuid)
WHERE ibn.bill_id = ROW('h',NULL, 1760)::relational_layer_bills.bill_id_type
	AND congress_session = 111 
 
	CORNING INCORPORATED
H.R.1760, To Mitigate the Effects of Black Carbon Emissions in the United States and
Throughout the World - all sections.


SELECT *
FROM raw___lobby.reports_fxml_fdw rff 
LIMIT 6


-- example layers: xml_file_number : 300345542
 
CREATE TABLE temp_display AS 
SELECT DISTINCT ON (upper(full_name)) "_lobbyist_pk",  full_name, first_name, last_name 
FROM relational_layer_reports.lobbyists l  
WHERE similarity(l.last_name , 'Bradshaw') > 0.9 --Tara
	OR similarity(l.last_name , 'Doney') > 0.9 -- john
	OR word_similarity(l.last_name , 'Steele') > 0.5 --DOnna
	OR word_similarity(l.last_name , 'Flynn') > 0.9 ; --DOnna
ALTER TABLE temp_display ADD PRIMARY KEY (_lobbyist_pk); 
	
	
	SELECT *
	FROM public.temp_display td 
	
	
	SELECt *
	FROM consolidated_layer_reports.lobbyists l 
	WHERE l._lobbyist_uuid = '00eb5bf0-5aca-5d80-a1de-3cf111259595';  

SELECT client_state, count(*) as c 
	--, registrant_zip, registrant_zipext, principal_city, principal_state
FROM relational___lobby.reports___xml rf
GROUP BY client_state
ORDER BY c DESC; 


SELECT similarity('Donna Flynn', 'Donna Steele Flynn')   -- 0.63
	 , similarity('Donna Flynn', 'Donna S. Flynn')       -- 0.86
	 , similarity('Donna S. Flynn', 'Donna Steele Flynn')-- 0.65
 , similarity('Donna Flynn', 'John Doney')				-- 0.15
--

 
 SELECT *
 FROM consolidated___lobby."_lobbyists_distinct" ld 
 WHERE lobbyist_name_cleaned ILIKE '%FLYNN%'
 
 	-- DONNA, FLYNN			2		{ERNST & YOUNG LLP (WASHINGTON COUNCIL ERNST & YOUNG)}	{BUD}					{URBAN, TIM}
 	-- STEELE FLYNN, DONNA	1325	{ERNST & YOUNG LLP (WASHINGTON COUNCIL ERNST & YOUNG)}	{TAX,ENG,RET,BUD,HCR}	{SWONGER, AMY,URBAN, TIM,DONEY, JOHN}

 
 {SWONGER, AMY,DONEY, JOHN,GASPER, GARY,URBAN, TIM,BRADSHAW, TARA}
 
 John DONEY; Tim URBAN; ...
 
 
 
 SELECT *
 FROM relational___lobbying_contributions.ld203_contributions lc 
 	INNER JOIN relational___lobbying_contributions.ld203 USING (ld203_uuid)
 	INNER JOIN consolidated___lobbying_contributions.ld203 as l2 USING (ld203_uuid)
 WHERE lobbyist_last_name IS NULL 
 	AND contributor_name NOT ILIKE '%SELF%'
 	AND is_no_contributions IS NOT TRUE
 	
 	 
 	
 	SELECT *
 	FROM relational_layer_campaign.candidate
 	
 	
 	
