
@Override
public boolean dispatchTouchEvent(MotionEvent event) {

  int action = event.getActionMasked();

  // touch to clear title screen and start gameplay
  if (startScreen && action == MotionEvent.ACTION_DOWN) {
    startScreen = false;
    fill(bgColor);                            // clear text (seems to solve some weird glitchiness)
    rect(width/2, height/2, width, height);
    pressTime = millis();                     // set to avoid long-press on exit from start screen
  }

  // when pressed, keep track of time for long-press
  else if (action == MotionEvent.ACTION_DOWN) {
    pressTime = millis();
    startPressX = mouseX;    // store start of press (prevents triggering long-press on movement)
    startPressY = mouseY;
  }

  // release triggers either player move or long-press action
  else if (action == MotionEvent.ACTION_UP) {    // also try ACTION_MOVE

    int pressDiffX = abs(mouseX - startPressX);
    int pressDiffY = abs(mouseY - startPressY);

      // if a long-press (long enough and with little movement)
      if (millis() - pressTime > longPressThresh && pressDiffX < maxPressDist && pressDiffY < maxPressDist) {
        vibe.vibrate(500);
      }

      // otherwise, move player (enough movement from start position)
      else if (pressDiffX > 80 || pressDiffY > 80) {
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

