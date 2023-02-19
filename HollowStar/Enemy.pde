class Enemy extends Character {
  /* Class that manages enemy objects */
  int enemyPower = 1;
  color enemyColour = color(0, 255, 0);
  
  Enemy(PVector pos, PVector vel, int health, int charWidth, int charHeight, int scaleFactor) {
    // Inits fields
    super(pos, vel, health, charWidth, charHeight, scaleFactor);
  }
  
  void update() {
    // Updates from parent class
    super.update();
    
    // Checks health
    checkHealth();
    
    // Checks if touched player
    if (hitCharacter(player)) {
      player.decreaseHealth(enemyPower);
    }
  }
  
  void drawMe() {
    // Draws self
    push();
    
    translate(pos.x, pos.y);
    
    fill(enemyColour);
    ellipse(0, 0, 100, 100);
    
    pop();
  }
  
  void checkHealth() {
    // Checks health & changes colour depending on damage
    if (health < 0) {
      enemyColour = color(255);
    }
  }
  
  boolean offScreen() {
    /* Checks if enemy is offscreen */
    return 
    ((pos.x < -charWidth/2) || (pos.x > width + charWidth/2) ||
    (pos.y < -charWidth/2) || (pos.y > height + charWidth/2));
  }
  
}
