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
from app.models.users import User, user_schema, users_schema
from app.models.categories import Category, categories_schema, category_schema
from app.models.properties import Property, properties_schema, property_schema
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
        name = str(request.data.get('name', ''))
        email = str(request.data.get('email', ''))
        phone = str(request.data.get('phone'))
        photo = str(request.data.get('photo'))
        role = str(request.data.get('role', ''))

        if email:
            user = User.query.filter_by(email=email).first()
        if phone:
            user = User.query.filter_by(phone=phone).first()

        if user:
            access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
            return make_response(jsonify({"token": access_token, "user": user_schema.dump(user)})), 200
        else:
            if name == '':
                name = email.split('@')[0]
            user = User(name, email, role, photo, phone)
            user.save()
            access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
            return make_response(jsonify({"token": access_token, "user": user_schema.dump(user)})), 201



    @app.route('/api/v1/user/edit', methods=['PUT'])
    @jwt_required
    def edit_user_details():
        if request.method == 'PUT':
            current_user = get_jwt_identity()
            name = request.form.get('name', '')
            email = request.form.get('email', '')
            phone = request.form.get('phone', '')
            image = request.files.get('image')
            user =  User.query.get(current_user)
            if user:
                user.add_added(name, email, phone)
                if image:
                    if image and imgur_handler.allowed_file(image.filename):
                        image_data = imgur_handler.send_image(image)
                        image_url = image_data["data"]["link"]
                        image_delete_hash =  image_data["data"]["deletehash"]
                        user.add_image(image_url, image_delete_hash)
                user.save()
                access_token = create_access_token(identity={'id': user.id}, expires_delta=timedelta(days=365))
                return make_response(jsonify({"message":"Success", "token": access_token, "user": user_schema.dump(user)}))
            return make_response(jsonify({"message":"User not found"})), 404



