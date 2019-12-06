import os
from flask_script import Manager # class for handling a set of commands
from flask_migrate import Migrate, MigrateCommand
from app.views import db, create_app
from app.models.user import User
from app.models.amenities import Amenity
from app.models.companies import Company
from app.models.locations import Location
from app.models.photos import Photo
from app.models.property import Property
from app.models.reviews import Review

app = create_app(config_name=os.getenv('APP_SETTINGS'))
migrate = Migrate(app, db)
manager = Manager(app)

manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()