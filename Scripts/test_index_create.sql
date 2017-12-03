DROP INDEX test_spatial_index;

CREATE INDEX test_spatial_index ON test_spatial (geo_doc)
    INDEXTYPE IS MDSYS.SPATIAL_INDEX;

SELECT SDO_GEOMETRY('POINT(-77.476508621284 37.56907082647)', 8307) FROM DUAL;
-- styuff

-- UPDATE test_spatial T SET T.geo_doc.SDO_SRID = 8307 WHERE T.geo_doc IS NOT NULL;

-- https://stackoverflow.com/questions/14707442/how-do-i-change-the-srids-for-oracle-sdo-geometry