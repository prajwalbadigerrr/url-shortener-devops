from flask import Flask, redirect, request, jsonify
import hashlib

app = Flask(__name__)
store = {}

@app.route('/shorten', methods=['POST'])
def shorten():
    url = request.json.get('url')
    if not url:
        return jsonify({'error': 'URL is required'}), 400
    short = hashlib.md5(url.encode()).hexdigest()[:6]
    store[short] = url
    return jsonify({'short_url': f'http://localhost:5000/{short}'})

@app.route('/<short_id>')
def redirect_url(short_id):
    url = store.get(short_id)
    if url:
        return redirect(url)
    return jsonify({'error': 'URL not found'}), 404

@app.route('/health')
def health():
    return jsonify({'status': 'ok', 'total_urls': len(store)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)