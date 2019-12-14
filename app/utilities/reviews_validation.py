

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
