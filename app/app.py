from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def time_service():
    return jsonify({
        'timestamp': datetime.utcnow().isoformat() + 'Z',
        'ip': request.headers.get('X-Forwarded-For', request.remote_addr)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
