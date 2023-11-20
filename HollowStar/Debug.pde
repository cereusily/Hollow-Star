class Debug {
  // Debug class
  boolean active;
  boolean cheatOn;
  boolean showHitbox;
  boolean skipTutorial;
  PVector lastHitCoordinates;
  int waveTime;
  
  Debug(boolean active) {
    waveTime = 2_000;
    this.active = active;
    
    if (active) {
      //last hit
      lastHitCoordinates = new PVector(0, 0);
      // Wave timew
      gameManager.waveMaxTime = waveTime;
      gameManager.waveTimeIncrement = 0;
      
  /* Change this if you want to cheat for testing purposes */
      this.cheatOn = true;
      this.skipTutorial = true;
      
      if (skipTutorial) {
        sceneManager.tutorialSceneOver = true;
      }
      
      // Hide hitboxes
      showHitbox = false;
    }
  }
  
  boolean getState() {
    return getState();
  }
  
  void debugCheat() {
    if (cheatOn) {
      if (gameManager.players.size() > 0) {
        Player player = gameManager.players.get(0);
        
        // Set cheats
        player.playerUlt.power = 2000;  // Insta kill taurus shot
        player.ultimateMeter = player.ultimateMaxMeter;      // Unlimited ultimate meter
      }
    }
  }
  
  void debugStats() {
    // Frame rate
    fill(255);
    text("FRAME RATE", 20, 270);
    text(str(frameRate), 20, 300);
    
    // Player
    text("PLAYER COORDINATES", 20, 370);
    if (gameManager.players.size() > 0) {
      text(str(gameManager.players.get(0).pos.x), 20, 400);
      text(str(gameManager.players.get(0).pos.y), 20, 430);
    }
    
    // Last hit
    text("LAST HIT COORDINATES", 20, 500);
    if (gameManager.players.size() == 0) {
      text(str(lastHitCoordinates.x), 20, 530);
      text(str(lastHitCoordinates.y), 20, 560);
    }
    

    
    // Wave number
    text("WAVE NUMBER", 20, 610);
    text(str(gameManager.waveNum), 20, 640);
    
    // Wave over debug
    text("WAVE OVER", width - 150, 170);
    text(str(gameManager.waveOver), width - 150, 200);
  }
  
  void updateDebug() {    
    if (active) {
      debugStats();
      debugCheat();
    } 
  }
}
