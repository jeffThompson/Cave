
// a messy little icon generator app :)

int s = 9;  // odd #s work better

size(72,72);
noStroke();

background(0);
for (int y=0; y<s; y++) {
  for (int x=0; x<s; x++) {  
    float d = abs(dist(s/2,s/2, x,y));
    d = map(d, 0,s/2, 255,0);
    fill(d);
    rect(x*(width/s), y*(height/s), width/s,height/s);
  }
}
save("icon-" + width + ".png");
