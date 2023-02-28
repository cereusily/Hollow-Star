class BossEnemy extends Enemy {
  // Fields for boss enemy
  
  ArrayList<Bullet> bossBullets = new ArrayList<Bullet>();
  
  int switchCooldown;
  int switchThreshold = 300;
  int bulletPower = 1;
  int maxHealth;
  String name;
  
  BossEnemy(PVector pos, PVector vel, int health, int charWidth, int charHeight, float scaleFactor, String state, String enemyType, String name) {
    super(pos, vel, health, charWidth, charHeight, scaleFactor, state, enemyType);
    
    // Overrides fields
    this.points = 1000;
    
    // Sets max health
    this.maxHealth = health;
    
    // Sets name
    this.name = name;
    
    // Sets colour
    PShape mainBody = shipShape.getChild(enemyShipParts.get("MainBody"));
    mainBody.setFill(255);
    
    PShape windowRoof = shipShape.getChild(enemyShipParts.get("WindowRoof"));
    windowRoof.setFill(255);
    
    PShape leftInnerWing = shipShape.getChild(enemyShipParts.get("LeftInnerWing"));
    leftInnerWing.setFill(255);
    
    PShape rightInnerWing = shipShape.getChild(enemyShipParts.get("RightInnerWing"));
    rightInnerWing.setFill(255);
    
    PShape leftWingBridge = shipShape.getChild(enemyShipParts.get("LeftWingBridge"));
    leftWingBridge.setFill(255);
    
    PShape rightWingBridge = shipShape.getChild(enemyShipParts.get("RightWingBridge"));
    rightWingBridge.setFill(255);
    
    PShape leftOuterFlap = shipShape.getChild(enemyShipParts.get("LeftOuterFlap"));
    leftOuterFlap.setFill(255);
    
    PShape rightOuterFlap = shipShape.getChild(enemyShipParts.get("RightOuterFlap"));
    rightOuterFlap.setFill(255);
    
    // Minions :D
    gameManager.addNewEnemy(new PVector(200, 0), "BLUE");
    gameManager.addNewEnemy(new PVector(width - 200, 0), "RED");
  } 
  
  void update() {
    displayArc();
    
    // Updates
    super.update();
    
    // Checks projectiles
    checkProjectiles();
    
    // Updates ship colour
    updateShipColour(); 
    
    // Updates health bar
    displayHealthBar();
    
    if (switchCooldown == switchThreshold) {
      this.switchState();
    }
    
    // Checks switching cooldown
    if (switchCooldown < switchThreshold) {
      switchCooldown++;
    }
    
    // Moves towards center
    if (this.pos.y < height/4) {
      this.vel.y = 2;
    }
    else {
      this.vel.y = 0;
    }
    
    fireBullets();
    updateBullets();
    
    if (!super.isAlive()) {
      gameManager.bossSpawned = false;
      gameManager.resetWaveTime();
    }
  }
  
  void switchState() {
    // Swaps states
    this.switchCooldown = 0;
    this.setState((state == "BLUE" ? "RED" : "BLUE"));
  }
  
  void updateShipColour() {
    // Updates ship color to state color
    switch(state){
      case "BLUE":
        stateColour = blue;
        break;
      case "RED":
        stateColour = red;
        break;
    }
    PShape leftOuterWing = shipShape.getChild(enemyShipParts.get("LeftOuterWing"));    
    leftOuterWing.setFill(stateColour);  
    
    PShape rightOuterWing = shipShape.getChild(enemyShipParts.get("RightOuterWing"));
    rightOuterWing.setFill(stateColour);
    
    PShape leftInnerWing = shipShape.getChild(enemyShipParts.get("LeftInnerWing"));    
    leftInnerWing.setFill(stateColour);  
    
    PShape rightInnerWing = shipShape.getChild(enemyShipParts.get("RightInnerWing"));
    rightInnerWing.setFill(stateColour);
    
    PShape mainWindow = shipShape.getChild(enemyShipParts.get("MainWindow"));
    mainWindow.setFill(stateColour); 
  }
  
  void updateBullets() {
    for (int i = 0; i < bossBullets.size(); i++) {
      Bullet currBullet = bossBullets.get(i);
      
      currBullet.update();
      currBullet.drawMe();
      
      // If bullet off screen => remove
      if (currBullet.offScreen()) {
        bossBullets.remove(i);
      }
    }
  }
  
  void displayArc() {
    // Displays gun arc
    float angle = map(switchCooldown, 0, switchThreshold, 0, TWO_PI);
    fill(this.stateColour);
    arc(this.pos.x, this.pos.y, 400, 400, 0, angle);
    fill(0);
    ellipse(this.pos.x, this.pos.y, 340, 340);
  }
  
  void displayHealthBar() {
    // Displays health bar
    strokeWeight(0);
    fill(orange);
    rect(width/2 - 200, 50, map(health, 0, maxHealth, 0, 400), 30, 20);
    textSize(36);
    textAlign(CENTER);
    text(name, width/2, 50);
    textAlign(LEFT);
  }
  
  void fireBullets() {
    float randomX = (float) random(-5, 5);
    float randomY = (float) random(-5, 5);
    
    PVector tempPos = this.pos.copy();
    
    Bullet newBullet = new Bullet(tempPos, new PVector(randomX, randomY), 15, 15);
    newBullet.colourWeight = 5;
    newBullet.setState(this.getState());
    
    bossBullets.add(newBullet);
  }
  
  void checkProjectiles() {
    // Checks projectile hit player
    for (int i = 0; i < bossBullets.size(); i++) {
      Bullet currBullet = bossBullets.get(i);
      
      // checks players
      for (int j = 0; j < players.size(); j++) {
        Player currPlayer = players.get(j);
        
        // If bullet is not same state as player
        if (currBullet.getState() != currPlayer.getState()) {
          if (dist(currBullet.pos.x, currBullet.pos.y, currPlayer.pos.x, currPlayer.pos.y) < currPlayer.charWidth/2) {
            currPlayer.decreaseHealth(bulletPower); 
            screenShakeTimer = 2;
            currBullet.removeSelf();
          }
        }
      }
    }
  }
}