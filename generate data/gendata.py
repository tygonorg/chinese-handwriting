# from PIL import Image,ImageDraw,ImageFont
# import  cv2
# import numpy as np
# import matplotlib.pyplot as plt
# img = cv2.imread("2.png")#If you want to read the Chinese name image file, you can use cv2.imdecode()
# pil_img = cv2.cvtColor(img,cv2.COLOR_BGR2RGB)#cv2 and PIL color hex code storage order is different, need to turn RGB mode
# pilimg = Image.fromarray(pil_img)#Image.fromarray() converts the array type to an image format, as opposed to np.array()
# Draw = ImageDraw.Draw(pilimg)#PIL print Chinese characters on the picture
# font = ImageFont.truetype("MaShanZheng-Regular.ttf",50,encoding="utf-8")#Parameter 1: Font file path, parameter 2: Font size; Windows system "simhei.ttf" is stored by default in path: C: \Windows\Fonts
# Draw.text((0,0),"Viking", (255,0,0),font=font)
# cv2img = cv2.cvtColor(np.array(pilimg),cv2.COLOR_RGB2BGR)# Convert the image to an array format that cv2.imshow() can display
# cv2.imshow("hanzi",cv2img)
# cv2.waitKey()
# cv2.destroyAllWindows()


import time
import os
import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont

## Make canvas and set the color

def genimage(fontname,text,fontsize):
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

    cv2.imwrite("data/"+text+"/"+fontname+".png", img)
lines = []
with open('listword.txt') as f:
    lines = f.readlines()
for line in lines:
    dirName = "data/"+line.rstrip()
    if not os.path.exists(dirName):
        os.mkdir(dirName)
        print("Directory " , dirName ,  " Created ")
    else:    
        print("Directory " , dirName ,  " already exists")
    genimage(fontname="MaShanZheng-Regular.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="NotoSansSC-Regular.otf",text=line.rstrip(),fontsize=45)
    genimage(fontname="ZCOOLQingKeHuangYou-Regular.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="LongCang-Regular.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="LiuJianMaoCao-Regular.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="ZhiMangXing-Regular.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="ZCOOLKuaiLe-Regular.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="SentyWEN2017.ttf",text=line.rstrip(),fontsize=40)
    genimage(fontname="0.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="wts11.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="simhei.ttf",text=line.rstrip(),fontsize=50)
    genimage(fontname="wt064.ttf",text=line.rstrip(),fontsize=50)