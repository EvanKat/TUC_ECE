from __future__ import absolute_import, division, print_function, unicode_literals

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import visualkeras as vk

# Helper libraries
import numpy as np
import matplotlib.pyplot as plt

from plots import plot_some_data, plot_some_predictions


epochs = 50


fashion_mnist = keras.datasets.fashion_mnist

(train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()

class_names = ['T-shirt/top', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

# Scale these values to a range of 0 to 1 before feeding them to the neural network model. 
# To do so, divide the values by 255. 
# It's important that the training set and the testing set be preprocessed in the same way
train_images = train_images / 255.0

test_images = test_images / 255.0

train_images_reshaped = np.reshape(train_images,
                (train_images.shape[0], train_images.shape[1], train_images.shape[2], 1)
                )

test_images_reshaped =np.reshape(test_images,
                (test_images.shape[0], test_images.shape[1], test_images.shape[2], 1)
                )

# Build the model
# Building the neural network requires configuring the layers of the model, then compiling the model.

mycnn_model = keras.Sequential([
    keras.layers.Conv2D(32, kernel_size=(3,3), strides=1, padding='same', activation=None, input_shape=(28,28,1)),
    keras.layers.BatchNormalization(axis=1),
   
    keras.layers.Conv2D(32, kernel_size=(3,3), strides=1, padding='same', activation=None),
    keras.layers.BatchNormalization(axis=1), 

    keras.layers.MaxPooling2D(pool_size=(2,2), padding='valid'),
    keras.layers.Dropout(0.2),

    keras.layers.Conv2D(64, kernel_size=(3,3), strides=1, padding='same', activation=None),
    keras.layers.BatchNormalization(axis=1),
   
    keras.layers.Conv2D(64, kernel_size=(3,3), strides=1, padding='same', activation=None),
    keras.layers.BatchNormalization(axis=1),
    

    keras.layers.MaxPooling2D(pool_size=(2,2), padding='valid'),
    keras.layers.Dropout(0.3),

    keras.layers.Conv2D(128, kernel_size=(3,3), strides=1, padding='same', activation=None),
    keras.layers.BatchNormalization(axis=1),
    

    keras.layers.MaxPooling2D(pool_size=(2,2), padding='valid'),
    keras.layers.Dropout(0.4),

    keras.layers.Flatten(input_shape=(28, 28)),
        
    keras.layers.Dense(128, activation='relu'),
    keras.layers.BatchNormalization(axis=1),
    
    keras.layers.Dropout(0.5),
    keras.layers.Dense(10)
]) 

# Visualise model
mycnn_model.summary()
vk.layered_view(mycnn_model, legend=True,to_file='model_drop.png')


mycnn_model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])


#Train the model
# Training the neural network model requires the following steps:

#   1. Feed the training data to the model. In this example, the training data is in the train_images and train_labels arrays.
#   2. The model learns to associate images and labels.
#   3. You ask the model to make predictions about a test set—in this example, the test_images array.
#   4. Verify that the predictions match the labels from the test_labels array.

mycnn_model.fit(train_images_reshaped, train_labels, epochs=epochs, validation_data=(test_images_reshaped, test_labels))

# Evaluate accuracy
test_loss, test_acc = mycnn_model.evaluate(test_images_reshaped,  test_labels, verbose=2)

print('\nTest accuracy:', test_acc)

# Make predictions
# With the model trained, you can use it to make predictions about some images. 
# The model's linear outputs, logits. 
# Attach a softmax layer to convert the logits to probabilities, which are easier to interpret. 
probability_model = tf.keras.Sequential([mycnn_model, 
                                         tf.keras.layers.Softmax()])

predictions = probability_model.predict(test_images_reshaped)

plot_some_predictions(test_images, test_labels, predictions, class_names, num_rows=5, num_cols=3)





