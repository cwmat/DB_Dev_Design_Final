import arcpy

csv_file = r"C:\Users\cmateer\Desktop\Output\out_points.txt"
fc = r"C:\Data\Critical Facilities\Downloads\nhgis0005_shape\nhgis0005_shape\nhgis0005_shapefile_tl2010_510_block_2010\Data.gdb\RVA_Points"

with open(csv_file, 'w+') as out_file:
    for row in arcpy.da.SearchCursor(fc, ["SHAPE@WKT"]):
        out_file.write("{0}\n".format(row[0]))


