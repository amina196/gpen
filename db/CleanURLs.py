import csv

thefile = csv.reader(open("GPEN_Organizations.csv", 'rb'))
dupes = open("websiteurls.csv", 'wb')
writeto = csv.writer(dupes, quoting = csv.QUOTE_ALL)
users = []
for row in thefile:
    if row[8] != '': 
        if row[8].startswith("http://") == False:
            row[8] = "http://" + row[8]
        writeto.writerow([row[0], row[8]])
    else:
        writeto.writerow([row[0]])
dupes.close()
