class Debug {
  // Debug class
  boolean active;
  
  Debug(boolean active) {
    this.active = active;
  }
  
  boolean getState() {
    return getState();
  }
  
  void debugStats() {
    text(str(frameRate), 20, 300);
    
  }
  
  void drawDebug() {
    
  }
  
  
  void updateDebug() {    
    if (active) {
      debugStats();
      drawDebug();
    } 
  }
}
