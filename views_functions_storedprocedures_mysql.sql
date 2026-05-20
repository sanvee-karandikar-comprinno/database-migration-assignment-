
-- Views conversion from MS-SQL to MySQL

-- View: humanresources_vemployee

CREATE VIEW humanresources_vemployee AS
SELECT
    e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    p.additionalcontactinfo
FROM humanresources_employee e
INNER JOIN person_person p
    ON p.businessentityid = e.businessentityid
INNER JOIN person_businessentityaddress bea
    ON bea.businessentityid = e.businessentityid
INNER JOIN person_address a
    ON a.addressid = bea.addressid
INNER JOIN person_stateprovince sp
    ON sp.stateprovinceid = a.stateprovinceid
INNER JOIN person_countryregion cr
    ON cr.countryregioncode = sp.countryregioncode
LEFT JOIN person_personphone pp
    ON pp.businessentityid = p.businessentityid
LEFT JOIN person_phonenumbertype pnt
    ON pp.phonenumbertypeid = pnt.phonenumbertypeid
LEFT JOIN person_emailaddress ea
    ON p.businessentityid = ea.businessentityid;


Select * from humanresources_vemployee      -- Example to query the view 


-- View: humanresources_vemployeedepartmenthistory

CREATE VIEW humanresources_vemployeedepartmenthistory AS
SELECT
    e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    s.name AS shift,
    d.name AS department,
    d.groupname,
    edh.startdate,
    edh.enddate
FROM humanresources_employee e
INNER JOIN person_person p
    ON p.businessentityid = e.businessentityid
INNER JOIN humanresources_employeedepartmenthistory edh
    ON e.businessentityid = edh.businessentityid
INNER JOIN humanresources_department d
    ON edh.departmentid = d.departmentid
INNER JOIN humanresources_shift s
    ON s.shiftid = edh.shiftid;


Select * from humanresources_vemployeedepartmenthistory    -- Example to query the view 


-- View: humanresources_vjobcandidate

CREATE OR REPLACE VIEW humanresources_vjobcandidate AS
SELECT
    jc.jobcandidateid,
    jc.businessentityid,

    ExtractValue(clean_xml, '//Name/Name.Prefix') AS name_prefix,
    ExtractValue(clean_xml, '//Name/Name.First') AS name_first,
    ExtractValue(clean_xml, '//Name/Name.Middle') AS name_middle,
    ExtractValue(clean_xml, '//Name/Name.Last') AS name_last,
    ExtractValue(clean_xml, '//Name/Name.Suffix') AS name_suffix,
    ExtractValue(clean_xml, '//Skills') AS skills,
    ExtractValue(clean_xml, '//Address/Addr.Type') AS addr_type,
    ExtractValue(clean_xml, '//Address/Addr.Location/Location/Loc.CountryRegion') AS addr_countryregion,
    ExtractValue(clean_xml, '//Address/Addr.Location/Location/Loc.State') AS addr_state,
    ExtractValue(clean_xml, '//Address/Addr.Location/Location/Loc.City') AS addr_city,
    ExtractValue(clean_xml, '//Address/Addr.PostalCode') AS addr_postalcode,
    ExtractValue(clean_xml, '//EMail') AS email,
    ExtractValue(clean_xml, '//WebSite') AS website,
    jc.modifieddate
FROM (
    SELECT
        jobcandidateid,
        businessentityid,
        modifieddate,

        REPLACE(
            REPLACE(
                resume,
                'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"',
                ''
            ),
            'ns:',
            ''
        ) AS clean_xml
    FROM humanresources_jobcandidate
) jc;


Select * from humanresources_vjobcandidate      -- Example to query the view 


-- View: humanresources_vjobcandidateeducation

CREATE OR REPLACE VIEW humanresources_vjobcandidateeducation AS

SELECT
    jobcandidateid,

    ExtractValue(clean_xml, '//Education[1]/Edu.Level') AS edu_level,

    STR_TO_DATE(
        REPLACE(ExtractValue(clean_xml, '//Education[1]/Edu.StartDate'), 'Z', ''),
        '%Y-%m-%d'
    ) AS edu_startdate,

    STR_TO_DATE(
        REPLACE(ExtractValue(clean_xml, '//Education[1]/Edu.EndDate'), 'Z', ''),
        '%Y-%m-%d'
    ) AS edu_enddate,

    ExtractValue(clean_xml, '//Education[1]/Edu.Degree') AS edu_degree,
    ExtractValue(clean_xml, '//Education[1]/Edu.Major') AS edu_major,
    ExtractValue(clean_xml, '//Education[1]/Edu.Minor') AS edu_minor,
    ExtractValue(clean_xml, '//Education[1]/Edu.GPA') AS edu_gpa,
    ExtractValue(clean_xml, '//Education[1]/Edu.GPAScale') AS edu_gpascale,
    ExtractValue(clean_xml, '//Education[1]/Edu.School') AS edu_school,

    ExtractValue(clean_xml, '//Education[1]/Edu.Location/Location/Loc.CountryRegion') AS edu_countryregion,
    ExtractValue(clean_xml, '//Education[1]/Edu.Location/Location/Loc.State') AS edu_state,
    ExtractValue(clean_xml, '//Education[1]/Edu.Location/Location/Loc.City') AS edu_city

FROM (
    SELECT
        jobcandidateid,
        REPLACE(
            REPLACE(
                resume,
                'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"',
                ''
            ),
            'ns:',
            ''
        ) AS clean_xml
    FROM humanresources_jobcandidate
) t

UNION ALL

