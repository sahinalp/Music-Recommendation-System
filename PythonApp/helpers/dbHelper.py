import psycopg2
import numpy as np
from dotenv import load_dotenv
import os

class DbHelper:
    def __init__(self):
    # Connect to the database
        load_dotenv(dotenv_path="Resources\config.env")

        self.conn = psycopg2.connect(
            host=os.getenv("DB_Host"),
            database=os.getenv("DB_Database"),
            user=os.getenv("DB_User"),
            password=os.getenv("DB_Password"))
        
        self.conn.autocommit=True

    def closeConnection(self):
        self.conn.close()
    
    def readData(self,name):
        cursor=self.conn.cursor()
        cursor.execute("""
        SELECT songid,uri,songcluster
        FROM "MusicRecommendation"."database"
        WHERE songname='{}';

        """.format(name))
        response = cursor.fetchall()

        data=np.ravel(response)
        data=data.reshape(-1,3)

        return data
    
    def readSuggesions(self,user_favorite_cluster):
        cursor=self.conn.cursor()
        cursor.execute("""
        SELECT uri,songname
        FROM "MusicRecommendation"."database"
        WHERE songcluster='{}' 
        order by popularity DESC;

        """.format(user_favorite_cluster))
        response = cursor.fetchall()

        data=np.ravel(response)
        data=data.reshape(-1,2)

        return data
    