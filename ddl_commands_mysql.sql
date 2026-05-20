Create database AdventureWorks2025

Use AdventureWorks2025


-- dbo schema 

CREATE TABLE dbo_awbuildversion (
    systeminformationid TINYINT AUTO_INCREMENT PRIMARY KEY,
    database_version VARCHAR(25) NOT NULL,
    versiondate DATETIME NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dbo_databaselog (
    databaselogid INT AUTO_INCREMENT PRIMARY KEY,
    posttime DATETIME NOT NULL,
    databaseuser VARCHAR(128) NOT NULL,
    event VARCHAR(128) NOT NULL,
    schema_name VARCHAR(128) NULL,
    object_name VARCHAR(128) NULL,
    tsql TEXT NOT NULL,
    xmlevent TEXT NOT NULL
);

CREATE TABLE dbo_errorlog (
    errorlogid INT AUTO_INCREMENT PRIMARY KEY,
    errortime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(128) NOT NULL,
    errornumber INT NOT NULL,
    errorseverity INT NULL,
    errorstate INT NULL,
    errorprocedure VARCHAR(126) NULL,
    errorline INT NULL,
    errormessage VARCHAR(4000) NOT NULL
);


-- Human resources schema 

CREATE TABLE humanresources_department (
    departmentid SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    groupname VARCHAR(50) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE humanresources_employee (
    businessentityid INT PRIMARY KEY,
    nationalidnumber VARCHAR(15) NOT NULL,
    loginid VARCHAR(256) NOT NULL,
    organizationnode TEXT NULL,
    organizationlevel INT NULL,
    jobtitle VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    maritalstatus CHAR(1) NOT NULL,
    gender CHAR(1) NOT NULL,
    hiredate DATE NOT NULL,
    salariedflag BOOLEAN NOT NULL DEFAULT TRUE,
    vacationhours SMALLINT NOT NULL DEFAULT 0,
    sickleavehours SMALLINT NOT NULL DEFAULT 0,
    currentflag BOOLEAN NOT NULL DEFAULT TRUE,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_employee_gender
        CHECK (UPPER(gender) IN ('M','F')),

    CONSTRAINT ck_employee_maritalstatus
        CHECK (UPPER(maritalstatus) IN ('M','S')),

    CONSTRAINT ck_employee_sickleavehours
        CHECK (sickleavehours BETWEEN 0 AND 120),

    CONSTRAINT ck_employee_vacationhours
        CHECK (vacationhours BETWEEN -40 AND 240)
);


ALTER TABLE humanresources_employee
ADD CONSTRAINT fk_employee_person
FOREIGN KEY (businessentityid)
REFERENCES person_person(businessentityid);



CREATE TABLE humanresources_employeedepartmenthistory (
    businessentityid INT NOT NULL,
    departmentid SMALLINT NOT NULL,
    shiftid TINYINT NOT NULL,
    startdate DATE NOT NULL,
    enddate DATE NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (
        businessentityid,
        startdate,
        departmentid,
        shiftid
    ),

    CONSTRAINT fk_edh_department
        FOREIGN KEY (departmentid)
        REFERENCES humanresources_department(departmentid),

    CONSTRAINT fk_edh_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources_employee(businessentityid),

    CONSTRAINT ck_edh_enddate
        CHECK (enddate >= startdate OR enddate IS NULL)
);



ALTER TABLE humanresources_employeedepartmenthistory
ADD CONSTRAINT fk_edh_shift
FOREIGN KEY (shiftid)
REFERENCES humanresources_shift(shiftid);



CREATE TABLE humanresources_employeepayhistory (
    businessentityid INT NOT NULL,
    ratechangedate DATETIME NOT NULL,
    rate DECIMAL(19,4) NOT NULL,
    payfrequency TINYINT NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid, ratechangedate),

    CONSTRAINT fk_employeepayhistory_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources_employee(businessentityid),

    CONSTRAINT ck_employeepayhistory_payfrequency
        CHECK (payfrequency IN (1, 2)),

    CONSTRAINT ck_employeepayhistory_rate
        CHECK (rate >= 6.50 AND rate <= 200.00)
);



CREATE TABLE humanresources_jobcandidate (
    jobcandidateid INT AUTO_INCREMENT PRIMARY KEY,
    businessentityid INT NULL,
    resume LONGTEXT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_jobcandidate_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources_employee(businessentityid)
);


CREATE TABLE humanresources_shift (
    shiftid TINYINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    starttime TIME NOT NULL,
    endtime TIME NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



-- Person schema 

CREATE TABLE person_address (
    addressid INT AUTO_INCREMENT PRIMARY KEY,
    addressline1 VARCHAR(60) NOT NULL,
    addressline2 VARCHAR(60) NULL,
    city VARCHAR(30) NOT NULL,
    stateprovinceid INT NOT NULL,
    postalcode VARCHAR(15) NOT NULL,
    spatiallocation POINT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



ALTER TABLE person_address
ADD CONSTRAINT fk_address_stateprovince
FOREIGN KEY (stateprovinceid)
REFERENCES person_stateprovince(stateprovinceid);



CREATE TABLE person_AddressType (
    AddressTypeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE person_businessentity (
    businessentityid INT AUTO_INCREMENT PRIMARY KEY,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE person_businessentityaddress (
    BusinessEntityID INT NOT NULL,
    AddressID INT NOT NULL,
    AddressTypeID INT NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_BusinessEntityAddress
        PRIMARY KEY (BusinessEntityID, AddressID, AddressTypeID),

    CONSTRAINT FK_BusinessEntityAddress_Address
        FOREIGN KEY (AddressID)
        REFERENCES person_address(AddressID),

    CONSTRAINT FK_BusinessEntityAddress_AddressType
        FOREIGN KEY (AddressTypeID)
        REFERENCES person_addresstype(AddressTypeID),

    CONSTRAINT FK_BusinessEntityAddress_BusinessEntity
        FOREIGN KEY (BusinessEntityID)
        REFERENCES person_businessentity(BusinessEntityID)
);



CREATE TABLE person_businessentitycontact (
    BusinessEntityID INT NOT NULL,
    PersonID INT NOT NULL,
    ContactTypeID INT NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_BusinessEntityContact
        PRIMARY KEY (BusinessEntityID, PersonID, ContactTypeID),

    CONSTRAINT FK_BusinessEntityContact_BusinessEntity
        FOREIGN KEY (BusinessEntityID)
        REFERENCES person_businessentity(BusinessEntityID),

    CONSTRAINT FK_BusinessEntityContact_ContactType
        FOREIGN KEY (ContactTypeID)
        REFERENCES person_contacttype(ContactTypeID),

    CONSTRAINT FK_BusinessEntityContact_Person
        FOREIGN KEY (PersonID)
        REFERENCES person_person(BusinessEntityID)
);



CREATE TABLE person_contacttype (
    ContactTypeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE person_CountryRegion (
    CountryRegionCode VARCHAR(3) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_CountryRegion
        PRIMARY KEY (CountryRegionCode)
);



CREATE TABLE person_emailaddress (
    BusinessEntityID INT NOT NULL,
    EmailAddressID INT NOT NULL AUTO_INCREMENT,
    EmailAddress VARCHAR(50) NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (BusinessEntityID, EmailAddressID),

    KEY idx_emailaddressid (EmailAddressID),

    CONSTRAINT FK_EmailAddress_Person
        FOREIGN KEY (BusinessEntityID)
        REFERENCES person_person(BusinessEntityID)
);



CREATE TABLE person_password (
    BusinessEntityID INT NOT NULL,
    PasswordHash VARCHAR(128) NOT NULL,
    PasswordSalt VARCHAR(10) NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Password
        PRIMARY KEY (BusinessEntityID),

    CONSTRAINT FK_Password_Person
        FOREIGN KEY (BusinessEntityID)
        REFERENCES person_person(BusinessEntityID)
);



CREATE TABLE person_person (
    businessentityid INT PRIMARY KEY,
    persontype CHAR(2) NOT NULL,
    namestyle BOOLEAN NOT NULL DEFAULT FALSE,
    title VARCHAR(8) NULL,
    firstname VARCHAR(50) NOT NULL,
    middlename VARCHAR(50) NULL,
    lastname VARCHAR(50) NOT NULL,
    suffix VARCHAR(10) NULL,
    emailpromotion INT NOT NULL DEFAULT 0,
    additionalcontactinfo LONGTEXT NULL,
    demographics LONGTEXT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_person_emailpromotion
        CHECK (emailpromotion BETWEEN 0 AND 2),

    CONSTRAINT ck_person_persontype
        CHECK (
            UPPER(persontype) IN ('GC','SP','EM','IN','VC','SC')
        )
);


ALTER TABLE person_person
ADD CONSTRAINT fk_person_businessentity
FOREIGN KEY (businessentityid)
REFERENCES person_businessentity(businessentityid);



CREATE TABLE person_personphone (
    BusinessEntityID INT NOT NULL,
    PhoneNumber VARCHAR(25) NOT NULL,
    PhoneNumberTypeID INT NOT NULL,
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_PersonPhone
        PRIMARY KEY (BusinessEntityID, PhoneNumber, PhoneNumberTypeID),

    CONSTRAINT FK_PersonPhone_Person
        FOREIGN KEY (BusinessEntityID)
        REFERENCES person_person(BusinessEntityID),

    CONSTRAINT FK_PersonPhone_PhoneNumberType
        FOREIGN KEY (PhoneNumberTypeID)
        REFERENCES person_phonenumbertype(PhoneNumberTypeID)
);



CREATE TABLE person_phonenumbertype (
    PhoneNumberTypeID INT NOT NULL AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_PhoneNumberType
        PRIMARY KEY (PhoneNumberTypeID)
);


CREATE TABLE person_StateProvince (
    StateProvinceID INT AUTO_INCREMENT PRIMARY KEY,
    StateProvinceCode CHAR(3) NOT NULL,
    CountryRegionCode VARCHAR(3) NOT NULL,
    IsOnlyStateProvinceFlag BOOLEAN NOT NULL DEFAULT TRUE,
    Name VARCHAR(50) NOT NULL,
    TerritoryID INT NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_StateProvince_CountryRegion
        FOREIGN KEY (CountryRegionCode)
        REFERENCES Person_CountryRegion(CountryRegionCode),

    CONSTRAINT FK_StateProvince_SalesTerritory
        FOREIGN KEY (TerritoryID)
        REFERENCES Sales_SalesTerritory(TerritoryID)
);




-- Production schema 

CREATE TABLE production_billofmaterials (
    billofmaterialsid INT AUTO_INCREMENT PRIMARY KEY,
    productassemblyid INT NULL,
    componentid INT NOT NULL,
    startdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enddate DATETIME NULL,
    unitmeasurecode CHAR(3) NOT NULL,
    bomlevel SMALLINT NOT NULL,
    perassemblyqty DECIMAL(8,2) NOT NULL DEFAULT 1.00,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_billofmaterials_product_componentid
        FOREIGN KEY (componentid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_billofmaterials_product_productassemblyid
        FOREIGN KEY (productassemblyid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_billofmaterials_unitmeasure_unitmeasurecode
        FOREIGN KEY (unitmeasurecode)
        REFERENCES production_unitmeasure(unitmeasurecode),

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



CREATE TABLE production_culture (
    cultureid CHAR(6) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE production_document (
    documentnode VARCHAR(255) PRIMARY KEY,
    documentlevel INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    owner INT NOT NULL,
    folderflag TINYINT(1) NOT NULL DEFAULT 0,
    filename VARCHAR(400) NOT NULL,
    fileextension VARCHAR(8) NOT NULL,
    revision CHAR(5) NOT NULL,
    changenumber INT NOT NULL DEFAULT 0,
    status TINYINT NOT NULL,
    documentsummary LONGTEXT,
    document LONGBLOB,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_document_rowguid UNIQUE (rowguid),
    CONSTRAINT fk_document_employee_owner
        FOREIGN KEY (owner)
        REFERENCES humanresources_employee(businessentityid),

    CONSTRAINT ck_document_status
        CHECK (status BETWEEN 1 AND 3)
);



CREATE TABLE production_illustration (
    illustrationid INT AUTO_INCREMENT PRIMARY KEY,
    diagram LONGTEXT,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE production_location (
    locationid SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    costrate DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    availability DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_location_availability
        CHECK (availability >= 0.00),

    CONSTRAINT ck_location_costrate
        CHECK (costrate >= 0.00)
);



CREATE TABLE production_product (
    productid INT AUTO_INCREMENT PRIMARY KEY,
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
    sellstartdate DATETIME NOT NULL,
    sellenddate DATETIME,
    discontinueddate DATETIME,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_productmodel
        FOREIGN KEY (productmodelid)
        REFERENCES production_productmodel(productmodelid),

    CONSTRAINT fk_product_productsubcategory
        FOREIGN KEY (productsubcategoryid)
        REFERENCES production_productsubcategory(productsubcategoryid),

    CONSTRAINT fk_product_sizeunitmeasure
        FOREIGN KEY (sizeunitmeasurecode)
        REFERENCES production_unitmeasure(unitmeasurecode),

    CONSTRAINT fk_product_weightunitmeasure
        FOREIGN KEY (weightunitmeasurecode)
        REFERENCES production_unitmeasure(unitmeasurecode),

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



CREATE TABLE production_productcategory (
    productcategoryid INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE production_productcosthistory (
    productid INT NOT NULL,
    startdate DATETIME NOT NULL,
    enddate DATETIME,
    standardcost DECIMAL(19,4) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_productcosthistory
        PRIMARY KEY (productid, startdate),

    CONSTRAINT fk_productcosthistory_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT ck_productcosthistory_enddate
        CHECK (
            enddate >= startdate
            OR enddate IS NULL
        ),

    CONSTRAINT ck_productcosthistory_standardcost
        CHECK (standardcost >= 0.00)
);



CREATE TABLE production_productdescription (
    productdescriptionid INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(400) NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE production_productdocument (
    productid INT NOT NULL,
    documentnode VARCHAR(255) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, documentnode),

    CONSTRAINT fk_productdocument_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_productdocument_document
        FOREIGN KEY (documentnode)
        REFERENCES production_document(documentnode)
);



CREATE TABLE production_productinventory (
    productid INT NOT NULL,
    locationid SMALLINT NOT NULL,
    shelf VARCHAR(10) NOT NULL,
    bin TINYINT NOT NULL,
    quantity SMALLINT NOT NULL DEFAULT 0,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, locationid),

    CONSTRAINT fk_productinventory_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_productinventory_location
        FOREIGN KEY (locationid)
        REFERENCES production_location(locationid),

    CONSTRAINT ck_productinventory_bin
        CHECK (bin BETWEEN 0 AND 100),

    CONSTRAINT ck_productinventory_shelf
        CHECK (shelf REGEXP '^[A-Za-z]$' OR shelf = 'N/A')
);



CREATE TABLE production_productlistpricehistory (
    productid INT NOT NULL,
    startdate DATETIME NOT NULL,
    enddate DATETIME NULL,
    listprice DECIMAL(19,4) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, startdate),

    CONSTRAINT fk_productlistpricehistory_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT ck_listpricehistory_enddate
        CHECK (enddate IS NULL OR enddate >= startdate),

    CONSTRAINT ck_listpricehistory_listprice
        CHECK (listprice > 0)
);



CREATE TABLE production_productmodel (
    productmodelid INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    catalogdescription TEXT,
    instructions TEXT,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);




CREATE TABLE production_productmodelillustration (
    productmodelid INT NOT NULL,
    illustrationid INT NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productmodelid, illustrationid),

    CONSTRAINT fk_productmodelillustration_model
        FOREIGN KEY (productmodelid)
        REFERENCES production_productmodel(productmodelid),

    CONSTRAINT fk_productmodelillustration_illustration
        FOREIGN KEY (illustrationid)
        REFERENCES production_illustration(illustrationid)
);



CREATE TABLE production_productmodelproductdescriptionculture (
    productmodelid INT NOT NULL,
    productdescriptionid INT NOT NULL,
    cultureid CHAR(6) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productmodelid, productdescriptionid, cultureid),

    CONSTRAINT fk_pmpdc_model
        FOREIGN KEY (productmodelid)
        REFERENCES production_productmodel(productmodelid),

    CONSTRAINT fk_pmpdc_description
        FOREIGN KEY (productdescriptionid)
        REFERENCES production_productdescription(productdescriptionid),

    CONSTRAINT fk_pmpdc_culture
        FOREIGN KEY (cultureid)
        REFERENCES production_culture(cultureid)
);



CREATE TABLE production_productphoto (
    productphotoid INT AUTO_INCREMENT PRIMARY KEY,
    thumbnailphoto LONGBLOB,
    thumbnailphotofilename VARCHAR(50),
    largephoto LONGBLOB,
    largephotofilename VARCHAR(50),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE production_productproductphoto (
    productid INT NOT NULL,
    productphotoid INT NOT NULL,
    primary_flag TINYINT(1) NOT NULL DEFAULT 0,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, productphotoid),

    CONSTRAINT fk_productproductphoto_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_productproductphoto_photo
        FOREIGN KEY (productphotoid)
        REFERENCES production_productphoto(productphotoid)
);




CREATE TABLE production_productreview (
    productreviewid INT AUTO_INCREMENT PRIMARY KEY,
    productid INT NOT NULL,
    reviewername VARCHAR(255) NOT NULL,
    reviewdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    emailaddress VARCHAR(50) NOT NULL,
    rating INT NOT NULL,
    comments LONGTEXT,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_productreview_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT ck_productreview_rating
        CHECK (rating BETWEEN 1 AND 5)
);




CREATE TABLE production_productsubcategory (
    productsubcategoryid INT AUTO_INCREMENT PRIMARY KEY,
    productcategoryid INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_productsubcategory_productcategory
        FOREIGN KEY (productcategoryid)
        REFERENCES production_productcategory(productcategoryid)
);



CREATE TABLE production_scrapreason (
    scrapreasonid SMALLINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE production_transactionhistory (
    transactionid INT AUTO_INCREMENT PRIMARY KEY,
    productid INT NOT NULL,
    referenceorderid INT NOT NULL,
    referenceorderlineid INT NOT NULL DEFAULT 0,
    transactiondate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transactiontype CHAR(1) NOT NULL,
    quantity INT NOT NULL,
    actualcost DECIMAL(19,4) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactionhistory_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT ck_transactionhistory_type
        CHECK (UPPER(transactiontype) IN ('P','S','W'))
);



CREATE TABLE production_transactionhistoryarchive (
    transactionid INT PRIMARY KEY,
    productid INT NOT NULL,
    referenceorderid INT NOT NULL,
    referenceorderlineid INT NOT NULL DEFAULT 0,
    transactiondate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transactiontype CHAR(1) NOT NULL,
    quantity INT NOT NULL,
    actualcost DECIMAL(19,4) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_transactionhistoryarchive_type
        CHECK (UPPER(transactiontype) IN ('P','S','W'))
);



CREATE TABLE production_unitmeasure (
    unitmeasurecode CHAR(3) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);




CREATE TABLE production_workorder (
    workorderid INT AUTO_INCREMENT PRIMARY KEY,
    productid INT NOT NULL,
    orderqty INT NOT NULL,
    scrappedqty SMALLINT NOT NULL,

    stockedqty INT GENERATED ALWAYS AS (COALESCE(orderqty - scrappedqty, 0)) STORED,

    startdate DATETIME NOT NULL,
    enddate DATETIME NULL,
    duedate DATETIME NOT NULL,
    scrapreasonid SMALLINT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_workorder_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_workorder_scrapreason
        FOREIGN KEY (scrapreasonid)
        REFERENCES production_scrapreason(scrapreasonid),

    CONSTRAINT ck_workorder_enddate
        CHECK (enddate IS NULL OR enddate >= startdate),

    CONSTRAINT ck_workorder_orderqty
        CHECK (orderqty > 0),

    CONSTRAINT ck_workorder_scrappedqty
        CHECK (scrappedqty >= 0)
);



CREATE TABLE production_workorderrouting (
    workorderid INT NOT NULL,
    productid INT NOT NULL,
    operationsequence SMALLINT NOT NULL,
    locationid SMALLINT NOT NULL,

    scheduledstartdate DATETIME NOT NULL,
    scheduledenddate DATETIME NOT NULL,
    actualstartdate DATETIME NULL,
    actualenddate DATETIME NULL,

    actualresourcehrs DECIMAL(9,4) NULL,
    plannedcost DECIMAL(19,4) NOT NULL,
    actualcost DECIMAL(19,4) NULL,

    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (workorderid, productid, operationsequence),

    FOREIGN KEY (workorderid)
        REFERENCES production_workorder(workorderid),

    FOREIGN KEY (locationid)
        REFERENCES production_location(locationid),

    CHECK (actualcost IS NULL OR actualcost > 0),

    CHECK (
        actualenddate IS NULL
        OR actualstartdate IS NULL
        OR actualenddate >= actualstartdate
    ),

    CHECK (actualresourcehrs IS NULL OR actualresourcehrs >= 0),

    CHECK (plannedcost > 0),

    CHECK (scheduledenddate >= scheduledstartdate)
);



-- Purchasing schema 

CREATE TABLE purchasing_productvendor (
    productid INT NOT NULL,
    businessentityid INT NOT NULL,

    averageleadtime INT NOT NULL,
    standardprice DECIMAL(19,4) NOT NULL,
    lastreceiptcost DECIMAL(19,4),
    lastreceiptdate DATETIME,

    minorderqty INT NOT NULL,
    maxorderqty INT NOT NULL,
    onorderqty INT,

    unitmeasurecode CHAR(3) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (productid, businessentityid),

    FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    FOREIGN KEY (businessentityid)
        REFERENCES purchasing_vendor(businessentityid),

    FOREIGN KEY (unitmeasurecode)
        REFERENCES production_unitmeasure(unitmeasurecode),

    CHECK (averageleadtime >= 1),
    CHECK (standardprice > 0),
    CHECK (lastreceiptcost IS NULL OR lastreceiptcost > 0),
    CHECK (minorderqty >= 1),
    CHECK (maxorderqty >= 1),
    CHECK (onorderqty IS NULL OR onorderqty >= 0)
);



CREATE TABLE purchasing_purchaseorderdetail (
    purchaseorderdetailid INT AUTO_INCREMENT PRIMARY KEY,

    purchaseorderid INT NOT NULL,
    duedate DATETIME NOT NULL,
    orderqty SMALLINT NOT NULL,
    productid INT NOT NULL,
    unitprice DECIMAL(19,4) NOT NULL,

    line_total DECIMAL(19,4)
        GENERATED ALWAYS AS (orderqty * unitprice) STORED,

    receivedqty DECIMAL(8,2) NOT NULL,
    rejectedqty DECIMAL(8,2) NOT NULL,

    stockedqty DECIMAL(8,2)
        GENERATED ALWAYS AS (receivedqty - rejectedqty) STORED,

    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (purchaseorderid)
        REFERENCES purchasing_purchaseorderheader(purchaseorderid),

    FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CHECK (orderqty > 0),
    CHECK (receivedqty >= 0),
    CHECK (rejectedqty >= 0),
    CHECK (unitprice >= 0)
);



CREATE TABLE purchasing_PurchaseOrderHeader (
    PurchaseOrderID INT AUTO_INCREMENT PRIMARY KEY,
    RevisionNumber TINYINT NOT NULL DEFAULT 0,
    Status TINYINT NOT NULL,
    EmployeeID INT NOT NULL,
    VendorID INT NOT NULL,
    ShipMethodID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ShipDate DATETIME NULL,
    SubTotal DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    TaxAmt DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    Freight DECIMAL(19,4) NOT NULL DEFAULT 0.00,

    -- MySQL computed column
    TotalDue DECIMAL(19,4)
        GENERATED ALWAYS AS (SubTotal + TaxAmt + Freight) STORED,

    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK (Freight >= 0),
    CHECK (Status BETWEEN 1 AND 4),
    CHECK (SubTotal >= 0),
    CHECK (TaxAmt >= 0)
);



ALTER TABLE purchasing_PurchaseOrderHeader
ADD CONSTRAINT FK_POHeader_Employee_BusinessEntityID
FOREIGN KEY (EmployeeID)
REFERENCES humanresources_employee(BusinessEntityID);

ALTER TABLE purchasing_PurchaseOrderHeader
ADD CONSTRAINT FK_POHeader_Vendor_BusinessEntityID
FOREIGN KEY (VendorID)
REFERENCES purchasing_vendor(BusinessEntityID);

ALTER TABLE purchasing_PurchaseOrderHeader
ADD CONSTRAINT FK_POHeader_ShipMethod_ShipMethodID
FOREIGN KEY (ShipMethodID)
REFERENCES purchasing_shipmethod(ShipMethodID);



CREATE TABLE purchasing_ShipMethod (
    ShipMethodID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ShipBase DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    ShipRate DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK (ShipBase > 0),
    CHECK (ShipRate > 0)
);



CREATE TABLE purchasing_vendor (
    businessentityid INT PRIMARY KEY,
    accountnumber VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,

    creditrating TINYINT NOT NULL,
    preferredvendorstatus TINYINT(1) NOT NULL DEFAULT 1,
    activeflag TINYINT(1) NOT NULL DEFAULT 1,

    purchasingwebserviceurl VARCHAR(1024),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (businessentityid)
        REFERENCES person_businessentity(businessentityid),

    CHECK (creditrating BETWEEN 1 AND 5)
);



-- Sales schema 

CREATE TABLE sales_countryregioncurrency (
    countryregioncode VARCHAR(3) NOT NULL,
    currencycode CHAR(3) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (countryregioncode, currencycode),

    CONSTRAINT fk_countryregioncurrency_countryregion
        FOREIGN KEY (countryregioncode)
        REFERENCES person_countryregion(countryregioncode),

    CONSTRAINT fk_countryregioncurrency_currency
        FOREIGN KEY (currencycode)
        REFERENCES sales_currency(currencycode)
) ENGINE=InnoDB;



CREATE TABLE sales_creditcard (
    creditcardid INT NOT NULL AUTO_INCREMENT,
    cardtype VARCHAR(50) NOT NULL,
    cardnumber VARCHAR(25) NOT NULL,
    expmonth TINYINT NOT NULL,
    expyear SMALLINT NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (creditcardid)
) ENGINE=InnoDB;


CREATE TABLE sales_currency (
    currencycode CHAR(3) NOT NULL,
    name VARCHAR(255) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (currencycode)
) ENGINE=InnoDB;



CREATE TABLE sales_currencyrate (
    currencyrateid INT NOT NULL AUTO_INCREMENT,
    currencyratedate DATETIME NOT NULL,
    fromcurrencycode CHAR(3) NOT NULL,
    tocurrencycode CHAR(3) NOT NULL,
    averagerate DECIMAL(19,4) NOT NULL,
    endofdayrate DECIMAL(19,4) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (currencyrateid),

    CONSTRAINT fk_currencyrate_fromcurrency
        FOREIGN KEY (fromcurrencycode)
        REFERENCES sales_currency(currencycode),

    CONSTRAINT fk_currencyrate_tocurrency
        FOREIGN KEY (tocurrencycode)
        REFERENCES sales_currency(currencycode)
) ENGINE=InnoDB;




CREATE TABLE sales_customer (
    customerid INT NOT NULL AUTO_INCREMENT,
    personid INT NULL,
    storeid INT NULL,
    territoryid INT NULL,

    accountnumber VARCHAR(50),

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (customerid),

    CONSTRAINT fk_customer_person
        FOREIGN KEY (personid)
        REFERENCES person_person(businessentityid),

    CONSTRAINT fk_customer_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales_salesterritory(territoryid),

    CONSTRAINT fk_customer_store
        FOREIGN KEY (storeid)
        REFERENCES sales_store(businessentityid)
) ENGINE=InnoDB;



USE adventureworks2025
DELIMITER //

CREATE TRIGGER trg_customer_accountnumber
BEFORE INSERT ON sales_customer
FOR EACH ROW
BEGIN
    SET NEW.accountnumber =
        CONCAT('AW', LPAD(NEW.customerid, 10, '0'));
END//

DELIMITER ;


CREATE TABLE sales_personcreditcard (
    businessentityid INT NOT NULL,
    creditcardid INT NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid, creditcardid),

    CONSTRAINT fk_personcreditcard_creditcard
        FOREIGN KEY (creditcardid)
        REFERENCES sales_creditcard(creditcardid),

    CONSTRAINT fk_personcreditcard_person
        FOREIGN KEY (businessentityid)
        REFERENCES person_person(businessentityid)
) ENGINE=InnoDB;



CREATE TABLE sales_salesorderdetail (
    salesorderdetailid INT NOT NULL AUTO_INCREMENT,
    salesorderid INT NOT NULL,

    carriertrackingnumber VARCHAR(25),
    orderqty SMALLINT NOT NULL,
    productid INT NOT NULL,
    specialofferid INT NOT NULL,

    unitprice DECIMAL(19,4) NOT NULL,
    unitpricediscount DECIMAL(19,4) NOT NULL DEFAULT 0.00,

    linenotal DECIMAL(19,4)
        GENERATED ALWAYS AS (unitprice * (1 - unitpricediscount) * orderqty) STORED,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesorderdetailid),

    KEY idx_salesorderid (salesorderid),

    CONSTRAINT fk_salesorderdetail_header
        FOREIGN KEY (salesorderid)
        REFERENCES sales_salesorderheader(salesorderid)
        ON DELETE CASCADE,

    CONSTRAINT fk_salesorderdetail_specialofferproduct
        FOREIGN KEY (specialofferid, productid)
        REFERENCES sales_specialofferproduct(specialofferid, productid),

    CONSTRAINT ck_orderqty CHECK (orderqty > 0),
    CONSTRAINT ck_unitprice CHECK (unitprice >= 0),
    CONSTRAINT ck_unitpricediscount CHECK (unitpricediscount >= 0)
) ENGINE=InnoDB;



CREATE TABLE sales_salesorderheader (
    salesorderid INT NOT NULL AUTO_INCREMENT,
    revisionnumber TINYINT NOT NULL DEFAULT 0,
    orderdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duedate DATETIME NOT NULL,
    shipdate DATETIME,

    status TINYINT NOT NULL,
    onlineorderflag TINYINT(1) NOT NULL DEFAULT 1,

    salesordernumber VARCHAR(30),

    purchaseordernumber VARCHAR(50),
    accountnumber VARCHAR(50),

    customerid INT NOT NULL,
    salespersonid INT,
    territoryid INT,

    billtoaddressid INT NOT NULL,
    shiptoaddressid INT NOT NULL,
    shipmethodid INT NOT NULL,

    creditcardid INT,
    creditcardapprovalcode VARCHAR(15),
    currencyrateid INT,

    subtotal DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    taxamt DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    freight DECIMAL(19,4) NOT NULL DEFAULT 0.00,

    totaldue DECIMAL(19,4)
        GENERATED ALWAYS AS (subtotal + taxamt + freight) STORED,

    comment VARCHAR(128),

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesorderid),

    CONSTRAINT ck_due CHECK (duedate >= orderdate),
    CONSTRAINT ck_freight CHECK (freight >= 0),
    CONSTRAINT ck_shipdate CHECK (shipdate IS NULL OR shipdate >= orderdate),
    CONSTRAINT ck_status CHECK (status BETWEEN 0 AND 8),
    CONSTRAINT ck_subtotal CHECK (subtotal >= 0),
    CONSTRAINT ck_taxamt CHECK (taxamt >= 0)
) ENGINE=InnoDB;



DELIMITER $$

CREATE TRIGGER trg_salesordernumber
BEFORE INSERT ON sales_salesorderheader
FOR EACH ROW
BEGIN
    SET NEW.salesordernumber = CONCAT('SO', NEW.salesorderid);
END$$

DELIMITER ;



CREATE TABLE sales_salesorderheadersalesreason (
    salesorderid INT NOT NULL,
    salesreasonid INT NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesorderid, salesreasonid),

    CONSTRAINT fk_sohsr_salesorderheader
        FOREIGN KEY (salesorderid)
        REFERENCES sales_salesorderheader(salesorderid)
        ON DELETE CASCADE,

    CONSTRAINT fk_sohsr_salesreason
        FOREIGN KEY (salesreasonid)
        REFERENCES sales_salesreason(salesreasonid)
) ENGINE=InnoDB;



CREATE TABLE sales_salesperson (
    businessentityid INT NOT NULL,
    territoryid INT NULL,

    salesquota DECIMAL(19,4),
    bonus DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    commissionpct DECIMAL(10,4) NOT NULL DEFAULT 0.00,

    salesytd DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    saleslastyear DECIMAL(19,4) NOT NULL DEFAULT 0.00,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid),

    CONSTRAINT fk_salesperson_employee
        FOREIGN KEY (businessentityid)
        REFERENCES humanresources_employee(businessentityid),

    CONSTRAINT fk_salesperson_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales_salesterritory(territoryid),

    CONSTRAINT ck_bonus CHECK (bonus >= 0),
    CONSTRAINT ck_commission CHECK (commissionpct >= 0),
    CONSTRAINT ck_salesytd CHECK (salesytd >= 0),
    CONSTRAINT ck_saleslastyear CHECK (saleslastyear >= 0),
    CONSTRAINT ck_salesquota CHECK (salesquota > 0)
) ENGINE=InnoDB;



CREATE TABLE sales_salespersonquotahistory (
    businessentityid INT NOT NULL,
    quotadate DATETIME NOT NULL,
    salesquota DECIMAL(19,4) NOT NULL,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid, quotadate),

    CONSTRAINT fk_spqh_salesperson
        FOREIGN KEY (businessentityid)
        REFERENCES sales_salesperson(businessentityid),

    CONSTRAINT ck_spqh_salesquota
        CHECK (salesquota > 0)
) ENGINE=InnoDB;




CREATE TABLE sales_salesreason (
    salesreasonid INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    reasontype VARCHAR(50) NOT NULL,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salesreasonid)
) ENGINE=InnoDB;



CREATE TABLE sales_salestaxrate (
    salestaxrateid INT NOT NULL AUTO_INCREMENT,
    stateprovinceid INT NOT NULL,
    taxtype TINYINT NOT NULL,
    taxrate DECIMAL(19,4) NOT NULL DEFAULT 0.00,
    name VARCHAR(50) NOT NULL,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (salestaxrateid),

    CONSTRAINT fk_salestaxrate_stateprovince
        FOREIGN KEY (stateprovinceid)
        REFERENCES person_stateprovince(stateprovinceid),

    CONSTRAINT ck_salestaxrate_taxtype
        CHECK (taxtype BETWEEN 1 AND 3)
) ENGINE=InnoDB;



CREATE TABLE sales_salesterritory (
  TerritoryId INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(50) NOT NULL,
  CountryRegionCode VARCHAR(3) NOT NULL,
  `Group` VARCHAR(50) NOT NULL,
  SalesYTD DECIMAL(19,4) NOT NULL DEFAULT 0.0000,
  SalesLastYear DECIMAL(19,4) NOT NULL DEFAULT 0.0000,
  CostYTD DECIMAL(19,4) NOT NULL DEFAULT 0.0000,
  CostLastYear DECIMAL(19,4) NOT NULL DEFAULT 0.0000,
  rowguid CHAR(50) DEFAULT NULL,
  ModifiedDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (TerritoryId),
  UNIQUE KEY AK_SalesTerritory_Name (Name),
  UNIQUE KEY AK_SalesTerritory_rowguid (rowguid),
  KEY FK_SalesTerritory_CountryRegion (CountryRegionCode)
) ENGINE=InnoDB



ALTER TABLE sales_salesterritory
ADD CONSTRAINT FK_SalesTerritory_CountryRegion
FOREIGN KEY (CountryRegionCode)
REFERENCES person_countryregion (CountryRegionCode);


ALTER TABLE sales_salesterritory
ADD CONSTRAINT CK_SalesTerritory_CostLastYear CHECK (CostLastYear >= 0),
ADD CONSTRAINT CK_SalesTerritory_CostYTD CHECK (CostYTD >= 0),
ADD CONSTRAINT CK_SalesTerritory_SalesLastYear CHECK (SalesLastYear >= 0),
ADD CONSTRAINT CK_SalesTerritory_SalesYTD CHECK (SalesYTD >= 0);



CREATE TABLE sales_sales_territory_history (
    businessentityid INT NOT NULL,
    territoryid INT NOT NULL,
    startdate DATETIME NOT NULL,
    enddate DATETIME NULL,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid, startdate, territoryid),

    CONSTRAINT fk_sth_salesperson
        FOREIGN KEY (businessentityid)
        REFERENCES sales_salesperson(businessentityid),

    CONSTRAINT fk_sth_territory
        FOREIGN KEY (territoryid)
        REFERENCES sales_salesterritory(territoryid),

    CONSTRAINT ck_sth_enddate
        CHECK (enddate IS NULL OR enddate >= startdate)
);



CREATE TABLE sales_shopping_cart_item (
    shoppingcartitemid INT NOT NULL AUTO_INCREMENT,
    shoppingcartid VARCHAR(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    productid INT NOT NULL,
    datecreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (shoppingcartitemid),

    CONSTRAINT fk_sci_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT ck_sci_quantity
        CHECK (quantity >= 1)
);



CREATE TABLE sales_specialoffer (
    specialofferid INT NOT NULL AUTO_INCREMENT,

    description VARCHAR(255) NOT NULL,
    discountpct DECIMAL(10,4) NOT NULL DEFAULT 0.00,
    type VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,

    startdate DATETIME NOT NULL,
    enddate DATETIME NOT NULL,

    minqty INT NOT NULL DEFAULT 0,
    maxqty INT,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (specialofferid),

    CONSTRAINT ck_discountpct CHECK (discountpct >= 0),
    CONSTRAINT ck_enddate CHECK (enddate >= startdate),
    CONSTRAINT ck_maxqty CHECK (maxqty IS NULL OR maxqty >= 0),
    CONSTRAINT ck_minqty CHECK (minqty >= 0)
) ENGINE=InnoDB;



CREATE TABLE sales_specialofferproduct (
    specialofferid INT NOT NULL,
    productid INT NOT NULL,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (specialofferid, productid),

    CONSTRAINT fk_sop_product
        FOREIGN KEY (productid)
        REFERENCES production_product(productid),

    CONSTRAINT fk_sop_specialoffer
        FOREIGN KEY (specialofferid)
        REFERENCES sales_specialoffer(specialofferid)
) ENGINE=InnoDB;



CREATE TABLE sales_store (
    businessentityid INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    salespersonid INT NULL,

    demographics JSON NULL,

    rowguid CHAR(50) NOT NULL DEFAULT (UUID()),
    modifieddate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (businessentityid),

    CONSTRAINT fk_store_businessentity
        FOREIGN KEY (businessentityid)
        REFERENCES person_businessentity(businessentityid),

    CONSTRAINT fk_store_salesperson
        FOREIGN KEY (salespersonid)
        REFERENCES sales_salesperson(businessentityid)
) ENGINE=InnoDB;



--Validation 

SELECT * FROM  dbo_awbuildversion;
SELECT * FROM  dbo_databaselog;
SELECT * FROM  dbo_errorlog;
SELECT * FROM humanresources_department
SELECT * FROM humanresources_employee
SELECT * FROM humanresources_employeedepartmenthistory;
SELECT * FROM humanresources_employeepayhistory;
SELECT * FROM humanresources_jobcandidate;
SELECT * FROM humanresources_shift
SELECT * FROM person_address;
SELECT * FROM person_addresstype;
SELECT * FROM person_businessentity;
SELECT * FROM person_businessentityaddress;
SELECT * FROM person_businessentitycontact;
SELECT * FROM person_contacttype;
SELECT * FROM person_countryregion;
SELECT * FROM person_emailaddress;
SELECT * FROM person_password;
SELECT * FROM person_person;
SELECT * FROM person_personphone;
SELECT * FROM person_phonenumbertype;
SELECT * FROM person_stateprovince;
SELECT * FROM production_billofmaterials;
SELECT * FROM production_culture;
SELECT * FROM production_document;
SELECT * FROM production_illustration;
SELECT * FROM production_location;
SELECT * FROM production_product;
SELECT * FROM production_productcategory;
SELECT * FROM production_productcosthistory;
SELECT * FROM production_productdescription;
SELECT * FROM production_productdocument;
SELECT * FROM production_productinventory;
SELECT * FROM production_productlistpricehistory;
SELECT * FROM production_productmodel;
SELECT * FROM production_productmodelillustration;
SELECT * FROM production_productmodelproductdescriptionculture;
SELECT * FROM production_productphoto;
SELECT * FROM production_productproductphoto;
SELECT * FROM production_productreview;
SELECT * FROM production_productsubcategory;
SELECT * FROM production_scrapreason;
SELECT * FROM production_transactionhistory;
SELECT * FROM production_transactionhistoryarchive;
SELECT * FROM production_unitmeasure;
SELECT * FROM production_workorder;
SELECT * FROM production_workorderrouting;
SELECT * FROM purchasing_productvendor;
SELECT * FROM purchasing_purchaseorderdetail;
SELECT * FROM purchasing_purchaseorderheader;
SELECT * FROM purchasing_shipmethod;
SELECT * FROM purchasing_vendor;
SELECT * FROM sales_countryregioncurrency;
SELECT * FROM sales_creditcard;
SELECT * FROM sales_currency;
SELECT * FROM sales_currencyrate;
SELECT * FROM sales_customer;
SELECT * FROM sales_personcreditcard;
SELECT * FROM sales_salesterritoryhistory;
SELECT * FROM sales_salesorderdetail;
SELECT * FROM sales_salesorderheader;
SELECT * FROM sales_salesorderheadersalesreason;
SELECT * FROM sales_salesperson;
SELECT * FROM sales_salespersonquotahistory;
SELECT * FROM sales_salesreason;
SELECT * FROM sales_salestaxrate;
SELECT * FROM sales_salesterritory;
SELECT * FROM sales_shopping_cart_item;
SELECT * FROM sales_specialoffer;
SELECT * FROM sales_specialofferproduct;
SELECT * FROM sales_store;

