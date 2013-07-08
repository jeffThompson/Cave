
void drawInstructionScreen() {

  int numTiles = 21;
  int horizOffset = 65;
  int vertOffset = 2;
  int tileSize = width/22;

  // random background tiles
  noStroke();
  for (int y=-tileSize; y<width; y+=tileSize) {
    for (int x=-tileSize; x<width; x+=tileSize) {
      fill(random(0, 40));
      rect(x + horizOffset, y, tileSize, tileSize);
    }
  }

  // dim
  for (int y=-tileSize; y<width; y+=tileSize) {
    for (int x=-tileSize; x<width; x+=tileSize) { 
      float dim = abs(dist(x, y, width/2, height/2));
      dim = map(dim, 0, width/1.5, 0, 255);
      dim = constrain(dim, 0, 255);
      fill(0, dim);
      rect(x + horizOffset, y, tileSize, tileSize);
    }
  }

  // image/text over squares
  smooth();
  image(instructionImage, width/2,height/2);    // since imageMode = CENTER
}

