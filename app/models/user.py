import jwt
from flask_bcrypt import Bcrypt
from shared import db, ma

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    email = db.Column(db.String(200))
    phone = db.Column(db.String(100))
    password = db.Column(db.String(255))
    image = db.Column(db.String(255))
    role = db.Column(db.String(20))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, password, email, role):
        self.name = name
        self.password = Bcrypt().generate_password_hash(password).decode()
        self.email = email
        self.role = role

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class UserSchema(ma.Schema):
    class Meta:
        fields = ("name", "email", "image", "role", "time_added")

user_schema = UserSchema()
users_schema = UserSchema(many=True)