SELECT
    jobcandidateid,

    ExtractValue(clean_xml, '//Education[2]/Edu.Level') AS edu_level,

    STR_TO_DATE(
        REPLACE(ExtractValue(clean_xml, '//Education[2]/Edu.StartDate'), 'Z', ''),
        '%Y-%m-%d'
    ) AS edu_startdate,

    STR_TO_DATE(
        REPLACE(ExtractValue(clean_xml, '//Education[2]/Edu.EndDate'), 'Z', ''),
        '%Y-%m-%d'
    ) AS edu_enddate,

    ExtractValue(clean_xml, '//Education[2]/Edu.Degree') AS edu_degree,
    ExtractValue(clean_xml, '//Education[2]/Edu.Major') AS edu_major,
    ExtractValue(clean_xml, '//Education[2]/Edu.Minor') AS edu_minor,
    ExtractValue(clean_xml, '//Education[2]/Edu.GPA') AS edu_gpa,
    ExtractValue(clean_xml, '//Education[2]/Edu.GPAScale') AS edu_gpascale,
    ExtractValue(clean_xml, '//Education[2]/Edu.School') AS edu_school,

    ExtractValue(clean_xml, '//Education[2]/Edu.Location/Location/Loc.CountryRegion') AS edu_countryregion,
    ExtractValue(clean_xml, '//Education[2]/Edu.Location/Location/Loc.State') AS edu_state,
    ExtractValue(clean_xml, '//Education[2]/Edu.Location/Location/Loc.City') AS edu_city

FROM (
    SELECT
        jobcandidateid,
        REPLACE(
            REPLACE(
                resume,
                'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"',
                ''
            ),
            'ns:',
            ''
        ) AS clean_xml
    FROM humanresources_jobcandidate
) t
WHERE ExtractValue(clean_xml, '//Education[2]/Edu.Level') IS NOT NULL
  AND ExtractValue(clean_xml, '//Education[2]/Edu.Level') <> '';


Select * from humanresources_vjobcandidateeducation


-- View: humanresources_vjobcandidateemployment


CREATE OR REPLACE VIEW humanresources_vjobcandidateemployment AS

SELECT * FROM (

SELECT
    jobcandidateid,
    1 AS employment_no,

    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[1]/Emp.StartDate'),'Z',''), '%Y-%m-%d') AS emp_startdate,
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[1]/Emp.EndDate'),'Z',''), '%Y-%m-%d') AS emp_enddate,
    ExtractValue(clean_xml, '//Employment[1]/Emp.OrgName') AS emp_orgname,
    ExtractValue(clean_xml, '//Employment[1]/Emp.JobTitle') AS emp_jobtitle,
    ExtractValue(clean_xml, '//Employment[1]/Emp.Responsibility') AS emp_responsibility,
    ExtractValue(clean_xml, '//Employment[1]/Emp.FunctionCategory') AS emp_functioncategory,
    ExtractValue(clean_xml, '//Employment[1]/Emp.IndustryCategory') AS emp_industrycategory,
    ExtractValue(clean_xml, '//Employment[1]/Emp.Location/Location/Loc.CountryRegion') AS emp_countryregion,
    ExtractValue(clean_xml, '//Employment[1]/Emp.Location/Location/Loc.State') AS emp_state,
    ExtractValue(clean_xml, '//Employment[1]/Emp.Location/Location/Loc.City') AS emp_city
FROM (
    SELECT
        jobcandidateid,
        REPLACE(
            REPLACE(
                resume,
                'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"',
                ''
            ),
            'ns:',
            ''
        ) AS clean_xml
    FROM humanresources_jobcandidate
) t

UNION ALL

SELECT
    jobcandidateid,
    2,
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[2]/Emp.StartDate'),'Z',''), '%Y-%m-%d'),
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[2]/Emp.EndDate'),'Z',''), '%Y-%m-%d'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.OrgName'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.JobTitle'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.Responsibility'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.FunctionCategory'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.IndustryCategory'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.Location/Location/Loc.CountryRegion'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.Location/Location/Loc.State'),
    ExtractValue(clean_xml, '//Employment[2]/Emp.Location/Location/Loc.City')
FROM (
    SELECT
        jobcandidateid,
        REPLACE(REPLACE(resume,
            'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"', ''),
            'ns:', '') AS clean_xml
    FROM humanresources_jobcandidate
) t

UNION ALL

SELECT
    jobcandidateid,
    3,
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[3]/Emp.StartDate'),'Z',''), '%Y-%m-%d'),
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[3]/Emp.EndDate'),'Z',''), '%Y-%m-%d'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.OrgName'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.JobTitle'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.Responsibility'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.FunctionCategory'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.IndustryCategory'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.Location/Location/Loc.CountryRegion'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.Location/Location/Loc.State'),
    ExtractValue(clean_xml, '//Employment[3]/Emp.Location/Location/Loc.City')
FROM (
    SELECT
        jobcandidateid,
        REPLACE(REPLACE(resume,
            'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"', ''),
            'ns:', '') AS clean_xml
    FROM humanresources_jobcandidate
) t

UNION ALL

SELECT
    jobcandidateid,
    4,
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[4]/Emp.StartDate'),'Z',''), '%Y-%m-%d'),
    STR_TO_DATE(REPLACE(ExtractValue(clean_xml, '//Employment[4]/Emp.EndDate'),'Z',''), '%Y-%m-%d'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.OrgName'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.JobTitle'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.Responsibility'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.FunctionCategory'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.IndustryCategory'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.Location/Location/Loc.CountryRegion'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.Location/Location/Loc.State'),
    ExtractValue(clean_xml, '//Employment[4]/Emp.Location/Location/Loc.City')
FROM (
    SELECT
        jobcandidateid,
        REPLACE(REPLACE(resume,
            'xmlns:ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"', ''),
            'ns:', '') AS clean_xml
    FROM humanresources_jobcandidate
) t

) final_result
WHERE emp_startdate IS NOT NULL;


Select * from humanresources_vjobcandidateemployment   -- Example to query the view


-- View: person_vadditionalcontactinfo

