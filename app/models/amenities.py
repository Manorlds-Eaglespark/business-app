from shared_db import db
from app.models.property import Property

class Amenity(db.Model):
    __tablename__ = 'amenities'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer, db.ForeignKey(Property.id), nullable=False)
    description = db.Column(db.String(255), nullable=False)
    property_ = db.relationship('Property', backref='amenity')


    def __init__(self, property_id, description):
        self.property_id = property_id
        self.description = description