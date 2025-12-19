from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def get_info():
    # Get current timestamp
    timestamp = datetime.now().isoformat()
    
    # Check for X-Forwarded-For header (if behind proxy/load balancer)
    if request.headers.get('X-Forwarded-For'):
        ip = request.headers.get('X-Forwarded-For').split(',')[0]
    else:
        ip = request.remote_addr
    
    response = {
        "timestamp": timestamp,
        "ip": f"your ip is {ip}"
    }
    
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
