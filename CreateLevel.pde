
void createLevel() {

  // set temp player position
  int px = x;
  int py = y;

  // generate image
  level = createImage(w, h, RGB);
  level.loadPixels();

  // fill with white
  for (int i=0; i<(w*h); i++) {
    level.pixels[i] = color(bgColor);
  }

  // random walk
  for (int i=0; i<numSteps; i++) {
    float r = level.pixels[py * w + px] >> 16 & 0xFF;   // get current color
    r += inc;
    r = constrain(r, 0,255);
    level.pixels[py * w + px] = color(r);

    px += int(random(-2, 2));      // random walk (+/-1)
    py += int(random(-2, 2));

    if (px < 0) px = w-1;          // if we've gone over the edge, wrap around
    else if (px > w-1) px = 0;
    if (py < 0) py = h-1;
    else if (py > h-1) py = 0;
  }
  
  // random respawn points
  for (int i=0; i<numRespawnPoints; i++) {
    px = int(random(w));
    py = int(random(h));
    
    while(level.pixels[py * w + px] == bgColor) {
      px = int(random(w));
      py = int(random(h));
    }
    level.pixels[py * w + px] = respawnColor;
    
    respawnPoints[i][0] = px;
    respawnPoints[i][1] = py;
  }
  
  // all done!
  level.updatePixels();
}

