import time
import subprocess
from flask import Flask, render_template, request, send_file

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/screenshot', methods=['POST','GET'])
def screenshot():
    if request.method == 'POST':
        url = request.form['url']
    else:
        url = request.args.get('url')

    subprocess.run(['wkhtmltopdf', url, 'output.pdf'])

    response = send_file('output.pdf')
#    response = make_response(converter.convert())
    response.headers['Content-Type'] = 'application/pdf'
    return response

if __name__ == '__main__':
    from gunicorn.app.base import Application

    class FlaskApplication(Application):
        def init(self, parser, opts, args):
            return {
                'bind': '0.0.0.0:5000',
                'workers': 4
            }

        def load(self):
            return app

    FlaskApplication().run()
