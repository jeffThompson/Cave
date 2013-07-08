
void movePlayer(char dir) {

  switch(dir) {
  case 'u':
    y -= 1;
    if (y < 0) y = h-1;
    if (level.pixels[y*w + x] == bgColor) {
      if (y == h-1) y = 0;
      else y += 1;
      playWallHit();
    }
    else if (level.pixels[y*w + x] == respawnColor) {
      playerDir = dir;
      respawn();
    }
    else { 
      playerDir = dir;
      playFootsteps();
    }
    break;

  case 'd':
    y += 1;
    if (y >= h) y = 0;
    if (level.pixels[y*w + x] == bgColor) {
      if (y == 0) y = h-1;
      else y -= 1;
      playWallHit();
    }
    else if (level.pixels[y*w + x] == respawnColor) {
      playerDir = dir;
      respawn();
    }
    else { 
      playerDir = dir;
      playFootsteps();
    }
    break;

  case 'l':
    x -=1;
    if (x < 0) x = w-1;
    if (level.pixels[y*w + x] == bgColor) {
      if (x == w-1) x = 0;
      else x += 1;
      playWallHit();
    }
    else if (level.pixels[y*w + x] == respawnColor) {
      playerDir = dir;
      respawn();
    }
    else { 
      playerDir = dir;
      playFootsteps();
    }
    break;

  case 'r':
    x += 1;
    if (x >= w) x = 0;
    if (level.pixels[y*w + x] == bgColor) {
      if (x == 0) x = w-1;
      else x -= 1;
      playWallHit();
    }
    else if (level.pixels[y*w + x] == respawnColor) {
      playerDir = dir;
      respawn();
    }
    else { 
      playerDir = dir;
      playFootsteps();
    }
    break;
  }
}

void respawn() {
  
  // if on, recharge the light
  if (drainLight) lightCharge = maxCharge;
  
  int px = x;  // store current location to ensure we don't respawn there
  int py = y;
  int newPoint = int(random(numRespawnPoints)); 
  x = respawnPoints[newPoint][0];
  y = respawnPoints[newPoint][1];

  while (x == px && y == py) {
    newPoint = int(random(numRespawnPoints));
    x = respawnPoints[newPoint][0];
    y = respawnPoints[newPoint][1];
  } 

  // play sounds
  playRespawn();
}
