import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, json
from flask_cors import CORS 
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token,
    get_jwt_identity, create_refresh_token, jwt_refresh_token_required)
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from instance.config import app_config
from datetime import timedelta
from shared import db, ma
from app.utilities.flask_imgur import Imgur
from app.models.user import User, user_schema, users_schema
from app.models.categories import Category, categories_schema, category_schema
from app.models.agents import Agent, agents_schema, agent_schema
from app.models.properties import Property, properties_schema, property_schema
from app.models.reviews import  Review, review_schema, reviews_schema
from app.models.locations import Location, location_schema, locations_schema
from app.models.amenities import Amenity, amenities_schema, amenity_schema
from app.models.photos import Photo, photo_schema, photos_schema
from app.utilities.user_functions import User_Functions
from app.utilities.model_validations import Register_Validation, Amenity_Validation, \
    Category_Validation, Agent_Validation, Location_Validation, Photo_Validation, \
        Property_Validation, Review_Validation
from app.utilities.login_requirements import login_required
from app.utilities.helpers import Helpers
                

def create_app(config_name):
    app = FlaskAPI(__name__, instance_relative_config=True)
    app.config.from_object(app_config[config_name])
    app.config.from_pyfile('config.py')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config["IMGUR_ID"] = os.getenv('IMGSER')
    app.config['JWT_SECRET_KEY'] = os.getenv('SECRET')
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv('SQLALCHEMY_DATABASE_URI')
    db.init_app(app)
    ma = Marshmallow(app)
    imgur_handler = Imgur(app)
    helper = Helpers()
    jwt = JWTManager(app)
    CORS(app)

    @app.route('/', methods=['GET'])
    def welcome_to_api():
        """Check if API is running"""
        response = {"status": 200,
            "message": "Welcome To Malazi App Backend API"}
        return make_response(jsonify(response)), 200



    # Auth endpoints ############################################################################################################

    @app.route('/api/v1/user/login', methods=['POST'])
    def login_user():
        email = request.data.get('email', '')
        password = request.data.get('password', '')
        user = User.query.filter_by(email=email).first()
        if user:
            if user.check_password(password):
                access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
                return make_response(jsonify({"message":"Successfully logged-in.", "token": access_token, "user": user_schema.dump(user)}))
            else:
                return make_response(jsonify( "You entered a incorrect password.")), 401
        else:
            user_data = {"email": email,  "password": password}
            user = User(email, password)
            user.save()
            access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
            return make_response(jsonify({"message":"Successfully logged-in.", "token": access_token, "user": user_schema.dump(user)}))




         
    @app.route('/api/v1/user/login/social', methods=['POST'])
    def login_social_user():
        provider = request.data.get('provider', '')
        authToken = request.data.get('token','')

        # if(provider == 'Google'):
        #     id_info = id_token.verify_oauth2_token(authToken, requests.Request(), os.getenv('CLIENT_ID'))
        #     if id_info['iss'] != 'accounts.google.com':
        #         return make_response(jsonify({"error": "Use correct signin options."})), 401
        #     user =  User.query.filter_by(email=id_info['email']).first()
            
        #     if user:
        #         access_token = create_access_token(identity={'id': user.id, 'country': user.country}, expires_delta=timedelta(days=365))
        #         return make_response(jsonify({"message":"Successfully logged-in.", "token": access_token, "country": get_country_detail(user.country)}))
        #     else:
        #         return make_response(jsonify({"error":"Sign-up first to continue."}))
        
        if(provider == 'Facebook'):
            user =  User.query.filter_by(email=authToken['email']).first()
            
            if user:
                access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
                return make_response(jsonify({"message":"Successfully logged-in.", "token": access_token, "user": user_schema.dump(user)}))
            else:
                userData = {"name": authToken['name'], "email": authToken['email'], "password": Bcrypt().generate_password_hash('uCXyJ:%N%5Dc-K+').decode()}
                user = User(userData)
                user.add_image(authToken['picture']['data']['url'])
                user.save()
                access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
                return make_response(jsonify({"message":"Successfully logged-in.", "token": access_token, "user": user_schema.dump(user)}))






