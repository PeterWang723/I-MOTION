from datetime import datetime
from typing import List

from fastapi import HTTPException
from sqlalchemy import Column, String, create_engine, Integer, DateTime, Inspector
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import time
from pydantic import BaseModel

Base = declarative_base()


class Acc_Item(BaseModel):
    uid: int
    x: float
    y: float
    z: float
    time: datetime


class Pred_Data(BaseModel):
    uid: int
    day: datetime
    data: list[Acc_Item]


class Infer_Data(BaseModel):
    u_id: int
    mode: str
    day: datetime
    start_time: datetime
    end_time: datetime


class Activity(Base):
    # 表的名字:
    __tablename__ = 'activity'

    # 表的结构:
    id = Column(Integer, autoincrement=True, primary_key=True, unique=True, nullable=False)
    u_id = Column(Integer, nullable=True)
    mode = Column(String(20), nullable=True)
    day = Column(DateTime, nullable=True)
    start_time = Column(DateTime, nullable=True)
    end_time = Column(DateTime, nullable=True)
    origin = Column(String, nullable=True)
    destination = Column(String, nullable=True)
    activities = Column(String, nullable=True)
    cost = Column(Integer, nullable=True)
    luggage_num = Column(Integer, nullable=True)
    luggage_type = Column(String, nullable=True)
    luggage_weight = Column(Integer, nullable=True)
    travel_car_cost = Column(Integer, nullable=True)


# 初始化数据库连接:
engine = create_engine('postgresql://postgres:mysecretpassword@localhost:5432')  # 用户名:密码@localhost:端口/数据库名

# 创建DBSession类型:
DBSession = sessionmaker(bind=engine)


def createTable():
    # Use Inspector to check for table existence
    inspector = Inspector.from_engine(engine)
    if 'activity' not in inspector.get_table_names():
        # Create tables only if they don't exist
        Base.metadata.create_all(bind=engine)


def insertData(pred_items: List[Infer_Data]):
    session = DBSession()
    try:
        activities = [Activity(**item.dict()) for item in pred_items]
        session.add_all(activities)
        session.commit()
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=str(e))
