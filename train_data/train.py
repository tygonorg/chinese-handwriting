#python 2.7 
# pip install turicreate
#add  2 folder Train and Test dataset
import turicreate as tc
import os
train_data = tc.image_analysis.load_images("Train", with_path=True)
train_data["label"] = train_data["path"].apply(lambda path: os.path.basename(os.path.split(path)[0]))
train_data["label"].summary()
test_data = tc.image_analysis.load_images("Test", with_path=True)
test_data["label"] = test_data["path"].apply(lambda path: os.path.basename(os.path.split(path)[0]))
test_data["label"].summary()
# train_data.explore()
model_type = "squeezenet_v1.1"
model = tc.image_classifier.create(train_data, target="label", model=model_type, verbose=True, max_iterations=100)
model.summary()                                 
metrics = model.evaluate(train_data)
metrics["accuracy"]
metrics = model.evaluate(test_data)
model.export_coreml("chinese.mlmodel")