import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, json
from flask_cors import CORS 
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from instance.config import app_config
from shared_db import db, ma
from app.models.user import User
from app.models.categories import Category
from app.models.companies import Company
from app.utilities.user_functions import User_Functions
from app.models.user import user_schema
from app.models.user import users_schema
from app.models.companies import company_schema
from app.models.companies import companies_schema
from app.models.categories import category_schema
from app.models.categories import categories_schema
from app.models.properties import property_schema
from app.models.properties import properties_schema
from app.utilities.register_validation import Register_Validation
from app.utilities.company_validation import Company_Validation
from app.utilities.category_validation import Category_Validation
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
########################################################################################### Login & Register

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


########################################################################################### Company CRUD

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


########################################################################################### Category CRUD

    @app.route('/api/v1/categories', methods=['GET','POST'])
    def get_add_new_category():
        if request.method == 'GET':
            categories = Category.query.all()
            return make_response(jsonify({"categories": categories_schema.dump(categories)})), 200

        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            description =  str(request.data.get('description', ''))
            verify_data = Category_Validation({"name":name, "description":description})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_category = Category(name, description)
                new_category.save()
                return make_response(jsonify({"message": "Category successfully created!", "category": category_schema.dump(new_category)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/categories/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_category(id):
        category = Category.query.get(id)
        if category:
            if request.method == 'DELETE':
                # @manager required     current user == company manager
                    category.delete()
                    return make_response(jsonify({"message": "You Successfully Deleted Category "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"category": category_schema.dump(category)})), 200
            elif request.method == 'PUT':
                name =   str(request.data.get('name', ''))
                description =  str(request.data.get('description', ''))
                if name and description:
                    category.name = name
                    category.description = description
                    category.save()
                    return make_response(jsonify({"message":"You successfully updated Category "+id, "category": category_schema.dump(category)})), 202
                else:
                    return make_response(jsonify({"message":"Include both Name & Description"})), 400
        else:
            return make_response(jsonify({"message": "Category does not exist"})), 404


########################################################################################### Property CRUD

    @app.route('/api/v1/property', methods=['GET','POST'])
    def add_get_new_company():
        if request.method == 'GET':
            properties = Property.query.all()
            return make_response(jsonify({"properties": properties_schema.dump(properties)})), 200

        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            description =   str(request.data.get('description', ''))
            category =   str(request.data.get('category', ''))
            company =   str(request.data.get('company', ''))

            verify_data = Property_Validation({     
                                                "name":name,
                                                "description":description, 
                                                "category":category,
                                                "company_id": company })
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_property = Property(name, description, category, company_id)
                new_property.save()
                return make_response(jsonify({"message": "Property created.", "property": property_schema.dump(new_property)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    return app
