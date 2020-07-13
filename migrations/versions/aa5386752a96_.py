"""empty message

Revision ID: aa5386752a96
Revises: 9543bc1467dd
Create Date: 2020-08-17 10:41:26.805375

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'aa5386752a96'
down_revision = '9543bc1467dd'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('thumbnail', sa.String(length=255), nullable=True))
    op.drop_column('users', 'photo')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('photo', sa.VARCHAR(length=255), autoincrement=False, nullable=True))
    op.drop_column('users', 'thumbnail')
    # ### end Alembic commands ###