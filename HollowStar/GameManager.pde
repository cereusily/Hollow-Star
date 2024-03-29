class GameManager {
  /* Helper class that manages game */
  boolean isActive;
  boolean gameWin;
  
  boolean gameOver;
  boolean gameStart = false;
  boolean bossDead = false;
  
  float screenShake;
  float screenShakeTimer;
  float screenJitter;
  
  int playerDeathTimer = -1;
  int restartTime = 150;
  
  boolean moveUp;
  boolean moveDown;
  boolean moveLeft;
  boolean moveRight;
  
  int lives = 3;
  int shipWidth = 100;
  
  //int enemyWidth = 80;
  int numEnemies = 10;
  
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
  
  Timer timer = new Timer();
  int waveInitTime = 15_000;
  int waveMaxTime = 15_000;
  int waveTimeIncrement = 5_000;
  int finalWaveNum = 3; // 0,1,2, 3 waves
  boolean waveOver;
  boolean waveUpdated = false;
  
  int waveNum = 0;
  boolean bossSpawned = false;
  
  // Boss ripple effects when die
  float rippleSize;  
  float maxRippleSize = 4000;
  float rippleColorIncrement = 0.01;
  color current = color(255);
  color newColor;
  
  int rippleTimer;
  
  float angle;
  PFont font;
  
  // score stuff
  int score;
  
  // Menu
  boolean menuOn;
  
  // Arraylists
  ArrayList<Player> players = new ArrayList<Player>();
  ArrayList<Star> stars = new ArrayList<Star>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<Part> parts = new ArrayList<Part>();
  ArrayList<Bullet> lastHitBullet = new ArrayList<Bullet>();
  ArrayList<Enemy> lastHitEnemy = new ArrayList<Enemy>();
 
  HashMap<String, Integer> playerShipParts = new HashMap<String, Integer>();
  HashMap<String, Integer> enemyShipParts = new HashMap<String, Integer>();

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
    
    // Starts timer
    timer.begin();
  }
  
  void setGameWin() {
    gameWin = true;
  }
  
  boolean checkGameWin() {
    return finalWaveNum <= (waveNum - 1);
  }
  
  void restart() {
    /* Restarts and clears settings */
    
    // Empties out all lists
    players.clear();
    stars.clear();
    enemies.clear();
    parts.clear();
    lastHitBullet.clear();
    lastHitEnemy.clear();
    
    playerDeathTimer = -1;
    screenShake = 3;
    screenShakeTimer = 0;
    screenJitter = 0;
    bossSpawned = false;
    enemyRespawnStartTime = millis();
    gameOver = false;
    
    // Initializes player & inits PShape group
    player = new Player(new PVector(width/2.25, height/1.5), new PVector(), 1, new PVector(shipWidth, shipWidth), 0.2);
    
    // Adds player to array
    players.add(player);
    
    // <--- WAVE CODE --->
    resetWaveTime();
  }
  
  /**
  =========================
  <--- Enemy Functions --->
  =========================
  */
  
  void addNewEnemy(PVector position, PVector velocity, String state) {
    // Adds new enemy at a specific row location
    enemies.add(new Enemy(position, velocity, 4, new PVector(enemyWidth - 45, enemyWidth - 45), enemyScale, state, "BASIC"));
  }
  
  void addEliteEnemy() {
    // Adds new elite enemy at random locations
    String randomState = getRandomState();
    float randomX = (int) random(120, width - 120);
    enemies.add(new Enemy(new PVector(randomX, -60), new PVector(0, 0.5), 15, new PVector(120, 120), 0.5, randomState, "ELITE"));
  }
  
  void addFastEnemy() {
    // Adds new fast enemy at random locations
    String randomState = getRandomState();
    float randomX = (int) random(120, width - 120);
    enemies.add(new Enemy(new PVector(randomX, -60), new PVector(0, 8), 15, new PVector(enemyWidth - 45, enemyWidth - 45), enemyScale, randomState, "BASIC"));
  }
  
  void addBossEnemy() {
    // Adds a basic boss enemy
    enemies.add(
    new BossEnemy(new PVector(width/2, 0), new PVector(0, 0), 1000, new PVector(120, 120), 0.5, 
    "BLUE", "BOSS", "HOLLOW STAR"));
  }
  
  String getRandomState() {
    return ((int) random(-1, 2) > 0) ? "BLUE" : "RED";
  }
  
  void createFleet() {
    // Create an alien and find the number of enemies in a row.
    int xSpace = (width / (enemyWidth + 50));
    
    // Spawns in basic enemies horizontally
    for (int i = 0; i < xSpace + 1; i++) {
      String randomState = getRandomState();
      addNewEnemy(new PVector(enemyWidth + (i * 150), -enemyWidth/4), new PVector(0, 4), randomState);
    }
  }
  
  
  void respawnFleet() {
    // Check time passed
    int passedTime = millis() - enemyRespawnStartTime;
    
    // Checks if fleet size less than 11
    if (passedTime > enemyRespawnTime) {
      // Respawns fleet if enough time passed
      if (enemies.size() < 10) {
        for (int i = 0; i < 2 + waveNum; i++) {
          
          // Loads in special enemies depending on wave num
          if (waveNum > 0) {    
            addEliteEnemy();
          }
          if (waveNum > 1) {
            addFastEnemy();
          }    
        }
        createFleet();
        enemyRespawnStartTime = millis();
      }
    }
  }
  
  void killAllEnemies() {
    /* Function that kills all */
    for (int i = 0; i < enemies.size(); i++) {
      Enemy currEnemy = enemies.get(i);
      currEnemy.health = -1;
    }
  }
  
  void startRippleTimer() {
    rippleTimer = 120;
  }
  
  void checkBossRipple() {
    // Check if theres ripple timer wee
    if (rippleTimer > 0) {
      displayBossRipple();
    }
    rippleTimer--;
  }
  
  void displayBossRipple() {
    // Draws boss explosion ripples
    push();
    noFill();
    
    translate(width/2, height/4);  // rough location where boss is
    stroke(255);
    
    // Lerps colours
    newColor = lerpColor(current, black, rippleColorIncrement);
    
    if (rippleSize <= maxRippleSize) {
      stroke(newColor);
      strokeWeight(16);
      
      // Draws ripples
      rippleSize += 20;
      ellipse(0, 0, rippleSize, rippleSize);
      ellipse(0, 0, rippleSize * .75, rippleSize * .75);
      ellipse(0, 0, rippleSize * .5, rippleSize * .5);
      
      rippleColorIncrement += 0.01;
    }
    pop();
  }
  
  /**  
  ====================
  <--- UI Methods --->
  ====================
  */
  
  void displayText() {
    push();
    textFont(gameManager.font);
    textSize(30);
    fill(255);
    text("HI SCORE: " + str(score), 40, 50);
    text("LIVES: " + str(gameManager.lives), width - 175, 50);
      
    // Enemies remaining
    textSize(15);
    text("HOSTILES REMAINING: ", width - 200, 80);
    if (enemies.size() == 0) {
      fill(255);
    }
    else {
      fill(255, 0, 0);
    }
    text(str(enemies.size()), width - 50, 100); 
    textSize(30);
    fill(255);
    pop();
  }
  
  void displayWaveTime() {
    // Draws wave time bar
    // Fills timer bar
    push();
    translate(15, 0);
    
    fill(244,3,3);
    noStroke();
    rect(20, 100, map(timer.getCurrentTime(), 0, waveMaxTime, 0, 200), 19);
    if (!waveOver) {
      text(timer.getCurrentTime() + " " + int(waveMaxTime) +  " " + int (map(timer.getCurrentTime(), 0, waveMaxTime, 0, 200)), 20, 160);
    }
    else {
      text("WAVE OVER", 20, 160);
    }
    
    pop();
  }
  
  void displayUltMeter() {
    /* Displays player's ultimate meter */
    push();
    
    translate(0, height/10);
    
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
    
    pop();
  }
  
  void displayGameOver() {
    
    push();
    
    // Pauses timer
    timer.pause();
    
    // Displays gameover
    textAlign(CENTER);
    textSize(42);
    fill(red);
    text("GAME OVER", width/2, 400);
    textSize(12);
    text("< PRESS ENTER/RETURN TO CONTINUE >", width/2, 450);
    textAlign(LEFT);
    gameOver = true;
    
    pop();
  }
  
  void displayMenu() {
    // Draw background
    background(0);
    
    // Adds stars
    if (gameManager.starOffCoolDown()) {
      gameManager.addStar();
    };
    
    // Pauses game timer
    timer.pause();
     
    // Displays main menu

    textFont(font);
    textAlign(CENTER);
    fill(255);
    
    // Line 1
    textSize(120);
    text("HOLLOW STAR", width/2, height/2);
    
    // Line 2
    textSize(30);
    text("< PRESS ENTER/RETURN TO START >", width/2, height/2 + 100);
    
    // Line 3
    textSize(20);
    text("< PRESS ESC TO QUIT >", width/2, height/2 + 140);
    
    // Line 4
    //textSize(20);
    //text("< PRESS TAB TO DISPLAY CONTROLS >", width/2, 530);
    
    textAlign(LEFT);
    updateStars();
    
  }
  
  void displayEndGame() {
    // Line 1
    push();
    textAlign(CENTER);
    
    textSize(120);
    text("CONGRATULATIONS.", width/2, 400);
    
    // Line 2
    textSize(30);
    text("YOU HAVE SAVED THE GALAXY.", width/2, 470);
    
    // Line 3
    textSize(20);
    text("HI SCORE: " + str(score), width/2, 500); 
    pop();
  }
  
  
  /* 
  =======================
  <--- Input Methods ---> 
  =======================
  */
  
  void checkKeyPressed() {
    /* Keeps track of arrow keys */
    
    // Checks for menu
    if (menuOn) {
      if (key == ENTER || key == RETURN) {
        menuOn = false;
      }
    }
    
    // Regular keyboard checks
    else {
      if (players.size() > 0  ) {
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
        if ((key == 'x' || key == 'X') && player.canUseUlt()) {
          player.fireUlt();
        }
        if (key == 'w' || key == 'W') {
          moveUp = true;
        }
        if (key == 's' || key == 'S') {
          moveDown = true;
        }
        if (key == 'a' || key == 'A') {
          moveLeft = true;
          player.rotateFactor = -PI/8;
        }
        if (key == 'd' || key == 'D') {
          moveRight = true;
          player.rotateFactor = PI/8;
        }
        if (keyCode == SHIFT && player.switchCooldown == player.switchThreshold) {
          player.switchState();
        }
      }
      else {
        holdFire = false;  // Stops firing if player is dead
      }
      // Pauses game
      if (key == ESC) {
        if (!menuOn) {
          key = 0;
        }
        menuOn = true;
      }
      if (gameOver) {
        // Resets game if over
        // Resets game if enter / return is entered
        if ((key == ENTER || key == RETURN)) {  // Starts game
            lives = 3;
            score = 0;
            waveNum = 0;
            sceneManager.introSceneOver = false;
            restart();
        }
      }
      
    }
  }
  
  void checkKeyReleased() {
    /* Checks when keys released */
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
    if (key == 'w' || key == 'W') {
      moveUp = false;
    }
    if (key == 's' || key == 'S') {
      moveDown = false;
    }
    if (key == 'a' || key == 'A') {
      moveLeft = false;  // nullpointer when no player in playerarray   
      if (gameStart) {  // Only resets rotation when player is in game => else nullpointer
        player.rotateFactor = 0;
      } 
    }
    if (key == 'd' || key == 'D') {
      moveRight = false;
      if (gameStart) {
        player.rotateFactor = 0;
      } 
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
  
  /* 
  =================================
  <--- Background Star Methods --->
  =================================
  */
  
  void addStar() {
    /* Creates new star to star array */
    int x = (int) random(0, width);  // => spawn star at random x axis
    int starSpeed = (int) random(0, starMaxSpeed);
    
    // Starts offscreen
    Star newStar = new Star(new PVector(x, -5), new PVector(0, starSpeed));
    stars.add(newStar);
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
  
  /* 
  ========================
  <--- Update Methods ---> 
  ========================
  */
  
  void updatePlayerBullets() {
    /* Updates player bullets */
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
  
  void drawLastHit() {
    /* Draws the last bullet hit */
    if (lastHitBullet.size() > 0) {
      Bullet currlastHitBullet = lastHitBullet.get(0);
      currlastHitBullet.drawMe();
    }
    if (lastHitEnemy.size() > 0) {
      Enemy currLastHitEnemy = lastHitEnemy.get(0);
      currLastHitEnemy.drawMe();
    }
  }
  
  void updatePlayerDeath() {
    /* Is called when player dies */
    if (playerDeathTimer == -1) {
      playerDeathTimer = restartTime;
    }
    if (playerDeathTimer > 0) {
      playerDeathTimer--;
    }
    if (playerDeathTimer == 0) {
      lives -= 1;
      restart();
    }
  }
  
  void updateScreenShake() {
    /* Calculates screen jitter */
    if (screenShakeTimer > 0) {
      screenJitter = random(-screenShake, screenShake);
      translate(screenJitter, screenJitter);
      screenShakeTimer--;
    }
  }
  
  
  void updatePlayer() {    // => Player is in array to avoid duplicate part method call during drawDeath();
    /* Updates player sprites */
    for (int i = 0; i < players.size(); i++) {
      Player currPlayer = players.get(i);
      
      currPlayer.update();
    }
  }
  
  void updateStars() {
    /* Updates star sprites */
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
    // displays explosions
    gameManager.checkBossRipple();
    
    /* Updates enemy sprites */
    for (int i = 0; i < enemies.size(); i++) {
      Enemy currEnemy = enemies.get(i);
      
      currEnemy.update();
      currEnemy.drawMe();
    }
  }
  
  void updateParts() {
    /* Updates part sprites */
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
        // -> Catches rare NullPointerError when parts are removed few frames too early due to lag
      }
    }
  }
  
  void updateWaveTime() {
    /* Updates and displays the timer bar */
    textSize(32);
    if (!sceneManager.introSceneOver) {
      timer.pause();
    }
    else {
      if (timer.getCurrentTime() > waveMaxTime){
        waveOver = true;
        timer.pause();
      }
      else if (waveOver) {
        timer.pause();
      }
      else {
        timer.keepRunning();
      }
    }
    displayWaveTime();
  }
  
  void addToWaveTime(int added) {
    waveMaxTime += added;
  }
  
  void resetWaveTime() {
    /* Resets wave clock */
    timer.reset();
    waveOver = false;
    bossDead = false;
    sceneManager.bossSceneOver = false;
  }
  
  /**
  ==========================
  <--- Parts Map Method --->
  ==========================
  */
  
  void initPartsMap() {
    /* Puts all parts into unique hashmap */
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
    
    // Player hashmap
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
    playerShipParts.put("ClosingLeftLine", 12);
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
