
void createStartScreen() {
  
  int[][] letterPx = {
    { }, 
    { 2, 3, 4, 7, 8, 11, 15, 17, 18, 19, 20 }, 
    { 1, 6, 9, 11, 15, 17 }, 
    { 1, 6, 9, 11, 15, 17 }, 
    { 1, 6, 7, 8, 9, 12, 14, 17, 18, 19 }, 
    { 1, 6, 9, 12, 14, 17 }, 
    { 1, 6, 9, 12, 14, 17 }, 
    { 2, 3, 4, 6, 9, 13, 17, 18, 19, 20 }, 
    { }
  };
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

  // word "cave"
  for (int i=0; i<letterPx.length; i++) {
    for (int x=0; x<letterPx[i].length; x++) {
      fill(random(120,255));
      rect(letterPx[i][x] * tileSize + horizOffset, i*tileSize + vertOffset*tileSize, tileSize, tileSize);
    }
  }
  
  // dim
  for (int y=-tileSize; y<width; y+=tileSize) {
    for (int x=-tileSize; x<width; x+=tileSize) { 
      float dim = abs(dist(x,y, width/2,height/2));
      dim = map(dim, 0,width/1.5, 0,255);
      dim = constrain(dim, 0,255);
      fill(0,dim);
      rect(x + horizOffset, y, tileSize, tileSize);
    }
  }

  // image/text over squares
  //smooth();
  //image(titleImage, width/2,height/2);    // since imageMode = CENTER
}

