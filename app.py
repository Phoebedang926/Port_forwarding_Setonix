from flask import Flask
import argparse

app = Flask(__name__)


@app.route("/")
def home():
    return "Welcome to the Flask server!"


@app.route("/simulator_home")
def simulator_home():
    return "Simulator Home Page"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--host", type=str, default="0.0.0.0")
    args = parser.parse_args()
    app.run(host=args.host, port=args.port)
