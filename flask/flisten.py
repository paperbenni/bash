#!usr/bin/env python3

import flask
import os

@app.route('/user/<username>')
def show_user_profile(username):
    print(username)
    os.system(myCmd)
    return 'User %s' % username
