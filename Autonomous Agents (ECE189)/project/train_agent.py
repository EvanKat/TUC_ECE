import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Activation, Dense, Flatten, BatchNormalization, Conv2D, MaxPooling2D, Dropout, ZeroPadding2D
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.metrics import categorical_crossentropy
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import TensorBoard, ModelCheckpoint
from sklearn.model_selection import train_test_split
from sklearn.metrics import precision_score,recall_score,classification_report
from sklearn.utils import shuffle
import matplotlib.pyplot as plt
import matplotlib.image  as mpimg
import numpy as np
import imutils
import cv2

# Check GPU
pd = tf.config.experimental.list_physical_devices('GPU')
tf.config.experimental.set_memory_growth(pd[0],True)


LerningRate = 0.001
EPOCHS = 100
BatchSize = 64
DataSize = 128
# Set up images
TAIN_DIR = "data/train"  
VALIDATION_DIR = "data/validation"

train_datagen = ImageDataGenerator( rescale=1.0/255,
                                    rotation_range=40, 
                                    width_shift_range=0.2, 
                                    height_shift_range=0.2,
                                    shear_range=0.2,
                                    zoom_range=0.2,
                                    horizontal_flip=True,
                                    fill_mode='nearest')

train_generator = train_datagen.flow_from_directory(TAIN_DIR,
                                                    batch_size=BatchSize/2,
                                                    target_size=(DataSize, DataSize))

validation_datagen = ImageDataGenerator(rescale=1.0/255)
validation_generator = validation_datagen.flow_from_directory(  VALIDATION_DIR,
                                                                batch_size=BatchSize/2,
                                                                target_size=(DataSize, DataSize))

# Set up CNN model
mycnn_model = Sequential(
    [
    Conv2D(32, (3,3), activation='relu', input_shape=(DataSize, DataSize, 3)),
    MaxPooling2D(2,2),
    
    Conv2D(128, (3,3), activation='relu'),
    MaxPooling2D(2,2),
    
    Flatten(),
    Dense(64, activation='relu'),
    Dropout(0.4),
    Dense(2, activation='softmax')
    ]
)

mycnn_model.compile(  optimizer=Adam(learning_rate=LerningRate),
                loss='binary_crossentropy', 
                metrics=['acc'])

mycnn_model.summary()

# Train model and keep track of each epoch
checkpoint = ModelCheckpoint('cnn_history/model-{epoch:03d}.model',
                            monitor='val_loss', 
                            verbose=0,
                            save_best_only=True,
                            mode='auto')

cnn_history = mycnn_model.fit(train_generator,
                    epochs=EPOCHS,
                    validation_data=validation_generator,
                    verbose=2,
                    callbacks=[checkpoint])

mycnn_model.save('models/myCNN_model.h5')


# set up Plots 
train_acc = cnn_history.history['acc']
val_acc = cnn_history.history['val_acc']

train_loss = cnn_history.history['loss']
val_loss = cnn_history.history['val_loss']

epochs = range(1, len(train_loss) + 1)

# Accuracy 
plt.plot(epochs, train_acc, color='black', label='Training')
plt.plot(epochs, val_acc, color='green', label='Validation')
plt.title('Training and Validation accuracy')
plt.xlabel('# Epochs')
plt.ylabel('Accuracy')
plt.legend()
plt.grid()
plt.savefig("plots/cnn_plot_accuracy_d.png")
plt.close()

# Losses
plt.plot(epochs, train_loss, color='blue', label='Training')
plt.plot(epochs, val_loss, color='red', label='Validation')
plt.title('Training and Validation loss')
plt.xlabel('# Epochs')
plt.ylabel('Loss')
plt.legend()
plt.grid()
plt.savefig("plots/cnn_plot_loss_d.png")
plt.close()