CREATE OR REPLACE VIEW person_vadditionalcontactinfo AS
SELECT
    p.businessentityid,
    p.firstname,
    p.middlename,
    p.lastname,

    ExtractValue(clean_xml, '//telephoneNumber/number') AS telephonenumber,

    TRIM(
        ExtractValue(clean_xml, '//telephoneNumber/SpecialInstructions')
    ) AS telephonespecialinstructions,

    ExtractValue(clean_xml, '//homePostalAddress/Street') AS street,
    ExtractValue(clean_xml, '//homePostalAddress/City') AS city,
    ExtractValue(clean_xml, '//homePostalAddress/StateProvince') AS stateprovince,
    ExtractValue(clean_xml, '//homePostalAddress/PostalCode') AS postalcode,
    ExtractValue(clean_xml, '//homePostalAddress/CountryRegion') AS countryregion,

    ExtractValue(clean_xml, '//homePostalAddress/SpecialInstructions')
        AS homeaddressspecialinstructions,

    ExtractValue(clean_xml, '//eMail/eMailAddress') AS emailaddress,

    TRIM(
        ExtractValue(clean_xml, '//eMail/SpecialInstructions')
    ) AS emailspecialinstructions,

    ExtractValue(
        clean_xml,
        '//eMail/SpecialInstructions/telephoneNumber/number'
    ) AS emailtelephonenumber,

    p.rowguid,
    p.modifieddate

FROM (
    SELECT
        businessentityid,
        firstname,
        middlename,
        lastname,
        rowguid,
        modifieddate,

        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        additionalcontactinfo,
                        'xmlns:ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"',
                        ''
                    ),
                    'xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"',
                    ''
                ),
                'ci:',
                ''
            ),
            'act:',
            ''
        ) AS clean_xml

    FROM person_person
    WHERE additionalcontactinfo IS NOT NULL
) p;


Select * from person_vadditionalcontactinfo    -- Example to query the view 

-- View: person_vstateprovincecountryregion

CREATE OR REPLACE VIEW person_vstateprovincecountryregion AS
SELECT
    sp.stateprovinceid,
    sp.stateprovincecode,
    sp.isonlystateprovinceflag,
    sp.name AS stateprovincename,
    sp.territoryid,
    cr.countryregioncode,
    cr.name AS countryregionname
FROM person_stateprovince sp
INNER JOIN person_countryregion cr
    ON sp.countryregioncode = cr.countryregioncode;

Select * from person_vstateprovincecountryregion     -- Example to query the view


-- View: production_vproductanddescription

CREATE OR REPLACE VIEW production_vproductanddescription AS
SELECT
    p.productid,
    p.name,
    pm.name AS productmodel,
    pmx.cultureid,
    pd.description
FROM production_product p
INNER JOIN production_productmodel pm
    ON p.productmodelid = pm.productmodelid
INNER JOIN production_productmodelproductdescriptionculture pmx
    ON pm.productmodelid = pmx.productmodelid
INNER JOIN production_productdescription pd
    ON pmx.productdescriptionid = pd.productdescriptionid;


Select * from production_vproductanddescription       -- Example to query the view


-- View: production_vproductmodelcatalogdescription

CREATE OR REPLACE VIEW production_vproductmodelcatalogdescription AS
SELECT
    productmodelid,
    name,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</Summary>', 1),
        '<p>',
        -1
    ) AS summary,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</Manufacturer>', 1),
        '<Name>',
        -1
    ) AS manufacturer,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</Copyright>', 1),
        '<Copyright>',
        -1
    ) AS copyright_text,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</ProductURL>', 1),
        '<ProductURL>',
        -1
    ) AS producturl,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</WarrantyPeriod>', 1),
        '<WarrantyPeriod>',
        -1
    ) AS warrantyperiod,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</NoOfYears>', 1),
        '<NoOfYears>',
        -1
    ) AS noofyears,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</wheel>', 1),
        '<wheel>',
        -1
    ) AS wheel,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</saddle>', 1),
        '<saddle>',
        -1
    ) AS saddle,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</pedal>', 1),
        '<pedal>',
        -1
    ) AS pedal,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</BikeFrame>', 1),
        '<BikeFrame>',
        -1
    ) AS bikeframe,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</Material>', 1),
        '<Material>',
        -1
    ) AS material,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</Color>', 1),
        '<Color>',
        -1
    ) AS color,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</ProductLine>', 1),
        '<ProductLine>',
        -1
    ) AS productline,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</Style>', 1),
        '<Style>',
        -1
    ) AS style,

    SUBSTRING_INDEX(
        SUBSTRING_INDEX(clean_xml, '</RiderExperience>', 1),
        '<RiderExperience>',
        -1
    ) AS riderexperience,

    rowguid,
    modifieddate

FROM (
    SELECT
        productmodelid,
        name,
        rowguid,
        modifieddate,
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(catalogdescription, '\\"', '"'),
                    'p1:', ''
                ),
                'html:', ''
            ),
            'wm:', ''
        ) AS clean_xml
    FROM production_productmodel
    WHERE catalogdescription IS NOT NULL
) t;


Select * from production_vproductmodelcatalogdescription       -- Example to query the view


-- View: production_vproductmodelinstructions

CREATE OR REPLACE VIEW production_vProductModelInstructions AS
SELECT
    pm.ProductModelID,
    pm.Name,

    EXTRACTVALUE(pm.Instructions, '/root') AS Instructions,

    CAST(EXTRACTVALUE(pm.Instructions, '/root/Location[1]/@LocationID') AS UNSIGNED) AS LocationID,

    CAST(EXTRACTVALUE(pm.Instructions, '/root/Location[1]/@SetupHours') AS DECIMAL(9,4)) AS SetupHours,

    CAST(EXTRACTVALUE(pm.Instructions, '/root/Location[1]/@MachineHours') AS DECIMAL(9,4)) AS MachineHours,

    CAST(EXTRACTVALUE(pm.Instructions, '/root/Location[1]/@LaborHours') AS DECIMAL(9,4)) AS LaborHours,

    CAST(EXTRACTVALUE(pm.Instructions, '/root/Location[1]/@LotSize') AS UNSIGNED) AS LotSize,

    TRIM(EXTRACTVALUE(pm.Instructions, '/root/Location[1]/step[1]')) AS Step,

    pm.rowguid,
    pm.ModifiedDate

FROM Production_ProductModel pm;


Select * from production_vProductModelInstructions         -- Example to query the view


-- View: purchasing_vvendorwithaddresses

