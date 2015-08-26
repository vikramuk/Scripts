from flask import Flask, url_for
from flask import request
from flask import json
from flask import jsonify
from flask import Response
import logging
#  Start of Authentication
from functools import wraps
#  End of Authentication
app = Flask(__name__)
#Start for Logging 
file_handler = logging.FileHandler('app.log')
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)
# End of Logging
'''
http://blog.luisrei.com/articles/flaskrest.html
'''

# First method for Pages
'''
GET /
Welcome

GET /articles
List of /articles

GET /articles/123
You are reading 123
'''
@app.route('/')
def api_root():
    return 'Welcome'

@app.route('/articles')
def api_articles():
    return 'List of ' + url_for('api_articles')

@app.route('/articles/<articleid>')
def api_article(articleid):
    return 'You are reading ' + articleid
# Second Method for GET Requests
'''
GET /hello
Hello John Doe

GET /hello?name=Luis
Hello Luis
'''
@app.route('/hello')
def api_hello():
    if 'name' in request.args:
        return 'Hello ' + request.args['name']
    else:
        return 'Hello John Doe'

# Third Method for Request Methods (HTTP Verbs)
'''
curl -X PATCH http://127.0.0.1:5000/echo
GET /echo
ECHO: GET

POST /ECHO
ECHO: POST
'''
@app.route('/echo', methods = ['GET', 'POST', 'PATCH', 'PUT', 'DELETE'])
def api_echo():
    if request.method == 'GET':
        return "ECHO: GET\n"

    elif request.method == 'POST':
        return "ECHO: POST\n"

    elif request.method == 'PATCH':
        return "ECHO: PATCH\n"

    elif request.method == 'PUT':
        return "ECHO: PUT\n"

    elif request.method == 'DELETE':
        return "ECHO: DELETE"
#  Fourth Method for Request Data & Headers
'''
curl -H "Content-type: application/json" \
-X POST http://127.0.0.1:5000/messages -d '{"message":"Hello Data"}'

curl -H "Content-type: application/octet-stream" \
-X POST http://127.0.0.1:5000/messages --data-binary @message.bin
'''
@app.route('/messages', methods = ['POST'])
def api_message():

    if request.headers['Content-Type'] == 'text/plain':
        return "Text Message: " + request.data

    elif request.headers['Content-Type'] == 'application/json':
        return "JSON Message: " + json.dumps(request.json)

    elif request.headers['Content-Type'] == 'application/octet-stream':
        f = open('./binary', 'wb')
        f.write(request.data)
        f.close()
        return "Binary message written!"
    else:
        return "415 Unsupported Media Type ;)"
		
		
#  Fifth Method for Response
'''
curl -i http://127.0.0.1:5000/hello
'''
@app.route('/helloResponse', methods = ['POST'])
def helloResponse():
    data = {
        'hello'  : 'world',
        'number' : 3
    }
    js = json.dumps(data)
    #	resp = Response(js, status=200, mimetype='application/json')
    resp = jsonify(data)
    resp.status_code = 200
    resp.headers['Link'] = 'http://luisrei.com'
    return resp
#  Sixth Method for Status And Error Codes
'''
GET /users/2
HTTP/1.0 200 OK
{
    "2": "steve"
}
GET /users/4
HTTP/1.0 404 NOT FOUND
{
"status": 404, 
"message": "Not Found: http://127.0.0.1:5000/users/4"
}
'''	
@app.errorhandler(404)
def not_found(error=None):
    message = {
            'status': 404,
            'message': 'Not Found: ' + request.url,
    }
    resp = jsonify(message)
    resp.status_code = 404

    return resp

@app.route('/users/<userid>', methods = ['GET'])
def api_users(userid):
    users = {'1':'john', '2':'steve', '3':'bill'}
    
    if userid in users:
        return jsonify({userid:users[userid]})
    else:
        return not_found()

# Start for Logging
@app.route('/hello', methods = ['GET'])
def api_loghello():
    app.logger.info('informing')
    app.logger.warning('warning')
    app.logger.error('Error!')    
    return "check your logs\n"
# End for Logging

# Start of Authentication
def check_auth(username, password):
    return username == 'admin' and password == 'secret'

def authenticate():
    message = {'message': "Authenticate."}
    resp = jsonify(message)

    resp.status_code = 401
    resp.headers['WWW-Authenticate'] = 'Basic realm="Example"'

    return resp

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth: 
            return authenticate()

        elif not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwargs)

    return decorated

@app.route('/secrets')
@requires_auth
def api_helloAuthentication():
    return "Shhh this is top secret spy stuff!"	
		
# End of Authentication
'''
GET /secrets
HTTP/1.0 401 UNAUTHORIZED
WWW-Authenticate: Basic realm="Example"
{
  "message": "Authenticate."
}
curl -v -u "admin:secret" http://127.0.0.1:5000/secrets
'''			
if __name__ == '__main__':
    app.run()
	
	
