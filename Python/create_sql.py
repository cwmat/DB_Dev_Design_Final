import csv

csv_file = r"C:\Users\chazm\Google Drive\HES\DB Design and Dev\Final Project\Python\out.csv"
out_file = r"C:\Users\chazm\Google Drive\HES\DB Design and Dev\Final Project\Python\insert.txt"

with open(out_file, 'w+') as out:
    with open(csv_file, 'r') as inf:
        reader = csv.reader(inf)
        for row in reader:
            print(row[0])
            output = "INSERT INTO smellscape VALUES ('{0}', SDO_UTIL.FROM_WKTGEOMETRY ('{1}'));\n".format(row[0], row[1])
            out.write(output)
