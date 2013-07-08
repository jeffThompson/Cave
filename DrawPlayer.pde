
void drawPlayer() {
  fill(playerColor);
  
  ellipse(width/2,height/2, tileSize/2,tileSize/2);
  
  /*
  // triangular player faces direction we last moved
  pushMatrix();
  translate(width/2, height/2);
  
  switch(playerDir) {
  case 'u':
    rotate(0);
    break;
  case 'r':
    rotate(HALF_PI);
    break;
  case 'd':
    rotate(PI);
    break;
  case 'l':
    rotate(-HALF_PI);
    break;
  }
  
  triangle(0, -tileSize/4, tileSize/4, tileSize/4, -tileSize/4, tileSize/4);
  popMatrix();
  */
}
