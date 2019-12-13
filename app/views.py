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
from app.models.properties import Property
from app.models.reviews import  Review
from app.models.locations import Location
from app.models.amenities import Amenity
from app.models.photos import Photo
from app.utilities.user_functions import User_Functions
from app.models.user import user_schema
from app.models.user import users_schema
from app.models.reviews import review_schema
from app.models.reviews import reviews_schema
from app.models.companies import company_schema
from app.models.companies import companies_schema
from app.models.categories import category_schema
from app.models.categories import categories_schema
from app.models.properties import property_schema
from app.models.properties import properties_schema
from app.models.locations import location_schema
from app.models.locations import locations_schema
from app.models.amenities import amenity_schema
from app.models.amenities import amenities_schema
from app.models.photos import photo_schema
from app.models.photos import photos_schema
from app.utilities.register_validation import Register_Validation
from app.utilities.company_validation import Company_Validation
from app.utilities.category_validation import Category_Validation
from app.utilities.property_validation import Property_Validation
from app.utilities.reviews_validation import Review_Validation
from app.utilities.location_validation import Location_Validation
from app.utilities.amenity_validation import Amenity_Validation
from app.utilities.photo_validation import Photo_Validation
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

    @app.route('/api/v1/properties', methods=['GET','POST'])
    def get_add_new_property():
        if request.method == 'GET':
            properties = Property.query.all()
            return make_response(jsonify({"properties": properties_schema.dump(properties)})), 200
        if request.method == 'POST':
            name =   str(request.data.get('name', ''))
            description =  str(request.data.get('description', ''))
            category =   request.data.get('category', '')
            company_id =  request.data.get('company_id', '')
            verify_data = Property_Validation({"name":name, "description":description, "category_id": category, "company_id": company_id})
            is_verified = verify_data.check_input()
            if is_verified[0] == 200:
                new_property = Property(name, description, category, company_id)
                new_property.save()
                return make_response(jsonify({"message": "property successfully created!", "property": property_schema.dump(new_property)})), 201
            else:
                return make_response(jsonify({"message":is_verified[1]})), is_verified[0]

    @app.route('/api/v1/properties/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_property(id):
        property_ = Property.query.get(id)
        if property_:
            if request.method == 'DELETE':
                # @manager required     current user == company manager
                    property_.delete()
                    return make_response(jsonify({"message": "You Successfully Deleted Property "+id})), 202
            elif request.method == 'GET':
                return make_response(jsonify({"property": property_schema.dump(property_)})), 200
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

########################################################################################### Reviews CRUD

    @app.route('/api/v1/reviews', methods=['GET','POST'])
    @login_required
    def get_add_new_review(current_user):
        if request.method == 'GET':
            reviews = Review.query.all()
            return make_response(jsonify({"reviews": reviews_schema.dump(reviews)})), 200
        if request.method == 'POST':
            user_id =   current_user
            property_id =  request.data.get('property', '')
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

    @app.route('/api/v1/reviews/<id>', methods=['GET','PUT','DELETE'])
    def get_update_delete_review(id):
        review = Review.query.get(id)
        if review:
            if request.method == 'DELETE':
                # @manager required     current user == company manager
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
                # @manager required     current user == company manager
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
