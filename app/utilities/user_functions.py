import os
import jwt
from flask_bcrypt import Bcrypt
from flask import make_response, request, jsonify, json
from app.models.users import User
from app.views import db
from datetime import datetime, timedelta

class User_Functions:
    
    @staticmethod
    def validate_user():
        # if not (name and email and password and thumbnail and role):
        #     return make_response({"message": "something missing!"}), 400
        # if len(name) < 3:
        return {"message": "Name should have atleast 4 characters"}

    @staticmethod
    def user_email_verified(given_password, password):
        return Bcrypt().check_password_hash(password, given_password)

    @staticmethod
    def generate_token(user_id, role):
        """ Generates the access token"""
        try:
            # set up a payload with an expiration time
            payload = {
                'exp': datetime.utcnow() + timedelta(minutes=15),
                'iat': datetime.utcnow(),
                'sub': user_id,
                'rle': role
            }
            # create the byte string token using the payload and the SECRET key
            jwt_string = jwt.encode(
                payload,
                str(os.getenv('SECRET')),
                algorithm='HS256'
            )
            return jwt_string.decode()

        except Exception as e:
            # return an error in string format if an exception occurs
            return str(e)

    @staticmethod
    def decode_token(token):
        """Decodes the access token from the Authorization header."""
        try:
            # try to decode the token using our SECRET variable
            payload = jwt.decode(token, current_app.config.get('SECRET'))
            return payload['sub']
        except jwt.ExpiredSignatureError:
            # the token is expired, return an error string
            return "Expired token. Please login to get a new token"
        except jwt.InvalidTokenError:
            # the token is invalid, return an error string
            return "Invalid token. Please register or login"
