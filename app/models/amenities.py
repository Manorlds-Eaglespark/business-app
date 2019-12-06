from app.views import db

class Amenity(db.Model):
    __tablename__ = 'amenities'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.String(15))
    description = db.Column(db.String(255))

    def __init__(self, property_id, description):
        self.property_id = property_id
        self.description = description