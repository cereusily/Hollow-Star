class Debug {
  // Debug class
  boolean active;
  boolean cheatOn;
  
  Debug(boolean active) {
    this.active = active;
    
/* Change this if you want to cheat for testing purposes */
    this.cheatOn = false;
  }
  
  boolean getState() {
    return getState();
  }
  
  void debugCheat() {
    if (cheatOn) {
      
      
      
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
