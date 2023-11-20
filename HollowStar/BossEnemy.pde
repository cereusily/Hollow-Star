

class BossEnemy extends Enemy {
  // Fields for boss enemy
  
  ArrayList<Bullet> bossBullets = new ArrayList<Bullet>();
  
  int switchCooldown;
  int switchThreshold;
  
  boolean waveUpdated;
  
  Gun bossGun;
  Gun bossSecondaryGun;
  
  int bulletPower = 1;
  int bulletUltValue = 25;
  
  float fireSpeed;
  int maxHealth;
  String name;
  
  BossEnemy(PVector pos, PVector vel, int health, PVector size, float scaleFactor, String state, String enemyType, String name) {
    super(pos, vel, health, size, scaleFactor, state, enemyType);
    
    // Overrides fields
    this.points = 800 + (100 * gameManager.waveNum);
    
    this.ultValue = 0;
    
    // Sets max health
    this.maxHealth = health;
    
    // Sets name
    this.name = name;

    // Sets wave upadted bool
    this.waveUpdated = false;
    
    // Sets gun
    this.bossGun = new MachineGun(this.pos, new PVector(0.6 +(0.1 * gameManager.waveNum), 0.6 + (0.1 * gameManager.waveNum)), bossBullets);
    this.bossSecondaryGun = new AquariusGun(this.pos, new PVector(3 + gameManager.waveNum, 3 + gameManager.waveNum), bossBullets);
    
    // Sets thresholds
    this.switchThreshold = 300 - (25 * gameManager.waveNum);
    this.bossGun.threshold = 150 - (12 * gameManager.waveNum);
    this.bossSecondaryGun.threshold = 190 - gameManager.waveNum;
    
    // Sets parts duration
    this.partRemoveTimer = 160;
    
    // Sets colour
    PShape mainBody = shipShape.getChild(gameManager.enemyShipParts.get("MainBody"));
    mainBody.setFill(255);
    
    PShape windowRoof = shipShape.getChild(gameManager.enemyShipParts.get("WindowRoof"));
    windowRoof.setFill(255);
    
    PShape leftInnerWing = shipShape.getChild(gameManager.enemyShipParts.get("LeftInnerWing"));
    leftInnerWing.setFill(255);
    
    PShape rightInnerWing = shipShape.getChild(gameManager.enemyShipParts.get("RightInnerWing"));
    rightInnerWing.setFill(255);
    
    PShape leftWingBridge = shipShape.getChild(gameManager.enemyShipParts.get("LeftWingBridge"));
    leftWingBridge.setFill(255);
    
    PShape rightWingBridge = shipShape.getChild(gameManager.enemyShipParts.get("RightWingBridge"));
    rightWingBridge.setFill(255);
    
    PShape leftOuterFlap = shipShape.getChild(gameManager.enemyShipParts.get("LeftOuterFlap"));
    leftOuterFlap.setFill(255);
    
    PShape rightOuterFlap = shipShape.getChild(gameManager.enemyShipParts.get("RightOuterFlap"));
    rightOuterFlap.setFill(255);
    
    // Minions :D
    gameManager.addNewEnemy(new PVector(200, 0), new PVector(0, 4), "BLUE");
    gameManager.addNewEnemy(new PVector(width - 200, 0), new PVector(0, 4), "RED");
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
    
    // Shoots gun
    bossGun.shoot((this.getState() == "BLUE" ? "RED" : "BLUE"));
    
    // switch case based off wave num
    switch(gameManager.waveNum) {
      case 0:
        if (getHealth() < this.maxHealth/2) { // uses at half health
          bossSecondaryGun.shoot(this.getState());  // Gets opposite state
        }
        break;
      case 1:
        if (getHealth() < (this.maxHealth * 0.66)) { // uses at 2/3 health
          bossSecondaryGun.shoot(this.getState());  // Gets opposite state
        }
        break;
      default:
        bossSecondaryGun.shoot(this.getState());
        break;
    }
    
    updateBullets();
    
    // Recharges gun
    bossGun.recharge();
    bossSecondaryGun.recharge();
    
    if (!super.isAlive()) {
      if (!waveUpdated) {
        gameManager.waveNum += 1;  // Indicates end of wave
        gameManager.addToWaveTime(gameManager.waveTimeIncrement);  // Increases wavetime increment
        gameManager.killAllEnemies();
        // resets ripples
        setupRipple();
        waveUpdated = true;
        gameManager.bossDead = true;
      }
    }
  }
  
  void setupRipple() {
    gameManager.rippleSize = 0;
    gameManager.rippleColorIncrement = 0;
    gameManager.newColor = color(255);
    gameManager.startRippleTimer();
  }
  
  int getHealth() {
    return this.health;
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
    PShape leftOuterWing = shipShape.getChild(gameManager.enemyShipParts.get("LeftOuterWing"));    
    leftOuterWing.setFill(stateColour);  
    
    PShape rightOuterWing = shipShape.getChild(gameManager.enemyShipParts.get("RightOuterWing"));
    rightOuterWing.setFill(stateColour);
    
    PShape leftInnerWing = shipShape.getChild(gameManager.enemyShipParts.get("LeftInnerWing"));    
    leftInnerWing.setFill(stateColour);  
    
    PShape rightInnerWing = shipShape.getChild(gameManager.enemyShipParts.get("RightInnerWing"));
    rightInnerWing.setFill(stateColour);
    
    PShape mainWindow = shipShape.getChild(gameManager.enemyShipParts.get("MainWindow"));
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
  
  void checkProjectiles() {
    // Checks projectile hit player
    for (int i = 0; i < bossBullets.size(); i++) {
      Bullet currBullet = bossBullets.get(i);
      
      // checks players
      for (int j = 0; j < gameManager.players.size(); j++) {
        Player currPlayer = gameManager.players.get(j);
        
        // If bullet is not same state as player
        if (currBullet.hit(player)) {
          if (currBullet.getState() != currPlayer.getState()) {
            currPlayer.decreaseHealth(bulletPower); 
            gameManager.screenShakeTimer = 2;
            currBullet.vel = new PVector(0, 0); // Zeroes out last hit for freeze effect
            gameManager.lastHitBullet.add(currBullet);
          }
          // If state is same as player
          if (currBullet.getState() == currPlayer.getState()) {
            player.addToUlt(this.bulletUltValue);  // If bullet is same state as player, player absorbs & gains ult points
          }
          
          bossBullets.remove(currBullet);
        }
      }
    }
  }
}
