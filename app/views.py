import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, json
from flask_cors import CORS 
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from instance.config import app_config
from shared_db import db, ma
from app.models.user import User
from app.utilities.user_functions import User_Functions
from app.models.user import user_schema
                
def create_app(config_name):
    app = FlaskAPI(__name__, instance_relative_config=True)
    app.config.from_object(app_config[config_name])
    app.config.from_pyfile('config.py')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv('SQLALCHEMY_DATABASE_URI')
    db.init_app(app)
    ma = Marshmallow(app)
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
        new_user = User(name, password, email, thumbnail, role)
        new_user.save()
        return make_response(jsonify({"message": "User successfully created!"})), 201

    @app.route('/api/v1/user/login', methods=['POST'])
    def login_registered_user():
        email = request.get_json()['email']
        password = request.get_json()['password']
        user = User.query.filter_by(email=email).first()
        if user:
            if User_Functions.user_email_verified(password, user.password):
                token = User_Functions.generate_token(user.id, user.role)
                return make_response(jsonify({"token": token, "message": "You have successfully LoggedIn"})),200
            else:
                return make_response(jsonify({"message": "You entered a wrong password"})),200
        else:
            return make_response(jsonify({"message": "Wrong credentials, try again"})),200
            

    return app
