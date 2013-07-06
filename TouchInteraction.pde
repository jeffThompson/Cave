
@Override
public boolean dispatchTouchEvent(MotionEvent event) {

  int action = event.getActionMasked();

  // touch to clear title screen and start gameplay
  if (startScreen && action == MotionEvent.ACTION_DOWN) {
    startScreen = false;
    fill(bgColor);                          // clear text (seems to solve some weird glitchiness)
    rect(width/2,height/2, width,height);
  } 

  // drag to move player
  else if (action == MotionEvent.ACTION_UP) {    // also try ACTION_MOVE
    int diffX = mouseX - pmouseX;
    int diffY = mouseY - pmouseY; 

    if (abs(diffX) < abs(diffY)) {
      if (diffY > 0) {         // up
        movePlayer('u');
      }
      else {                   // down
        movePlayer('d');
      }
    }
    else {
      if (diffX < 0) {         // right
        movePlayer('r');
      }
      else {                   // left
        movePlayer('l');
      }
    }
  }

  // pass data along when done!
  return super.dispatchTouchEvent(event);
}

