-- ******************************************************
-- 2017ps3.sql
--
-- Loader for PS-3 Database
--
-- Description:	This script contains the DDL to load
--              the tables of the
--              INVENTORY database
--
-- There are 6 tables on this DB
--
-- Author:  Maria R. Garcia Altobello
--
-- Student:  <<Insert your name here>>
--
-- Date:   October, 2017
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool 2017ps3.lst


-- ******************************************************
--    DROP TABLES
-- Note:  Issue the appropiate commands to drop tables
-- ******************************************************


-- ******************************************************
--    DROP SEQUENCES
-- Note:  Issue the appropiate commands to drop sequences
-- ******************************************************



-- ******************************************************
--    CREATE TABLES
-- ******************************************************


CREATE table tbComponent (
        prodNo          char (3)                not null,
        compNo          char (2)                not null,
        partNo          char (2)                null,
        noPartsReq      number (2,0)            default 1     not null
);


CREATE table tbPart (
        partNo          char(2)                 not null,
        partDescr       varchar2(15)            not null,
        quantityOnHand  number(8,0)             not null
);


CREATE table tbProduct (
        prodNo          char(3)                 not null,
        productName     varchar2(15)            not null,
        schedule        number(2,0)             not null
);


CREATE table tbQuote (
        vendorNo        char(2)                 not null,
        partNo          char(2)                 not null,
        priceQuote      number(11,2)            default 0     not null
);


CREATE table tbShipment (
        shipmentNo      number (11,0)           not null,
        vendorNo        char (3)                not null,
        partNo          char (2)                not null,
        quantity        number (4,0)            default 1,
        shipmentDate    date                    default CURRENT_DATE     not null
);


CREATE table tbVendor (
        vendorNo        char(3)                 not null,
        vendorName      varchar2(25)            not null,
        vendorCity      varchar2(15)            null
);


-- ******************************************************
--    CREATE SEQUENCES
-- ******************************************************

CREATE sequence seq_shipment
    increment by 1
    start with 1;
    
    
-- ******************************************************
--    POPULATE TABLES
--
-- Note:  Follow instructions and data provided on PS-3
--        to populate the tables
-- ******************************************************

/* inventory tbComponent */


/* inventory tbPart */


/* inventory tbProduct */


/* inventory tbQuote */


/* inventory tbShipment */


/* inventory tbVendor */


-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
-- ******************************************************

SELECT * FROM tbComponent;
SELECT * FROM tbPart;
SELECT * FROM tbProduct;
SELECT * FROM tbQuote;
SELECT * FROM tbShipment;
SELECT * FROM tbVendor;


-- ******************************************************
--    QUALITY CONTROLS
--
-- Note:  Test only 2 constraints of each of
--        the following types:
--        *) Entity integrity
--        *) Referential integrity
--        *) Column constraints
-- ******************************************************


-- ******************************************************
--    END SESSION
-- ******************************************************

spool off

