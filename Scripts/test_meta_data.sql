INSERT INTO user_sdo_geom_metadata
        -- (TABLE_NAME,
        -- COLUMN_NAME,
        -- DIMINFO,
        -- SRID) 
    VALUES (
        'test_spatial',
        'geo_doc',
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
        8307
    );