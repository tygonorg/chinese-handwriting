# chinese handwriting IOS
This is project chinese hand wridtting in IOS
## Table of contents
* [Generate data](#generate-data)
* [Train data](#train-data)
* [Demo IOS App](#demo-ios-app)
# Generate data
## Setup environment:
You can install [Anacoda](https://www.anaconda.com/) to using both python 3.6 & 2.7
- Python 3.6
- opencv
- fontTools
- Pillow
## Run
To run generate data in comand line run :
Make a Train folder in folder train_data
```bash
$ cd ../'generate data'
$ python gendata.py
```
Finish comand you will see data in :
train_data/Train
# Train data
## Setup environment:
You can install [Anacoda](https://www.anaconda.com/) to using both python 3.6 & 2.7
- Python 2.7
- numpy
- pandas
- turicreate
## Run
To run generate data in comand line run :
Make a Train folder in folder train_data
```bash
$ cd ../train_data
$ python gendata.py
```
Finish comand you will see data in :
train_data/Mchinese.mlmodel
# Demo IOS APP
## Setup environment:
you can you xcode > 12 and ios >= 14 to buil app
Open folder ios_app/ChineseHandWriting/ an open project
copy file train_data/Mchinese.mlmodel in to model and replace it
## Run
open project and run
You can run demo with Mchinese.mlmodel demo with any character chinese
