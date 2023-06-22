from PyQt5.QtWidgets import*
from PyQt5.QtCore import pyqtSlot
from PyQt5.uic import loadUi
from PyQt5 import QtGui, QtWidgets, QtCore
from PyQt5.QtGui import QImage, QKeySequence,QPixmap,QPainter
from PyQt5 import QtTest
from PyQt5.QtCore import QObject

from PyQt5.Qt import Qt

import random
import numpy as np
import pandas as pd
from helpers.appHelper import AppHelper
from musicSelection import loadWindow
from helpers.dbHelper import DbHelper
dbHelper=DbHelper()
appHelper=AppHelper()
#%% Ui

class loadui(QMainWindow):
    
    
    def __init__(self):
        super().__init__()
        loadUi("Main.ui",self)
        self.pushButton_search.clicked.connect(self.search)
        self.pushButton_addList.clicked.connect(self.saveFavMusicId)
        self.pushButton_create.clicked.connect(self.createRecommendation)

        self.textEdit_list.setTextInteractionFlags(QtCore.Qt.LinksAccessibleByMouse)
        self.textEdit_recommendation.setTextInteractionFlags(QtCore.Qt.LinksAccessibleByMouse)

        self.text=""
        self.data=None
        self.label_text=["What's your first favorite music?","What's your second favorite music?","What's your third favorite music?","What's your fourth favorite music?","What's your fifth favorite music?"]
        self.fav_music_id=[]
        self.fav_music_song_link=[]
        self.fav_music_artist_name=[]
        self.fav_music_name=[]
        self.fav_music_cluster=[]
        self.progress_value=0

    def search(self):
        self.text=self.textEdit_song.toPlainText()
        self.text=self.text.strip()
        self.data=dbHelper.readData(self.text)
        uri_list=list(self.data[:,1])
        id_list=list(self.data[:,0])
        cluster_list=list(self.data[:,2])
        self.image_window=loadWindow()
        self.image_window.setWindowTitle(self.text)
        self.image_window.showImages(uri_list,id_list,cluster_list)
        self.image_window.show()
         
        self.pushButton_search.setEnabled(False)
        self.pushButton_addList.setEnabled(True)
    
    def saveFavMusicId(self):
        if self.image_window.id!="":
            self.fav_music_id.append(self.image_window.id)
            self.fav_music_song_link.append(self.image_window.song_link)
            self.fav_music_artist_name.append(self.image_window.artist_name)
            self.fav_music_cluster.append(self.image_window.cluster)
            self.fav_music_name.append(self.text)
            
            self.textEdit_list.setText("")
            for i in range(len(self.fav_music_id)):
                value="<a href="+self.fav_music_song_link[i]+">"+self.fav_music_name[i]+" - "+self.fav_music_artist_name[i]+"</a>"
                self.textEdit_list.append(value)
            self.progress_value+=20
            self.progressBar.setValue(self.progress_value)
            if self.progress_value==100:
                self.pushButton_create.setEnabled(True)
                self.spinBox_recommend_count.setEnabled(True)
                self.pushButton_addList.setEnabled(False)

            else:
                self.label_question.setText(self.label_text[int(self.progress_value/20)])
                self.pushButton_search.setEnabled(True)
                self.pushButton_addList.setEnabled(False)
            self.textEdit_song.setText("")
        else:
            self.pushButton_search.setEnabled(True)
            self.pushButton_addList.setEnabled(False)

    def createRecommendation(self):
        user_favorite_cluster=appHelper.findFavoriteCluster(self.fav_music_cluster)
        suggestions=dbHelper.readSuggesions(user_favorite_cluster)
        
        for i in range(self.spinBox_recommend_count.value()):
            uri=suggestions[i][0]
            link="https://open.spotify.com/track/"+uri.split(":")[-1]
            artist_name=appHelper.getArtistName(link)
            value="<a href="+link+">"+str(i+1)+" - "+suggestions[i][1]+" - "+artist_name+"</a>"
            self.textEdit_recommendation.append(value)


        
app = QApplication([])
window = loadui()
window.show()
app.exec_()
# %%
