CREATE TABLE dbo.awbuildversion (
    systeminformationid SMALLSERIAL PRIMARY KEY,
    database_version VARCHAR(25) NOT NULL,
    versiondate TIMESTAMP NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dbo.databaselog (
    databaselogid SERIAL PRIMARY KEY,
    posttime TIMESTAMP NOT NULL,
    databaseuser VARCHAR(128) NOT NULL,
    event VARCHAR(128) NOT NULL,
    schema_name VARCHAR(128),
    object_name VARCHAR(128),
    tsql TEXT NOT NULL,
    xmlevent XML NOT NULL
);

CREATE TABLE dbo.errorlog (
    errorlogid SERIAL PRIMARY KEY,
    errortime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(128) NOT NULL,
    errornumber INT NOT NULL,
    errorseverity INT,
    errorstate INT,
    errorprocedure VARCHAR(126),
    errorline INT,
    errormessage VARCHAR(4000) NOT NULL
);

select * from dbo.databaselog;

INSERT INTO dbo.databaselog
(
    databaselogid,
    posttime,
    databaseuser,
    event,
    schema_name,
    object_name,
    tsql,
    xmlevent
)
VALUES
(
    1,
    '2025-11-14 13:01:06',
    'dbo',
    'CREATE_TABLE',
    'dbo',
    'ErrorLog',
    'CREATE TABLE [dbo].[ErrorLog](      [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,      [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),      [UserName] [sysname] NOT NULL,      [ErrorNumber] [int] NOT NULL,      [ErrorSeverity] [int] NULL,      [ErrorState] [int] NULL,      [ErrorProcedure] [nvarchar](126) NULL,      [ErrorLine] [int] NULL,      [ErrorMessage] [nvarchar](4000) NOT NULL  ) ON [PRIMARY]',
    '<EVENT_INSTANCE><EventType>CREATE_TABLE</EventType><PostTime>2025-11-14T13:01:06.930</PostTime><SPID>57</SPID><ServerName>rwestmsft</ServerName><LoginName>NORTHAMERICA\\randolphwest</LoginName><UserName>dbo</UserName><DatabaseName>AdventureWorks</DatabaseName><SchemaName>dbo</SchemaName><ObjectName>ErrorLog</ObjectName><ObjectType>TABLE</ObjectType><TSQLCommand><SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE"/><CommandText>CREATE TABLE [dbo].[ErrorLog](&#x0D;     [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,&#x0D;     [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),&#x0D;     [UserName] [sysname] NOT NULL,&#x0D;     [ErrorNumber] [int] NOT NULL,&#x0D;     [ErrorSeverity] [int] NULL,&#x0D;     [ErrorState] [int] NULL,&#x0D;     [ErrorProcedure] [nvarchar](126) NULL,&#x0D;     [ErrorLine] [int] NULL,&#x0D;     [ErrorMessage] [nvarchar](4000) NOT NULL&#x0D; ) ON [PRIMARY]</CommandText></TSQLCommand></EVENT_INSTANCE>'
);

CREATE SCHEMA IF NOT EXISTS humanresources;
CREATE TABLE humanresources.department (
    departmentid SMALLSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    groupname VARCHAR(50) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE humanresources.employee (
    businessentityid INT PRIMARY KEY,
    nationalidnumber VARCHAR(15) NOT NULL,
    loginid VARCHAR(256) NOT NULL,
    organizationnode TEXT,
    organizationlevel INT,
    jobtitle VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    maritalstatus CHAR(1) NOT NULL,
    gender CHAR(1) NOT NULL,
    hiredate DATE NOT NULL,
    salariedflag BOOLEAN NOT NULL DEFAULT TRUE,
    vacationhours SMALLINT NOT NULL DEFAULT 0,
    sickleavehours SMALLINT NOT NULL DEFAULT 0,
    currentflag BOOLEAN NOT NULL DEFAULT TRUE,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_employee_birthdate
        CHECK (
            birthdate >= DATE '1930-01-01'
            AND birthdate <= CURRENT_DATE - INTERVAL '18 years'
        ),

    CONSTRAINT ck_employee_gender
        CHECK (UPPER(gender) IN ('M', 'F')),

    CONSTRAINT ck_employee_hiredate
        CHECK (
            hiredate >= DATE '1996-07-01'
            AND hiredate <= CURRENT_DATE + INTERVAL '1 day'
        ),

    CONSTRAINT ck_employee_maritalstatus
        CHECK (UPPER(maritalstatus) IN ('M', 'S')),

    CONSTRAINT ck_employee_sickleavehours
        CHECK (sickleavehours BETWEEN 0 AND 120),

    CONSTRAINT ck_employee_vacationhours
        CHECK (vacationhours BETWEEN -40 AND 240)
);

CREATE TABLE person.person (
    businessentityid INT PRIMARY KEY,
    persontype CHAR(2) NOT NULL,
    namestyle BOOLEAN NOT NULL DEFAULT FALSE,
    title VARCHAR(8),
    firstname VARCHAR(50) NOT NULL,
    middlename VARCHAR(50),
    lastname VARCHAR(50) NOT NULL,
    suffix VARCHAR(10),
    emailpromotion INT NOT NULL DEFAULT 0,
    additionalcontactinfo TEXT,
    demographics TEXT,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_person_emailpromotion
        CHECK (emailpromotion BETWEEN 0 AND 2),

    CONSTRAINT ck_person_persontype
        CHECK (
            UPPER(persontype) IN ('GC','SP','EM','IN','VC','SC')
        )
);

ALTER TABLE humanresources.employee
ADD CONSTRAINT fk_employee_person
FOREIGN KEY (businessentityid)
REFERENCES person.person(businessentityid);

CREATE TABLE person.businessentity (
    businessentityid SERIAL PRIMARY KEY,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE humanresources.employeedepartmenthistory (
    businessentityid INT NOT NULL,
    departmentid SMALLINT NOT NULL,
    shiftid SMALLINT NOT NULL,
    startdate DATE NOT NULL,
    enddate DATE NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_employeedepartmenthistory
        PRIMARY KEY (
            businessentityid,
            startdate,
            departmentid,
            shiftid
        ),

    CONSTRAINT fk_edh_department
        FOREIGN KEY (departmentid)
        REFERENCES humanresources.department(departmentid),

    CONSTRAINT fk_edh_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources.employee(businessentityid),

    CONSTRAINT ck_edh_enddate
        CHECK (enddate >= startdate OR enddate IS NULL)
);

CREATE TABLE humanresources.shift (
    shiftid SMALLSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    starttime TIME NOT NULL,
    endtime TIME NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE humanresources.employeedepartmenthistory
ADD CONSTRAINT fk_edh_shift
FOREIGN KEY (shiftid)
REFERENCES humanresources.shift(shiftid);

CREATE TABLE humanresources.employeepayhistory (
    businessentityid INT NOT NULL,
    ratechangedate TIMESTAMP NOT NULL,
    rate NUMERIC(19,4) NOT NULL,
    payfrequency SMALLINT NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_employeepayhistory
        PRIMARY KEY (businessentityid, ratechangedate),

    CONSTRAINT fk_employeepayhistory_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources.employee(businessentityid),

    CONSTRAINT ck_employeepayhistory_payfrequency
        CHECK (payfrequency IN (1, 2)),

    CONSTRAINT ck_employeepayhistory_rate
        CHECK (rate >= 6.50 AND rate <= 200.00)
);

CREATE TABLE humanresources.jobcandidate (
    jobcandidateid SERIAL PRIMARY KEY,
    businessentityid INT NULL,
    resume XML NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_jobcandidate_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources.employee(businessentityid)
);

CREATE TABLE person.address (
    addressid SERIAL PRIMARY KEY,
    addressline1 VARCHAR(60) NOT NULL,
    addressline2 VARCHAR(60),
    city VARCHAR(30) NOT NULL,
    stateprovinceid INT NOT NULL,
    postalcode VARCHAR(15) NOT NULL,
    spatiallocation POINT,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE person.countryregion (
    countryregioncode VARCHAR(3) NOT NULL,
    name VARCHAR(50) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_countryregion
        PRIMARY KEY (countryregioncode)
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE sales.salesterritory (
    territoryid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    countryregioncode VARCHAR(3) NOT NULL,
    "group" VARCHAR(50) NOT NULL,
    salesytd NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    saleslastyear NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    costytd NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    costlastyear NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    rowguid UUID NOT NULL DEFAULT uuid_generate_v4(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_salesterritory_countryregion
        FOREIGN KEY (countryregioncode)
        REFERENCES person.countryregion(countryregioncode),

    CONSTRAINT ck_salesterritory_salesytd
        CHECK (salesytd >= 0.00),

    CONSTRAINT ck_salesterritory_saleslastyear
        CHECK (saleslastyear >= 0.00),

    CONSTRAINT ck_salesterritory_costytd
        CHECK (costytd >= 0.00),

    CONSTRAINT ck_salesterritory_costlastyear
        CHECK (costlastyear >= 0.00)
);

CREATE TABLE person.stateprovince (
    stateprovinceid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stateprovincecode CHAR(3) NOT NULL,
    countryregioncode VARCHAR(3) NOT NULL,
    isonlystateprovinceflag BOOLEAN NOT NULL DEFAULT TRUE,
    name VARCHAR(50) NOT NULL,
    territoryid INTEGER NOT NULL,
    rowguid UUID NOT NULL DEFAULT uuid_generate_v4(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stateprovince_countryregion
        FOREIGN KEY (countryregioncode)
        REFERENCES person.countryregion(countryregioncode),

    CONSTRAINT fk_stateprovince_salesterritory
        FOREIGN KEY (territoryid)
        REFERENCES sales.salesterritory(territoryid)
);

ALTER TABLE person.address
ADD CONSTRAINT fk_address_stateprovince
FOREIGN KEY (stateprovinceid)
REFERENCES person.stateprovince(stateprovinceid);

CREATE TABLE person.addresstype (
    addresstypeid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE person.businessentityaddress (
    businessentityid INTEGER NOT NULL,
    addressid INTEGER NOT NULL,
    addresstypeid INTEGER NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_businessentityaddress
        PRIMARY KEY (businessentityid, addressid, addresstypeid),

    CONSTRAINT fk_businessentityaddress_address
        FOREIGN KEY (addressid)
        REFERENCES person.address(addressid),

    CONSTRAINT fk_businessentityaddress_addresstype
        FOREIGN KEY (addresstypeid)
        REFERENCES person.addresstype(addresstypeid),

    CONSTRAINT fk_businessentityaddress_businessentity
        FOREIGN KEY (businessentityid)
        REFERENCES person.businessentity(businessentityid)
);

CREATE TABLE person.contacttype (
    contacttypeid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE person.businessentitycontact (
    businessentityid INTEGER NOT NULL,
    personid INTEGER NOT NULL,
    contacttypeid INTEGER NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_businessentitycontact
        PRIMARY KEY (businessentityid, personid, contacttypeid),

    CONSTRAINT fk_businessentitycontact_businessentity
        FOREIGN KEY (businessentityid)
        REFERENCES person.businessentity(businessentityid),

    CONSTRAINT fk_businessentitycontact_contacttype
        FOREIGN KEY (contacttypeid)
        REFERENCES person.contacttype(contacttypeid),

    CONSTRAINT fk_businessentitycontact_person
        FOREIGN KEY (personid)
        REFERENCES person.person(businessentityid)
);

CREATE TABLE person.emailaddress (
    businessentityid INTEGER NOT NULL,
    emailaddressid INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL,
    emailaddress VARCHAR(50) NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_emailaddress
        PRIMARY KEY (businessentityid, emailaddressid),

    CONSTRAINT fk_emailaddress_person
        FOREIGN KEY (businessentityid)
        REFERENCES person.person(businessentityid)
);

CREATE TABLE person."password" (
    businessentityid INTEGER NOT NULL,
    passwordhash VARCHAR(128) NOT NULL,
    passwordsalt VARCHAR(10) NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_password
        PRIMARY KEY (businessentityid),

    CONSTRAINT fk_password_person
        FOREIGN KEY (businessentityid)
        REFERENCES person.person(businessentityid)
);

CREATE TABLE person.personphone (
    businessentityid INTEGER NOT NULL,
    phonenumber VARCHAR(25) NOT NULL,
    phonenumbertypeid INTEGER NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_personphone
        PRIMARY KEY (businessentityid, phonenumber, phonenumbertypeid),

    CONSTRAINT fk_personphone_person
        FOREIGN KEY (businessentityid)
        REFERENCES person.person(businessentityid),

    CONSTRAINT fk_personphone_phonenumbertype
        FOREIGN KEY (phonenumbertypeid)
        REFERENCES person.phonenumbertype(phonenumbertypeid)
);

CREATE TABLE person.phonenumbertype (
    PhoneNumberTypeID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = 'person';

CREATE TABLE production.unitmeasure (
    unitmeasurecode CHAR(3) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.productmodel (
    productmodelid SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    catalogdescription XML,
    instructions XML,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.productcategory (
    productcategoryid SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.productsubcategory (
    productsubcategoryid SERIAL PRIMARY KEY,
    productcategoryid INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_productsubcategory_productcategory
        FOREIGN KEY (productcategoryid)
        REFERENCES production.productcategory(productcategoryid)
);

CREATE TABLE production.product (
    productid SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    productnumber VARCHAR(25) NOT NULL,
    makeflag BOOLEAN NOT NULL DEFAULT TRUE,
    finishedgoodsflag BOOLEAN NOT NULL DEFAULT TRUE,
    color VARCHAR(15),
    safetystocklevel SMALLINT NOT NULL,
    reorderpoint SMALLINT NOT NULL,
    standardcost DECIMAL(19,4) NOT NULL,
    listprice DECIMAL(19,4) NOT NULL,
    size VARCHAR(5),
    sizeunitmeasurecode CHAR(3),
    weightunitmeasurecode CHAR(3),
    weight DECIMAL(8,2),
    daystomanufacture INT NOT NULL,
    productline CHAR(2),
    class CHAR(2),
    style CHAR(2),
    productsubcategoryid INT,
    productmodelid INT,
    sellstartdate TIMESTAMP NOT NULL,
    sellenddate TIMESTAMP,
    discontinueddate TIMESTAMP,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_productmodel
        FOREIGN KEY (productmodelid)
        REFERENCES production.productmodel(productmodelid),

    CONSTRAINT fk_product_productsubcategory
        FOREIGN KEY (productsubcategoryid)
        REFERENCES production.productsubcategory(productsubcategoryid),

    CONSTRAINT fk_product_sizeunitmeasure
        FOREIGN KEY (sizeunitmeasurecode)
        REFERENCES production.unitmeasure(unitmeasurecode),

    CONSTRAINT fk_product_weightunitmeasure
        FOREIGN KEY (weightunitmeasurecode)
        REFERENCES production.unitmeasure(unitmeasurecode),

    CONSTRAINT ck_product_class
        CHECK (
            UPPER(class) IN ('H', 'M', 'L')
            OR class IS NULL
        ),

    CONSTRAINT ck_product_daystomanufacture
        CHECK (daystomanufacture >= 0),

    CONSTRAINT ck_product_listprice
        CHECK (listprice >= 0.00),

    CONSTRAINT ck_product_productline
        CHECK (
            UPPER(productline) IN ('R', 'M', 'T', 'S')
            OR productline IS NULL
        ),

    CONSTRAINT ck_product_reorderpoint
        CHECK (reorderpoint > 0),

    CONSTRAINT ck_product_safetystocklevel
        CHECK (safetystocklevel > 0),

    CONSTRAINT ck_product_sellenddate
        CHECK (
            sellenddate >= sellstartdate
            OR sellenddate IS NULL
        ),

    CONSTRAINT ck_product_standardcost
        CHECK (standardcost >= 0.00),

    CONSTRAINT ck_product_style
        CHECK (
            UPPER(style) IN ('U', 'M', 'W')
            OR style IS NULL
        ),

    CONSTRAINT ck_product_weight
        CHECK (
            weight > 0.00
            OR weight IS NULL
        )
);

CREATE TABLE production.billofmaterials (
    billofmaterialsid SERIAL PRIMARY KEY,
    productassemblyid INT NULL,
    componentid INT NOT NULL,
    startdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enddate TIMESTAMP NULL,
    unitmeasurecode CHAR(3) NOT NULL,
    bomlevel SMALLINT NOT NULL,
    perassemblyqty DECIMAL(8,2) NOT NULL DEFAULT 1.00,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_billofmaterials_product_componentid
        FOREIGN KEY (componentid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_billofmaterials_product_productassemblyid
        FOREIGN KEY (productassemblyid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_billofmaterials_unitmeasure_unitmeasurecode
        FOREIGN KEY (unitmeasurecode)
        REFERENCES production.unitmeasure(unitmeasurecode),

    CONSTRAINT ck_billofmaterials_bomlevel
        CHECK (
            (
                productassemblyid IS NULL
                AND bomlevel = 0
                AND perassemblyqty = 1.00
            )
            OR
            (
                productassemblyid IS NOT NULL
                AND bomlevel >= 1
            )
        ),

    CONSTRAINT ck_billofmaterials_enddate
        CHECK (
            enddate > startdate
            OR enddate IS NULL
        ),

    CONSTRAINT ck_billofmaterials_perassemblyqty
        CHECK (perassemblyqty >= 1.00),

    CONSTRAINT ck_billofmaterials_productassemblyid
        CHECK (
            productassemblyid <> componentid
            OR productassemblyid IS NULL
        )
);

CREATE TABLE production.culture (
    cultureid CHAR(6) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.document (
    documentnode TEXT PRIMARY KEY,
    documentlevel INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    owner INT NOT NULL,
    folderflag BOOLEAN NOT NULL DEFAULT FALSE,
    filename VARCHAR(400) NOT NULL,
    fileextension VARCHAR(8) NOT NULL,
    revision CHAR(5) NOT NULL,
    changenumber INT NOT NULL DEFAULT 0,
    status SMALLINT NOT NULL,
    documentsummary TEXT,
    document BYTEA,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_document_rowguid UNIQUE (rowguid),

    CONSTRAINT fk_document_employee_owner
        FOREIGN KEY (owner)
        REFERENCES humanresources.employee(businessentityid),

    CONSTRAINT ck_document_status
        CHECK (status BETWEEN 1 AND 3)
);

CREATE TABLE production.illustration (
    illustrationid SERIAL PRIMARY KEY,
    diagram XML,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.location (
    locationid SMALLSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    costrate NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    availability DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_location_availability
        CHECK (availability >= 0.00),

    CONSTRAINT ck_location_costrate
        CHECK (costrate >= 0.00)
);

CREATE TABLE production.productcosthistory (
    productid INT NOT NULL,
    startdate TIMESTAMP NOT NULL,
    enddate TIMESTAMP,
    standardcost NUMERIC(19,4) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_productcosthistory
        PRIMARY KEY (productid, startdate),

    CONSTRAINT fk_productcosthistory_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT ck_productcosthistory_enddate
        CHECK (
            enddate >= startdate
            OR enddate IS NULL
        ),

    CONSTRAINT ck_productcosthistory_standardcost
        CHECK (standardcost >= 0.00)
);

CREATE TABLE production.productdescription (
    productdescriptionid SERIAL PRIMARY KEY,
    description VARCHAR(400) NOT NULL,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.productdocument (
    productid INT NOT NULL,
    documentnode TEXT NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_productdocument
        PRIMARY KEY (productid, documentnode),

    CONSTRAINT fk_productdocument_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_productdocument_document
        FOREIGN KEY (documentnode)
        REFERENCES production.document(documentnode)
);

CREATE TABLE production.productinventory (
    productid INT NOT NULL,
    locationid SMALLINT NOT NULL,
    shelf VARCHAR(10) NOT NULL,
    bin SMALLINT NOT NULL,
    quantity SMALLINT NOT NULL DEFAULT 0,
    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, locationid),

    CONSTRAINT fk_productinventory_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_productinventory_location
        FOREIGN KEY (locationid)
        REFERENCES production.location(locationid),

    CONSTRAINT ck_productinventory_bin
        CHECK (bin >= 0 AND bin <= 100),

    CONSTRAINT ck_productinventory_shelf
        CHECK (shelf ~ '^[A-Za-z]$' OR shelf = 'N/A')
);

CREATE TABLE production.productlistpricehistory (
    productid INT NOT NULL,
    startdate TIMESTAMP NOT NULL,
    enddate TIMESTAMP NULL,
    listprice NUMERIC(19,4) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, startdate),

    CONSTRAINT fk_productlistpricehistory_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT ck_listpricehistory_enddate
        CHECK (enddate IS NULL OR enddate >= startdate),

    CONSTRAINT ck_listpricehistory_listprice
        CHECK (listprice > 0)
);

CREATE TABLE production.productmodelillustration (
    productmodelid INT NOT NULL,
    illustrationid INT NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productmodelid, illustrationid),

    CONSTRAINT fk_productmodelillustration_model
        FOREIGN KEY (productmodelid)
        REFERENCES production.productmodel(productmodelid),

    CONSTRAINT fk_productmodelillustration_illustration
        FOREIGN KEY (illustrationid)
        REFERENCES production.illustration(illustrationid)
);

CREATE TABLE production.productmodelproductdescriptionculture (
    productmodelid INT NOT NULL,
    productdescriptionid INT NOT NULL,
    cultureid CHAR(6) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productmodelid, productdescriptionid, cultureid),

    CONSTRAINT fk_pmpdc_model
        FOREIGN KEY (productmodelid)
        REFERENCES production.productmodel(productmodelid),

    CONSTRAINT fk_pmpdc_description
        FOREIGN KEY (productdescriptionid)
        REFERENCES production.productdescription(productdescriptionid),

    CONSTRAINT fk_pmpdc_culture
        FOREIGN KEY (cultureid)
        REFERENCES production.culture(cultureid)
);

CREATE TABLE production.productphoto (
    productphotoid SERIAL PRIMARY KEY,
    thumbnailphoto BYTEA,
    thumbnailphotofilename VARCHAR(50),
    largephoto BYTEA,
    largephotofilename VARCHAR(50),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.productproductphoto (
    productid INT NOT NULL,
    productphotoid INT NOT NULL,
    primary_flag BOOLEAN NOT NULL DEFAULT FALSE,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_productproductphoto PRIMARY KEY (productid, productphotoid),

    CONSTRAINT fk_productproductphoto_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_productproductphoto_photo
        FOREIGN KEY (productphotoid)
        REFERENCES production.productphoto(productphotoid)
);

CREATE TABLE production.productreview (
    productreviewid SERIAL PRIMARY KEY,
    productid INT NOT NULL,
    reviewername VARCHAR(255) NOT NULL,
    reviewdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    emailaddress VARCHAR(50) NOT NULL,
    rating INT NOT NULL,
    comments TEXT,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_productreview_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT ck_productreview_rating
        CHECK (rating BETWEEN 1 AND 5)
);

CREATE TABLE production.scrapreason (
    scrapreasonid SMALLSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE production.transactionhistory (
    transactionid INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100000 INCREMENT BY 1) PRIMARY KEY,
    productid INT NOT NULL,
    referenceorderid INT NOT NULL,
    referenceorderlineid INT NOT NULL DEFAULT 0,
    transactiondate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transactiontype CHAR(1) NOT NULL,
    quantity INT NOT NULL,
    actualcost NUMERIC(19,4) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactionhistory_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT ck_transactionhistory_type
        CHECK (UPPER(transactiontype) IN ('P','S','W'))
);

CREATE TABLE production.transactionhistoryarchive (
    transactionid INT PRIMARY KEY,
    productid INT NOT NULL,
    referenceorderid INT NOT NULL,
    referenceorderlineid INT NOT NULL DEFAULT 0,
    transactiondate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transactiontype CHAR(1) NOT NULL,
    quantity INT NOT NULL,
    actualcost NUMERIC(19,4) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_transactionhistoryarchive_type
        CHECK (UPPER(transactiontype) IN ('P','S','W'))
);

CREATE TABLE production.workorder (
    workorderid INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    productid INT NOT NULL,
    orderqty INT NOT NULL,
    scrappedqty SMALLINT NOT NULL,

    -- computed column (PostgreSQL generated column)
    stockedqty INT GENERATED ALWAYS AS (COALESCE(orderqty - scrappedqty, 0)) STORED,

    startdate TIMESTAMP NOT NULL,
    enddate TIMESTAMP NULL,
    duedate TIMESTAMP NOT NULL,
    scrapreasonid SMALLINT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_workorder_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_workorder_scrapreason
        FOREIGN KEY (scrapreasonid)
        REFERENCES production.scrapreason(scrapreasonid),

    CONSTRAINT ck_workorder_enddate
        CHECK (enddate IS NULL OR enddate >= startdate),

    CONSTRAINT ck_workorder_orderqty
        CHECK (orderqty > 0),

    CONSTRAINT ck_workorder_scrappedqty
        CHECK (scrappedqty >= 0)
);

CREATE TABLE production.workorderrouting (
    workorderid INT NOT NULL,
    productid INT NOT NULL,
    operationsequence SMALLINT NOT NULL,
    locationid SMALLINT NOT NULL,

    scheduledstartdate TIMESTAMP NOT NULL,
    scheduledenddate TIMESTAMP NOT NULL,
    actualstartdate TIMESTAMP NULL,
    actualenddate TIMESTAMP NULL,

    actualresourcehrs NUMERIC(9,4) NULL,
    plannedcost NUMERIC(19,4) NOT NULL,
    actualcost NUMERIC(19,4) NULL,

    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (workorderid, productid, operationsequence),

    CONSTRAINT fk_wor_workorder
        FOREIGN KEY (workorderid)
        REFERENCES production.workorder(workorderid),

    CONSTRAINT fk_wor_location
        FOREIGN KEY (locationid)
        REFERENCES production.location(locationid),

    CONSTRAINT ck_wor_actualcost
        CHECK (actualcost IS NULL OR actualcost > 0),

    CONSTRAINT ck_wor_actualenddate
        CHECK (
            actualenddate IS NULL
            OR actualstartdate IS NULL
            OR actualenddate >= actualstartdate
        ),

    CONSTRAINT ck_wor_actualresourcehrs
        CHECK (actualresourcehrs IS NULL OR actualresourcehrs >= 0),

    CONSTRAINT ck_wor_plannedcost
        CHECK (plannedcost > 0),

    CONSTRAINT ck_wor_sched_end
        CHECK (scheduledenddate >= scheduledstartdate)
);

CREATE TABLE purchasing.vendor (
    businessentityid INT PRIMARY KEY,
    accountnumber VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,

    creditrating SMALLINT NOT NULL,
    preferredvendorstatus BOOLEAN NOT NULL DEFAULT TRUE,
    activeflag BOOLEAN NOT NULL DEFAULT TRUE,

    purchasingwebserviceurl VARCHAR(1024),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (businessentityid)
        REFERENCES person.businessentity(businessentityid),

    CHECK (creditrating BETWEEN 1 AND 5)
);


CREATE TABLE purchasing.productvendor (
    productid INT NOT NULL,
    businessentityid INT NOT NULL,

    averageleadtime INT NOT NULL,
    standardprice NUMERIC(19,4) NOT NULL,
    lastreceiptcost NUMERIC(19,4),
    lastreceiptdate TIMESTAMP,

    minorderqty INT NOT NULL,
    maxorderqty INT NOT NULL,
    onorderqty INT,

    unitmeasurecode CHAR(3) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, businessentityid),

    FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    FOREIGN KEY (businessentityid)
        REFERENCES purchasing.vendor(businessentityid),

    FOREIGN KEY (unitmeasurecode)
        REFERENCES production.unitmeasure(unitmeasurecode),

    CHECK (averageleadtime >= 1),
    CHECK (standardprice > 0),
    CHECK (lastreceiptcost IS NULL OR lastreceiptcost > 0),
    CHECK (minorderqty >= 1),
    CHECK (maxorderqty >= 1),
    CHECK (onorderqty IS NULL OR onorderqty >= 0)
);

CREATE TABLE "purchasing"."ShipMethod" (
    "ShipMethodID" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "ShipBase" NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    "ShipRate" NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    "rowguid" UUID NOT NULL DEFAULT gen_random_uuid(),
    "ModifiedDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CK_ShipMethod_ShipBase" CHECK ("ShipBase" > 0),
    CONSTRAINT "CK_ShipMethod_ShipRate" CHECK ("ShipRate" > 0)
);

CREATE TABLE purchasing.purchaseorderdetail (
    purchaseorderdetailid INT GENERATED ALWAYS AS IDENTITY,

    purchaseorderid INT NOT NULL,
    duedate TIMESTAMP NOT NULL,
    orderqty SMALLINT NOT NULL,
    productid INT NOT NULL,

    unitprice NUMERIC(19,4) NOT NULL,

    line_total NUMERIC(19,4)
        GENERATED ALWAYS AS (orderqty * unitprice) STORED,

    receivedqty NUMERIC(8,2) NOT NULL,
    rejectedqty NUMERIC(8,2) NOT NULL,

    stockedqty NUMERIC(8,2)
        GENERATED ALWAYS AS (receivedqty - rejectedqty) STORED,

    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (purchaseorderdetailid),

    CONSTRAINT fk_pod_header
        FOREIGN KEY (PurchaseOrderID)
        REFERENCES purchasing.PurchaseOrderHeader(PurchaseOrderID),

    CONSTRAINT fk_pod_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CHECK (orderqty > 0),
    CHECK (receivedqty >= 0),
    CHECK (rejectedqty >= 0),
    CHECK (unitprice >= 0)
);

CREATE TABLE purchasing.purchaseorderheader (
    purchaseorderid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    revisionnumber SMALLINT NOT NULL,
    status SMALLINT NOT NULL,
    employeeid INT NOT NULL,
    vendorid INT NOT NULL,
    shipmethodid INT NOT NULL,
    orderdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipdate TIMESTAMP,
    subtotal NUMERIC(19,4) NOT NULL,
    taxamt NUMERIC(19,4) NOT NULL,
    freight NUMERIC(19,4) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales.currency (
    currencycode CHAR(3) NOT NULL,
    name VARCHAR NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_currency PRIMARY KEY (currencycode)
);

CREATE TABLE sales.countryregioncurrency (
    countryregioncode VARCHAR(3) NOT NULL,
    currencycode CHAR(3) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_countryregioncurrency
        PRIMARY KEY (countryregioncode, currencycode),

    CONSTRAINT fk_countryregioncurrency_countryregion
        FOREIGN KEY (countryregioncode)
        REFERENCES person.countryregion(countryregioncode),

    CONSTRAINT fk_countryregioncurrency_currency
        FOREIGN KEY (currencycode)
        REFERENCES sales.currency(currencycode)
);

CREATE TABLE sales.creditcard (
    creditcardid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cardtype VARCHAR(50) NOT NULL,
    cardnumber VARCHAR(25) NOT NULL,
    expmonth SMALLINT NOT NULL,
    expyear SMALLINT NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales.currencyrate (
    currencyrateid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    currencyratedate TIMESTAMP NOT NULL,
    fromcurrencycode CHAR(3) NOT NULL,
    tocurrencycode CHAR(3) NOT NULL,
    averagerate NUMERIC(19,4) NOT NULL,
    endofdayrate NUMERIC(19,4) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_currencyrate_fromcurrency
        FOREIGN KEY (fromcurrencycode)
        REFERENCES sales.currency(currencycode),

    CONSTRAINT fk_currencyrate_tocurrency
        FOREIGN KEY (tocurrencycode)
        REFERENCES sales.currency(currencycode)
);

CREATE TABLE sales.salesperson (
    businessentityid INT PRIMARY KEY,
    territoryid INT,

    salesquota NUMERIC(19,4),
    bonus NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    commissionpct NUMERIC(10,4) NOT NULL DEFAULT 0.00,

    salesytd NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    saleslastyear NUMERIC(19,4) NOT NULL DEFAULT 0.00,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_salesperson_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources.employee(businessentityid),

    CONSTRAINT fk_salesperson_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales.salesterritory(territoryid),

    CONSTRAINT ck_bonus CHECK (bonus >= 0),
    CONSTRAINT ck_commission CHECK (commissionpct >= 0),
    CONSTRAINT ck_salesytd CHECK (salesytd >= 0),
    CONSTRAINT ck_saleslastyear CHECK (saleslastyear >= 0),
    CONSTRAINT ck_salesquota CHECK (salesquota > 0)
);

CREATE TABLE sales.store (
    businessentityid INT PRIMARY KEY,
    name VARCHAR NOT NULL,
    salespersonid INT,

    demographics XML,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_store_businessentity
        FOREIGN KEY (businessentityid)
        REFERENCES person.businessentity(businessentityid),

    CONSTRAINT fk_store_salesperson
        FOREIGN KEY (salespersonid)
        REFERENCES sales.salesperson(businessentityid)
);

CREATE TABLE sales.customer (
    customerid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    personid INT,
    storeid INT,
    territoryid INT,

    accountnumber TEXT,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customer_person
        FOREIGN KEY (personid)
        REFERENCES person.person(businessentityid),

    CONSTRAINT fk_customer_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales.salesterritory(territoryid),

    CONSTRAINT fk_customer_store
        FOREIGN KEY (storeid)
        REFERENCES sales.store(businessentityid)
);

CREATE OR REPLACE FUNCTION sales.generate_account_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.accountnumber :=
        'AW' || LPAD(NEW.customerid::TEXT, 10, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_customer_accountnumber
BEFORE INSERT ON sales.customer
FOR EACH ROW
EXECUTE FUNCTION sales.generate_account_number();

CREATE TABLE sales.personcreditcard (
    businessentityid INT NOT NULL,
    creditcardid INT NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_personcreditcard
        PRIMARY KEY (businessentityid, creditcardid),

    CONSTRAINT fk_personcreditcard_creditcard
        FOREIGN KEY (creditcardid)
        REFERENCES sales.creditcard(creditcardid),

    CONSTRAINT fk_personcreditcard_person
        FOREIGN KEY (businessentityid)
        REFERENCES person.person(businessentityid)
);

CREATE TABLE sales.salesorderheader (
    salesorderid INT GENERATED ALWAYS AS IDENTITY,
    revisionnumber SMALLINT NOT NULL DEFAULT 0,
    orderdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duedate TIMESTAMP NOT NULL,
    shipdate TIMESTAMP,

    status SMALLINT NOT NULL,
    onlineorderflag BOOLEAN NOT NULL DEFAULT TRUE,

    salesordernumber TEXT
        GENERATED ALWAYS AS (
            COALESCE('SO' || salesorderid::TEXT, '*** ERROR ***')
        ) STORED,

    purchaseordernumber TEXT,
    accountnumber TEXT,

    customerid INT NOT NULL,
    salespersonid INT,
    territoryid INT,

    billtoaddressid INT NOT NULL,
    shiptoaddressid INT NOT NULL,
    shipmethodid INT NOT NULL,

    creditcardid INT,
    creditcardapprovalcode VARCHAR(15),
    currencyrateid INT,

    subtotal NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    taxamt NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    freight NUMERIC(19,4) NOT NULL DEFAULT 0.00,

    totaldue NUMERIC(19,4)
        GENERATED ALWAYS AS (
            COALESCE(subtotal + taxamt + freight, 0)
        ) STORED,

    comment TEXT,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesorderid),

    CONSTRAINT fk_soh_billto
        FOREIGN KEY (billtoaddressid)
        REFERENCES person.address(addressid),

    CONSTRAINT fk_soh_shipto
        FOREIGN KEY (shiptoaddressid)
        REFERENCES person.address(addressid),

    CONSTRAINT fk_soh_creditcard
        FOREIGN KEY (creditcardid)
        REFERENCES sales.creditcard(creditcardid),

    CONSTRAINT fk_soh_currencyrate
        FOREIGN KEY (currencyrateid)
        REFERENCES sales.currencyrate(currencyrateid),

    CONSTRAINT fk_soh_customer
        FOREIGN KEY (customerid)
        REFERENCES sales.customer(customerid),

    CONSTRAINT fk_soh_salesperson
        FOREIGN KEY (salespersonid)
        REFERENCES sales.salesperson(businessentityid),

    CONSTRAINT fk_soh_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales.salesterritory(territoryid),

    CONSTRAINT fk_soh_shipmethod
        FOREIGN KEY (shipmethodid)
        REFERENCES purchasing.shipmethod(shipmethodid),

    CONSTRAINT ck_soh_due_date CHECK (duedate >= orderdate),
    CONSTRAINT ck_soh_freight CHECK (freight >= 0),
    CONSTRAINT ck_soh_shipdate CHECK (shipdate IS NULL OR shipdate >= orderdate),
    CONSTRAINT ck_soh_status CHECK (status BETWEEN 0 AND 8),
    CONSTRAINT ck_soh_subtotal CHECK (subtotal >= 0),
    CONSTRAINT ck_soh_taxamt CHECK (taxamt >= 0)
);

CREATE TABLE sales.specialoffer (
    specialofferid INT GENERATED ALWAYS AS IDENTITY,

    description TEXT NOT NULL,
    discountpct NUMERIC(10,4) NOT NULL DEFAULT 0.00,
    type TEXT NOT NULL,
    category TEXT NOT NULL,

    startdate TIMESTAMP NOT NULL,
    enddate TIMESTAMP NOT NULL,

    minqty INT NOT NULL DEFAULT 0,
    maxqty INT,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (specialofferid),

    CONSTRAINT ck_specialoffer_discountpct CHECK (discountpct >= 0),
    CONSTRAINT ck_specialoffer_enddate CHECK (enddate >= startdate),
    CONSTRAINT ck_specialoffer_maxqty CHECK (maxqty IS NULL OR maxqty >= 0),
    CONSTRAINT ck_specialoffer_minqty CHECK (minqty >= 0)
);

CREATE TABLE sales.specialofferproduct (
    specialofferid INT NOT NULL,
    productid INT NOT NULL,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (specialofferid, productid),

    CONSTRAINT fk_sop_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT fk_sop_specialoffer
        FOREIGN KEY (specialofferid)
        REFERENCES sales.specialoffer(specialofferid)
);

CREATE TABLE sales.salesorderdetail (
    salesorderid INT NOT NULL,
    salesorderdetailid INT GENERATED ALWAYS AS IDENTITY,

    carriertrackingnumber VARCHAR(25),
    orderqty SMALLINT NOT NULL,
    productid INT NOT NULL,
    specialofferid INT NOT NULL,

    unitprice NUMERIC(19,4) NOT NULL,
    unitpricediscount NUMERIC(19,4) NOT NULL DEFAULT 0.00,

    linenotal NUMERIC(19,4)
        GENERATED ALWAYS AS (
            COALESCE((unitprice * (1 - unitpricediscount) * orderqty), 0.0)
        ) STORED,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesorderid, salesorderdetailid),

    CONSTRAINT fk_salesorderdetail_header
        FOREIGN KEY (salesorderid)
        REFERENCES sales.salesorderheader(salesorderid)
        ON DELETE CASCADE,

    CONSTRAINT fk_salesorderdetail_specialofferproduct
        FOREIGN KEY (specialofferid, productid)
        REFERENCES sales.specialofferproduct(specialofferid, productid),

    CONSTRAINT ck_orderqty CHECK (orderqty > 0),
    CONSTRAINT ck_unitprice CHECK (unitprice >= 0),
    CONSTRAINT ck_unitpricediscount CHECK (unitpricediscount >= 0)
);

CREATE TABLE sales.salesreason (
    salesreasonid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    reasontype VARCHAR(50) NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales.salesorderheadersalesreason (
    salesorderid INT NOT NULL,
    salesreasonid INT NOT NULL,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesorderid, salesreasonid),

    CONSTRAINT fk_sohsr_salesorderheader
        FOREIGN KEY (salesorderid)
        REFERENCES sales.salesorderheader(salesorderid)
        ON DELETE CASCADE,

    CONSTRAINT fk_sohsr_salesreason
        FOREIGN KEY (salesreasonid)
        REFERENCES sales.salesreason(salesreasonid)
);

CREATE TABLE sales.salespersonquotahistory (
    businessentityid INT NOT NULL,
    quotadate TIMESTAMP NOT NULL,
    salesquota NUMERIC(19,4) NOT NULL,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid, quotadate),

    CONSTRAINT fk_spqh_salesperson
        FOREIGN KEY (businessentityid)
        REFERENCES sales.salesperson(businessentityid),

    CONSTRAINT ck_spqh_salesquota
        CHECK (salesquota > 0)
);

CREATE TABLE sales.salestaxrate (
    salestaxrateid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stateprovinceid INT NOT NULL,
    taxtype SMALLINT NOT NULL,
    taxrate NUMERIC(19,4) NOT NULL DEFAULT 0.00,
    name VARCHAR(50) NOT NULL,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_salestaxrate_stateprovince
        FOREIGN KEY (stateprovinceid)
        REFERENCES person.stateprovince(stateprovinceid),

    CONSTRAINT ck_salestaxrate_taxtype
        CHECK (taxtype BETWEEN 1 AND 3)
);


CREATE TABLE sales.salesterritoryhistory (
    businessentityid INT NOT NULL,
    territoryid INT NOT NULL,
    startdate TIMESTAMP NOT NULL,
    enddate TIMESTAMP NULL,

    rowguid UUID NOT NULL DEFAULT gen_random_uuid(),
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid, startdate, territoryid),

    CONSTRAINT fk_sth_salesperson
        FOREIGN KEY (businessentityid)
        REFERENCES sales.salesperson(businessentityid),

    CONSTRAINT fk_sth_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales.salesterritory(territoryid),

    CONSTRAINT ck_sth_enddate
        CHECK (enddate IS NULL OR enddate >= startdate)
);



CREATE TABLE sales.shopping_cart_item (
    shoppingcartitemid SERIAL PRIMARY KEY,
    shoppingcartid VARCHAR(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    productid INT NOT NULL,
    datecreated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifieddate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sci_product
        FOREIGN KEY (productid)
        REFERENCES production.product(productid),

    CONSTRAINT ck_sci_quantity
        CHECK (quantity >= 1)
);


select 13+25+5+19+3+6

Select * from dbo.awbuildversion

Select * from dbo.databaselog

Select * from dbo.errorlog

Select * from humanresources.department


INSERT INTO person.person (
    businessentityid,
    persontype,
    namestyle,
    title,
    firstname,
    middlename,
    lastname,
    suffix,
    emailpromotion,
    additionalcontactinfo,
    demographics,
    rowguid,
    modifieddate
)
VALUES (
    1,
    'EM',
    '0',
    NULL,
    'Ken',
    'J',
    'Sánchez',
    NULL,
    '0',
    NULL,
    '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey">
  <TotalPurchaseYTD>0</TotalPurchaseYTD>
</IndividualSurvey>',
    '92C4279F-1207-48A3-8448-4636514EB7E2',
    '2020-01-07 00:00:00.000'
);

--dbo

Select * from dbo.awbuildversion

Select * from dbo.databaselog

Select * from dbo.errorlog


--hr
select * from humanresources.department

select * from humanresources.employee

select * from humanresources.employeedepartmenthistory

select * from humanresources.employeepayhistory

select * from humanresources.jobcandidate

select * from humanresources.shift


--person
Select * from person.address

Select * from person.addresstype

Select * from person.businessentity

Select * from person.businessentityaddress

Select * from person.businessentitycontact

Select * from person.contacttype

Select * from person.countryregion

Select * from person.emailaddress

Select * from person.password

Select * from person.person

Select * from person.personphone

Select * from person.phonenumbertype

Select * from person.stateprovince


select * from production.illustration
insert into i


ALTER TABLE person.address
ALTER COLUMN spatiallocation TYPE TEXT;



