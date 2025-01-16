from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Welcome to the Flask server!"

@app.route("/simulator_home")
def simulator_home():
    return "Simulator Home Page"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9000) #change port here
