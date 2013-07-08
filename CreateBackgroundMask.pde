
void createBackgroundMask() {
  
  // image to use as a mask for light pool on long-click
  bgMask = createImage(width,height, RGB);
  bgMask.loadPixels();
  for (int i=0; i<bgMask.pixels.length; i++) {    // fill all black
    bgMask.pixels[i] = color(0);
  }
  bgMask.updatePixels();
  
  // white circle to use to punch hole in mask image
  PGraphics circle = createGraphics(width,height);
  circle.beginDraw();
  circle.background(255);
  circle.fill(0);
  circle.noStroke();
  circle.ellipse(width/2,height/2, lightSize,lightSize);
  circle.endDraw();

  // create a transparent hole in the mask image
  bgMask.mask(circle.get());
}
