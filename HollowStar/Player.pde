

class Player extends Character {
  float acc = 0.7;
  float damp = 0.87;
  
  int shipWidth = 100;
  
  PVector upAcc = new PVector(0, -acc);
  PVector downAcc = new PVector(0, acc);
  PVector leftAcc = new PVector(-acc, 0);
  PVector rightAcc = new PVector(acc, 0);
  
  PShape shipShape;
  
  ArrayList<Bullet> playerBullets = new ArrayList<Bullet>();
  
  color bulletOuterColour = color(0, 0, 255);
  color bulletInnerColour = color(255);
  
  // Player guns
  Gun playerGun;
  Gun playerUlt;
  
  int switchCooldown;
  int switchThreshold = 20;
  
  int deathTimer= -1;
  int deathAnimationTime = 30;
  PVector deathPosition;
    
  String state = "BLUE";
  color stateColour = blue;
  
  int ultimateMeter;
  int ultimateMaxMeter = 150;
  
  
  Player(PVector pos, PVector vel, int health, PVector size, float scaleFactor) {
    // Calls parent super init function
    super(pos, vel, health, size, scaleFactor);
    
    // Creates PShape group to house drawings
    shipShape = createShape(GROUP);
    
    // Init ship shape
    initShipShape();
    
    // Init pisces gun
    playerGun = new PiscesGun(this.pos, new PVector(0, -10), playerBullets);
    
    // Init ult gun
    playerUlt = new TaurusGun(this.pos, new PVector(0, -20), playerBullets); 
  }
  
  void update() {
    // Multiples velocity by dampening
    vel.mult(damp);
    
    // Calls parent update function
    super.update();

    // Checks switching cooldown
    if (switchCooldown < switchThreshold) {
      switchCooldown++;
    }
    
    // Sets ult if exceeds limit
    if (ultimateMeter > ultimateMaxMeter) {
      ultimateMeter = ultimateMaxMeter;
    }
    
    // Calls projectile hit
    checkProjectiles();

    // Checks health
    checkHealth();
    
    // Death timer
    if (deathTimer > 0) {
      deathTimer--;
    }  
    if (deathTimer == 0) {
      drawDeath();
      gameManager.players.remove(this);
    }

    // Check color state => Refactor to game manager later
    updateShipColour();
  }
  
  boolean isAlive() {
    return deathTimer == -1;
  }
  
  void checkHealth() {
    // Checks if player is dead 
    if (health < 1) {
      
      // Sets animations
      if (isAlive()) {      
        deathTimer = deathAnimationTime;
        gameManager.screenShake = 100;
      }
    }
  }
  
  void fire() {
    playerGun.shoot(this.getState());
  }
  
  boolean canUseUlt() {
    return (this.ultimateMeter >= this.ultimateMaxMeter);
  }
  
  void addToUlt(int inc) {
    if (ultimateMeter < ultimateMaxMeter) {
      ultimateMeter += inc;
    }
  }
  
  void fireUlt() {
    playerUlt.shoot(this.state);
    ultimateMeter = 0;
  }

  void checkProjectiles() {
    /* Checks if projectile hit something */
    for (int i = 0; i < playerBullets.size(); i++) {
      Bullet currBullet = playerBullets.get(i);
      
      // Regular enemies
      for (int j = 0; j < gameManager.enemies.size(); j++) {
        Enemy currEnemy = gameManager.enemies.get(j);
        
        // Check if player states matches enemies
        if (currBullet.hit(currEnemy)) {
          
          // if same state => regular bullet power
          if (currEnemy.getState() == currBullet.getState()) {
            currEnemy.decreaseHealth(currBullet.power); 
            
            gameManager.screenShakeTimer = 2;
            currEnemy.pos.y -= 2.5;
          }   
          // If not same state => double bullet power & increase ult
          if (currEnemy.getState() != currBullet.getState()) {
            currEnemy.decreaseHealth(currBullet.power * 2); 
            addToUlt(currEnemy.getUltValue());
            gameManager.screenShakeTimer = 3;
            currEnemy.pos.y -= 5;
          }
          
          // Subtracts durability
          currBullet.durability--;
          
          // Removes self if no more durability
          if (!currBullet.hasDurability()) {
            currBullet.removeSelf(playerBullets); 
          }            
        }
      }  
    } 
  }
  
