
void playFootsteps() {

  // change amount of reverb based on tile  
  // lighter = more reverb/higher, darker = less/lower
  float c = level.pixels[y * w + x] >> 16 & 0xFF;
  decayTime = int(map(c, minTileBrightness,255, minReverb, maxReverb));
  reverb.setDecayTime(decayTime);

  // play sound and vibration pattern
  if (beep.isPlaying()) {
    beep.seekTo(0);
  }
  else {
    beep.start();
  }
  vibe.vibrate(footstepVibration, -1);
}

void playWallHit() {
  vibe.vibrate(wallHitVibration, -1);
}

void playRespawn() {
  vibe.vibrate(respawnVibration, -1);
}
