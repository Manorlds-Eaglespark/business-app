import os
from flask_api import FlaskAPI
from flask import make_response, request, jsonify, json
from flask_cors import CORS 
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from instance.config import app_config
from shared import db, ma
from app.models.user import User, user_schema
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
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv('SQLALCHEMY_DATABASE_URI')
    db.init_app(app)
    ma = Marshmallow(app)
    helper = Helpers()
    CORS(app)

    @app.route('/', methods=['GET'])
    def welcome_to_api():
        """Check if API is running"""
        response = {"status": 200,
            "message": "Welcome To Malazi App Backend API"}
        return make_response(jsonify(response)), 200

########################################################################################### Login & Register

    @app.route('/api/v1/users/register', methods=['POST'])
    def register_new_user():
        user = request.get_json()['user']
        name = user['name']
        password = user['password']
        email = user['email']
        role = user['role']
        verify_data = Register_Validation({"name":name, "password":password, "email":email, "role":role})
        is_verified = verify_data.check_input()
        if is_verified[0] == 200:
            user = User.query.filter_by(email=email).first()
            if not user:
                new_user = User(name, password, email, role)
                new_user.save()
                return make_response(jsonify({"message": "User successfully created!"})), 201
            else:
                return make_response(jsonify({"error": "Email already in use, try with a different one."})), 406
        else:
            return make_response(jsonify({"error":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/users/login', methods=['POST'])
    def login_registered_user():
        user = request.get_json()['user']
        email = user['email']
        password = user['password']
        user = User.query.filter_by(email=email).first()
        if user:
            if User_Functions.user_email_verified(password, user.password):
                token = User_Functions.generate_token(user.id, user.role)
                return make_response(jsonify({"token": token, "message": "You have successfully LoggedIn", "role": user.role})),200
            else:
                return make_response(jsonify({"error": "You entered a wrong password"})),401
        else:
            return make_response(jsonify({"error": "Wrong credentials, try again"})),401

########################################################################################### Agent CRUD

    @app.route('/api/v1/agents', methods=['GET','POST'])
    @login_required
    def register_new_agent(current_user):
        if request.method == 'GET':
            agents = Agent.query.all()
            return make_response(jsonify({"agents": agents_schema.dump(agents)})), 200
        if request.method == 'POST':
            manager =   current_user
            name =   str(request.data.get('name', ''))
            description =   str(request.data.get('description', ''))
            telephone =   str(request.data.get('telephone', ''))
            email =   str(request.data.get('email', ''))
            address =   str(request.data.get('address', ''))
            agent_data = {'manager':manager, 'name': name, 'description': description, 'telephone': telephone, 'email': email, 'address': address}
            verify_data = Agent_Validation(agent_data)
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_agent = Agent(agent_data)
                new_agent.save()
                return make_response(jsonify({"message": "Agent successfully created!", "agent": agent_schema.dump(new_agent)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/agents/<id>', methods=['GET','PUT','DELETE'])
    @login_required
    def get_update_delete_agent(current_user, id):
        agent = Agent.query.get(id)
        if agent:
            if request.method == 'GET':
                return make_response(jsonify({"agent": agent_schema.dump(agent)})), 200
            elif request.method == 'PUT':
                name =   str(request.data.get('name', ''))
                description =   str(request.data.get('description', ''))
                telephone =   str(request.data.get('telephone', ''))
                email =   str(request.data.get('email', ''))
                address =   str(request.data.get('address', ''))   
                agent_obj = {'name': name, 'description': description, 'telephone': telephone, 'email': email, 'address': address}             
                agent.add_added(agent_obj)
                agent.name = name
                agent.description = description
                agent.save()
                return make_response(jsonify({"message":"You successfully updated Agent "+id, "agent": agent_schema.dump(agent)})), 202

            elif request.method == 'DELETE':
                agent.delete()
                return make_response(jsonify({"message": "You Successfully Deleted agent "+id})), 202
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

    @app.route('/api/v1/properties', methods=['GET','POST'])
    def get_add_new_property():
        if request.method == 'GET':
            properties = Property.query.all()
            properties_all = properties_schema.dump(properties)
            all_properties = []
            for property in properties_all:
                property['photos'] = photos_schema.dump(Photo.query.filter_by(property_id=property['id']))
                property['locations'] = locations_schema.dump(Location.query.filter_by(property_id=property['id']))
                property['amenities'] = amenities_schema.dump(Amenity.query.filter_by(property_id=property['id']))
                all_properties.append(property)
            return make_response(jsonify({"properties": all_properties})), 200
        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            description =  str(request.data.get('description', ''))
            category =   request.data.get('category', 0)
            agent_id =  request.data.get('agent_id', 0)
            verify_data = Property_Validation({"name":name, "description":description, "category_id": category, "agent_id": agent_id})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_property = Property(name, description, category, agent_id)
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

    @app.route('/api/v1/properties/search', methods=['POST'])
    def search_properties_if_available():
        search_query = request.data.get('search', '')
        property_by_name = Property.query.filter(Property.name.ilike("%" + search_query + "%")).all()
        property_by_description = Property.query.filter(Property.description.ilike("%" + search_query + "%")).all()
        property_1 = properties_schema.dump(property_by_name)
        property_2 = properties_schema.dump(property_by_description)
        properties = property_1 + property_2
        return make_response(jsonify({"properties": helper.remove_dupes(properties) })), 200

########################################################################################### Reviews CRUD

    @app.route('/api/v1/properties/<property_id>/reviews', methods=['GET','POST'])
    @login_required
    def get_add_new_review(current_user, property_id):
        if request.method == 'GET':
            reviews = Review.query.all()
            return make_response(jsonify({"reviews": reviews_schema.dump(reviews)})), 200
        if request.method == 'POST':
            user_id =   current_user
            comment =   request.data.get('comment', '')
            rating =  request.data.get('rating', '')
            verify_data = Review_Validation({"user_id":user_id, "property_id":property_id, "comment": comment, "rating": rating})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_review = Review(user_id, property_id, comment, rating)
                new_review.save()
                return make_response(jsonify({"message": "Review successfully saved!", "review": review_schema.dump(new_review)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<property_id>/reviews/<id>', methods=['GET','PUT','DELETE'])
    @login_required
    def get_update_delete_review(id):
        review = Review.query.get(id)
        if review:
            if request.method == 'DELETE':
                review.delete()
                return make_response(jsonify({"message": "You Successfully deleted Review "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"review": review_schema.dump(review)})), 200
            elif request.method == 'PUT':
                comment =   str(request.data.get('comment', ''))
                rating =  str(request.data.get('rating', ''))
                if comment and rating:
                    review.comment = comment
                    review.rating = rating
                    review.save()
                    return make_response(jsonify({"message":"You successfully updated review "+id, "review": review_schema.dump(review)})), 202
                else:
                    return make_response(jsonify({"message":"Include both Name & Description"})), 400
        else:
            return make_response(jsonify({"message": "Review does not exist"})), 404

########################################################################################### Locations CRUD

    @app.route('/api/v1/properties/<property_id>/locations', methods=['GET','POST'])
    def get_add_new_location(property_id):
        if request.method == 'GET':
            locations = Location.query.filter_by(property_id=property_id).all()
            return make_response(jsonify({"locations": locations_schema.dump(locations)})), 200
        if request.method == 'POST':
            latitude =   request.data.get('latitude','')
            longitude =   request.data.get('longitude', '')
            description =  request.data.get('description', '')
            verify_data = Location_Validation({"latitude":latitude, "longitude":longitude, "description": description})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_location = Location(property_id, latitude, longitude, description)
                new_location.save()
                return make_response(jsonify({"message": "Location successfully saved!", "Location": location_schema.dump(new_location)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<property_id>/locations/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_locations(property_id, id):
        location = Location.query.get(id)
        if location:
            if request.method == 'DELETE':
                location.delete()
                return make_response(jsonify({"message": "You Successfully deleted Location "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"location": location_schema.dump(location)})), 200
            elif request.method == 'PUT':
                latitude =   str(request.data.get('latitude', ''))
                longitude =  str(request.data.get('longitude', ''))
                description =  str(request.data.get('description', ''))
                if latitude and longitude and description:
                    location.latitude = latitude
                    location.longitude = longitude
                    location.description = description
                    location.save()
                    return make_response(jsonify({"message":"You successfully updated location "+id, "review": location_schema.dump(location)})), 202
                else:
                    return make_response(jsonify({"message":"Include Latitude, Longitude & Description"})), 400
        else:
            return make_response(jsonify({"message": "Location does not exist"})), 404


########################################################################################### Amenity CRUD

    @app.route('/api/v1/properties/<property_id>/amenities', methods=['GET','POST'])
    def get_add_new_amenity(property_id):
        if request.method == 'GET':
            amenities = Amenity.query.filter_by(property_id=property_id).all()
            return make_response(jsonify({"amenities": amenities_schema.dump(amenities)})), 200
        if request.method == 'POST':
            description =  request.data.get('description', '')
            verify_data = Amenity_Validation({"description": description})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_amenity = Amenity(property_id, description)
                new_amenity.save()
                return make_response(jsonify({"message": "Amenity successfully saved!", "Amenity": amenity_schema.dump(new_amenity)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<property_id>/amenities/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_amenities(property_id, id):
        amenity = Amenity.query.get(id)
        if amenity:
            if request.method == 'DELETE':
                # @manager required     current user == company manager
                    amenity.delete()
                    return make_response(jsonify({"message": "You Successfully deleted Amenity "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"amenity": amenity_schema.dump(amenity)})), 200
            elif request.method == 'PUT':
                description =  str(request.data.get('description', ''))
                if description:
                    amenity.description = description
                    amenity.save()
                    return make_response(jsonify({"message":"You successfully updated amenity "+id, "amenity": amenity_schema.dump(amenity)})), 202
                else:
                    return make_response(jsonify({"message":"Include a Description"})), 400
        else:
            return make_response(jsonify({"message": "Amenity does not exist"})), 404


########################################################################################### Photos CRUD

    @app.route('/api/v1/properties/<property_id>/photo-albums', methods=['GET','POST'])
    def get_add_new_photo(property_id):
        if request.method == 'GET':
            photos = Photo.query.filter_by(property_id=property_id).all()
            return make_response(jsonify({"photo_urls": photos_schema.dump(photos)})), 200
        if request.method == 'POST':
            photo_1 =  request.data.get('photo_1', '')
            photo_2 =  request.data.get('photo_2', '')
            photo_3 =  request.data.get('photo_3', '')
            photo_4 =  request.data.get('photo_4', '')
            photo_5 =  request.data.get('photo_5', '')
            photo_6 =  request.data.get('photo_6', '')
            photo_7 =  request.data.get('photo_7', '')
            photo_obj = {"property_id": property_id,"photo_1": photo_1, "photo_2": photo_2, "photo_3": photo_3, "photo_4": photo_4, "photo_5": photo_5, "photo_6": photo_6, "photo_7": photo_7}
            verify_data = Photo_Validation(photo_obj)
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_photos = Photo(photo_obj)
                new_photos.save()
                return make_response(jsonify({"message": "Photos successfully uploaded!", "Photo_urls": photo_schema.dump(new_photos)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<property_id>/photo-albums/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_photos(property_id, id):
        photo = Photo.query.get(id)
        if photo:
            if request.method == 'DELETE':
                # @manager required     current user == company manager
                    photo.delete()
                    return make_response(jsonify({"message": "You Successfully deleted photo album "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"photo_urls": photo_schema.dump(photo)})), 200
            elif request.method == 'PUT':
                photo_1 =  str(request.data.get('photo_1', ''))
                photo_2 =  str(request.data.get('photo_2', ''))
                photo_3 =  str(request.data.get('photo_3', ''))
                photo_4 =  str(request.data.get('photo_4', ''))
                photo_5 =  str(request.data.get('photo_5', ''))
                photo_6 =  str(request.data.get('photo_6', ''))
                photo_7 =  str(request.data.get('photo_7', ''))
                given_images = {"photo_1": photo_1, "photo_2": photo_2, "photo_3": photo_3, "photo_4": photo_4, "photo_5": photo_5, "photo_6": photo_6, "photo_7": photo_7}
                photo.add_added(given_images)
                photo.save()
                return make_response(jsonify({"message":"You successfully updated photo album "+id, "Photo_urls": photo_schema.dump(photo)})), 202
        else:
            return make_response(jsonify({"message": "Photo album does not exist"})), 404


    return app
