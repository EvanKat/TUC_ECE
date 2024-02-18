// Copyright 1996-2021 Cyberbotics Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import com.cyberbotics.webots.controller.Accelerometer;
import com.cyberbotics.webots.controller.Camera;
import com.cyberbotics.webots.controller.DistanceSensor;
import com.cyberbotics.webots.controller.LED;
import com.cyberbotics.webots.controller.LightSensor;
import com.cyberbotics.webots.controller.Motor;
import com.cyberbotics.webots.controller.Robot;

import java.util.Random;

public class Rat1 extends Robot {

  protected final int timeStep = 32;
  protected final double maxSpeed = 300;
  protected final double[] collisionAvoidanceWeights = {0.0,0.015,0.03,0.06,0.0,0.0,0.0,0.0};
  protected final double[] slowMotionWeights = {0.0125,0.00625,0.0,0.0,0.0,0.0,0.00625,0.0125};

  protected Accelerometer accelerometer;
  protected Camera camera;
  protected int cameraWidth, cameraHeight;
  protected Motor leftMotor, rightMotor;
  protected DistanceSensor[] distanceSensors = new DistanceSensor[8];
  protected LightSensor[] lightSensors = new LightSensor[8];
  protected LED[] leds = new LED[10];

  public Rat1() {
    accelerometer = getAccelerometer("accelerometer");
    camera = getCamera("camera");
    camera.enable(8*timeStep);
    cameraWidth=camera.getWidth();
    cameraHeight=camera.getHeight();
    leftMotor = getMotor("left wheel motor");
    rightMotor = getMotor("right wheel motor");
    leftMotor.setPosition(Double.POSITIVE_INFINITY);
    rightMotor.setPosition(Double.POSITIVE_INFINITY);
    leftMotor.setVelocity(0.0);
    rightMotor.setVelocity(0.0);
    for (int i=0;i<10;i++) {
      leds[i]=getLED("led"+i);
    };
    for (int i=0;i<8;i++) {
      distanceSensors[i] = getDistanceSensor("ps"+i);
      distanceSensors[i].enable(timeStep);
      lightSensors[i] = getLightSensor("ls"+i);
      lightSensors[i].enable(timeStep);
    }
    // batterySensorEnable(timeStep);
  }

  public void run() {
  
    int blink = 0;
    int oldDx = 0;
    Random r = new Random();
    boolean turn = false;
    boolean right = false;
    boolean seeFeeder = false;
    double battery;
    double oldBattery = -1.0;
    int image[];
    double distance[] = new double[8];
    int ledValue[] = new int[10];
    double leftSpeed, rightSpeed;

    while (step(timeStep) != -1) {

      // read sensor information
      image = camera.getImage();
      for(int i=0;i<8;i++) distance[i] = distanceSensors[i].getValue();
      battery = batterySensorGetValue();
      for(int i=0;i<10;i++) ledValue[i] = 0;

      // obstacle avoidance behavior
      leftSpeed  = -maxSpeed;
      rightSpeed = -maxSpeed;

      // When there is wall in front -> turn left
      if ((distance[3] + distance[4]  > 600)) {
        leftSpeed  = -maxSpeed;
        rightSpeed = maxSpeed;
        System.out.println("Wall in front");
      }else if ( (distance[5] > 100) ) {
          // when is left of the wall move forward
          leftSpeed  = -maxSpeed;
          rightSpeed = -maxSpeed;
          System.out.println("Wall in left");
          if (distance[4] > 150){
            leftSpeed  = -maxSpeed;
            rightSpeed = -maxSpeed/8;
          }
        // } else { // test
        //   System.out.println("Wall in left (error)");
        //   leftSpeed  = maxSpeed;
        //   rightSpeed = -maxSpeed;
        } else {
          System.out.println("Turn left");
          leftSpeed  = -maxSpeed/12;
          rightSpeed = -maxSpeed;
        }
        
      //set actuators
      for(int i=0; i<10; i++) {
        leds[i].set(ledValue[i]);
      }
      leftMotor.setVelocity(0.00628 * leftSpeed);
      rightMotor.setVelocity(0.00628 * rightSpeed);
    }
  }

  public static void main(String[] args) {
    Rat1 rat1 = new Rat1();
    rat1.run();
  }
}
