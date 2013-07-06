
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
 
 Created with generous support from Harvestworks' Cultural Innovation Fund program.
 
 TO DO:
 + Finalize color (random?)
 + Better tint (dims red, current tile)
 + Sounds for: wall hit, teleport
 
 TO CONSIDER:
 + Long tap-hold-release for a wall-sweep flash (like the sonar, but all around)
 
 Keyboard adjustments:
 1-9    changes the distance the player can see (in pixels)
 'D'    toggle debugging info
 'R'    reset to setup (and build a new level)
 'Z'    full zoom out
 
 Required permissions:
 + MODIFY_AUDIO_SETTINGS
 + VIBRATE
 
 */

String beepFilename = "beep_331-400-300.wav";    // sound to play when walking
int visionDistance = 6;                          // radius of tiles shown onscreen

color bgColor = color(0);                 // background color (areas of level we can't go)
color tintColor = color(255, 150, 0);     // overlay color
int tintStrength = 100;                   // 0 = no tint, 255 = fully opaque (probably not a good idea)
color playerColor = color(255);           // color of player in center
color respawnColor = color(255,0,0);      // color of respawn points

boolean startScreen = true;         // show title screen?
boolean randomTintColor = true;     // create a random overlay color on load?
boolean debug = true;               // print debugging info (both onscreen and via USB)

int w = 100;                        // level dimensions
int h = 100;
int numSteps = 20000;               // # of steps in random walk
int inc = 40;                       // color step in random walk (or: how quickly we get to 0)
int minTileBrightness = 50;         // darkest tile (first step from background)
int numRespawnPoints = 30;          // # of points that cause the player to spawn in a new location

int longPressThresh = 300;          // time (in ms) for long-press (less will be normal click)
int maxPressDist = 50;              // max distance the mouse can move during a long-press

int minReverb = 10;                 // min amount of reverb (smallest space)
int maxReverb = 3000;
int decayTime = 20000;              // 10 to 20k
short density = 1000;               // 0 to 1k
short diffusion = 0;                // 0 to 1k
short roomLevel = 0;                // -9k to 0
short reverbLevel = 2000;           // -9k to 2k
short reflectionsDelay = 0;         // 0 to 300
short reflectionsLevel = 1000;      // -9k to 1k
short reverbDelay = 0;              // 0 to 100

long[] footstepVibration = {        // vibration pattern for footsteps (off, on, off, on...)
  50, 150, 60, 100
};
long[] wallHitVibration = {         // pattern when hitting the wall
  0,30
};
long[] respawnVibration = {         // pattern when respawning
  0,20,90,20,80,20,70,20,60,20,50,20,40,20,30,20,30,20,20,20,10,150,150
};

PImage level, titleImage;      // level and title screen
int x, y;                      // player x,y position
char playerDir = 'u';          // direction player is facing (for drawing player onscreen)
int tileSize;                  // display size of each tile
PFont font;                    // debugging font
int prevVisionDistance;        // reset from full zoom-out
long pressTime;                // time (in ms) for detecting long-press
int startPressX, startPressY;  // location of mouse press (for triggering long-press)
int[][] respawnPoints = new int[numRespawnPoints][2];

MediaPlayer beep;
EnvironmentalReverb reverb;
Vibrator vibe;


void setup() {
  orientation(LANDSCAPE);
  rectMode(CENTER);
  titleImage = loadImage("TitleScreen.png");
  smooth();
  noStroke();

  // set player to random location
  x = int(random(w));
  y = int(random(h));
  println("Random starting location: " + x + ", " + y);

  // create level image
  println("Building level...");
  createLevel();
  level.loadPixels();                                      // load for access to color array (throws an error in Android if you don't)
  tileSize = min(width, height) / (visionDistance*2 + 1);  // size tiles based on screen dims

  // load fonts
  println("Loading fonts...");
  font = createFont("Monospaced", height/36);
  textFont(font);
  textAlign(LEFT, TOP);

  // load sound effects and initialize vibration
  println("Loading sounds...");
  loadSounds();
  vibe = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);

  // random background/overlay color, if specified
  if (randomTintColor) {
    // just be sure we can't accidentally generate the respawn color
    tintColor = color(random(50, 150), random(50, 255), random(50, 255));
  }
}


void draw() {
  // start screen
  if (startScreen) {
    displayStartScreen();
  }

  // draw level
  else {
    background(bgColor);
    drawTiles();

    // overlay with background color
    fill(tintColor, tintStrength);
    rect(width/2, height/2, width, height);   // since rectMode = CENTER

    // draw current tile (with no overlay)
    fill(level.pixels[y*w + x]);
    rect(width/2,height/2, tileSize,tileSize);
    drawPlayer();

    if (debug) {
      fill(255);
      text("POSITION: " + x + ", " + y + "\nHEIGHT:   " + (level.pixels[y * w + x] >> 16 & 0xFF) + "\nVISION:   " + visionDistance, 50, 50);
    }
  }
}

