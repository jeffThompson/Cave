
import android.view.inputmethod.InputMethodManager;   // imports required for keyboard
import android.content.Context;
import android.media.*;                               // audio playback
import android.content.res.*;
import android.media.AudioTrack;
import android.media.audiofx.EnvironmentalReverb;
import android.os.Vibrator;                           // vibration
import android.view.inputmethod.InputMethodManager;   // keyboard
import android.view.MotionEvent;                      // fancy touch access

/*
CAVE
 Jeff Thompson | 2013 | www.jeffreythompson.org
 
 Wander an algorithmic cave, listening for the height of the ceiling changing and
 bumping into walls. But don't let your light go out, or you'll be left in the dark!
 
 Swipe your finger up/right/down/left to move your player. A long-tap will illuminate
 neighboring tiles but it will drain your light!
 
 Created with generous support from Harvestworks' Cultural Innovation Fund program.
 
 TO DO:
 + .. 
 
 TO CONSIDER:
 + light could move with mouseX/Y; stop when light hits edge of screen?
 
 Keyboard adjustments:
 1-9    changes the distance the player can see (in pixels)
 'D'    toggle debugging info (default off)
 'R'    reset to setup (and build a new level)
 'Z'    full zoom out (default off)
 'B'    toggle background tile tinting (default off, which still tints a little bit)
 
 Required permissions:
 + MODIFY_AUDIO_SETTINGS
 + VIBRATE
 
 */

int visionDistance = 1;         // radius of tiles shown onscreen (can be changed with # keys)

final String stepFilename = "step_331-440-300.wav";        // sound to play when walking
final String wallHitFilename = "wallHit_100-90-440.wav";   // sound when hitting a wall
final String respawnFilename = "respawn_10.wav";           // respawn sound effect

final color bgColor = color(0);                 // background color (areas of level we can't go)
color tintColor = color(20, 10, 0);             // overlay color
final int tintStrength = 100;                   // 0 = no tint, 255 = fully opaque (probably not a good idea)
final color playerColor = color(255);           // color of player in center
final color respawnColor = color(255, 0, 0);    // color of respawn points

boolean startScreen = true;               // show title screen?
final boolean randomTintColor = true;     // create a random overlay color on load?
boolean debug = true;                     // print debugging info (both onscreen and via USB)
final boolean drainLight = true;          // limited supply of light?
boolean tintBackground = false;           // tint background tiles as well? (off tints just a little bit)

final int w = 100;                        // level dimensions
final int h = 100;
final int numSteps = 20000;               // # of steps in random walk
final int inc = 40;                       // color step in random walk (or: how quickly we get to 0)
final int minTileBrightness = 50;         // darkest tile (first step from background)
final int numRespawnPoints = 400;         // # of points that cause the player to spawn in a new location

final int longPressThresh = 500;          // time (in ms) for long-press
final int maxPressDist = 40;              // max distance the mouse can move during a long-press

final int maxCharge = 60 * 1000;          // starting charge for light (in ms)
int lightCharge = maxCharge;              // current charge (goes down as player long-clicks
long prevMillis;                          // keep track of time we've had the light on

final int minReverb = 10;                 // min amount of reverb (smallest space)
final int maxReverb = 3000;
int decayTime = 20000;                    // 10 to 20k (changes with tile height)
final short density = 1000;               // 0 to 1k
final short diffusion = 0;                // 0 to 1k
final short roomLevel = 0;                // -9k to 0
final short reverbLevel = 2000;           // -9k to 2k
final short reflectionsDelay = 0;         // 0 to 300
final short reflectionsLevel = 1000;      // -9k to 1k
final short reverbDelay = 0;              // 0 to 100

// vibration patterns (off, on, off, on...)
final long[] footstepVibration = { 
  50, 150, 60, 100
};
final long[] wallHitVibration = { 
  0, 30
};
long[] respawnVibration = new long[(6000 / 100) + 1];  // generated in setup

PImage level, titleImage;      // level and title screen
int x, y;                      // player x,y position
char playerDir = 'u';          // direction player is facing (for drawing player onscreen)
int tileSize, lightSize;       // display size of each tile
PFont font;                    // debugging font
int prevVisionDistance;        // reset from full zoom-out
long pressTime;                // time (in ms) for detecting long-press
int startPressX, startPressY;  // location of mouse press (for triggering long-press)
PImage bgMask;                 // mask for hiding objects beyond circular light

int[][] respawnPoints = new int[numRespawnPoints][2];

