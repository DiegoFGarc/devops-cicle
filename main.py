from flask import Flask

app = Flask(__name__)

@app.route('/test', methods=['GET'])
def hello_devops():
    return 'Hello DevOps :D'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)