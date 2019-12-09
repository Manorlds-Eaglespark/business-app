from shared_db import db
from app.models.property import Property

class Location(db.Model):
    __tablename__ = 'locations'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer, db.ForeignKey(Property.id))
    latidude = db.Column(db.String(15))
    longitude = db.Column(db.String(15))
    description = db.Column(db.String(255))
    property_ = db.relationship('Property', backref='location')

    def __init__(self, property_id, latidude, longitude, description):
        self.property_id = property_id
        self.latidude = latitude
        self.longitude = longitude
        self.description = description