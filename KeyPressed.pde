
void keyPressed() {

  // use menu button to toggle keyboard
  // via: http://stackoverflow.com/a/2348030
  if (key == CODED && keyCode == MENU) {
    InputMethodManager inputMgr = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
    inputMgr.toggleSoftInput(0, 0);
  }
  
  // 'B' toggles background tile tinting
  else if (key == 'b') tintBackground = !tintBackground;
  
  // 'D' toggles debugging info onscreen
  else if (key == 'd') debug = !debug;
  
  // 'L' toggles light meter
  else if (key == 'l') showLightUI = !showLightUI;
  
  // 'T' create a respawn point right next to you
  else if (key == 't') {
    level.pixels[y*w + x + 1] = respawnColor;
    int[] newPoint = { x+1, y };
    respawnPoints = (int[][]) append(respawnPoints, newPoint);  // add new point to list of respawn locations
  }
  
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
  else if (key >= 49 && key < 58) {
    visionDistance = int(key - 48);                           // 49 = 1, so 49-48 = 1!
    tileSize = min(width, height) / (visionDistance*2 + 1);   // update tile/light size
    lightSize = height - tileSize/2;
  }
}
