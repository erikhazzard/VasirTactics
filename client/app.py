# ==============================================================================
# app.py
#   A backend example for the proto demo.  Will serve up data and static pages
#
# ==============================================================================
import flask
import datetime
import json
import re

# ==============================================================================
#
# Setup flask app
#
# ==============================================================================
app = flask.Flask(__name__)
#DB_CONNECTION = pymongo.Connection('localhost', 27017)
#use the database
#DB = DB_CONNECTION.vasirTactics

#redisClient = redis.StrictRedis(host='localhost', port=6379, db=0)
#CACHE_PREFIX = 'vasirTactics:'
PORT = 7200
# ==============================================================================
#
# Static Endpoints
#
# ==============================================================================
#Base render func, everything get passed through here
def render_skeleton(template_name='index.html', **kwargs):
    return flask.render_template(template_name, **kwargs)

@app.route('/')
def index():
    return flask.render_template('index.html')

@app.route('/tests')
def tests():
    return flask.render_template('unit_tests.html')

@app.route('/experiment/')
def experiment():
    return flask.render_template('experiment.html')

# ==============================================================================
#
# Run server
#
# ==============================================================================
if __name__ == "__main__":
    app.debug = True
    app.run(port=PORT)
