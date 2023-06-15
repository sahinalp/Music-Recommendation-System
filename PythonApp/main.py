from PyQt5.QtWidgets import*
from PyQt5.QtCore import pyqtSlot
from PyQt5.uic import loadUi
from PyQt5 import QtGui, QtWidgets, QtCore
from PyQt5.QtGui import QImage, QKeySequence,QPixmap,QPainter
from PyQt5 import QtTest
from PyQt5.QtCore import QObject

from PyQt5.Qt import Qt

#%% Ui

class loadui(QMainWindow):
    
    
    def __init__(self):
        super().__init__()
        loadUi("main.ui",self)
        
        
    

app = QApplication([])
window = loadui()
window.show()
app.exec_()
# %%
