import time
import os
import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from fontTools.ttLib import TTFont

#check blank char
def char_in_font(unicode_char, font):
    for cmap in font['cmap'].tables:
        if cmap.isUnicode():
            if ord(unicode_char) in cmap.cmap:
                return True
    return False

def genimage(fontname,text,fontsize,dirname):
    #check blank char 
    f = TTFont(fontname)
    if char_in_font(unicode_char=text,font=f) == False:
        print("character "+text+" not found in font"+fontname)
        return
    img = np.zeros((60,60,3),np.uint8)
    img.fill(255)
    b,g,r,a = 0,255,0,0

    ## Use cv2.FONT_HERSHEY_XXX to write English.
    # text = time.strftime("%Y/%m/%d %H:%M:%S %Z", time.localtime()) 
    # cv2.putText(img,  text, (50,50), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (b,g,r), 1, cv2.LINE_AA)


    ## Use simsum.ttc to write Chinese.
    fontpath = fontname # <== 这里是宋体路径 
    font = ImageFont.truetype(fontpath, fontsize)
    img_pil = Image.fromarray(img)
    draw = ImageDraw.Draw(img_pil)
    w, h = draw.textsize(text,font = font)
    draw.text(((60-w)/2, (60-h)/2),  text, font = font, fill = 0)

    img = np.array(img_pil)
    cv2.imwrite(dirname+"/"+fontname+".png", img)
    #check if blank img
    imgcheck = Image.open(dirname+"/"+fontname+".png")
    clrs = imgcheck.getcolors()
    if len(clrs) == 1:
        print("file is blank remove file "+text+fontname+".png")
        os.remove(dirname+"/"+fontname+".png")

lines = []
with open('listword.txt') as f:
    lines = f.readlines()
dirName = "../train_data/Train/"
#dirName = "data1/"

relevant_path = "."
included_extensions = ['ttf','otf']
file_names = [fn for fn in os.listdir(relevant_path)
              if any(fn.endswith(ext) for ext in included_extensions)]
print(file_names)


for line in lines:
    d = dirName+line.rstrip()
    if not os.path.exists(d):
        os.mkdir(d)
        print("Directory " , d ,  " Created ")
    else:    
        print("Directory " , d ,  " already exists")
    for font in file_names:
        genimage(fontname=font,text=line.rstrip(),fontsize=50,dirname=d)