CREATE VIEW Purchasing_vVendorWithAddresses AS
SELECT
    v.BusinessEntityID,
    v.Name,
    at.Name AS AddressType,
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    sp.Name AS StateProvinceName,
    a.PostalCode,
    cr.Name AS CountryRegionName
FROM Purchasing_Vendor v
INNER JOIN Person_BusinessEntityAddress bea
    ON bea.BusinessEntityID = v.BusinessEntityID
INNER JOIN Person_Address a
    ON a.AddressID = bea.AddressID
INNER JOIN Person_StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN Person_CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
INNER JOIN Person_AddressType at
    ON at.AddressTypeID = bea.AddressTypeID;

Select * from Purchasing_vVendorWithAddresses               -- Example to query the view


-- View: purchasing_vvendorwithcontacts

CREATE VIEW Purchasing_vVendorWithContacts AS
SELECT
    v.BusinessEntityID,
    v.Name,
    ct.Name AS ContactType,
    p.Title,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    p.Suffix,
    pp.PhoneNumber,
    pnt.Name AS PhoneNumberType,
    ea.EmailAddress,
    p.EmailPromotion
FROM Purchasing_Vendor v
INNER JOIN Person_BusinessEntityContact bec
    ON bec.BusinessEntityID = v.BusinessEntityID
INNER JOIN Person_ContactType ct
    ON ct.ContactTypeID = bec.ContactTypeID
INNER JOIN Person_Person p
    ON p.BusinessEntityID = bec.PersonID
LEFT JOIN Person_EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;
    

Select * from Purchasing_vVendorWithContacts                  -- Example to query the view


-- View: sales_vindividualcustomer

CREATE VIEW Sales_vIndividualCustomer AS
SELECT
    p.BusinessEntityID,
    p.Title,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    p.Suffix,
    pp.PhoneNumber,
    pnt.Name AS PhoneNumberType,
    ea.EmailAddress,
    p.EmailPromotion,
    at.Name AS AddressType,
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    sp.Name AS StateProvinceName,
    a.PostalCode,
    cr.Name AS CountryRegionName,
    p.Demographics
FROM Person_Person p
INNER JOIN Person_BusinessEntityAddress bea
    ON bea.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person_Address a
    ON a.AddressID = bea.AddressID
INNER JOIN Person_StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN Person_CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
INNER JOIN Person_AddressType at
    ON at.AddressTypeID = bea.AddressTypeID
INNER JOIN Sales_Customer c
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person_EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID
WHERE c.StoreID IS NULL;


Select * from Sales_vIndividualCustomer                    -- Example to query the view


-- View: sales_vpersondemographics

CREATE VIEW Sales_vPersonDemographics AS
SELECT
    p.BusinessEntityID,

    ExtractValue(p.Demographics,
        '/IndividualSurvey/TotalPurchaseYTD') AS TotalPurchaseYTD,

    STR_TO_DATE(
        REPLACE(
            ExtractValue(p.Demographics,
                '/IndividualSurvey/DateFirstPurchase'),
            'Z', ''
        ),
        '%Y-%m-%dT%H:%i:%s'
    ) AS DateFirstPurchase,

    STR_TO_DATE(
        REPLACE(
            ExtractValue(p.Demographics,
                '/IndividualSurvey/BirthDate'),
            'Z', ''
        ),
        '%Y-%m-%dT%H:%i:%s'
    ) AS BirthDate,

    ExtractValue(p.Demographics,
        '/IndividualSurvey/MaritalStatus') AS MaritalStatus,

    ExtractValue(p.Demographics,
        '/IndividualSurvey/YearlyIncome') AS YearlyIncome,

    ExtractValue(p.Demographics,
        '/IndividualSurvey/Gender') AS Gender,

    CAST(
        ExtractValue(p.Demographics,
            '/IndividualSurvey/TotalChildren')
        AS UNSIGNED
    ) AS TotalChildren,

    CAST(
        ExtractValue(p.Demographics,
            '/IndividualSurvey/NumberChildrenAtHome')
        AS UNSIGNED
    ) AS NumberChildrenAtHome,

    ExtractValue(p.Demographics,
        '/IndividualSurvey/Education') AS Education,

    ExtractValue(p.Demographics,
        '/IndividualSurvey/Occupation') AS Occupation,

    CAST(
        ExtractValue(p.Demographics,
            '/IndividualSurvey/HomeOwnerFlag')
        AS UNSIGNED
    ) AS HomeOwnerFlag,

    CAST(
        ExtractValue(p.Demographics,
            '/IndividualSurvey/NumberCarsOwned')
        AS UNSIGNED
    ) AS NumberCarsOwned

FROM Person_Person p
WHERE p.Demographics IS NOT NULL;


Select * from Sales_vPersonDemographics                -- Example to query the view


-- View: sales_vsalesperson

CREATE VIEW Sales_vSalesPerson AS
SELECT
    s.BusinessEntityID,
    p.Title,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    p.Suffix,
    e.JobTitle,
    pp.PhoneNumber,
    pnt.Name AS PhoneNumberType,
    ea.EmailAddress,
    p.EmailPromotion,
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    sp.Name AS StateProvinceName,
    a.PostalCode,
    cr.Name AS CountryRegionName,
    st.Name AS TerritoryName,
    st.`Group` AS TerritoryGroup,
    s.SalesQuota,
    s.SalesYTD,
    s.SalesLastYear
FROM Sales_SalesPerson s
INNER JOIN HumanResources_Employee e
    ON e.BusinessEntityID = s.BusinessEntityID
INNER JOIN Person_Person p
    ON p.BusinessEntityID = s.BusinessEntityID
INNER JOIN Person_BusinessEntityAddress bea
    ON bea.BusinessEntityID = s.BusinessEntityID
INNER JOIN Person_Address a
    ON a.AddressID = bea.AddressID
INNER JOIN Person_StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN Person_CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
LEFT JOIN Sales_SalesTerritory st
    ON st.TerritoryID = s.TerritoryID
LEFT JOIN Person_EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;

    
Select * from Sales_vSalesPerson                    -- Example to query the view


-- View: sales_vsalespersonsalesbyfiscalyears

