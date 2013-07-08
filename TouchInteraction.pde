
@Override
public boolean dispatchTouchEvent(MotionEvent event) {

  int action = event.getActionMasked();

  // touch to skip title screen and read instructions
  if (startScreen && action == MotionEvent.ACTION_DOWN) {
    startScreen = false;
    drawInstructionScreen();
  }

  // touch to clear instruction screen and start gameplay
  else if (instructionScreen && action == MotionEvent.ACTION_DOWN) {
    instructionScreen = false;    
    fill(bgColor);                            // clear text (seems to solve some weird glitchiness)
    rect(width/2, height/2, width, height);
    pressTime = millis();                     // set to avoid long-press on exit from start screen
    if (!step.isPlaying()) playFootsteps();   // play a beep
  }

  // when pressed, keep track of time for long-press
  else if (action == MotionEvent.ACTION_DOWN) {
    pressTime = prevMillis = millis();
    startPressX = mouseX;    // store start of press (prevents triggering long-press on movement)
    startPressY = mouseY;
  }

  // release triggers either player move or long-press action
  else if (action == MotionEvent.ACTION_UP) {

    int pressDiffX = abs(mouseX - startPressX);
    int pressDiffY = abs(mouseY - startPressY);
    println("Movement: " + pressDiffX + ", " + pressDiffY);

    // if not, test if a long-press (long enough and with little movement)
    if (millis() - pressTime > longPressThresh) { 
      // println("Click time: " + (millis() - pressTime));     
      // longPress();
    }

    // move player (if enough movement from start position)
    else if (pressDiffX > maxPressDist || pressDiffY > maxPressDist) {
      int diffX = mouseX - pmouseX;
      int diffY = mouseY - pmouseY; 
      if (abs(diffX) < abs(diffY)) {
        if (diffY > 0) movePlayer('u');    // up
        else movePlayer('d');              // down
      }
      else {
        if (diffX < 0) movePlayer('r');    // right
        else movePlayer('l');              // left
      }
    }
  }

  // pass data along when done!
  return super.dispatchTouchEvent(event);
}

