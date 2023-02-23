class GameManager {
  /* Helper class that manages game */
  boolean moveUp;
  boolean moveDown;
  boolean moveLeft;
  boolean moveRight;
  
  boolean holdFire;
  int bulletCoolDownStartTime;
  int bulletCoolDownTime = 125;
  
  int starCoolDownStartTime;
  int starCoolDownTime = 70;
  int starMaxSpeed = 15;
  
  PVector upAcc = new PVector(0, -2);
  PVector downAcc = new PVector(0, 2);
  PVector leftAcc = new PVector(-2, 0);
  PVector rightAcc = new PVector(2, 0);
  
  float enemyScale = 0.3;
  int enemyWidth = 120;  // => Basic enemy scale
  
  int enemyRespawnTime = 4_000;
  int enemyRespawnStartTime;
  
  PFont font;

  GameManager() {
    // Constructor
  }
  
  void initAssets() {
    /* Initializes game assets */
    
    // Populates hashmaps
    initPartsMap();
    
    // Loads font
    font = createFont("VCR_OSD_MONO_1.001.ttf", 128);
    
    // Initializes player & inits PShape group
    player = new Player(new PVector(width/2.25, height/1.5), new PVector(), 1, shipWidth, shipWidth, 0.2);
    
    // Adds player to array
    players.add(player);
    
    // Initializes enemies
    // Debug add elite enemy
    enemies.add(new Enemy(new PVector(200, 0), new PVector(0, 0.5), 4, 120, 120, 0.5, "BLUE", true));

    // Creates initial fleet
    createFleet();
  }
  
  void debug() {
    respawnFleet();
  }
  
  void createFleet() {
    // Create an alien and find the number of enemies in a row.
    int xSpace = (width / (enemyWidth + 50));
    
    // Spawns in basic enemies horizontally
    for (int i = 0; i < xSpace + 1; i++) {
      String randomState = ((int) random(-1, 2) > 0) ? "BLUE" : "RED";
      addNewEnemy(enemyWidth + (i * 150), 0, randomState);
    }
  }
  
  void respawnFleet() {
    // Check time passed
    int passedTime = millis() - enemyRespawnStartTime;
    
    // Checks if fleet size less than 10
    if (enemies.size() < 10) {
      // Respawns fleet if enough time passed
      if (passedTime> enemyRespawnTime) {
        createFleet();
        enemyRespawnStartTime = millis();
      }
    }
  }
  
  void checkKeyPressed() {
    // Keeps track of arrow keys
    if (key == CODED) {
      if (keyCode == UP) {
        moveUp = true;
      }
      if (keyCode == DOWN) {
        moveDown = true;
      }
      if (keyCode == LEFT) {
        moveLeft = true;
        player.rotateFactor = -PI/8;
      }
      if (keyCode == RIGHT) {
        moveRight = true;
        player.rotateFactor = PI/8;
      }
      if (keyCode == SHIFT) {
        player.switchState();
      }
    }
    // Player bullets
    if (key == ' ') {
      holdFire = true;
    }
    
    // Ends game
    if (key == ESC) {
      exit();
    }
  }
  
  void checkKeyReleased() {
    // Checks when keys released
    if (key == CODED) {
      if (keyCode == UP) {
        moveUp = false;
      }
      if (keyCode == DOWN) {
        moveDown = false;
      }
      if (keyCode == LEFT) {
        moveLeft = false;
        player.rotateFactor = 0;
      }
      if (keyCode == RIGHT) {
        moveRight = false;
        player.rotateFactor = 0;
      }
    }
    // Player bullets
    if (key == ' ') {
      holdFire = false;
    }
  }
  
  void checkEvents() {
    /* Responds to key presses & mouse events */
    // Checks player movement
    if (moveUp) {
      player.accelerate(upAcc);
    }
    if (moveDown) {
      player.accelerate(downAcc);
    }
    
    if (moveRight) {
      player.accelerate(rightAcc);
    }
    
    if (moveLeft) {
      player.accelerate(leftAcc);
    }
    
    if (holdFire) {
      if(bulletOffCoolDown()) {
        player.fireBullet();
      };
    }
  }
  
  void addStar() {
    /* Creates new star to star array */
    int x = (int) random(0, width);  // => spawn star at random x axis
    int starSpeed = (int) random(0, starMaxSpeed);
    
    Star newStar = new Star(new PVector(x, 0), new PVector(0, starSpeed));
    stars.add(newStar);
  }
  
  void addNewEnemy(int x, int y, String state) {
    // Adds new enemy at a specific row location
    PVector position = new PVector(x, y);
    enemies.add(new Enemy(position, new PVector(0, 2), 2, enemyWidth - 45, enemyWidth - 45, enemyScale, state, false));
  }
  
  
  boolean starOffCoolDown() {
    /* Checks star cool down time */
    int passedCoolDownTime = millis() - starCoolDownStartTime;
    
    if (passedCoolDownTime > starCoolDownTime) {
      starCoolDownStartTime = millis();
      return true;
    }
    return false;
  }
  
  boolean bulletOffCoolDown() {
    /* Checks bullet cool down time */
    int passedCoolDownTime = millis() - bulletCoolDownStartTime;
    
    if (passedCoolDownTime > bulletCoolDownTime) {
      bulletCoolDownStartTime = millis();
      return true;
    }
    return false;
  }
  
  void updatePlayerBullets() {
    // Updates player bullets
    for (int i = 0; i < player.playerBullets.size(); i++) {
      Bullet currPlayerBullet = player.playerBullets.get(i);
      
      currPlayerBullet.update();
      
      // Removes bullets if offscreen
      if (currPlayerBullet.offScreen()) {
        player.playerBullets.remove(i);
      }
    }
  }
  
  void updatePlayer() {
    // updates player sprites
    for (int i = 0; i < players.size(); i++) {
      Player currPlayer = players.get(i);
      
      currPlayer.update();
    }
  }
  
  void updateStars() {
    // Updates star sprites
    for (int i = 0; i < stars.size(); i++) {
      Star currStar = stars.get(i);
      
      currStar.update();
      
      // Removes stars if offscreen
      if (currStar.offScreen()) {
        stars.remove(i);
      }
    }
  }
  
  void updateEnemies() {
    // Updates enemy sprites
    for (int i = 0; i < enemies.size(); i++) {
      Enemy currEnemy = enemies.get(i);
      
      currEnemy.update();
      
      // Removes enemies if offscreen
      if (currEnemy.offScreen()) {
        enemies.remove(i);
      }
    }
  }
  
  void updateParts() {
    for(int i = 0; i < parts.size(); i++) {
      Part currPart = parts.get(i);
      
      currPart.update();
      
      // Removes part if off screen
      if (currPart.offScreen()) {
        parts.remove(i);
      }
    }
  }
  
  void updateExplosionParticles() {
    for(int i = 0; i < explosionParticles.size(); i++) {
      Bullet currParticle = explosionParticles.get(i);
      
      currParticle.update();
      
      // Removes part if off screen
      if (currParticle.offScreen()) {
        explosionParticles.remove(i);
      }
    }
  }
  
  void initPartsMap() {
    // enemy hashmap
    enemyShipParts.put("MainBody", 0);
    enemyShipParts.put("MainWindow", 1);
    enemyShipParts.put("WindowRoof", 2);
    enemyShipParts.put("LeftInnerWing", 3);
    enemyShipParts.put("RightInnerWing", 4);
    enemyShipParts.put("LeftWingBridge", 5);
    enemyShipParts.put("LeftOuterWing", 6);
    enemyShipParts.put("LeftOuterFlap", 7);
    enemyShipParts.put("RightWingBridge", 8);
    enemyShipParts.put("RightOuterWing", 9);
    enemyShipParts.put("RightOuterFlap", 10);
    enemyShipParts.put("NoseDetails", 11);
    
    // Play hashmap
    playerShipParts.put("LeftMainGun", 0);
    playerShipParts.put("LeftGunSub", 1);
    playerShipParts.put("RightGunMain", 2);
    playerShipParts.put("RightGunSub", 3);
    playerShipParts.put("LeftThrusterMain", 4);
    playerShipParts.put("LeftThrustExhaust", 5);
    playerShipParts.put("RightThrusterMain", 6);
    playerShipParts.put("RightThrusterExhaust", 7);
    playerShipParts.put("TailFlap", 8);
    playerShipParts.put("MainBody", 9);
    playerShipParts.put("LeftWing", 10);
    playerShipParts.put("RightWing", 11);
    playerShipParts.put("losingLeftLine", 12);
    playerShipParts.put("ClosingRightLine", 13);
    playerShipParts.put("MainWindow", 14);
    playerShipParts.put("LeftHorn", 15);
    playerShipParts.put("LeftTriHorn", 16);
    playerShipParts.put("RightHorn", 17);
    playerShipParts.put("RightTriHorn", 18);
    playerShipParts.put("TailWingLine", 19);
    playerShipParts.put("NoseBridge", 20);
  }
}