CREATE VIEW Sales_vSalesPersonSalesByFiscalYears AS
SELECT
    soh.SalesPersonID,
    CONCAT(
        p.FirstName, ' ',
        COALESCE(p.MiddleName, ''), ' ',
        p.LastName
    ) AS FullName,
    e.JobTitle,
    st.Name AS SalesTerritory,

    SUM(
        CASE
            WHEN YEAR(DATE_ADD(soh.OrderDate, INTERVAL 6 MONTH)) = 2002
            THEN soh.SubTotal
            ELSE 0
        END
    ) AS `2002`,

    SUM(
        CASE
            WHEN YEAR(DATE_ADD(soh.OrderDate, INTERVAL 6 MONTH)) = 2003
            THEN soh.SubTotal
            ELSE 0
        END
    ) AS `2003`,

    SUM(
        CASE
            WHEN YEAR(DATE_ADD(soh.OrderDate, INTERVAL 6 MONTH)) = 2004
            THEN soh.SubTotal
            ELSE 0
        END
    ) AS `2004`

FROM Sales_SalesPerson sp
INNER JOIN Sales_SalesOrderHeader soh
    ON sp.BusinessEntityID = soh.SalesPersonID
INNER JOIN Sales_SalesTerritory st
    ON sp.TerritoryID = st.TerritoryID
INNER JOIN HumanResources_Employee e
    ON soh.SalesPersonID = e.BusinessEntityID
INNER JOIN Person_Person p
    ON p.BusinessEntityID = sp.BusinessEntityID

GROUP BY
    soh.SalesPersonID,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    e.JobTitle,
    st.Name;
    
    
    
Select * from Sales_vSalesPersonSalesByFiscalYears           -- Example to query the view


-- View: sales_vstorewithaddresses

CREATE VIEW Sales_vStoreWithAddresses AS
SELECT
    s.BusinessEntityID,
    s.Name,
    at.Name AS AddressType,
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    sp.Name AS StateProvinceName,
    a.PostalCode,
    cr.Name AS CountryRegionName
FROM Sales_Store s
INNER JOIN Person_BusinessEntityAddress bea
    ON bea.BusinessEntityID = s.BusinessEntityID
INNER JOIN Person_Address a
    ON a.AddressID = bea.AddressID
INNER JOIN Person_StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
INNER JOIN Person_CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
INNER JOIN Person_AddressType at
    ON at.AddressTypeID = bea.AddressTypeID;
    
    
Select * from Sales_vStoreWithAddresses                     -- Example to query the view


-- View: sales_vstorewithcontacts

CREATE VIEW Sales_vStoreWithContacts AS
SELECT
    s.BusinessEntityID,
    s.Name,
    ct.Name AS ContactType,
    p.Title,
    p.FirstName,
    p.MiddleName,
    p.LastName,
    p.Suffix,
    pp.PhoneNumber,
    pnt.Name AS PhoneNumberType,
    ea.EmailAddress,
    p.EmailPromotion
FROM Sales_Store s
INNER JOIN Person_BusinessEntityContact bec
    ON bec.BusinessEntityID = s.BusinessEntityID
INNER JOIN Person_ContactType ct
    ON ct.ContactTypeID = bec.ContactTypeID
INNER JOIN Person_Person p
    ON p.BusinessEntityID = bec.PersonID
LEFT JOIN Person_EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Person_PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;
    
    
Select * from Sales_vStoreWithContacts                            -- Example to query the view


-- View: sales_vstorewithdemographics

CREATE VIEW Sales_vStoreWithDemographics AS
SELECT
    s.BusinessEntityID,
    s.Name,

    ExtractValue(s.Demographics,
        '/StoreSurvey/AnnualSales') AS AnnualSales,

    ExtractValue(s.Demographics,
        '/StoreSurvey/AnnualRevenue') AS AnnualRevenue,

    ExtractValue(s.Demographics,
        '/StoreSurvey/BankName') AS BankName,

    ExtractValue(s.Demographics,
        '/StoreSurvey/BusinessType') AS BusinessType,

    CAST(
        ExtractValue(s.Demographics,
            '/StoreSurvey/YearOpened')
        AS UNSIGNED
    ) AS YearOpened,

    ExtractValue(s.Demographics,
        '/StoreSurvey/Specialty') AS Specialty,

    CAST(
        ExtractValue(s.Demographics,
            '/StoreSurvey/SquareFeet')
        AS UNSIGNED
    ) AS SquareFeet,

    ExtractValue(s.Demographics,
        '/StoreSurvey/Brands') AS Brands,

    ExtractValue(s.Demographics,
        '/StoreSurvey/Internet') AS Internet,

    CAST(
        ExtractValue(s.Demographics,
            '/StoreSurvey/NumberEmployees')
        AS UNSIGNED
    ) AS NumberEmployees

FROM Sales_Store s;


Select * from Sales_vStoreWithDemographics                       -- Example to query the view





-- Functions converted from MS-SQL to MySQL 

-- Function: ufn_get_document_status_text

CREATE FUNCTION ufn_get_document_status_text(p_status INT)
RETURNS VARCHAR(16)
DETERMINISTIC
RETURN CASE p_status
    WHEN 1 THEN 'Pending approval'
    WHEN 2 THEN 'Approved'
    WHEN 3 THEN 'Obsolete'
    ELSE '** Invalid **'
END;

SELECT ufn_get_document_status_text(3)           -- Example to query the function


--  Function: ufn_get_stock

DELIMITER $$

