
-- PostgreSQL row counts

-- Validation for row counts

SELECT COUNT(*) AS count FROM dbo.awbuildversion; --1
SELECT COUNT(*) AS count FROM dbo.databaselog;  --927
SELECT COUNT(*) AS count FROM dbo.errorlog;  --0
SELECT COUNT(*) AS count FROM humanresources.department; --16
SELECT COUNT(*) AS count FROM humanresources.employee; --290
SELECT COUNT(*) AS count FROM humanresources.employeedepartmenthistory; --296
SELECT COUNT(*) AS count FROM humanresources.employeepayhistory;  --316
SELECT COUNT(*) AS count FROM humanresources.jobcandidate; --13
SELECT COUNT(*) AS count FROM humanresources.shift;  --3
SELECT COUNT(*) AS count FROM person.address; --19614
SELECT COUNT(*) AS count FROM person.addresstype; --6
SELECT COUNT(*) AS count FROM person.businessentity;  --20777
SELECT COUNT(*) AS count FROM person.businessentityaddress;  --19614
SELECT COUNT(*) AS count FROM person.businessentitycontact;  --909
SELECT COUNT(*) AS count FROM person.contacttype;  --20
SELECT COUNT(*) AS count FROM person.countryregion;  --238
SELECT COUNT(*) AS count FROM person.emailaddress;  --19972
SELECT COUNT(*) AS count FROM person.password; --19972
SELECT COUNT(*) AS count FROM person.person;  --19972
SELECT COUNT(*) AS count FROM person.personphone; --19972
SELECT COUNT(*) AS count FROM person.phonenumbertype;  --3
SELECT COUNT(*) AS count FROM person.stateprovince; --181
SELECT COUNT(*) AS count FROM production.billofmaterials;  --2679
SELECT COUNT(*) AS count FROM production.culture;  --8
SELECT COUNT(*) AS count FROM production.document;  --12
SELECT COUNT(*) AS count FROM production.illustration;  --5
SELECT COUNT(*) AS count FROM production.location;  --14
SELECT COUNT(*) AS count FROM production.product;  --504
SELECT COUNT(*) AS count FROM production.productcategory;  --4
SELECT COUNT(*) AS count FROM production.productcosthistory;  --395
SELECT COUNT(*) AS count FROM production.productdescription;  --762
SELECT COUNT(*) AS count FROM production.productdocument;  --32
SELECT COUNT(*) AS count FROM production.productinventory;  --1069
SELECT COUNT(*) AS count FROM production.productlistpricehistory;  --395
SELECT COUNT(*) AS count FROM production.productmodel;  --128
SELECT COUNT(*) AS count FROM production.productmodelillustration;  --7
SELECT COUNT(*) AS count FROM production.productmodelproductdescriptionculture;  --762
SELECT COUNT(*) AS count FROM production.productphoto;  --101
SELECT COUNT(*) AS count FROM production.productproductphoto;  --504
SELECT COUNT(*) AS count FROM production.productreview;  --4
SELECT COUNT(*) AS count FROM production.productsubcategory;  --37
SELECT COUNT(*) AS count FROM production.scrapreason;  --16
SELECT COUNT(*) AS count FROM production.transactionhistory;  --113443
SELECT COUNT(*) AS count FROM production.transactionhistoryarchive;  --89253
SELECT COUNT(*) AS count FROM production.unitmeasure;   --38
SELECT COUNT(*) AS count FROM production.workorder;  --72591
SELECT COUNT(*) AS count FROM production.workorderrouting;  --67131
SELECT COUNT(*) AS count FROM purchasing.productvendor;  --460
SELECT COUNT(*) AS count FROM purchasing.purchaseorderdetail; --8845
SELECT COUNT(*) AS count FROM purchasing.purchaseorderheader;  --4012
SELECT COUNT(*) AS count FROM purchasing.shipmethod;  --5
SELECT COUNT(*) AS count FROM purchasing.vendor;  --104
SELECT COUNT(*) AS count FROM sales.countryregioncurrency;  --109
SELECT COUNT(*) AS count FROM sales.creditcard;  --19118
SELECT COUNT(*) AS count FROM sales.currency;  --105
SELECT COUNT(*) AS count FROM sales.currencyrate;  --13532
SELECT COUNT(*) AS count FROM sales.customer;  --19820
SELECT COUNT(*) AS count FROM sales.personcreditcard;  --19118
SELECT COUNT(*) AS count FROM sales.salesterritoryhistory;  --17
SELECT COUNT(*) AS count FROM sales.salesorderdetail;  --121317
SELECT COUNT(*) AS count FROM sales.salesorderheader;  --31465
SELECT COUNT(*) AS count FROM sales.salesorderheadersalesreason;  --27647
SELECT COUNT(*) AS count FROM sales.salesperson;  --17
SELECT COUNT(*) AS count FROM sales.salespersonquotahistory;  --163
SELECT COUNT(*) AS count FROM sales.salesreason; --10
SELECT COUNT(*) AS count FROM sales.salestaxrate;  --29
SELECT COUNT(*) AS count FROM sales.salesterritory;  --10
SELECT COUNT(*) AS count FROM sales.shopping_cart_item;  --3
SELECT COUNT(*) AS count FROM sales.specialoffer;  --16
SELECT COUNT(*) AS count FROM sales.specialofferproduct;  --538
SELECT COUNT(*) AS count FROM sales.store;   --701