########################################################################################### Category CRUD
    @app.route('/api/v1/categories', methods=['GET','POST'])
    def get_add_new_category():
        if request.method == 'GET':
            categories = Category.query.all()
            return make_response(jsonify(categories_schema.dump(categories))), 200
        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            image = request.files.get("image")
            
            if name and image and imgur_handler.allowed_file(image.filename):
                image_data = imgur_handler.send_image(image)
                image_url = image_data["data"]["link"]
                image_delete_hash =  image_data["data"]["deletehash"]
                new_category = Category(name, image_url, image_delete_hash)
                new_category.save()
                return make_response(jsonify({"message": "Category successfully created!", "category": category_schema.dump(new_category)})), 201
            else:
                return make_response(jsonify({"message": "Category not saved"})), 400

    @app.route('/api/v1/categories/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_category(id):
        category = Category.query.get(id)
        if category:
            if request.method == 'DELETE':
                imgur_handler.delete_image(category.img_del_hash)
                category.delete()
                return make_response(jsonify({"message": "You Successfully Deleted Category "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"category": category_schema.dump(category)})), 200
            elif request.method == 'PUT':
                name =   str(request.data.get('name', ''))
                image =  request.data.get('image', '')
                if name and image:
                    category.name = name
                    category.image = image
                    category.save()
                    return make_response(jsonify({"message":"You successfully updated Category "+id, "category": category_schema.dump(category)})), 202
                else:
                    return make_response(jsonify({"message":"Include name & upload new image"})), 400
        else:
            return make_response(jsonify({"message": "Category does not exist"})), 404




########################################################################################### Images CRUD
    @app.route('/api/v1/images/property/<id>', methods=['GET','POST'])
    def get_add_new_images(id):
        if request.method == 'GET':
            photos = Photo.query.filter_by(property_id=id).all()
            return make_response(jsonify(photos_schema.dump(photos)))

        if request.method == 'POST':
            images_number = request.form.get('images_number')
            for i in range(int(images_number)):
                image = request.files.get("image"+str(i))
                if image and imgur_handler.allowed_file(image.filename):
                    image_data = imgur_handler.send_image(image)
                    image_url = image_data["data"]["link"]
                    image_delete_hash =  image_data["data"]["deletehash"]
                    imageObj = Photo({"property_id": id, "image": image_url, "del_hash": image_delete_hash})
                    imageObj.save()
            return make_response(jsonify({"status":"Images uploaded"}))

########################################################################################### Property CRUD
    @app.route('/api/v1/properties', methods=['GET','POST'])
    def get_add_new_property():
        if request.method == 'GET':
            properties = Property.query.all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
                property['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=property['id']))
                all_properties.append(property)
            return make_response(jsonify( all_properties)), 200
        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            price_offer =   str(request.data.get('price_offer', ''))
            description =  str(request.data.get('description', ''))
            category =   request.data.get('category', 0)
            agent_id =  request.data.get('agent_id', 0)
            address = request.data.get('address', '')
            long = request.data.get('long', 0.0)
            lat = request.data.get('lat', 0.0)
            verify_data = Property_Validation({"name":name, "price_offer":price_offer, "description":description, "category_id": category, "agent_id": agent_id})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_property = Property(name, price_offer, description, category, agent_id, address, lat, long)
                new_property.save()
                return make_response(jsonify({"message": "property successfully created!", "property": property_schema.dump(new_property)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_property(id):
        property_ = Property.query.get(id)
        if property_:
            if request.method == 'DELETE':
                    property_.delete()
                    return make_response(jsonify({"message": "You Successfully Deleted Property "+id})), 202
            elif request.method == 'GET':
                property_i =  property_schema.dump(property_)
                property_i['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=id))
                property_i['locations'] = locations_schema.dump(Location.query.filter_by(property_id=id))
                property_i['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=id))
                return make_response(jsonify({'property': property_i})), 200
            elif request.method == 'PUT':
                name =   str(request.data.get('name', ''))
                description =  str(request.data.get('description', ''))
                if name and description:
                    property_.name = name
                    property_.description = description
                    property_.save()
                    return make_response(jsonify({"message":"You successfully updated Property "+id, "category": property_schema.dump(property_)})), 202
                else:
                    return make_response(jsonify({"message":"Include both Name & Description"})), 400
        else:
            return make_response(jsonify({"message": "Property does not exist"})), 404


    @app.route('/api/v1/properties/category/<id>', methods=['GET'])
    def get_property_by_category(id):
        if request.method == 'GET':
            properties = Property.query.filter_by(category_id=id).all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
                property['location'] = locations_schema.dump(Location.query.filter_by(property_id=property['id']))
                property['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=property['id']))
                all_properties.append(property)
            return make_response(jsonify( all_properties)), 200


########################################################################################### Property Search
    @app.route('/api/v1/properties/search', methods=['POST'])
    def search_properties_if_available():
        search_query = request.data.get('search', '')
        property_by_name = Property.query.filter(Property.name.ilike("%" + search_query + "%")).all()
        property_by_description = Property.query.filter(Property.description.ilike("%" + search_query + "%")).all()
        property_by_address = Property.query.filter(Property.address.ilike("%" + search_query + "%")).all()
        property_1 = properties_schema.dump(property_by_name)
        property_2 = properties_schema.dump(property_by_description)
        property_3 = properties_schema.dump(property_by_address)
        properties = property_1 + property_2 + property_3
        all_properties = []
        for property in properties:
            property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
            property['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=property['id']))
            all_properties.append(property)
        return make_response(jsonify(helper.remove_dupes(all_properties))), 200



    return app
