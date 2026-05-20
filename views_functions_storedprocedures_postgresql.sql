-- Views converted from MS-SQL to PostgreSQL

-- View : humanresources.vemployee

CREATE OR REPLACE VIEW humanresources.vemployee AS
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
FROM humanresources.employee e
INNER JOIN person.person p
    ON p.businessentityid = e.businessentityid
INNER JOIN person.businessentityaddress bea
    ON bea.businessentityid = e.businessentityid
INNER JOIN person.address a
    ON a.addressid = bea.addressid
INNER JOIN person.stateprovince sp
    ON sp.stateprovinceid = a.stateprovinceid
INNER JOIN person.countryregion cr
    ON cr.countryregioncode = sp.countryregioncode
LEFT JOIN person.personphone pp
    ON pp.businessentityid = p.businessentityid
LEFT JOIN person.phonenumbertype pnt
    ON pp.phonenumbertypeid = pnt.phonenumbertypeid
LEFT JOIN person.emailaddress ea
    ON ea.businessentityid = p.businessentityid;


Select * from humanresources.vemployee              -- Example to query the view


-- View : humanresources.vemployeedepartment

CREATE OR REPLACE VIEW humanresources.vemployeedepartment AS
SELECT
    e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    d.name AS department,
    d.groupname,
    edh.startdate
FROM humanresources.employee e
INNER JOIN person.person p
    ON p.businessentityid = e.businessentityid
INNER JOIN humanresources.employeedepartmenthistory edh
    ON e.businessentityid = edh.businessentityid
INNER JOIN humanresources.department d
    ON edh.departmentid = d.departmentid
WHERE edh.enddate IS NULL;

Select * from humanresources.vemployeedepartment                 -- Example to query the view


-- View : humanresources.vemployeedepartmenthistory

CREATE OR REPLACE VIEW humanresources.vemployeedepartmenthistory AS
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
FROM humanresources.employee e
INNER JOIN person.person p
    ON p.businessentityid = e.businessentityid
INNER JOIN humanresources.employeedepartmenthistory edh
    ON e.businessentityid = edh.businessentityid
INNER JOIN humanresources.department d
    ON edh.departmentid = d.departmentid
INNER JOIN humanresources.shift s
    ON s.shiftid = edh.shiftid;

Select * from humanresources.vemployeedepartmenthistory             -- Example to query the view


-- View : humanresources.vjobcandidate

