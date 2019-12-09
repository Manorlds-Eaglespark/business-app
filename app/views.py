import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, json
from flask_cors import CORS 
from flask_sqlalchemy import SQLAlchemy
from instance.config import app_config
from shared_db import db
from app.models.user import User
from app.helpers.user_functions import UserHelper
                
def create_app(config_name):
    app = FlaskAPI(__name__, instance_relative_config=True)
    app.config.from_object(app_config[config_name])
    app.config.from_pyfile('config.py')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv('SQLALCHEMY_DATABASE_URI')
    db.init_app(app)
    CORS(app)

    @app.route('/', methods=['GET'])
    def welcome_to_api():
        """Check if API is running"""
        response = {"status": 200,
            "message": "Welcome To Malazi App API"}
        return make_response(jsonify(response)), 200


    @app.route('/api/v1/user/register', methods=['POST'])
    def register_new_user():
        name = request.get_json()['name']
        password = request.get_json()['password']
        email = request.get_json()['email']
        role = 'buyer'
        thumbnail = request.get_json()['thumbnail']
        UserHelper.validate_user()
        # UserHelper.validate_user(name, email, password, thumbnail, role)
        # new_user = User(name, password, email, thumbnail, role)
        # new_user.save()
        # response = {
        #     "message": "User successfully created!"}
        # return make_response(jsonify(response)), 201
        return {"bn":1}

    return app