MediaPlayer step, wallHit, respawn, rear, left, front, right;    // sound effects
EnvironmentalReverb reverb;                                      // reverb (for step only)
Vibrator vibe;                                                   // vibration motor


void setup() {
  orientation(LANDSCAPE);
  rectMode(CENTER);
  imageMode(CENTER);
  titleImage = loadImage("TitleScreen_textOnly.png");
  smooth();
  noStroke();

  // set player to random location
  x = int(random(w));
  y = int(random(h));
  println("Random starting location: " + x + ", " + y);

  // create level image
  println("Building level...");
  createLevel();
  level.loadPixels();                                       // load for access to color array (throws an error in Android if you don't)
  tileSize = min(width, height) / (visionDistance*2 + 1);   // size tiles based on screen dims  
  lightSize = height - tileSize/2;                          // flashlight diameter
  prevMillis = 0;

  // load font for debugging
  println("Loading fonts...");
  font = createFont("Monospaced", height/36);
  textFont(font);
  textAlign(LEFT, TOP);

  // load sound effects and initialize vibration
  println("Loading sounds...");
  loadSounds();
  vibe = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
  respawnVibration[0] = 0;
  for (int i=1; i<respawnVibration.length; i+=2) {    // create rumble the length of the respawn sound
    respawnVibration[i] = 50;
    respawnVibration[i+1] = 50;
  }

  // create background mask for light pool on long-press
  createBackgroundMask();

  // random background/overlay color, if specified
  if (randomTintColor) {
    // just be sure we can't accidentally generate the respawn color
    tintColor = color(random(50, 150), random(50, 255), random(50, 255));
  }

  // create start screen
  createStartScreen();
}


void draw() {
  // start screen
  if (startScreen) {
    // do nothing at all, just wait until someone touches the screen
  }

  // draw level
  else {
    background(bgColor);

    // draw current tile
    fill(level.pixels[y*h+x]);
    rect(width/2, height/2, tileSize, tileSize);
    fill(tintColor, tintStrength);                     // tint to level color
    rect(width/2, height/2, tileSize, tileSize);    

    // if the mouse is on and we've been doing so for a while, draw a circle to show long click
    if (mousePressed && millis() - pressTime > longPressThresh*0.5) {

      //lightCharge -= int(millis() - pressTime);
      lightCharge -= millis() - prevMillis;
      prevMillis = millis();

      // while ramping up
      if (millis() - pressTime < longPressThresh) {
        float s = map(millis() - pressTime, 0, longPressThresh, 0, lightSize);  // scale size based on press time 
        s = constrain(s, 0, lightSize);                                         // don't get too big!
        fill(255, 100);                                                         // while ramping up, white
        ellipse(width/2, height/2, s, s);
      }

      // when lit, draw tiles around us
      else {
        drawTiles();                                         // draw, dim, and tint surrounding tiles
        image(bgMask, width/2, height/2, width, height);     // then draw mask to light pool
      }
    }

    // if specified, show remaining light charge
    if (drainLight) {

      int chargeWidth = 100;
      int chargeHeight = height/2;
      float ch = map(lightCharge, maxCharge, 0, chargeHeight, 2);

      // dim the view as we drain the light
      fill(0, map(lightCharge, maxCharge, 0, 0, 255));
      ellipse(width/2, height/2, lightSize, lightSize);

      // display the light UI
      /*
      rectMode(CORNER);
       noFill();
       stroke(255);
       rect(100, height*0.75, 100, -height*0.5);
       
       noStroke();
       fill(tintColor);
       rect(101, height*0.75, 98, -ch);
       rectMode(CENTER);
       
       textAlign(CENTER, CENTER);
       fill(255);
       text(nf((lightCharge/1000f), -1, 2) + "\nsec", 150, height*0.75 + 40); 
       textAlign(LEFT, TOP);
       */
    } 

    // draw player
    drawPlayer();

    // if on, display debugging info
    if (debug) {
      fill(255);
      String details = "POSITION: " + x + ", " + y;
      details += "\nHEIGHT:   " + (level.pixels[y * w + x] >> 16 & 0xFF);
      details += "\nVISION:   " + visionDistance;
      details += "\nTINT:     " + (tintColor >> 16 & 0xFF)  + ", " + (tintColor >> 8 & 0xFF) + ", " + (tintColor & 0xFF);
      details += "\nFPS:      " + frameRate;
      text(details, 50, 50);
    }
  }
}

