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
    thumbnail = db.Column(db.String(255))
    role = db.Column(db.String(20))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, email, password):
        self.password = Bcrypt().generate_password_hash(password).decode()
        self.email = email
        self.role = 'user'
        self.name = name

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def add_image(self, image_url):
        self.thumbnail = image_url
        
    def check_password(self, password):
        return Bcrypt().check_password_hash(self.password, password)

class UserSchema(ma.Schema):
    class Meta:
        fields = ("name", "email", "phone",  "thumbnail", "role", "time_added")

user_schema = UserSchema()
users_schema = UserSchema(many=True)