########################################################################################### Category CRUD
    @app.route('/api/v1/categories', methods=['GET','POST'])
    def get_add_new_category():
        if request.method == 'GET':
            categories = Category.query.all()
            return make_response(jsonify(categories_schema.dump(categories))), 200
        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            image = request.files.get("image")

            print(name)
            print(image)
            
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
    @app.route('/api/v1/properties/frontpage', methods=['GET'])
    def get_front_page():
        if request.method == 'GET':
            properties = Property.query.order_by(Property.id.desc()).limit(10).all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['agent'] = users_schema.dump(User.query.filter_by(id=property['agent_id']))[0]
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
                all_properties.append(property)
            return make_response(jsonify( all_properties)), 200


    @app.route('/api/v1/properties', methods=['GET','POST'])
    def get_add_new_property():
        if request.method == 'GET':
            properties = Property.query.order_by(Property.id.desc()).all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['agent'] = users_schema.dump(User.query.filter_by(id=property['agent_id']))[0]
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
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
            amenities = request.data.get('amenities', '')
            verify_data = Property_Validation({"name":name, "price_offer":price_offer, "description":description, "category_id": category, "agent_id": agent_id})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_property = Property(name, price_offer, description, category, agent_id, address, lat, long, amenities)
                new_property.save()
                return make_response(jsonify({"message": "property successfully created!", "property": property_schema.dump(new_property)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<id>', methods=['GET','PUT','DELETE'])
    @jwt_required
    def get_update_delete_property(id):
        property_ = Property.query.get(id)
        if property_:
            if request.method == 'DELETE':
                photos = Photo.query.filter_by(property_id=id)
                for photo in photos:
                    imgur_handler.delete_image(delete_hash=photo.del_hash)
                property_.delete()
                return make_response(jsonify({"message": "You Successfully Deleted Property "+id})), 202
            elif request.method == 'GET':
                property_i =  property_schema.dump(property_)
                property_i['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=id))
                property_i['agent'] = users_schema.dump(User.query.filter_by(id=property_i.agent_id))[0]
                property_i['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=id))
                return make_response(jsonify({'property': property_i})), 200
            elif request.method == 'PUT':
                property_data =  request.data.get('prop_details')
                property_.name = property_data['name']
                property_.description = property_data['description']
                property_.price_offer = property_data['price']
                property_.address = property_data['address']
                property_.save()
                property = property_schema.dump(property_)
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property_.id))
                property['agent'] = users_schema.dump(User.query.filter_by(id=property['agent_id']))[0]
                return make_response(jsonify(property)), 202
                
        else:
            return make_response(jsonify({"message": "Property does not exist"})), 404


    @app.route('/api/v1/properties/category/<id>', methods=['GET'])
    def get_property_by_category(id):
        if request.method == 'GET':
            page = request.args.get('page', 1, type=int)
            start = (page - 1) * 10
            end = start + 10
            properties = Property.query.order_by(Property.id.desc()).filter_by(category_id=id).all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
                property['agent'] = users_schema.dump(User.query.filter_by(id=property['agent_id']))[0]
                all_properties.append(property)
            return make_response(jsonify(all_properties[start:end])), 200


    
    @app.route('/api/v1/properties/agent/<id>', methods=['GET'])
    def get_property_by_agent(id):
        if request.method == 'GET':
            page = request.args.get('page', 1, type=int)
            start = (page - 1) * 5
            end = start + 5
            properties = Property.query.order_by(Property.id.desc()).filter_by(agent_id=id).all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
                property['agent'] = users_schema.dump(User.query.filter_by(id=property['agent_id']))[0]
                all_properties.append(property)
            return make_response(jsonify( all_properties[start:end])), 200



    @app.route('/api/v1/property/create', methods=['POST'])
    @jwt_required
    def add_new_property():
        property_data =  request.data.get('prop_details')
        current_user = get_jwt_identity()
        new_property = Property(property_data['name'], property_data['price'], property_data['description'], property_data['category'], current_user['id'], property_data['address'], 0.0, 0.0, property_data['amenities'])
        new_property.save()
        return make_response(jsonify({"message": "property successfully created!", "property": property_schema.dump(new_property)})), 201

    
    @app.route('/api/v1/property/create/<property_id>/images', methods=['POST'])
    @jwt_required
    def add_new_property_images(property_id):
        images_count = request.form.get('count', 0)
        for i in range(int(images_count)):
            image = request.files.get('image'+str(i))
            if image and imgur_handler.allowed_file(image.filename):
                image_data = imgur_handler.send_image(image)
                image_url = image_data["data"]["link"]
                image_delete_hash =  image_data["data"]["deletehash"]
                imageObj = Photo({"property_id": property_id, "image": image_url, "del_hash": image_delete_hash})
                imageObj.save()
        return make_response(jsonify({"status":"Images uploaded"}))
          


########################################################################################### Property Search
    @app.route('/api/v1/properties/search', methods=['POST'])
    def search_properties_if_available():
        search_query = request.data.get('search', '')
        property_by_name = Property.query.order_by(Property.id.desc()).filter(Property.name.ilike("%" + search_query + "%")).all()
        property_by_description = Property.query.filter(Property.description.ilike("%" + search_query + "%")).all()
        property_by_address = Property.query.filter(Property.address.ilike("%" + search_query + "%")).all()
        property_1 = properties_schema.dump(property_by_name)
        property_2 = properties_schema.dump(property_by_description)
        property_3 = properties_schema.dump(property_by_address)
        properties = property_1 + property_2 + property_3
        all_properties = []
        for property in properties:
            property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
            property['agent'] = users_schema.dump(User.query.filter_by(id=property['agent_id']))[0]
            property['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=property['id']))
            all_properties.append(property)
        return make_response(jsonify(helper.remove_dupes(all_properties))), 200



########################################################################################### Amenities

    @app.route('/api/v1/amenities', methods=['GET','POST'])
    def get_add_new_amenity():
        if request.method == 'GET':
            amenities = Amenity.query.all()
            return make_response(jsonify(amenities_schema.dump(amenities))), 200

        if request.method == 'POST':
            name =  request.form.get('name', '')
            icon = request.files.get('icon')
            if name and icon and imgur_handler.allowed_file(icon.filename):
                image_data = imgur_handler.send_image(icon)
                image_url = image_data["data"]["link"]
                image_delete_hash =  image_data["data"]["deletehash"]

                new_amenity = Amenity(image_url, image_delete_hash, name)
                new_amenity.save()
                return make_response(jsonify({"message": "Amenity successfully saved!", "Amenity": amenity_schema.dump(new_amenity)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/amenities/<id>', methods=['GET','DELETE'])
    def get_update_delete_amenities(id):
        amenity = Amenity.query.get(id)
        if amenity:
            if request.method == 'DELETE':
                imgur_handler.delete_image(delete_hash=amenity.del_icon)
                amenity.delete()
                return make_response(jsonify({"message": "You Successfully deleted Amenity "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"amenity": amenity_schema.dump(amenity)})), 200
            return make_response(jsonify({"message": "Amenity does not exist"})), 404


    return app
