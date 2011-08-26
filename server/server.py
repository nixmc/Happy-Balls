#!/usr/bin/env python

import sqlite3

from flask import Flask, g, request

app = Flask(__name__)
DATABASE = 'happy-balls.db'

def connect_db():
    return sqlite3.connect(DATABASE)

@app.before_request
def before_request():
    g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
    if hasattr(g, 'db'):
        g.db.close()

@app.route('/')
def index():
    return 'Hello World!\n'

@app.route('/add', methods=['POST'])
def add():
    try:
        location = int(request.form['location'])
        print "location: ", location
        happiness = int(request.form['happiness'])
        print "happiness: ", happiness
        unhappiness = int(request.form['unhappiness'])
        print "unhappiness: ", unhappiness
        g.db.execute("""INSERT INTO happiness(location, happiness, unhappiness) VALUES (?, ?, ?);""", (location, happiness, unhappiness))
        g.db.commit()
    except Exception, e:
        return "%s\n" % str(e), 400, None, "text/plain"
    return "OK\n", 200, None, "text/plain"

if __name__ == '__main__':
    app.run()
