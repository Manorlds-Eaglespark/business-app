import jwt
from flask_bcrypt import Bcrypt
from shared_db import db

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    email = db.Column(db.String(200))
    password = db.Column(db.String(255))
    thumbnail = db.Column(db.String(255))
    role = db.Column(db.String(20))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, password, email, thumbnail, role):
        self.name = name
        self.password = Bcrypt().generate_password_hash(password).decode()
        self.email = email
        self.thumbnail = thumbnail
        self.role = role

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
