
void drawTiles() {

  noStroke();

  for (int ty = -visionDistance; ty <= visionDistance; ty++) {
    for (int tx = -visionDistance; tx <= visionDistance; tx++) {

      // pixel position (adjusted from player position)
      int px = x + tx;
      int py = y + ty;

      // wrap around sides of image
      if (px < 0) px += w;
      else if (px >= w) px = px % w;
      if (py < 0) py += h;
      else if (py >= h) py = py % h;

      // screen position (center)
      int sx = width/2 + (tx*tileSize);
      int sy = height/2 + (ty*tileSize);

      // draw tile
      float dist = abs(dist(0,0, tx,ty));
      float dim = map(dist, 0, visionDistance, 255,0);
      dim = constrain(dim, 0, 255);
      fill(level.pixels[py * w + px], dim);
      rect(sx, sy, tileSize, tileSize);
    }
  }
}

