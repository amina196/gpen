import csv

thecats = csv.reader(open("Organizations(old).csv", "rb"))
thefile = open("GPEN_OrganizationSectors.csv", 'wb')
wr = csv.writer(thefile, quoting = csv.QUOTE_ALL)
for data in thecats:
    for i in range(31, 51):
        if (data[i] == "TRUE"):
            wr.writerow((data[0], data[1], str(i - 30)))
            print (data[0], data[1], str(i - 30))
thefile.close
