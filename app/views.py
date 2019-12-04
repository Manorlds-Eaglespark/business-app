import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, abort, json
from flask_cors import CORS
from instance.config import app_config

def create_app(config_name):
    app = FlaskAPI(__name__, instance_relative_config=True)
    app.config.from_object(app_config[config_name])
    app.config.from_pyfile('config.py')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv('SQLALCHEMY_DATABASE_URI')
    CORS(app)

    @app.route('/', methods=['GET'])
    def welcome_to_api():
        response = {"status": 200,
            "message": "Welcome To Malazi App API"}
        return make_response(jsonify(response)), 200

    return app
