from shared import db, ma

class Category(db.Model):
    __tablename__ = 'categories'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    image = db.Column(db.String(255), nullable=False)
    img_del_hash = db.Column(db.String(255), nullable=False)
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, image, img_del_hash):
        self.name = name
        self.image = image
        self.img_del_hash = img_del_hash

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()


class CategorySchema(ma.Schema):
    class Meta:
        fields = ("id", "name", "image", "time_added")

category_schema = CategorySchema()
categories_schema = CategorySchema(many=True)
