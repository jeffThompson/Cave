
void playFootsteps() {

  // change amount of reverb based on tile
  // lighter = more reverb/higher, darker = less/lower
  float c = level.pixels[y * w + x] >> 16 & 0xFF;
  decayTime = int(map(c, minTileBrightness,255, minReverb, maxReverb));
  reverb.setDecayTime(decayTime);

  // play sound and vibration pattern
  if (step.isPlaying()) step.seekTo(0);
  else step.start();
  vibe.vibrate(footstepVibration, -1);
}

void playWallHit() {
  if (wallHit.isPlaying()) wallHit.seekTo(0);
  else wallHit.start();
  vibe.vibrate(wallHitVibration, -1);
}

void playRespawn() {
  if (respawn.isPlaying()) respawn.seekTo(0);
  else respawn.start();
  vibe.vibrate(respawnVibration, -1);
}
