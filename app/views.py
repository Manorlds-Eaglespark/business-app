import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, json
from flask_cors import CORS 
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from instance.config import app_config
from shared_db import db, ma
from app.models.user import User
from app.models.companies import Company
from app.utilities.user_functions import User_Functions
from app.models.user import user_schema
from app.models.user import users_schema
from app.models.companies import company_schema
from app.models.companies import companies_schema
from app.utilities.register_validation import Register_Validation
from app.utilities.company_validation import Company_Validation
from app.utilities.login_requirements import login_required
                
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
        role = request.get_json()['role']
        thumbnail = request.get_json()['thumbnail']
        verify_data = Register_Validation({"name":name, "password":password, "email":email, "thumbnail":thumbnail, "role":role})
        is_verified = verify_data.check_input()
        if is_verified[0] == 200:
            new_user = User(name, password, email, thumbnail, role)
            new_user.save()
            return make_response(jsonify({"message": "User successfully created!"})), 201
        else:
            return make_response(jsonify({"message":is_verified[1]})), is_verified[0]


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

        self.manager = manager
        self.name = name
        self.description = description

    @app.route('/api/v1/company', methods=['GET','POST'])
    def register_new_company():
        if request.method == 'GET':
            companies = Company.query.all()
            return make_response(jsonify({"companies": companies_schema.dump(companies)})), 200

        if request.method == 'POST':
            manager = request.get_json()['manager']
            name = request.get_json()['name']
            description = request.get_json()['description']
            verify_data = Company_Validation({"manager":manager, "name":name, "description":description})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_company = Company(manager, name, description)
                new_company.save()
                return make_response(jsonify({"message": "Company successfully created!"})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]


    @app.route('/api/v1/company/<id>', methods=['GET','PUT','DELETE'])
    @login_required
    def get_update_delete_company(current_user, id):
        company = Company.query.get(id)
        if company:
            if request.method == 'DELETE':
                # @manager required     current user == company manager
                    company.delete()
                    return make_response(jsonify({"message": "You Successfully Deleted Company "+id})), 202
            
            elif request.method == 'GET':
                return make_response(jsonify({"company": company_schema.dump(company)})), 200
            
            elif request.method == 'PUT':
                name =   str(request.data.get('name', ''))
                description =  str(request.data.get('description', ''))
                if name and description:
                    company.name = name
                    company.description = description
                    company.save()
                    return make_response(jsonify({"message":"You successfully updated Company "+id, "company": company_schema.dump(company)})), 202
                else:
                    return make_response(jsonify({"message":"Include both Name & Description"})), 400
        else:
            return make_response(jsonify({"message": "Company does not exist"})), 404


    return app
