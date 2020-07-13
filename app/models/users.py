import jwt
from flask_bcrypt import Bcrypt
from shared import db, ma

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    email = db.Column(db.String(200))
    phone = db.Column(db.String(100))
    thumbnail = db.Column(db.String(255))
    role = db.Column(db.String(10))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, email, role, thumbnail, phone):
        self.email = email
        self.role = role
        self.name = name
        self.thumbnail = thumbnail
        self.phone = phone

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def add_added(self, name, email, phone):
        if name:
            self.name = name
        if email:
            self.email = email
        if phone:
            self.phone = phone


class UserSchema(ma.Schema):
    class Meta:
        fields = ("id", "name", "email", "phone", "thumbnail", "role", "time_added")

user_schema = UserSchema()
users_schema = UserSchema(many=True)
