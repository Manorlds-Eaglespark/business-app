from app.models.property import Property
from app.views import db

class PropertyHelper(property):

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
        