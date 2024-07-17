from sqlalchemy import create_engine, Column, Integer, String, Float, declarative_base, Session
from random import randint
import time

DATABASE_URL = "postgresql+psycopg2://postgres:postgres@postgres:5432/postgres"

try:
    time.sleep(5)  # Wait for the database to be ready

    engine = create_engine(DATABASE_URL)
    Base = declarative_base()

    class Order(Base):
        __tablename__ = "orders"
        customer_id = Column(Integer, primary_key=True)
        category = Column(String(255))
        cost = Column(Float)
        item_name = Column(String(255))

    Base.metadata.create_all(engine)

    session = Session(engine)

    # Prepare data for bulk insert
    orders = [
        Order(
            customer_id=i,
            category=f"Category {randint(1, 10)}",
            cost=i * 10,
            item_name=f"Item {i}"
        ) for i in range(1, 100001)
    ]

    session.bulk_save_objects(orders)
    session.commit()

    # Query to verify some inserted data
    orders = session.query(Order).limit(5).all()
    for order in orders:
        print(order.customer_id, order.category, order.cost, order.item_name)

    session.close()

except Exception as e:
    print(e)