  void switchState() {
    // Swaps states
    this.switchCooldown = 0;
    this.setState((state == "BLUE" ? "RED" : "BLUE"));
  }
  
  String getState() {
    return this.state;
  }
  
  void setState(String newState) {
    this.state = newState;
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
    
    // Updates main body
    PShape mainBody = shipShape.getChild(gameManager.playerShipParts.get("MainBody"));    
    mainBody.setFill(stateColour); 
    
    // Updates secondary parts
    color secondaryFill = (state == "BLUE" ? blueGray : orange);
    
    PShape leftWing = shipShape.getChild(gameManager.playerShipParts.get("LeftWing"));    
    leftWing.setFill(secondaryFill); 
    PShape rightWing = shipShape.getChild(gameManager.playerShipParts.get("RightWing"));    
    rightWing.setFill(secondaryFill); 
    PShape tailFlap = shipShape.getChild(gameManager.playerShipParts.get("TailFlap"));  
    tailFlap.setFill(secondaryFill);
  }
  
  void breakPart(String partName) {
    // breaks specific part
    float x = (float) random(-2, 2);
    float y = (float) random(-1, -2);
    
    // Copies player position vector
    PVector tempPos = new PVector();
    
    // Copies last bullet hit or else last death coords
    if (gameManager.lastHitBullet.size() > 0) {
      tempPos = gameManager.lastHitBullet.get(0).pos.copy();
    }
    else if (gameManager.lastHitEnemy.size() > 0) {
      tempPos = gameManager.lastHitEnemy.get(0).pos.copy();
    }
    else {
      tempPos = this.pos.copy();
    }
    
    // Creates broken parts at copied vector
    PShape brokenPart = shipShape.getChild(gameManager.playerShipParts.get(partName));
    gameManager.parts.add(new Part(tempPos, new PVector(x, y), 160, brokenPart, this.scaleFactor, PI/20, 1000));
  }
  
  void displayArc() {
    // Displays switch arc
    float angle = map(switchCooldown, 0, switchThreshold, 0, TWO_PI);
    fill(this.stateColour);
    arc(0, 0, 500, 500, 0, angle);
    fill(0);
    ellipse(0, 0, 440, 440);
  }
  
  void drawMe() {
    // Jitter
    float jitter = (float) random(-5, 5);
      
    // Draws characters
    push();
    translate(pos.x, pos.y);
    scale(scaleFactor);

    // draw arc
    displayArc();

    // Draws thrusters
    push();
    rotate(rotateFactor);
    stroke(this.stateColour);
    fill(255);
    ellipse(-125, 150, 30 + jitter, 80 + jitter);
    ellipse(125, 150, 30 + jitter, 80 + jitter);
    pop();
    
    // Draws ship
    push();
    shapeMode(CENTER);
    rotate(rotateFactor);
    translate(-size.x * 1.95, -size.y * 1.95);
    shape(shipShape);
    pop();
    
    push();
    scale(1);
    // Bounding radial
    if (debug.active) {
      fill(0, 255, 0);
      ellipse(0, 0, size.x, size.y);
    }
    pop();
    pop();
  }  
  
  void drawDeath() {
    // Draws death animation
    
    // Creates destroyed parts
    for (String name : gameManager.playerShipParts.keySet()) {
      breakPart(name);
    }
  }
  
