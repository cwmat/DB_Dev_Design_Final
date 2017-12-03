-- ******************************************************
-- set_spatial_metadata.sql
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

spool set_spatial_metadata.lst

-- Smellscape metadata
INSERT INTO user_sdo_geom_metadata
    VALUES (
        'smellscape',
        'feature_geometry',
        SDO_DIM_ARRAY    -- DIMINFO attribute, stores dimension bounds and tolerance
        (
            SDO_DIM_ELEMENT
            (
            'LONGITUDE', -- dimension name for first dimension
            -180,        -- SDO_LB - lower bound of the dimension values
            180,         -- upper bound for the dimension values
            0.5          -- tolerance for values - 0.5 meters   
            ),
            SDO_DIM_ELEMENT
            (
            'LATITUDE', -- dimension name for second dimension
            -90,        -- SDO_LB - lower bound of the dimension values
            90,         -- upper bound for the dimension values
            0.5          -- tolerance for values - 0.5 meters   
            )
        ),
        8307            -- SRID for WGS 84 Datum
    );


-- smell_profile metadata
INSERT INTO user_sdo_geom_metadata
    VALUES (
        'smell_profile',
        'feature_geometry',
        SDO_DIM_ARRAY    -- DIMINFO attribute, stores dimension bounds and tolerance
        (
            SDO_DIM_ELEMENT
            (
            'LONGITUDE', -- dimension name for first dimension
            -180,        -- SDO_LB - lower bound of the dimension values
            180,         -- upper bound for the dimension values
            0.5          -- tolerance for values - 0.5 meters   
            ),
            SDO_DIM_ELEMENT
            (
            'LATITUDE', -- dimension name for second dimension
            -90,        -- SDO_LB - lower bound of the dimension values
            90,         -- upper bound for the dimension values
            0.5          -- tolerance for values - 0.5 meters   
            )
        ),
        8307            -- SRID for WGS 84 Datum
    );













-- ******************************************************
--    END SESSION
-- ******************************************************

spool off