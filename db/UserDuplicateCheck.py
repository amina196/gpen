import csv

thefile = csv.reader(open("GPEN_User.csv", 'rb'))
dupes = open("duplicates.txt", 'w')
writeto = csv.writer(dupes, quoting = csv.QUOTE_ALL)
users = []
for row in thefile:
    user = row[1] + " " + row[2]
    if user in users:
        writeto.writerow([user])
    else:
        users.append(user)
dupes.close()
