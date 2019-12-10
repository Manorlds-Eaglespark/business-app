from shared_db import db
from app.models.properties import Property

class Review(db.Model):
    __tablename__ = 'reviews'
    id = db.Column(db.Integer, primary_key=True)
    user = db.Column(db.String(155))
    property_id = db.Column(db.Integer, db.ForeignKey(Property.id))
    comment = db.Column(db.String(255))
    rating = db.Column(db.Integer)
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())
    property_ = db.relationship('Property', backref='review')

    def __init__(self, user, property_id, comment, rating):
        self.user = user
        self.property_id = property_id
        self.comment = comment
        self.rating = rating