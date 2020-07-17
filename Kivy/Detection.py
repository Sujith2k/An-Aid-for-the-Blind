import cv2
import numpy as np

net = cv2.dnn.readNet("yolov3-tiny_last.weights", "yolov3-tiny.cfg")

classes = ['Person','Billboard','Bus','Traffic sign','Truck','Currency']


layer_names = net.getLayerNames()
output_layers = [layer_names[i[0] - 1] for i in net.getUnconnectedOutLayers()]
colors = np.random.uniform(0, 255, size=(len(classes), 3))

def ret_classes(img):
    img = cv2.cvtColor(img, cv2.COLOR_RGBA2RGB)
    #img = cv2.resize(img, None, fx=0.4, fy=0.4)

    height, width, channels = img.shape
    
    # Detecting objects
    blob = cv2.dnn.blobFromImage(img, 0.00392, (416, 416), (0, 0, 0), True, crop=False)
    
    net.setInput(blob)
    outs = net.forward(output_layers)
    
    # Showing informations on the screen
    class_ids = []
    confidences = []
    result = []
    for out in outs:
        for detection in out:
            scores = detection[5:]
            class_id = np.argmax(scores)
            confidence = scores[class_id]
            if confidence > 0.3:
                # Object detected
                result.append((classes[class_id],float(confidence)))
    return(result)
