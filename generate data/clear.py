import time
import os
import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont
def checkblankimage(filename):
    if filename.endswith(".DS_Store"):
        os.remove(filename)
        return
    imgcheck = Image.open(filename)
    clrs = imgcheck.getcolors()
    if len(clrs) == 1:
        print("file is blank remove file :"+filename)
        os.remove(filename)

dirName = "../train_data/Train/"
folders = list(filter(lambda x: os.path.isdir(os.path.join(dirName, x)), os.listdir(dirName)))
for folder in folders:
    print(folder)
    newfo = dirName + folder
    files = list(filter(lambda x: os.path.isfile(os.path.join(newfo, x)), os.listdir(newfo)))
    for f in files:
        print(f)
        checkblankimage(filename=newfo+"/"+f)
