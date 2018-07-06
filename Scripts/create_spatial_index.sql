-- ******************************************************
-- create_spatial_index.sql 
--
-- Loader for the Smell Map Database
--
-- Description:	This script contains the DDL to load
--              the tables of the
--              SMELL_MAP database
--
-- There are 7 tables in this DB
--
-- Author:  Charles Mateer
--
-- Student:  Charles Mateer cmateer@g.harvard.edu
--
-- Date:   November, 2017
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool create_spatial_index.lst


-- ******************************************************
--    DROP EXISTING SPATIAL INDEXES
-- ******************************************************

DROP INDEX smellscape_spatial_index;
DROP INDEX smell_profile_spatial_index;


-- ******************************************************
--    CREATE SPATIAL INDEX
-- ******************************************************

CREATE INDEX smellscape_spatial_index ON smellscape (feature_geometry)
    INDEXTYPE IS MDSYS.SPATIAL_INDEX;

CREATE INDEX smell_profile_spatial_index ON smell_profile (feature_geometry)
    INDEXTYPE IS MDSYS.SPATIAL_INDEX;


-- ******************************************************
-- ******************************************************
-- ******************************************************
-- ******************************************************
-- ******************************************************
--    Added to main smellscape load - only use this file for testing
-- ******************************************************
-- ******************************************************
-- ******************************************************
-- ******************************************************

-- ******************************************************
--    END SESSION
-- ******************************************************

spool off