CREATE FUNCTION ufn_get_stock(p_productid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ret INT;

    SELECT COALESCE(SUM(quantity), 0)
    INTO ret
    FROM production_productinventory
    WHERE productid = p_productid
      AND locationid = 6;  -- Only look at inventory in the misc storage

    RETURN ret;
END$$

DELIMITER ;

SELECT ufn_get_stock(1)                      -- Example to query the function


-- Function: ufn_leading_zeros

CREATE FUNCTION ufn_leading_zeros(p_value INT)
RETURNS VARCHAR(8) DETERMINISTIC
BEGIN
    -- LPAD pads the string on the left with '0' to a total length of 8
    RETURN LPAD(p_value, 8, '0');
END$$

DELIMITER ;

SELECT ufn_leading_zeros(123);                -- Example to query the function

-- Function: ufnGetAccountingEndDate

CREATE FUNCTION ufnGetAccountingEndDate()
RETURNS DATETIME(3)
DETERMINISTIC
RETURN TIMESTAMP('2004-07-01 00:00:00.000') - INTERVAL 2 MICROSECOND;


SELECT ufnGetAccountingEndDate();                 -- Example to query the function


-- Function: ufnGetAccountingStartDate

CREATE FUNCTION ufnGetAccountingStartDate()
RETURNS DATETIME
DETERMINISTIC
BEGIN
    RETURN TIMESTAMP('2003-07-01 00:00:00'); 


SELECT ufnGetAccountingStartDate();                  -- Example to query the function


-- Function: ufnGetProductDealerPrice

DELIMITER $$

CREATE FUNCTION ufnGetProductDealerPrice(
    p_productid INT,
    p_orderdate DATETIME
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE dealer_price DECIMAL(10,2);

    SELECT plph.listprice * 0.60
    INTO dealer_price
    FROM production_product p
    JOIN production_productlistpricehistory plph
        ON p.productid = plph.productid
    WHERE p.productid = p_productid
      AND p_orderdate BETWEEN plph.startdate
          AND COALESCE(plph.enddate, '9999-12-31')
    LIMIT 1;

    RETURN dealer_price;
END$$

DELIMITER ;


SELECT ufnGetProductDealerPrice(711, '2024-01-01');    -- Example to query the function



-- Function: ufnGetProductListPrice


DELIMITER $$

CREATE FUNCTION ufnGetProductListPrice(
    p_productid INT,
    p_orderdate DATETIME
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE list_price DECIMAL(10,2);

    SELECT plph.listprice
    INTO list_price
    FROM production_product p
    JOIN production_productlistpricehistory plph
        ON p.productid = plph.productid
    WHERE p.productid = p_productid
      AND p_orderdate BETWEEN plph.startdate
          AND COALESCE(plph.enddate, '9999-12-31')
    ORDER BY plph.startdate DESC
    LIMIT 1;

    RETURN list_price;
END$$

DELIMITER ;

SELECT ufnGetProductListPrice(711, '2024-01-01');             -- Example to query the function


-- Function: ufnGetProductStandardCost

DELIMITER $$

CREATE FUNCTION ufnGetProductStandardCost(
    p_productid INT,
    p_orderdate DATETIME
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE standard_cost DECIMAL(10,2);

    SELECT pch.standardcost
    INTO standard_cost
    FROM production_productcosthistory pch
    WHERE pch.productid = p_productid
      AND p_orderdate BETWEEN pch.startdate
          AND COALESCE(pch.enddate, '9999-12-31')
    ORDER BY pch.startdate DESC
    LIMIT 1;

    RETURN standard_cost;
END$$

DELIMITER ;

SELECT ufnGetProductStandardCost(711, '2024-01-01');              -- Example to query the function


-- Function: ufnGetPurchaseOrderStatusText

CREATE FUNCTION ufnGetPurchaseOrderStatusText(p_status INT)
RETURNS VARCHAR(15)
DETERMINISTIC
    RETURN CASE p_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Complete'
        ELSE '** Invalid **'
    END;


SELECT ufnGetPurchaseOrderStatusText(21);           -- Example to query the function


-- Function: ufnGetSalesOrderStatus

CREATE FUNCTION ufnGetSalesOrderStatus(p_status INT)
RETURNS VARCHAR(16)
DETERMINISTIC 
    RETURN CASE p_status 
		WHEN 1 THEN 'In process'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Backordered'
        WHEN 4 THEN 'Rejected'
        WHEN 5 THEN 'Shipped'
        WHEN 6 THEN 'Cancelled'
        ELSE '**Invalid**'
	END;

SELECT ufnGetSalesOrderStatus(12);                          -- Example to query the function






-- Stored procedures converted from MS-SQL to MySQL

-- Procedure: hr_uspUpdateEmployeeLogin

DELIMITER $$

CREATE PROCEDURE hr_uspUpdateEmployeeLogin(
    IN p_BusinessEntityID INT,
    IN p_OrganizationNode VARCHAR(255),  -- MySQL has no hierarchyid
    IN p_LoginID VARCHAR(256),
    IN p_JobTitle VARCHAR(50),
    IN p_HireDate DATETIME,
    IN p_CurrentFlag BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Assuming you have a logging procedure similar to uspLogError
        CALL uspLogError();
    END;

    UPDATE HumanResources.Employee
    SET OrganizationNode = p_OrganizationNode,
        LoginID = p_LoginID,
        JobTitle = p_JobTitle,
        HireDate = p_HireDate,
        CurrentFlag = p_CurrentFlag
    WHERE BusinessEntityID = p_BusinessEntityID;
END$$

DELIMITER ;


-- Procedure: hr_uspUpdateEmployeePersonalInfo

DELIMITER $$

CREATE PROCEDURE hr_uspUpdateEmployeePersonalInfo(
    IN p_BusinessEntityID INT,
    IN p_NationalIDNumber VARCHAR(15),
    IN p_BirthDate DATETIME,
    IN p_MaritalStatus CHAR(1),
    IN p_Gender CHAR(1)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Assuming you have a logging procedure similar to uspLogError
        CALL uspLogError();
    END;

    UPDATE HumanResources.Employee
    SET NationalIDNumber = p_NationalIDNumber,
        BirthDate = p_BirthDate,
        MaritalStatus = p_MaritalStatus,
        Gender = p_Gender
    WHERE BusinessEntityID = p_BusinessEntityID;
END$$

DELIMITER ;


-- Procedure: log_ddl_command

-- Create a logging table
CREATE TABLE database_log (
    post_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    database_user VARCHAR(100),
    event VARCHAR(50),
    schema_name VARCHAR(100),
    object_name VARCHAR(100),
    ddl_command TEXT
);

-- Example: Wrapper procedure to log DDL statements
DELIMITER $$

CREATE PROCEDURE log_ddl_command(
    IN p_event VARCHAR(50),
    IN p_schema_name VARCHAR(100),
    IN p_object_name VARCHAR(100),
    IN p_ddl_command TEXT
)
BEGIN
    INSERT INTO database_log(
        post_time,
        database_user,
        event,
        schema_name,
        object_name,
        ddl_command
    ) VALUES (
        NOW(),
        CURRENT_USER(),
        p_event,
        p_schema_name,
        p_object_name,
        p_ddl_command
    );
END$$

DELIMITER ;


-- Procedure: ufn_get_contact_information

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ufn_get_contact_information`(IN p_personid INT)
BEGIN

    IF p_personid IS NULL THEN
        SELECT NULL AS PersonID,
               NULL AS FirstName,
               NULL AS LastName,
               NULL AS JobTitle,
               NULL AS BusinessEntityType;
    END IF;

    -- Employee
    IF EXISTS (
        SELECT 1
        FROM humanresources_employee e
        WHERE e.businessentityid = p_personid
    ) THEN
        SELECT
            p_personid AS PersonID,
            p.firstname,
            p.lastname,
            e.jobtitle,
            'Employee' AS BusinessEntityType
        FROM humanresources_employee e
        JOIN person_person p
            ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = p_personid;
    END IF;

    -- Vendor Contact
    IF EXISTS (
        SELECT 1
        FROM purchasing_vendor v
        JOIN person_businessentitycontact bec
            ON bec.businessentityid = v.businessentityid
        WHERE bec.personid = p_personid
    ) THEN
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            ct.name,
            'Vendor Contact'
        FROM purchasing_vendor v
        JOIN person_businessentitycontact bec
            ON bec.businessentityid = v.businessentityid
        JOIN person_contacttype ct
            ON ct.contacttypeid = bec.contacttypeid
        JOIN person_person p
            ON p.businessentityid = bec.personid
        WHERE bec.personid = p_personid;
    END IF;

    -- Store Contact
    IF EXISTS (
        SELECT 1
        FROM sales_store s
        JOIN person_businessentitycontact bec
            ON bec.businessentityid = s.businessentityid
        WHERE bec.personid = p_personid
    ) THEN
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            ct.name,
            'Store Contact'
        FROM sales_store s
        JOIN person_businessentitycontact bec
            ON bec.businessentityid = s.businessentityid
        JOIN person_contacttype ct
            ON ct.contacttypeid = bec.contacttypeid
        JOIN person_person p
            ON p.businessentityid = bec.personid
        WHERE bec.personid = p_personid;
    END IF;

    -- Consumer
    IF EXISTS (
        SELECT 1
        FROM sales_customer c
        JOIN person_person p
            ON p.businessentityid = c.personid
        WHERE p.businessentityid = p_personid
          AND c.storeid IS NULL
    ) THEN
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            NULL AS JobTitle,
            'Consumer' AS BusinessEntityType
        FROM person_person p
        JOIN sales_customer c
            ON c.personid = p.businessentityid
        WHERE p.businessentityid = p_personid
          AND c.storeid IS NULL;
    END IF;

END$$
DELIMITER ;


-- Procedure: usp_get_bill_of_materials

CREATE PROCEDURE usp_get_bill_of_materials(
    IN p_start_product_id INT,
    IN p_check_date DATE
)
BEGIN
    -- Recursive CTE
    WITH RECURSIVE bom_cte AS (
        -- Anchor
        SELECT 
            b.productassemblyid,
            b.componentid,
            p.name AS componentdesc,
            b.perassemblyqty,
            p.standardcost,
            p.listprice,
            b.bomlevel,
            0 AS recursionlevel
        FROM production_billofmaterials b
        JOIN production_product p
            ON b.componentid = p.productid
        WHERE b.productassemblyid = p_start_product_id
          AND p_check_date >= b.startdate
          AND p_check_date <= IFNULL(b.enddate, p_check_date)

        UNION ALL

        -- Recursive member
        SELECT
            b.productassemblyid,
            b.componentid,
            p.name AS componentdesc,
            b.perassemblyqty,
            p.standardcost,
            p.listprice,
            b.bomlevel,
            cte.recursionlevel + 1
        FROM bom_cte cte
        JOIN production_billofmaterials b
            ON b.productassemblyid = cte.componentid
        JOIN production_product p
            ON b.componentid = p.productid
        WHERE p_check_date >= b.startdate
          AND p_check_date <= IFNULL(b.enddate, p_check_date)
    )
    SELECT 
        b.productassemblyid,
        b.componentid,
        b.componentdesc,
        SUM(b.perassemblyqty) AS totalquantity,
        b.standardcost,
        b.listprice,
        b.bomlevel,
        b.recursionlevel
    FROM bom_cte b
    GROUP BY b.componentid, b.componentdesc, b.productassemblyid, b.bomlevel, b.recursionlevel, b.standardcost, b.listprice
    ORDER BY b.bomlevel, b.productassemblyid, b.componentid;
END $$

DELIMITER ;



-- Procedure: usp_get_employee_managers

DELIMITER $$

CREATE PROCEDURE usp_get_employee_managers(
    IN p_businessentityid INT
)
BEGIN

    WITH RECURSIVE emp_cte AS (

        -- Anchor employee
        SELECT
            e.businessentityid,
            e.organizationnode,
            p.firstname,
            p.lastname,
            e.jobtitle,
            0 AS recursionlevel
        FROM humanresources_employee e
        JOIN person_person p
            ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = p_businessentityid

        UNION ALL

        -- Recursive manager lookup
        SELECT
            mgr.businessentityid,
            mgr.organizationnode,
            pp.firstname,
            pp.lastname,
            mgr.jobtitle,
            cte.recursionlevel + 1
        FROM humanresources_employee mgr
        JOIN emp_cte cte
            ON mgr.organizationnode =
               SUBSTRING_INDEX(
                   TRIM(TRAILING '/' FROM cte.organizationnode),
                   '/',
                   LENGTH(TRIM(TRAILING '/' FROM cte.organizationnode))
                   - LENGTH(REPLACE(TRIM(TRAILING '/' FROM cte.organizationnode), '/', ''))
               )
        JOIN person_person pp
            ON pp.businessentityid = mgr.businessentityid
    )

    SELECT *
    FROM emp_cte
    ORDER BY recursionlevel;

END$$

DELIMITER ;


-- Procedure: usp_get_manager_employees

DELIMITER $$

CREATE PROCEDURE usp_get_manager_employees(
    IN p_businessentityid INT
)
BEGIN

    WITH RECURSIVE emp_cte AS (

        -- Anchor employee
        SELECT
            e.businessentityid,
            e.organizationnode,
            p.firstname,
            p.lastname,
            0 AS recursionlevel
        FROM humanresources_employee e
        JOIN person_person p
            ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = p_businessentityid

        UNION ALL

        -- Recursive employees under manager
        SELECT
            e.businessentityid,
            e.organizationnode,
            p.firstname,
            p.lastname,
            cte.recursionlevel + 1
        FROM humanresources_employee e
        JOIN emp_cte cte
            ON SUBSTRING_INDEX(
                   TRIM(TRAILING '/' FROM e.organizationnode),
                   '/',
                   LENGTH(TRIM(TRAILING '/' FROM e.organizationnode))
                   - LENGTH(REPLACE(TRIM(TRAILING '/' FROM e.organizationnode), '/', ''))
               ) = TRIM(TRAILING '/' FROM cte.organizationnode)
        JOIN person_person p
            ON p.businessentityid = e.businessentityid
    )

    SELECT
        cte.recursionlevel,
        cte.organizationnode,
        mp.firstname AS managerfirstname,
        mp.lastname AS managerlastname,
        cte.businessentityid,
        cte.firstname,
        cte.lastname
    FROM emp_cte cte
    LEFT JOIN humanresources_employee me
        ON SUBSTRING_INDEX(
               TRIM(TRAILING '/' FROM cte.organizationnode),
               '/',
               LENGTH(TRIM(TRAILING '/' FROM cte.organizationnode))
               - LENGTH(REPLACE(TRIM(TRAILING '/' FROM cte.organizationnode), '/', ''))
           ) = TRIM(TRAILING '/' FROM me.organizationnode)
    LEFT JOIN person_person mp
        ON mp.businessentityid = me.businessentityid
    ORDER BY recursionlevel, organizationnode;

END$$

DELIMITER ;


-- Procedure: usp_get_where_used_productid

DELIMITER $$

CREATE PROCEDURE usp_get_where_used_productid(
    IN p_start_product_id INT,
    IN p_check_date DATE
)
BEGIN

    WITH RECURSIVE bom_cte AS (

        -- Anchor
        SELECT
            b.productassemblyid,
            b.componentid,
            p.name AS componentdesc,
            b.perassemblyqty,
            p.standardcost,
            p.listprice,
            b.bomlevel,
            0 AS recursionlevel
        FROM production_billofmaterials b
        JOIN production_product p
            ON b.productassemblyid = p.productid
        WHERE b.componentid = p_start_product_id
          AND p_check_date >= b.startdate
          AND p_check_date <= COALESCE(b.enddate, p_check_date)

        UNION ALL

        -- Recursive
        SELECT
            b.productassemblyid,
            b.componentid,
            p.name,
            b.perassemblyqty,
            p.standardcost,
            p.listprice,
            b.bomlevel,
            cte.recursionlevel + 1
        FROM bom_cte cte
        JOIN production_billofmaterials b
            ON cte.productassemblyid = b.componentid
        JOIN production_product p
            ON b.productassemblyid = p.productid
        WHERE p_check_date >= b.startdate
          AND p_check_date <= COALESCE(b.enddate, p_check_date)
          AND cte.recursionlevel < 25
    )

    SELECT
        productassemblyid,
        componentid,
        componentdesc,
        SUM(perassemblyqty) AS totalquantity,
        standardcost,
        listprice,
        bomlevel,
        recursionlevel
    FROM bom_cte
    GROUP BY
        productassemblyid,
        componentid,
        componentdesc,
        bomlevel,
        recursionlevel,
        standardcost,
        listprice
    ORDER BY bomlevel, productassemblyid, componentid;

END$$

DELIMITER ;


-- Procedure: usp_search_candidate_resumes_like

DELIMITER $$

CREATE PROCEDURE usp_search_candidate_resumes_like(IN p_search_string VARCHAR(1000))
BEGIN
    SELECT 
        jobcandidateid,
        (LENGTH(resume) - LENGTH(REPLACE(resume, p_search_string, ''))) / LENGTH(p_search_string) AS relevance
    FROM humanresources_jobcandidate
    WHERE resume LIKE CONCAT('%', p_search_string, '%')
    ORDER BY relevance DESC, jobcandidateid;
END$$

DELIMITER ;


-- Procedure: uspLogError

DELIMITER $$

CREATE PROCEDURE uspLogError(OUT p_errorlogid INT)
BEGIN
    -- Declare variables first
    DECLARE v_error_number INT DEFAULT 0;
    DECLARE v_message TEXT;
    DECLARE v_done INT DEFAULT 0;

    -- Declare the exception handler next
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_message = MESSAGE_TEXT;

        INSERT INTO errorlog (
            username,
            errornumber,
            errorseverity,
            errorstate,
            errorprocedure,
            errorline,
            errormessage
        ) VALUES (
            USER(),
            v_error_number,
            0,
            0,
            'uspLogError',
            0,
            v_message
        );

        SET p_errorlogid = LAST_INSERT_ID();
    END;

    -- Default output if no error
    SET p_errorlogid = 0;
END$$

DELIMITER ;


-- Procedure: uspPrintError

CREATE PROCEDURE uspPrintError()
BEGIN
    
    DECLARE v_error_message TEXT;

    -- Retrieve last error message in MySQL
    GET DIAGNOSTICS CONDITION 1
        v_error_message = MESSAGE_TEXT;

    SELECT CONCAT('Error Message: ', v_error_message) AS ErrorInfo;
END$$

DELIMITER ;