  void initShipShape() {
    // Populates shipShape group with drawing shapes
    strokeWeight(4);
    fill(steelGray);
  
    // Left gun - main (1)
    PShape leftMainGun = createShape();
    leftMainGun.beginShape();
    leftMainGun.fill(steelGray);
    leftMainGun.vertex(75, 125);
    leftMainGun.vertex(100, 125);
    leftMainGun.vertex(100, 225);
    leftMainGun.vertex(75, 225);
    leftMainGun.endShape(CLOSE);
    shipShape.addChild(leftMainGun);
    
    // left gun - sub (2)
    PShape leftGunSub = createShape();
    leftGunSub.beginShape();
    fill(steelGray);
    leftGunSub.vertex(25, 175);
    leftGunSub.vertex(50, 175);
    leftGunSub.vertex(50, 225);
    leftGunSub.vertex(25, 225);
    leftGunSub.endShape(CLOSE);
    shipShape.addChild(leftGunSub);
    
    // right gun - main (3)
    PShape rightGunMain = createShape();
    rightGunMain.beginShape();
    rightGunMain.fill(steelGray);
    rightGunMain.vertex(300, 125);
    rightGunMain.vertex(325, 125);
    rightGunMain.vertex(325, 225);
    rightGunMain.vertex(300, 225);
    rightGunMain.endShape(CLOSE);
    shipShape.addChild(rightGunMain);
    
    // right gun - sub (4)
    PShape rightGunSub = createShape();
    rightGunSub.beginShape();
    rightGunSub.fill(steelGray);
    rightGunSub.vertex(350, 175);
    rightGunSub.vertex(375, 175);
    rightGunSub.vertex(375, 225);
    rightGunSub.vertex(350, 225);
    rightGunSub.endShape(CLOSE);
    shipShape.addChild(rightGunSub);
    
    // Left thruster - main (5)
    PShape leftThrusterMain = createShape();
    leftThrusterMain.beginShape();
    leftThrusterMain.fill(blueGray);
    leftThrusterMain.vertex(50, 275);
    leftThrusterMain.vertex(100, 275);
    leftThrusterMain.vertex(100, 325);
    leftThrusterMain.vertex(50, 300);
    leftThrusterMain.endShape(CLOSE);
    shipShape.addChild(leftThrusterMain);
    
    // Left thrust - exhaust (6)
    PShape leftThrustExhaust = createShape();
    leftThrustExhaust.beginShape();
    leftThrustExhaust.fill(steelGray);
    leftThrustExhaust.vertex(50, 275);
    leftThrustExhaust.vertex(100, 300);
    leftThrustExhaust.vertex(100, 325);
    leftThrustExhaust.vertex(50, 300);
    leftThrustExhaust.endShape(CLOSE);
    shipShape.addChild(leftThrustExhaust);
    
    // right thruster - main (7)
    PShape rightThrusterMain = createShape();
    rightThrusterMain.beginShape();
    rightThrusterMain.fill(blueGray);
    rightThrusterMain.vertex(300, 275);
    rightThrusterMain.vertex(350, 275);
    rightThrusterMain.vertex(350, 300);
    rightThrusterMain.vertex(300, 325);
    rightThrusterMain.endShape(CLOSE);
    shipShape.addChild(rightThrusterMain);
    
    // right thruster - exhaust (8)
    PShape rightThrusterExhaust = createShape();
    rightThrusterExhaust.beginShape();
    rightThrusterExhaust.fill(steelGray);
    rightThrusterExhaust.vertex(300, 300);
    rightThrusterExhaust.vertex(350, 275);
    rightThrusterExhaust.vertex(350, 300);
    rightThrusterExhaust.vertex(300, 325);
    rightThrusterExhaust.endShape();
    shipShape.addChild(rightThrusterExhaust);
  
    // Tail flap (9)
    PShape tailFlap = createShape();
    tailFlap.beginShape();
    tailFlap.fill(blueGray);
    tailFlap.vertex(200, 350);
    tailFlap.vertex(150, 325);
    tailFlap.vertex(150, 300);
    tailFlap.vertex(200, 325);
    tailFlap.vertex(250, 300);
    tailFlap.vertex(250, 325);
    tailFlap.endShape(CLOSE);
    shipShape.addChild(tailFlap);
    
    // Main Body (10)
    PShape mainBody = createShape();
    mainBody.beginShape();
    mainBody.fill(blue);
    mainBody.vertex(200, 0);
    mainBody.vertex(250, 125);
    mainBody.vertex(250, 212.5);
    mainBody.vertex(400, 212.5);
    mainBody.vertex(400, 250);
    mainBody.vertex(225, 300);
    mainBody.vertex(200, 400);
    mainBody.vertex(175, 300);
    mainBody.vertex(0, 250);
    mainBody.vertex(0, 212.5);
    mainBody.vertex(150, 212.5);
    mainBody.vertex(150, 125);
    mainBody.endShape(CLOSE);
    shipShape.addChild(mainBody);
    
    // Left Wing (11)
    PShape leftWing = createShape();
    leftWing.beginShape();
    leftWing.fill(blueGray);
    leftWing.vertex(50, 212.5);
    leftWing.vertex(125, 212.5);
    leftWing.vertex(125, 300);
    leftWing.vertex(50, 275);
    leftWing.endShape(CLOSE);
    shipShape.addChild(leftWing);
    
    // Right Wing (12)
    PShape rightWing = createShape();
    rightWing.beginShape();
    rightWing.fill(blueGray);
    rightWing.vertex(275, 212.5);
    rightWing.vertex(350, 212.5);
    rightWing.vertex(350, 275);
    rightWing.vertex(275, 300);
    rightWing.endShape(CLOSE);
    shipShape.addChild(rightWing);
    
    // Closing lines (13) & (14)
    PShape closingLeftLine = createShape();
    closingLeftLine.beginShape();
    closingLeftLine.vertex(150, 212.5);
    closingLeftLine.vertex(175, 300);
    closingLeftLine.endShape();
    shipShape.addChild(closingLeftLine);
    
    PShape closingRightLine = createShape();
    closingRightLine.beginShape();
    closingRightLine.vertex(250, 212.5);
    closingRightLine.vertex(225, 300);
    closingRightLine.endShape();
    shipShape.addChild(closingRightLine);
      
    // Main Window (15)
    PShape mainWindow = createShape();
    mainWindow.beginShape();
    mainWindow.fill(orange);
    mainWindow.vertex(200, 195);
    mainWindow.vertex(225, 220);
    mainWindow.vertex(225, 245);
    mainWindow.vertex(200, 295);
    mainWindow.vertex(175, 245);
    mainWindow.vertex(175, 220);
    mainWindow.endShape(CLOSE);
    shipShape.addChild(mainWindow);
    
    // Left Horn (16)
    PShape leftHorn = createShape();
    leftHorn.beginShape();
    leftHorn.fill(orange);
    leftHorn.vertex(150, 50);
    leftHorn.vertex(100, 100);
    leftHorn.vertex(150, 175);
    leftHorn.vertex(150, 125);
    leftHorn.vertex(125, 100);
    leftHorn.endShape(CLOSE);
    shipShape.addChild(leftHorn);
    
    // Left triangle horn (17)
    PShape leftTriHorn = createShape();
    leftTriHorn.beginShape();
    leftTriHorn.fill(orange);
    leftTriHorn.vertex(150, 175);
    leftTriHorn.vertex(100, 212.5);
    leftTriHorn.vertex(150, 212.5);
    leftTriHorn.endShape(CLOSE);
    shipShape.addChild(leftTriHorn);
    
    // Right Horn (18)
    PShape rightHorn = createShape();
    rightHorn.beginShape();
    rightHorn.fill(orange);
    rightHorn.vertex(250, 50);
    rightHorn.vertex(300, 100);
    rightHorn.vertex(250, 175);
    rightHorn.vertex(250, 125);
    rightHorn.vertex(275, 100);
    rightHorn.endShape(CLOSE);
    shipShape.addChild(rightHorn);
    
    // Right triangle horn (19)
    PShape rightTriHorn = createShape();
    rightTriHorn.beginShape();
    rightTriHorn.fill(orange);
    rightTriHorn.vertex(250, 175);
    rightTriHorn.vertex(300, 212.5);
    rightTriHorn.vertex(250, 212.5);
    rightTriHorn.endShape(CLOSE);
    shipShape.addChild(rightTriHorn);
  
    // Tail Wing line (20)
    PShape tailWingLine = createShape();
    tailWingLine.beginShape();
    tailWingLine.stroke(0);
    tailWingLine.vertex(200, 300);
    tailWingLine.vertex(200, 350);
    tailWingLine.endShape();
    shipShape.addChild(tailWingLine);
    
    // Ship nose bridge line details (21)
    PShape noseBridge = createShape();
    noseBridge.beginShape();
    noseBridge.stroke(0);
    noseBridge.noFill();
    
    noseBridge.vertex(150, 175);  // Left
    noseBridge.vertex(175, 125);
    noseBridge.vertex(175, 125);
    noseBridge.vertex(200, 0);
    
    noseBridge.vertex(200, 0);  // Right
    noseBridge.vertex(225, 125);
    noseBridge.vertex(225, 125);
    noseBridge.vertex(250, 175);
    
    noseBridge.endShape();
    shipShape.addChild(noseBridge);
  }
}
