class Debug {
  // Debug class
  boolean active;
  boolean cheatOn;
  
  Debug(boolean active) {
    this.active = active;
    
/* Change this if you want to cheat for testing purposes */
    this.cheatOn = true;
  }
  
  boolean getState() {
    return getState();
  }
  
  void debugCheat() {
    if (cheatOn) {
      if (players.size() > 0) {
        Player player = players.get(0);
        
        // Set cheats
        player.playerUlt.power = 2000;  // Insta kill taurus shot
        player.ultimateMeter = 20;      // Unlimited ultimate meter
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
    if (players.size() > 0) {
      text(str(players.get(0).pos.x), 20, 400);
      text(str(players.get(0).pos.y), 20, 430);
    }
    
    // Last hit
    text("LAST HIT COORDINATES", 20, 500);
    if (lastHitBullet.size() > 0) {
      text(str(lastHitBullet.get(0).pos.x), 20, 530);
      text(str(lastHitBullet.get(0).pos.y), 20, 560);
    }
    
    // Wave number
    text("WAVE NUMBER", 20, 610);
    text(str(gameManager.waveNum), 20, 640);
    
    // Wave over debug
    text("WAVE OVER", width - 150, 170);
    text(str(gameManager.waveOver), width-150, 200);
  }
  
  void drawDebug() {
    
  }
  
  
  void updateDebug() {    
    if (active) {
      debugStats();
      debugCheat();
      drawDebug();
    } 
  }
}
