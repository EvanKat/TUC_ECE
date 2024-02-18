import cv2
import numpy as np
from tensorflow.keras.models import load_model

model=load_model("./models/myCNN_model.h5")

labels_dict={0:'no',1:'yes'}
color_dict={0:(0,0,255),1:(0,255,0)}

size = 4

webcam = cv2.VideoCapture(0) #Use camera 0

# We load the xml file
classifier = cv2.CascadeClassifier('requirements/haarcascade_frontalface_default.xml')

while True:
    (r, im) = webcam.read()
    # Mirroring
    im=cv2.flip(im,1,1) 

    # Resize the image
    mini = cv2.resize(im, (im.shape[1] // size, im.shape[0] // size))

    # detect MultiScale / faces 
    faces = classifier.detectMultiScale(mini)

    # Draw rectangles around each face
    for f in faces:
        (x, y, w, h) = [v * size for v in f] #Scale the shapesize backup
        #Save just the rectangle faces in SubRecFaces
        face_img = im[y:y+h, x:x+w]
        resized=cv2.resize(face_img,(128,128))
        normalized=resized/255.0
        reshaped=np.reshape(normalized,(1,128,128,3))
        reshaped = np.vstack([reshaped])
        result=model.predict(reshaped)
        # print(np.maximum(result))

        label=np.argmax(result,axis=1)[0]
        # x = np.amax(result)
        output = (labels_dict[label] + ":{0:.1%}".format(np.amax(result)))

        cv2.rectangle(im,(x-10,y-20),(x+w+10,y+h+10),color_dict[label],2)
        cv2.rectangle(im,(x-10,y-40),(x+w+10,y+10),color_dict[label],-1)
        cv2.putText(im, output, (x-10, y-10),cv2.FONT_HERSHEY_SIMPLEX,0.8,(255,255,255),2)
        # cv2.putText(im, str(labels_dict[label] + np.amax(result)), (x, y-12),cv2.FONT_HERSHEY_SIMPLEX,0.8,(255,255,255),2)
        
    # Show the image
    cv2.imshow('LIVE',   im)
    key = cv2.waitKey(10)
    # if Esc key is press then break out of the loop 
    if key == 27: #The Esc key
        break
# Stop video
webcam.release()

# Close all started windows
cv2.destroyAllWindows()