

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