CREATE OR REPLACE VIEW humanresources.vjobcandidate AS
SELECT
    jc.jobcandidateid,
    jc.businessentityid,

    (xpath(
        '/r:Resume/r:Name/r:Name.Prefix/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Name.Prefix",

    (xpath(
        '/r:Resume/r:Name/r:Name.First/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Name.First",

    (xpath(
        '/r:Resume/r:Name/r:Name.Middle/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Name.Middle",

    (xpath(
        '/r:Resume/r:Name/r:Name.Last/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Name.Last",

    (xpath(
        '/r:Resume/r:Name/r:Name.Suffix/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Name.Suffix",

    (xpath(
        '/r:Resume/r:Skills/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Skills",

    (xpath(
        '/r:Resume/r:Address/r:Addr.Type/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Addr.Type",

    (xpath(
        '/r:Resume/r:Address/r:Addr.Location/r:Location/r:Loc.CountryRegion/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Addr.Loc.CountryRegion",

    (xpath(
        '/r:Resume/r:Address/r:Addr.Location/r:Location/r:Loc.State/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Addr.Loc.State",

    (xpath(
        '/r:Resume/r:Address/r:Addr.Location/r:Location/r:Loc.City/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Addr.Loc.City",

    (xpath(
        '/r:Resume/r:Address/r:Addr.PostalCode/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Addr.PostalCode",

    (xpath(
        '/r:Resume/r:EMail/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "EMail",

    (xpath(
        '/r:Resume/r:WebSite/text()',
        jc.resume::xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "WebSite",

    jc.modifieddate
FROM humanresources.jobcandidate jc;


Select * from humanresources.vjobcandidate                   -- Example to query the view


-- View : humanresources.vjobcandidateeducation

CREATE OR REPLACE VIEW humanresources.vjobcandidateeducation AS
SELECT
    jc.jobcandidateid,

    (xpath(
        '/r:Edu/r:Level/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Level",

    (
        (xpath('/r:Edu/r:StartDate/text()', education.edu_xml,
            ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
        ))[1]::text
    )::timestamp AS "Edu.StartDate",

    (
        (xpath('/r:Edu/r:EndDate/text()', education.edu_xml,
            ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
        ))[1]::text
    )::timestamp AS "Edu.EndDate",

    (xpath(
        '/r:Edu/r:Degree/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Degree",

    (xpath(
        '/r:Edu/r:Major/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Major",

    (xpath(
        '/r:Edu/r:Minor/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Minor",

    (xpath(
        '/r:Edu/r:GPA/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.GPA",

    (xpath(
        '/r:Edu/r:GPAScale/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.GPAScale",

    (xpath(
        '/r:Edu/r:School/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.School",

    (xpath(
        '/r:Edu/r:Location/r:Location/r:Loc.CountryRegion/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Loc.CountryRegion",

    (xpath(
        '/r:Edu/r:Location/r:Location/r:Loc.State/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Loc.State",

    (xpath(
        '/r:Edu/r:Location/r:Location/r:Loc.City/text()',
        education.edu_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Edu.Loc.City"

FROM humanresources.jobcandidate jc

CROSS JOIN LATERAL
    unnest(
        xpath(
            '/r:Resume/r:Education',
            jc.resume::xml,
            ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
        )
    ) AS education(edu_xml);


Select * from humanresources.vjobcandidateeducation       -- Example to query the view


-- View : humanresources.vjobcandidateemployment


CREATE OR REPLACE VIEW humanresources.vjobcandidateemployment AS
SELECT
    jc.jobcandidateid,

    (xpath(
        '/r:Emp/r:StartDate/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text::timestamptz AS "Emp.StartDate",

    (xpath(
        '/r:Emp/r:EndDate/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text::timestamptz AS "Emp.EndDate",

    (xpath(
        '/r:Emp/r:OrgName/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.OrgName",

    (xpath(
        '/r:Emp/r:JobTitle/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.JobTitle",

    (xpath(
        '/r:Emp/r:Responsibility/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.Responsibility",

    (xpath(
        '/r:Emp/r:FunctionCategory/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.FunctionCategory",

    (xpath(
        '/r:Emp/r:IndustryCategory/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.IndustryCategory",

    (xpath(
        '/r:Emp/r:Location/r:Location/r:Loc.CountryRegion/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.Loc.CountryRegion",

    (xpath(
        '/r:Emp/r:Location/r:Location/r:Loc.State/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.Loc.State",

    (xpath(
        '/r:Emp/r:Location/r:Location/r:Loc.City/text()',
        emp.emp_xml,
        ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
    ))[1]::text AS "Emp.Loc.City"

FROM humanresources.jobcandidate jc

CROSS JOIN LATERAL
    unnest(
        xpath(
            '/r:Resume/r:Employment',
            jc.resume::xml,
            ARRAY[ARRAY['r', 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume']]
        )
    ) AS emp(emp_xml);


Select * from humanresources.vjobcandidateemployment          -- Example to query the view


-- View : person.vadditionalcontactinfo

CREATE OR REPLACE VIEW person.vadditionalcontactinfo AS
SELECT
    p.businessentityid,
    p.firstname,
    p.middlename,
    p.lastname,
    p.rowguid,
    p.modifieddate,

    (xpath(
        '/act:AdditionalContactInfo/act:telephoneNumber/act:number/text()',
        x.ci_xml,
        ARRAY[
            ARRAY['ci','http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo'],
            ARRAY['act','http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes']
        ]
    ))[1]::text AS telephonenumber

FROM person.person p

LEFT JOIN LATERAL (
    SELECT
        CASE 
            WHEN p.additionalcontactinfo IS NOT NULL
             AND btrim(p.additionalcontactinfo) LIKE '<%'
            THEN p.additionalcontactinfo::xml
            ELSE NULL
        END AS ci_xml
) x ON TRUE;


Select * from person.vadditionalcontactinfo;                   -- Example to query the view


-- View : sales.vindividualcustomer

CREATE OR REPLACE VIEW sales.vindividualcustomer AS
SELECT 
    p.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    p.demographics
   FROM person.person p
     JOIN sales.customer c ON c.personid = p.businessentityid
     JOIN person.businessentityaddress bea ON bea.businessentityid = p.businessentityid
     JOIN person.address a ON a.addressid = bea.addressid
     JOIN person.stateprovince sp ON sp.stateprovinceid = a.stateprovinceid
     JOIN person.countryregion cr ON cr.countryregioncode::text = sp.countryregioncode::text
     JOIN person.addresstype at ON at.addresstypeid = bea.addresstypeid
     LEFT JOIN person.emailaddress ea ON ea.businessentityid = p.businessentityid
     LEFT JOIN person.personphone pp ON pp.businessentityid = p.businessentityid
     LEFT JOIN person.phonenumbertype pnt ON pnt.phonenumbertypeid = pp.phonenumbertypeid
  WHERE c.storeid IS NULL;

Select * from sales.vindividualcustomer                    -- Example to query the view







-- Functions converted from MS-SQL to PostgreSQL

-- Function : ufn_get_contact_information

CREATE OR REPLACE FUNCTION ufn_get_contact_information(p_personid INT)
RETURNS TABLE (
    personid INT,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    jobtitle VARCHAR(50),
    businessentitytype VARCHAR(50)
)
AS $$
BEGIN
    IF p_personid IS NULL THEN
        RETURN;
    END IF;

  
    IF EXISTS (
        SELECT 1
        FROM humanresources.employee e
        WHERE e.businessentityid = p_personid
    ) THEN
        RETURN QUERY
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            e.jobtitle,
            'Employee'::VARCHAR
        FROM humanresources.employee e
        JOIN person.person p
            ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = p_personid;
    END IF;


    IF EXISTS (
        SELECT 1
        FROM purchasing.vendor v
        JOIN person.businessentitycontact bec
            ON bec.businessentityid = v.businessentityid
        WHERE bec.personid = p_personid
    ) THEN
        RETURN QUERY
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            ct.name,
            'Vendor Contact'::VARCHAR
        FROM purchasing.vendor v
        JOIN person.businessentitycontact bec
            ON bec.businessentityid = v.businessentityid
        JOIN person.contacttype ct
            ON ct.contacttypeid = bec.contacttypeid
        JOIN person.person p
            ON p.businessentityid = bec.personid
        WHERE bec.personid = p_personid;
    END IF;


    IF EXISTS (
        SELECT 1
        FROM sales.store s
        JOIN person.businessentitycontact bec
            ON bec.businessentityid = s.businessentityid
        WHERE bec.personid = p_personid
    ) THEN
        RETURN QUERY
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            ct.name,
            'Store Contact'::VARCHAR
        FROM sales.store s
        JOIN person.businessentitycontact bec
            ON bec.businessentityid = s.businessentityid
        JOIN person.contacttype ct
            ON ct.contacttypeid = bec.contacttypeid
        JOIN person.person p
            ON p.businessentityid = bec.personid
        WHERE bec.personid = p_personid;
    END IF;


    IF EXISTS (
        SELECT 1
        FROM sales.customer c
        JOIN person.person p2
            ON p2.businessentityid = c.personid
        WHERE p2.businessentityid = p_personid
          AND c.storeid IS NULL
    ) THEN
        RETURN QUERY
        SELECT
            p_personid,
            p.firstname,
            p.lastname,
            NULL::VARCHAR,
            'Consumer'::VARCHAR
        FROM person.person p
        JOIN sales.customer c
            ON c.personid = p.businessentityid
        WHERE p.businessentityid = p_personid
          AND c.storeid IS NULL;
    END IF;

END;
$$ LANGUAGE plpgsql;


Select * from ufn_get_contact_information(1);              -- Example to query the function



-- Function : ufn_get_accounting_end_date

CREATE OR REPLACE FUNCTION ufn_get_accounting_end_date()
RETURNS TIMESTAMP
AS $$
BEGIN
    RETURN TIMESTAMP '2004-07-01' - INTERVAL '2 milliseconds';
END;
$$ LANGUAGE plpgsql;

Select * from ufn_get_accounting_end_date();              -- Example to query the function



-- Function : ufn_get_accounting_start_date

CREATE OR REPLACE FUNCTION ufn_get_accounting_start_date()
RETURNS TIMESTAMP
LANGUAGE sql
AS $$
    SELECT TIMESTAMP '2003-07-01';
$$;


Select * from ufn_get_accounting_start_date();                 -- Example to query the function



-- Function : ufn_get_document_status_text

CREATE OR REPLACE FUNCTION ufn_get_document_status_text(p_status INT)
RETURNS VARCHAR(16)
LANGUAGE sql
AS $$
    SELECT CASE p_status
        WHEN 1 THEN 'Pending approval'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Obsolete'
        ELSE '** Invalid **'
    END;
$$;


Select * from ufn_get_document_status_text(3123);                  -- Example to query the function


-- Function : ufn_get_product_dealer_price

CREATE OR REPLACE FUNCTION ufn_get_product_dealer_price(
    p_productid INT,
    p_orderdate TIMESTAMP
)
RETURNS NUMERIC
LANGUAGE sql
AS $$
    SELECT plph.listprice * 0.60
    FROM production.product p
    JOIN production.productlistpricehistory plph
        ON p.productid = plph.productid
    WHERE p.productid = p_productid
      AND p_orderdate BETWEEN plph.startdate
          AND COALESCE(plph.enddate, TIMESTAMP '9999-12-31')
    LIMIT 1;
$$;

Select * from ufn_get_product_dealer_price(1, '2024-01-01')                -- Example to query the function 



-- Function : ufn_get_product_list_price

CREATE OR REPLACE FUNCTION production.ufn_get_product_list_price(
    p_productid INT,
    p_orderdate TIMESTAMP
)
RETURNS NUMERIC(19,4) AS
$$
DECLARE
    v_listprice NUMERIC(19,4);
BEGIN
    SELECT plph.listprice
    INTO v_listprice
    FROM production.product p
    INNER JOIN production.productlistpricehistory plph
        ON p.productid = plph.productid
    WHERE p.productid = p_productid
      AND p_orderdate BETWEEN plph.startdate AND COALESCE(plph.enddate, '9999-12-31'::timestamp);

    RETURN v_listprice;
END;
$$
LANGUAGE plpgsql;

Select * from  ufn_get_product_list_price(1, '2024-01-01')                -- Example to query the function


-- Function : get_product_standard_cost

CREATE OR REPLACE FUNCTION production.ufn_get_product_standard_cost(
    p_productid INT,
    p_orderdate TIMESTAMP
)
RETURNS NUMERIC(19,4) AS
$$
DECLARE
    v_standardcost NUMERIC(19,4);
BEGIN
    SELECT pch.standardcost
    INTO v_standardcost
    FROM production.product p
    INNER JOIN production.productcosthistory pch
        ON p.productid = pch.productid
    WHERE p.productid = p_productid
      AND p_orderdate BETWEEN pch.startdate AND COALESCE(pch.enddate, '9999-12-31'::timestamp);

    RETURN v_standardcost;
END;
$$
LANGUAGE plpgsql;

Select * from ufn_get_product_standard_cost(1, '2024-01-01')               -- Example to query the function


-- Function : ufn_get_purchase_order_status_text

CREATE OR REPLACE FUNCTION purchasing.ufn_get_purchase_order_status_text(
    p_status SMALLINT
)
RETURNS VARCHAR(15) AS
$$
BEGIN
    RETURN CASE p_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Complete'
        ELSE '** Invalid **'
    END;
END;
$$
LANGUAGE plpgsql;

Select * from ufn_get_purchase_order_status_text(1);                    -- Example to query the function


-- Function : ufn_get_sales_order_status_text

CREATE OR REPLACE FUNCTION sales.ufn_get_sales_order_status_text(
    p_status SMALLINT
)
RETURNS VARCHAR(15) AS
$$
BEGIN
    RETURN CASE p_status
        WHEN 1 THEN 'In process'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Backordered'
        WHEN 4 THEN 'Rejected'
        WHEN 5 THEN 'Shipped'
        WHEN 6 THEN 'Cancelled'
        ELSE '** Invalid **'
    END;
END;
$$
LANGUAGE plpgsql;

Select * from ufn_get_sales_order_status_text(1);             -- Example to query the function 


-- Function : ufn_get_stock

CREATE OR REPLACE FUNCTION production.ufn_get_stock(
    p_productid INT
)
RETURNS INT AS
$$
DECLARE
    v_stock INT;
BEGIN
    SELECT COALESCE(SUM(quantity), 0)
    INTO v_stock
    FROM production.productinventory
    WHERE productid = p_productid
      AND locationid = 6;  -- Only look at inventory in the misc storage

    RETURN v_stock;
END;
$$
LANGUAGE plpgsql;

Select * from ufn_get_stock(1);                    -- Example to query the function


-- Function : ufn_leading_zeros

CREATE OR REPLACE FUNCTION dbo.ufn_leading_zeros(p_value INT)
RETURNS VARCHAR(8) AS
$$
BEGIN
    RETURN LPAD(p_value::TEXT, 8, '0');
END;
$$
LANGUAGE plpgsql
IMMUTABLE;

Select * from ufn_leading_zeros(1);





-- Stored procedures converted  from MS-SQL to PostgreSQL

-- Procedure : usp_get_bill_of_materials

CREATE OR REPLACE FUNCTION dbo.usp_get_bill_of_materials(
    p_start_product_id INT,
    p_check_date TIMESTAMP
)
RETURNS TABLE (
    productassemblyid INT,
    componentid INT,
    componentdesc VARCHAR,
    totalquantity NUMERIC,
    standardcost NUMERIC,
    listprice NUMERIC,
    bomlevel INT,
    recursionlevel INT
) AS
$$
BEGIN
    RETURN QUERY
    WITH RECURSIVE bom_cte AS (
        -- Anchor member: level 0 components
        SELECT 
            b.productassemblyid,
            b.componentid,
            p.name AS componentdesc,
            b.perassemblyqty,
            p.standardcost,
            p.listprice,
            b.bomlevel,
            0 AS recursionlevel
        FROM production.billofmaterials b
        JOIN production.product p ON b.componentid = p.productid
        WHERE b.productassemblyid = p_start_product_id
          AND p_check_date >= b.startdate
          AND p_check_date <= COALESCE(b.enddate, p_check_date)

        UNION ALL

        -- Recursive member: components of components
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
        JOIN production.billofmaterials b ON b.productassemblyid = cte.componentid
        JOIN production.product p ON b.componentid = p.productid
        WHERE p_check_date >= b.startdate
          AND p_check_date <= COALESCE(b.enddate, p_check_date)
          AND cte.recursionlevel < 25 -- limit recursion to mimic MAXRECURSION 25
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
    GROUP BY productassemblyid, componentid, componentdesc, bomlevel, recursionlevel, standardcost, listprice
    ORDER BY bomlevel, productassemblyid, componentid;
END;
$$
LANGUAGE plpgsql;



-- Procedure : usp_get_employee_managers

CREATE OR REPLACE FUNCTION dbo.usp_get_employee_managers(
    p_businessentityid INT
)
RETURNS TABLE (
    recursionlevel INT,
    employeeid INT,
    firstname VARCHAR,
    lastname VARCHAR,
    managerid INT,
    managerfirstname VARCHAR,
    managerlastname VARCHAR
) AS
$$
BEGIN
    RETURN QUERY
    WITH RECURSIVE emp_cte AS (
        
        SELECT
            e.businessentityid AS employeeid,
            p.firstname,
            p.lastname,
            e.managerid, 
            0 AS recursionlevel
        FROM humanresources.employee e
        JOIN person.person p ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = p_businessentityid

        UNION ALL

        
        SELECT
            m.businessentityid AS employeeid,
            mp.firstname,
            mp.lastname,
            m.managerid,
            cte.recursionlevel + 1
        FROM emp_cte cte
        JOIN humanresources.employee m ON m.businessentityid = cte.managerid
        JOIN person.person mp ON mp.businessentityid = m.businessentityid
        WHERE cte.recursionlevel < 25
    )
    SELECT 
        cte.recursionlevel,
        cte.employeeid,
        cte.firstname,
        cte.lastname,
        cte.managerid,
        mp.firstname AS managerfirstname,
        mp.lastname AS managerlastname
    FROM emp_cte cte
    LEFT JOIN humanresources.employee me ON cte.managerid = me.businessentityid
    LEFT JOIN person.person mp ON mp.businessentityid = me.businessentityid
    ORDER BY cte.recursionlevel, cte.employeeid;
END;
$$
LANGUAGE plpgsql;



-- Procedure : usp_get_manager_employees

CREATE OR REPLACE FUNCTION dbo.usp_get_manager_employees(
    p_managerid INT
)
RETURNS TABLE (
    recursionlevel INT,
    employeeid INT,
    firstname VARCHAR,
    lastname VARCHAR,
    managerid INT,
    managerfirstname VARCHAR,
    managerlastname VARCHAR
) AS
$$
BEGIN
    RETURN QUERY
    WITH RECURSIVE emp_cte AS (
       
        SELECT
            e.businessentityid AS employeeid,
            p.firstname,
            p.lastname,
            e.managerid,
            0 AS recursionlevel
        FROM humanresources.employee e
        JOIN person.person p ON p.businessentityid = e.businessentityid
        WHERE e.managerid = p_managerid

        UNION ALL

        SELECT
            e.businessentityid AS employeeid,
            p.firstname,
            p.lastname,
            e.managerid,
            cte.recursionlevel + 1
        FROM humanresources.employee e
        JOIN person.person p ON p.businessentityid = e.businessentityid
        JOIN emp_cte cte ON e.managerid = cte.employeeid
        WHERE cte.recursionlevel < 25
    )
    SELECT
        cte.recursionlevel,
        cte.employeeid,
        cte.firstname,
        cte.lastname,
        cte.managerid,
        mp.firstname AS managerfirstname,
        mp.lastname AS managerlastname
    FROM emp_cte cte
    LEFT JOIN humanresources.employee me ON cte.managerid = me.businessentityid
    LEFT JOIN person.person mp ON mp.businessentityid = me.businessentityid
    ORDER BY cte.recursionlevel, cte.employeeid;
END;
$$
LANGUAGE plpgsql;


-- Procedure : usp_get_where_used_productid

CREATE OR REPLACE FUNCTION dbo.usp_get_where_used_productid(
    p_startproductid INT,
    p_checkdate TIMESTAMP
)
RETURNS TABLE (
    productassemblyid INT,
    componentid INT,
    componentdesc VARCHAR,
    totalquantity NUMERIC,
    standardcost NUMERIC,
    listprice NUMERIC,
    bomlevel INT,
    recursionlevel INT
) AS
$$
BEGIN
    RETURN QUERY
    WITH RECURSIVE bom_cte AS (
        SELECT
            b.productassemblyid,
            b.componentid,
            p.name AS componentdesc,
            b.perassemblyqty,
            p.standardcost,
            p.listprice,
            b.bomlevel,
            0 AS recursionlevel
        FROM production.billofmaterials b
        JOIN production.product p
          ON b.productassemblyid = p.productid
        WHERE b.componentid = p_startproductid
          AND p_checkdate >= b.startdate
          AND p_checkdate <= COALESCE(b.enddate, p_checkdate)

        UNION ALL
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
        JOIN production.billofmaterials b
          ON cte.productassemblyid = b.componentid
        JOIN production.product p
          ON b.productassemblyid = p.productid
        WHERE p_checkdate >= b.startdate
          AND p_checkdate <= COALESCE(b.enddate, p_checkdate)
          AND cte.recursionlevel < 25  
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
    GROUP BY
        b.productassemblyid,
        b.componentid,
        b.componentdesc,
        b.standardcost,
        b.listprice,
        b.bomlevel,
        b.recursionlevel
    ORDER BY
        b.bomlevel,
        b.productassemblyid,
        b.componentid;
END;
$$
LANGUAGE plpgsql;


-- Procedure : usp_log_error

CREATE OR REPLACE PROCEDURE dbo.usp_log_error(
    OUT p_errorlogid INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_err_sqlstate TEXT;
    v_err_message TEXT;
    v_err_detail TEXT;
    v_err_hint TEXT;
BEGIN
    p_errorlogid := 0;

    BEGIN
        
        GET STACKED DIAGNOSTICS
            v_err_message = MESSAGE_TEXT,
            v_err_sqlstate = RETURNED_SQLSTATE,
            v_err_detail = PG_EXCEPTION_DETAIL,
            v_err_hint = PG_EXCEPTION_HINT;

        INSERT INTO dbo.errorlog(
            username,
            error_number,
            error_severity,
            error_state,
            error_procedure,
            error_line,
            errormessage
        )
        VALUES (
            current_user,
            NULL,            
            NULL,             
            NULL,             
            NULL,             
            NULL,           
            v_err_message
        )
        RETURNING errorlogid INTO p_errorlogid;

    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred in procedure usp_log_error: %', SQLERRM;
        p_errorlogid := -1;
    END;
END;
$$;



-- Procedure : usp_print_error

CREATE OR REPLACE PROCEDURE dbo.usp_print_error()
LANGUAGE plpgsql
AS $$
DECLARE
    v_sqlstate TEXT;
    v_message TEXT;
    v_detail TEXT;
    v_hint TEXT;
BEGIN
    
    GET STACKED DIAGNOSTICS
        v_message = MESSAGE_TEXT,
        v_sqlstate = RETURNED_SQLSTATE,
        v_detail = PG_EXCEPTION_DETAIL,
        v_hint = PG_EXCEPTION_HINT;

    RAISE NOTICE 'Error SQLSTATE: %, Message: %', v_sqlstate, v_message;
    IF v_detail IS NOT NULL THEN
        RAISE NOTICE 'Detail: %', v_detail;
    END IF;
    IF v_hint IS NOT NULL THEN
        RAISE NOTICE 'Hint: %', v_hint;
    END IF;
END;
$$;


-- Procedures : usp_search_candidate_resumes

CREATE OR REPLACE FUNCTION dbo.usp_search_candidate_resumes(
    p_search_string text,
    p_use_inflectional boolean DEFAULT false,
    p_use_thesaurus boolean DEFAULT false,
    p_language text DEFAULT 'english'
)
RETURNS TABLE(jobcandidateid int, rank float)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tsquery tsquery;
BEGIN
    IF p_use_thesaurus THEN
        v_tsquery := plainto_tsquery(p_language, p_search_string);
    ELSIF p_use_inflectional THEN
        v_tsquery := websearch_to_tsquery(p_language, p_search_string);
    ELSE
        v_tsquery := plainto_tsquery(p_language, p_search_string);
    END IF;

    RETURN QUERY
    SELECT jc.jobcandidateid,
           ts_rank_cd(to_tsvector(p_language, coalesce(jc.resume, '')), v_tsquery) AS rank
    FROM humanresources.jobcandidate jc
    WHERE to_tsvector(p_language, coalesce(jc.resume, '')) @@ v_tsquery
    ORDER BY rank DESC;
END;
$$;



-- Procedures : usp_update_employee_hire_info

CREATE OR REPLACE PROCEDURE humanresources.usp_update_employee_hire_info(
    p_businessentityid int,
    p_jobtitle varchar(50),
    p_hiredate timestamp,
    p_ratechangedate timestamp,
    p_rate numeric(19,4),
    p_payfrequency smallint,
    p_currentflag boolean
)
LANGUAGE plpgsql
AS $$
BEGIN
    
    BEGIN
        UPDATE humanresources.employee
        SET jobtitle = p_jobtitle,
            hiredate = p_hiredate,
            currentflag = p_currentflag
        WHERE businessentityid = p_businessentityid;

        INSERT INTO humanresources.employeepayhistory (
            businessentityid,
            ratechangedate,
            rate,
            payfrequency
        ) VALUES (
            p_businessentityid,
            p_ratechangedate,
            p_rate,
            p_payfrequency
        );

    EXCEPTION
        WHEN OTHERS THEN
            PERFORM dbo.usp_log_error();
            RAISE;  
END;
$$;


-- Procedure : usp_update_employee_login

CREATE OR REPLACE PROCEDURE humanresources.usp_update_employee_login(
    p_businessentityid int,
    p_organizationnode ltree,
    p_loginid varchar(256),
    p_jobtitle varchar(50),
    p_hiredate timestamp,
    p_currentflag boolean
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        UPDATE humanresources.employee
        SET organizationnode = p_organizationnode,
            loginid = p_loginid,
            jobtitle = p_jobtitle,
            hiredate = p_hiredate,
            currentflag = p_currentflag
        WHERE businessentityid = p_businessentityid;

    EXCEPTION
        WHEN OTHERS THEN
            PERFORM dbo.usp_log_error();
            RAISE;  
    END;
END;
$$;



-- Procedure : usp_update_employee_personal_info

CREATE OR REPLACE PROCEDURE humanresources.usp_update_employee_personal_info(
    p_businessentityid int,
    p_nationalidnumber varchar(15),
    p_birthdate timestamp,
    p_maritalstatus char(1),
    p_gender char(1)
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        UPDATE humanresources.employee
        SET nationalidnumber = p_nationalidnumber,
            birthdate = p_birthdate,
            maritalstatus = p_maritalstatus,
            gender = p_gender
        WHERE businessentityid = p_businessentityid;

    EXCEPTION
        WHEN OTHERS THEN
            PERFORM dbo.usp_log_error();
            RAISE;  
    END;
END;
$$;