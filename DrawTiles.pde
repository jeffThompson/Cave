
void drawTiles() {

  // iterate surrounding tiles
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

      // draw tile, dim based on distance from center
      float dist = abs(dist(0,0, tx,ty));
      float dim = map(dist, 0, visionDistance+1, 255,0);  // +1 = last row/col will be dark
      dim = constrain(dim, 0, 255);
      fill(level.pixels[py * w + px], dim);
      rect(sx, sy, tileSize, tileSize);
      
      // if a respawn or background tile, do NOT tint
      // otherwise, tint the tile a nice (random) shade :)
      if (level.pixels[py * w + px] == respawnColor) {
        fill(255);
        ellipse(sx,sy, tileSize/12,tileSize/12);    // little dot on respawn points
      }
      else if (!tintBackground && level.pixels[py * w + px] == bgColor) {
        // if specified, skip tinting background tiles
        // or, tint just a little
        fill(tintColor, 30);
        rect(sx,sy, tileSize,tileSize);
      }
      else {
        fill(tintColor, tintStrength);
        rect(sx,sy, tileSize,tileSize);
      }
    }
  }
}
