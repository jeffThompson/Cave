
void keyPressed() {

  // use menu button to toggle keyboard
  // via: http://stackoverflow.com/a/2348030
  if (key == CODED && keyCode == MENU) {
    InputMethodManager inputMgr = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
    inputMgr.toggleSoftInput(0, 0);
  }
  
  // 'D' toggles debugging info onscreen
  else if (key == 'd') debug = !debug;
  
  // 'R' restarts and builds a new level
  else if (key == 'r') {
    setup();
  }
  
  // 'Z' zooms in/out from full view
  else if (key == 'z') {
    if (visionDistance < w) {
      prevVisionDistance = visionDistance;
      visionDistance = max(w,h);
    }
    else {
      visionDistance = prevVisionDistance;
    }
    tileSize = min(width, height) / (visionDistance*2 + 1);
  }

  // # keys change the distance we can see
  else if (key > 49 && key < 58) {
    visionDistance = int(key - 48);                           // 49 = 1, so 49-48 = 1!
    tileSize = min(width, height) / (visionDistance*2 + 1);   // update tile size
  }
}
