

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