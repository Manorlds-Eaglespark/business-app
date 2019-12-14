import re



class Amenity_Validation():
    
    def __init__(self, amenity_data):
        self.description = amenity_data["description"]

    def check_input(self):
        if not self.description:
            return [400, "Add amenity description first"]
        elif not isinstance(self.description, str):
            return [406, "Description should be a String "]
        return [200, "All Good"]


class Category_Validation():
    
    def __init__(self, category_data):
        self.name = category_data["name"]
        self.description = category_data["description"]

    def check_input(self):
        if not (self.name and self.description):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.name, str) or not isinstance(self.description, str)):
            return [406, "Make sure to use correct types for all fields "]
        return [200, "All Good"]


class Company_Validation():
    
    def __init__(self, company_data):
        self.manager = company_data["manager"]
        self.name = company_data["name"]
        self.description = company_data["description"]

    def check_input(self):
        if not (self.manager and self.name and self.description):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.manager, int) or not isinstance(self.name, str) or not isinstance(self.description, str)):
            return [406, "Make sure to use correct types for all fields "]
        return [200, "All Good"]


class Location_Validation():
    
    def __init__(self, location_data):
        self.latitude = location_data["latitude"]
        self.longitude = location_data["longitude"]
        self.description = location_data["description"]

    def check_input(self):
        if not (self.latitude and self.longitude and self.description):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.latitude, float) or not isinstance(self.longitude, float) or not isinstance(self.description, str)):
            return [406, "Make sure to use correct types for all fields: Floats and String "]
        return [200, "All Good"]


class Photo_Validation():
    
    def __init__(self, photo_data):
        self.photo_1 = photo_data["photo_1"]
        self.photo_2 = photo_data["photo_2"]
        self.photo_3 = photo_data["photo_3"]
        self.photo_4 = photo_data["photo_4"]
        self.photo_5 = photo_data["photo_5"]
        self.photo_6 = photo_data["photo_6"]
        self.photo_7 = photo_data["photo_7"]

    def check_input(self):
        if not self.photo_1:
            return [400, "Upload atleast 1 image"]
        elif not isinstance(self.photo_1, str):
            return [406, "Image url should be a String "]
        return [200, "All Good"]


class Property_Validation():
    
    def __init__(self, property_data):
        self.name = property_data["name"]
        self.description = property_data["description"]
        self.category_id = property_data["category_id"]
        self.company_id = property_data["company_id"]

    def check_input(self):
        if not (self.name and self.description and self.category_id and self.company_id):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.company_id, int) or not isinstance(self.category_id, int) or not isinstance(self.name, str) or not isinstance(self.description, str)):
            return [406, "Make sure to use correct types for all fields "]
        return [200, "All Good"]


class Register_Validation():
    
    def __init__(self, user_data):
        self.name = user_data["name"]
        self.password = user_data["password"]
        self.email = user_data["email"]
        self.thumbnail = user_data["thumbnail"]
        self.role = user_data["role"]

    def check_input(self):
        if not (self.name and self.password and self.email and self.thumbnail and self.role):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.name, str) or not isinstance(self.password, str) or not isinstance(self.email, str) or not isinstance(self.email, str) or not isinstance(self.thumbnail, str) or not isinstance(self.role, str)):
            return [406, "Make sure to use alphabetical characters use only "]
        elif self.password.isspace() or len(self.password) < 4:
            return [406, "Make sure your password has atlest 4 letters"]
        elif re.search('[0-9]', self.password) is None:
            return [406, "Make sure your password has a number in it"]
        elif re.search('[A-Z]', self.password) is None:
            return [406, "Make sure your password has a capital letter in it"]
        elif not re.match("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$", self.email) is not None:
            return [406, "Please enter a valid Email."]
        return [200, "All Good"]


class Review_Validation():
    
    def __init__(self, review_data):
        self.user_id = review_data["user_id"]
        self.property_id = review_data["property_id"]
        self.comment = review_data["comment"]
        self.rating = review_data["rating"]

    def check_input(self):
        if not (self.user_id and self.comment and self.rating):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.user_id, int) or not isinstance(self.comment, str) or not isinstance(self.rating, int)):
            return [406, "Make sure to use correct types for all fields "]
        return [200, "All Good"]
