
class Amenity_Validation():
    
    def __init__(self, amenity_data):
        self.description = amenity_data["description"]

    def check_input(self):
        if not self.description:
            return [400, "Add amenity description first"]
        elif not isinstance(self.description, str):
            return [406, "Description should be a String "]
        return [200, "All Good"]