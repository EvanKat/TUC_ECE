//-----------------------------------------------------------------------------
//  File:         FieldPlayer.java (to be used in a Webots java controllers)
//  Date:         April 30, 2008
//  Description:  Field player "2", "3" or "4" for "red" or "blue" team
//  Project:      Robotstadium, the online robot soccer competition
//  Author:       Yvan Bourquin - www.cyberbotics.com
//  Changes:      November 4, 2008: Adapted to Webots6
//-----------------------------------------------------------------------------

import com.cyberbotics.webots.controller.*;

public class FieldPlayer extends Player {

  private Motion backwardsMotion, forwardsMotion, forwards50Motion, turnRight40Motion, turnLeft40Motion;
  private Motion turnRight60Motion, turnLeft60Motion, turnLeft180Motion, sideStepRightMotion, sideStepLeftMotion;
  // Extra
  private Motion shoot, HandWave; 
  private double goDir = 0.0;
  double ballDir = 0.0;
  private double goalDir = 0.0; // interpolated goal direction (with respect to front direction of robot body)

  public FieldPlayer(int playerID, int teamID) {
    super(playerID, teamID);
    backwardsMotion     = new Motion("../../motions/Backwards.motion");
    forwardsMotion      = new Motion("../../motions/Forwards.motion");
    forwards50Motion    = new Motion("../../motions/Forwards50.motion");
    turnRight40Motion   = new Motion("../../motions/TurnRight40.motion");
    turnLeft40Motion    = new Motion("../../motions/TurnLeft40.motion");
    turnRight60Motion   = new Motion("../../motions/TurnRight60.motion");
    turnLeft60Motion    = new Motion("../../motions/TurnLeft60.motion");
    turnLeft180Motion   = new Motion("../../motions/TurnLeft180.motion");
    sideStepRightMotion = new Motion("../../motions/SideStepRight.motion");
    sideStepLeftMotion  = new Motion("../../motions/SideStepLeft.motion");
    shoot               = new Motion("../../motions/Shoot.motion");
    HandWave            = new Motion("../../motions/HandWave.motion");
    // move arms along the body
    Motor leftShoulderPitch = getMotor("LShoulderPitch");
    leftShoulderPitch.setPosition(1.5);
    Motor rightShoulderPitch = getMotor("RShoulderPitch");
    rightShoulderPitch.setPosition(1.5);
  }

  // normalize angle between -PI and +PI
  private double normalizeAngle(double angle) {
    while (angle > Math.PI) angle -= 2.0 * Math.PI;
    while (angle < -Math.PI) angle += 2.0 * Math.PI;
    return angle;
  }

  // relative body turn
  private void turnBodyRel(double angle) {
    if (angle > 0.7)
      turnRight60();
    else if (angle < -0.7)
      turnLeft60();
    else if (angle > 0.3)
      turnRight40();
    else if (angle < -0.3)
      turnLeft40();
  }

  protected void runStep() {
    super.runStep();
    double dir = camera.getGoalDirectionAngle();
    if (dir != NaoCam.UNKNOWN)
      goalDir = dir - headYawPosition.getValue();
  }

  private void turnRight60() {
    playMotion(turnRight60Motion); // 59.2 degrees
    goalDir = normalizeAngle(goalDir - 1.033);
  }

  private void turnLeft60() {
    playMotion(turnLeft60Motion); // 59.2 degrees
    goalDir = normalizeAngle(goalDir + 1.033);
  }

  private void turnRight40() {
    playMotion(turnRight40Motion); // 39.7 degrees
    goalDir = normalizeAngle(goalDir - 0.693);
  }

  private void turnLeft40() {
    playMotion(turnLeft40Motion); // 39.7 degrees
    goalDir = normalizeAngle(goalDir + 0.693);
  }
  
  private void turnLeft180() {
    playMotion(turnLeft180Motion); // 163.6 degrees
    goalDir = normalizeAngle(goalDir + 2.855);
  }

  @Override public void run() {
    step(SIMULATION_STEP);

    while (true) {

      runStep();

      getUpIfNecessary();

      while (getBallDirection() == NaoCam.UNKNOWN) {
        System.out.println("searching the ball"); 
        getUpIfNecessary();
        if (getBallDirection() != NaoCam.UNKNOWN) break;
        headScan();
        if (getBallDirection() != NaoCam.UNKNOWN) break;
        playMotion(backwardsMotion);
        playMotion(backwardsMotion); ////
        playMotion(backwardsMotion); ////
        playMotion(backwardsMotion); ////
        playMotion(backwardsMotion); ////
        playMotion(backwardsMotion); ////
        if (getBallDirection() != NaoCam.UNKNOWN) break;
        headScan();
        if (getBallDirection() != NaoCam.UNKNOWN) break;
        turnLeft180();
      }

      ballDir = getBallDirection();
      double ballDist = getBallDistance();
      double goDir = normalizeAngle(ballDir - goalDir);
      System.out.println("ball dist: " + ballDist + " ball dir: " + ballDir + " goal dir: " + goalDir + " goDir: " + goDir);
      // boolean BodyIsSet = false;
      
      
      if (ballDist > 1.5){
        playMotion(HandWave);
        System.out.println("Move fast to ball");
        // goDir = normalizeAngle(ballDir - goalDir);

        if (goDir < ballDir - 0.5)
          goDir = ballDir - 0.5;
        else if (goDir > ballDir + 0.5)
          goDir = ballDir + 0.5;

        goDir = normalizeAngle(goDir);
        playMotion(forwards50Motion);
      }
      else if (ballDist > 0.50) {
        // runStep();
        playMotion(forwardsMotion);
        
        if ( goDir < -0.25) {
          System.out.println("Step left");
          
          if (ballDir < -0.15){
          playMotion(sideStepLeftMotion);
          }    
          // playMotion(sideStepLeftMotion);
          
        }
        else if ( goDir > 0.25) {
          System.out.println("Step right");
          playMotion(sideStepRightMotion);
          
          if (ballDir > 0.0){
          playMotion(sideStepRightMotion);
          }    
          playMotion(sideStepRightMotion);
        }
      } else {
        playMotion(forwardsMotion);
        if (ballDist < 0.25){
          // turnBodyRel(goDir);
          System.out.println("Shoot");
          playMotion(shoot);
        }
      }      
    }
  }
}
