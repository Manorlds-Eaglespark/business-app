"""empty message

Revision ID: abc509114544
Revises: ad038a22a663
Create Date: 2019-12-11 16:55:24.450660

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'abc509114544'
down_revision = 'ad038a22a663'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('locations', sa.Column('latitude', sa.Float(), nullable=True))
    op.drop_column('locations', 'latidude')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('locations', sa.Column('latidude', sa.VARCHAR(length=15), autoincrement=False, nullable=True))
    op.drop_column('locations', 'latitude')
    # ### end Alembic commands ###
