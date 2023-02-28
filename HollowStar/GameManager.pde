class GameManager {
  /* Helper class that manages game */
  boolean moveUp;
  boolean moveDown;
  boolean moveLeft;
  boolean moveRight;
  
  int lives = 3;
  
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
  
  int waveStartTime;
  int waveCounter;
  int waveMaxTime = 1_000;
  boolean waveOver;
  
  int waveNum = 0;
  boolean bossSpawned = false;
  
  PFont font;

  GameManager() {
   
  }
  
  void initAssets() {
    /* Initializes game assets */
    menuOn = true;
    
    isActive = true;
    
    // Populates hashmaps
    initPartsMap();
    
    // Loads font
    font = createFont("VCR_OSD_MONO_1.001.ttf", 128);
  }
  
  void restart() {
    // Empties out all lists
    players.clear();
    stars.clear();
    enemies.clear();
    parts.clear();
    
    playerDeathTimer = -1;
    screenShake = 3;
    screenShakeTimer = 0;
    screenJitter = 0;
    bossSpawned = false;
    enemyRespawnStartTime = millis();
    
    // Initializes player & inits PShape group
    player = new Player(new PVector(width/2.25, height/1.5), new PVector(), 1, new PVector(shipWidth, shipWidth), 0.2);
    
    // Adds player to array
    players.add(player);
    
    // <--- WAVE CODE --->
    resetWaveTime();
    
    // Initializes enemies
    // Debug add elite enemy
    enemies.add(new Enemy(new PVector(200, 0), new PVector(0, 0.5), 4, new PVector(120, 120), 0.5, "BLUE", "ELITE"));

    // Creates initial fleet
    createFleet();
  }
  
  void addBossEnemy() {
    enemies.add(
    new BossEnemy(new PVector(width/2, 0), new PVector(0, 0), 250, new PVector(120, 120), 0.5, 
    "BLUE", "BOSS", "HOLLOW STAR"));
  }
  
  void resetWaveTime() {
    waveCounter = 0;
    waveStartTime = millis();
    waveOver = false;
  }
  
  void updateWaveTime() {
    textSize(32);
    if (waveCounter - waveStartTime < waveMaxTime){
      waveCounter = millis();
    }
    else {
      waveOver = true;
    }
    
    // Fills timer bar
    fill(244,3,3);
    noStroke();
    rect(20,100,map(waveCounter - waveStartTime, 0, waveMaxTime, 0, 200), 19);
    if (!waveOver) {
      text(waveCounter - waveStartTime + " " + int(waveMaxTime) +  " " + int (map(waveCounter - waveStartTime, 0, waveMaxTime, 0, 200)), 20, 160);
    }
    else {
      text("WAVE OVER", 20, 160);
    }
  }
  
  void createFleet() {
    // Create an alien and find the number of enemies in a row.
    int xSpace = (width / (enemyWidth + 50));
    
    // Spawns in basic enemies horizontally
    for (int i = 0; i < xSpace + 1; i++) {
      String randomState = ((int) random(-1, 2) > 0) ? "BLUE" : "RED";
      addNewEnemy(new PVector(enemyWidth + (i * 150), 0), randomState);
    }
  }
   
  void respawnFleet() {
    // Check time passed
    int passedTime = millis() - enemyRespawnStartTime;
    
    // Checks if fleet size less than 11
    if (enemies.size() < 11) {
      // Respawns fleet if enough time passed
      if (passedTime> enemyRespawnTime) {
        createFleet();
        enemyRespawnStartTime = millis();
      }
    }
  }
  
  void displayUltMeter() {
    // Displays player's ultimate meter
    if (player.canUseUlt()) {
      textAlign(CENTER);
      fill(255);
      text("FULL", 130, 700);
      fill(153,50,204);
    }
    else {
      fill(player.stateColour);
    }
    // Ult bar
    rect(30, 700, map(player.ultimateMeter, 0, player.ultimateMaxMeter, 0, 200), 20, 28);
    
    // Ult backgrouund bar
    noFill();
    strokeWeight(4);
    stroke(255);
    rect(30, 700, 200, 20, 28);
    
    textAlign(LEFT);
  }
  
  void displayGameOver() {
    // Displays gameover
    
    textAlign(CENTER);
    textSize(42);
    fill(red);
    text("GAME OVER", width/2, 400);
    textSize(12);
    text("< PRESS ENTER/RETURN TO CONTINUE >", width/2, 450);
    textAlign(LEFT);
    gameOver = true;
  }
  
  void displayMenu() {
    // Displays main menu
    textFont(font);
    textAlign(CENTER);
    fill(255);
    textSize(120);
    text("HOLLOW STAR", width/2, 400);
    textSize(30);
    text("< PRESS ENTER/RETURN TO START >", width/2, 470);
    textSize(20);
    text("< PRESS ESC TO QUIT >", width/2, 500);
    textAlign(LEFT);
  }
  
  void checkKeyPressed() {
    // Keeps track of arrow keys
    
    // Checks for menu
    if (menuOn) {
      if (key == ENTER || key == RETURN) {
        menuOn = false;
        isActive = true;
      }
    }
    // Regular checks
    else {
      if (player.isAlive()) {
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
          if (keyCode == SHIFT && player.switchCooldown == player.switchThreshold) {
            player.switchState();
          }
        }
        // Player bullets
        if (key == ' ') {
          holdFire = true;
        }
        
        // Ult shot
        if (key == 'x' && player.canUseUlt()) {
          player.fireUlt();
        }
      }
      else {
        holdFire = false;  // Stops firing if player is dead
      }
      // Ends game
      if (key == ESC) {
        // resets key
        key = 0;
        menuOn = true;
        isActive = false;
      }
      // Resets game if enter / return is entered
      if ((key == ENTER || key == RETURN) && gameOver) {  // Starts game
          lives = 3;
          score = 0;
          restart();
      }
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
        moveLeft = false;  // nullpointer when no player in playerarray   
        if (gameStart) {  // Only resets rotation when player is in game => else nullpointer
          player.rotateFactor = 0;
        } 
      }
      if (keyCode == RIGHT) {
        moveRight = false;
        if (gameStart) {
          player.rotateFactor = 0;
        } 
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
    
    if (holdFire && player.isAlive()) {
      player.fire();
      player.playerGun.recharge();
    }
  }
  
  void addStar() {
    /* Creates new star to star array */
    int x = (int) random(0, width);  // => spawn star at random x axis
    int starSpeed = (int) random(0, starMaxSpeed);
    
    Star newStar = new Star(new PVector(x, 0), new PVector(0, starSpeed));
    stars.add(newStar);
  }
  
  void addNewEnemy(PVector position, String state) {
    // Adds new enemy at a specific row location
    enemies.add(new Enemy(position, new PVector(0, 2), 4, new PVector(enemyWidth - 45, enemyWidth - 45), enemyScale, state, "BASIC"));
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
  
  
  void updatePlayerBullets() {
    // Updates player bullets
    for (int i = 0; i < player.playerBullets.size(); i++) {
      Bullet currPlayerBullet = player.playerBullets.get(i);
      
      currPlayerBullet.update();
      currPlayerBullet.drawMe();
      
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
      currStar.drawMe();
      
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
      currEnemy.drawMe();
      
      // Removes enemies if offscreen
      if (currEnemy.offScreen()) {
        enemies.remove(i);
      }
    }
  }
  
  void updateParts() {
    // Updates part sprites
    for(int i = 0; i < parts.size(); i++) {
      try {
        Part currPart = parts.get(i);
      
        currPart.update();
        currPart.drawMe();
        
        // Removes part if off screen
        if (currPart.offScreen()) {
          parts.remove(i);
        }
      }
      catch (Exception e) {
        // -> Catches rare error when parts are removed too early
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
