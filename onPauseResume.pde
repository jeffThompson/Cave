
void onPause() {
  //
  super.onPause();
}

void onResume() {
  super.onResume();
  
  startScreen = true;          // show the start screen each time
  instructionScreen = true;    // show instructions too
  createStartScreen();
  startTime = millis();        // reset time for start screen timeout
}

