
void longPress() {

  /*
  int duration = 500;     // duration to play each note
   int silence = 30;       // silence between tiles
   
   // sweep neighboring pixels
   for (int i=0; i<=4; i++) {
   
   int pos = 0;
   switch(i) {
   case 0:
   pos = (y+1)*w + x;    // D
   playBeep(rear, pos, duration, silence);
   break;
   case 1:
   pos = y*w + x-1;      // L
   playBeep(left, pos, duration, silence);
   break;
   case 2:
   pos = (y-1)*w + x;    // U
   playBeep(front, pos, duration, silence);
   break;
   case 3:
   pos = y*w + x+1;      // R
   playBeep(right, pos, duration, silence);
   break;
   }
   }
   */
}

void playBeep(MediaPlayer m, int i, int duration, int silence) {

  if (m.isPlaying()) m.seekTo(0);
  else m.start();

  if (level.pixels[i] == bgColor) {
    m.setVolume(0, 0);
    vibe.vibrate(duration);
  }
  else if (level.pixels[i] == respawnColor) {
    //
  }
  else {
    float c = map(level.pixels[i] >> 16 & 0xFF, 0, 255, 0.1, 0.7);
    m.setVolume(c, c);
  }

  delay(duration);

  m.setVolume(0, 0);
  delay(silence);

  m.pause();
}

