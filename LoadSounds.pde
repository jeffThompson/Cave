
void loadSounds() {

  try {
    
    // add reverb settings
    reverb = new EnvironmentalReverb(0, 0);
    reverb.setDecayTime(decayTime);
    reverb.setDensity(density);
    reverb.setDiffusion(diffusion);
    reverb.setReverbLevel(reverbLevel);
    reverb.setRoomLevel(roomLevel);
    reverb.setReflectionsDelay(reflectionsDelay);
    reverb.setReflectionsLevel(reflectionsLevel);
    reverb.setReverbDelay(reverbDelay);
    reverb.setEnabled(true);
    
    // load step
    step = new MediaPlayer();
    AssetManager assets = this.getAssets();
    AssetFileDescriptor fd = assets.openFd(stepFilename);
    step.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    step.attachAuxEffect(reverb.getId());
    step.setAuxEffectSendLevel(1.0f);
    step.prepare();
    
    // load wall hit
    wallHit = new MediaPlayer();
    fd = assets.openFd(wallHitFilename);
    wallHit.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    //wallHit.attachAuxEffect(reverb.getId());
    //wallHit.setAuxEffectSendLevel(1.0f);
    wallHit.prepare();
  
    // load respawn
    respawn = new MediaPlayer();
    fd = assets.openFd(respawnFilename);
    respawn.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    respawn.prepare();
    
    // load scan sounds
    rear = new MediaPlayer();
    fd = assets.openFd("rear.wav");
    rear.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    rear.prepare();
    
    left = new MediaPlayer();
    fd = assets.openFd("left.wav");
    left.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    left.prepare();
    
    front = new MediaPlayer();
    fd = assets.openFd("front.wav");
    front.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    front.prepare();
    
    right = new MediaPlayer();
    fd = assets.openFd("right.wav");
    right.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    right.prepare();
  }
  
  catch (IOException ioe) {
    println("Error (probably could not find or load the audio file - is it in the sketch's data folder?)");
  }
}
