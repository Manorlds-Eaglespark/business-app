from shared_db import db, ma
from app.models.properties import Property

class Location(db.Model):
    __tablename__ = 'locations'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer, db.ForeignKey(Property.id))
    latitude = db.Column(db.String(15))
    longitude = db.Column(db.String(15))
    description = db.Column(db.String(255))
    property_ = db.relationship('Property', backref='location')

    def __init__(self, property_id, latitude, longitude, description):
        self.property_id = property_id
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        
    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class LocationSchema(ma.Schema):
    class Meta:
        fields = ("id", "property_id", "latitude", "longitude", "description")

location_schema = LocationSchema()
locations_schema = LocationSchema(many=True)
