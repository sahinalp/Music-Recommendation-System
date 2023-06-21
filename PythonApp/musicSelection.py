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

appHelper=AppHelper()

class loadWindow(QMainWindow):
    
    
    def __init__(self):
        super().__init__()
        loadUi("MusicSelection.ui",self)
        self.id=""
        self.song_link=""
        self.artist_name=""
        self.cluster=""

    def showImages(self,uri_list,id_list,cluster_list):
        row=0
        column=0
        for i in range(len(uri_list)):
            appHelper.getSongImage(uri=uri_list[i])
            image_label = QtWidgets.QLabel(self)
            image_label.setAlignment(QtCore.Qt.AlignCenter)

            image_path="images/"+uri_list[i].split(":")[-1]+".png"
            pixmap=QtGui.QPixmap(image_path).scaled(100, 100, QtCore.Qt.AspectRatioMode.KeepAspectRatio)
            image_label.setPixmap(pixmap)

            artist_name=appHelper.getArtistName(appHelper.song_link)
            image_label.mousePressEvent = self.create_click_event(id_list[i],appHelper.song_link,artist_name,cluster_list[i])
            image_label.enterEvent = self.create_enter_event(image_label,artist_name)
            image_label.leaveEvent = self.create_leave_event(image_label,pixmap)
            self.gridLayout_image.addWidget(image_label,column,row)
            row+=1
            if row==5:
                row=0
                column+=1
        
    def create_click_event(self, id,song_link,artist_name,cluster):
        def on_click(event):
            self.id=id
            self.song_link=song_link
            self.artist_name=artist_name
            self.cluster=cluster
            self.close()
        return on_click

    def create_enter_event(self,image_label,artist_name):
        def on_enter(event):
            image_label.setAlignment(QtCore.Qt.AlignCenter)

            image_label.setText(artist_name)

        
        return on_enter
            
    def create_leave_event(self,image_label,pixmap):
        def on_leave(event):
            image_label.setText("")
            image_label.setPixmap(pixmap)
        
        return on_leave
    
