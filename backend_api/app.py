from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, db
import random


def get_code():
    return random.randint(1000,9999)

# Initialize Firebase
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://universal-remote-db-default-rtdb.firebaseio.com/'  # ← replace with your URL
})

app = Flask(__name__)

@app.route("/")
def home():
    return "Welcome to universal remote"

@app.route("/sendcmd", methods=["POST"])
def sendcmd():
    data = request.get_json()
    result = {"status": "False"}
    if data and all(k in data for k in ("type", "model", "command")):
        ref = db.reference("/remote_cmd")
        code=get_code()
        command_payload={
            "code":code,
            "data":data
        }
        ref.set(command_payload)  # Overwrites previous data
        result["status"] = "True"
    return jsonify(result)

@app.route("/getcmd", methods=["GET"])
def getcmd():
    ref = db.reference("/remote_cmd")
    data = ref.get()
    return jsonify(data or {})