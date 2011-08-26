#!/usr/bin/env python
import sqlite3

conn = sqlite3.connect("happy-balls.db")
curs = conn.cursor()
curs.execute("""CREATE TABLE IF NOT EXISTS happiness (
    time TIMESTAMP DEFAULT (datetime('now','localtime')),
    location INT,
    happiness INT,
    unhappiness INT
  );""")
conn.close()
