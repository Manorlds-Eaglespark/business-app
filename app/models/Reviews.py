from shared import db, ma
from app.models.properties import Property
from app.models.user import User

class Review(db.Model):
    __tablename__ = 'reviews'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey(User.id))
    property_id = db.Column(db.Integer, db.ForeignKey(Property.id))
    comment = db.Column(db.String(255))
    rating = db.Column(db.Integer)
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())
    property_ = db.relationship('Property', backref='review')
    user = db.relationship('User', backref='review')

    def __init__(self, user_id, property_id, comment, rating):
        self.user_id = user_id
        self.property_id = property_id
        self.comment = comment
        self.rating = rating
    
    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()


class ReviewSchema(ma.Schema):
    class Meta:
        fields = ("id", "user_id", "property_id", "comment", "rating", "time_added")

review_schema = ReviewSchema()
reviews_schema = ReviewSchema(many=True)
