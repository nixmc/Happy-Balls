#!/usr/bin/env python2.6
import csv, datetime, pprint, sqlite3, sys

conn = sqlite3.connect("happy-balls.db")
curs = conn.cursor()
rows = curs.execute("""SELECT %s AS time, location, SUM(happiness), SUM(unhappiness) FROM happiness WHERE time BETWEEN '2011-09-03 00:00:00' AND '2011-09-04 00:00:00' GROUP BY 1, 2 ORDER BY time""" % """strftime('%s', time) - strftime('%s', time) % 60""")

# First pass, key data by date
data = {}
for when, location, happiness, unhappiness in rows:
    when = datetime.datetime.fromtimestamp(int(when))
    data.setdefault(when, {})
    data[when][location] = (happiness, unhappiness)

# Second pass, fill-in-blanks
out = csv.writer(open("results.csv", "wb"))
last = None
interval = datetime.timedelta(minutes=1)
dates = sorted(data.keys())
for when in dates:
    if last is None:
        last = when
    while last + interval < when:
        # Fill in blanks
        last += interval
        for loc in range(1,7):
            out.writerow((last.strftime("%a, %d %b %Y %H:%M:%S +0000"), loc, 0, 0))
    for loc in range(1,7):
        happy, unhappy = data[when].get(loc, (0, 0))
        out.writerow((when.strftime("%a, %d %b %Y %H:%M:%S +0000"), loc, happy, unhappy))
    last = when

sys.exit(0)
