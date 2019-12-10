
      self.name = name
        self.description = description
        self.category = category
        self.company_id = company

class Property_Validation():
    
    def __init__(self, property_data):
        self.name = property_data["name"]
        self.description = property_data["description"]
        self.category = property_data["category"]
        self.company_id = property_data["company_id"]

    def check_input(self):
        if not (self.name and self.description and self.category and self.company_id):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.company_id, int) or not instance(self.category, int) or not isinstance(self.name, str) or not isinstance(self.description, str)):
            return [406, "Make sure to use correct types for all fields "]
        return [200, "All Good"]