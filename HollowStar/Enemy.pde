class Enemy extends Character {
  
  /* Class that manages enemy objects */
  
  int enemyPower = 1;
  int partRemoveTimer = 80;
  color enemyColour = color(0, 255, 0);
  PShape shipShape;
  
  int deathTimer = -1;
  int deathAnimationTime = 5;
  int points;
  int screenShakeValue;
  
  String state;
  color stateColour;
  String enemyType;
  
  int ultValue = 5;
  
  
  Enemy(PVector pos, PVector vel, int health, PVector size, float scaleFactor, String state, String enemyType) {
    // Inits fields
    super(pos, vel, health, size, scaleFactor);
    
    this.state = state;
    this.enemyType = enemyType;
    
    // Create group
    shipShape = createShape(GROUP);
    
    // Draws ship
    initShipShape();
    
    // Updates colour states;
    updateShipColour();
    
    // Initializes colour
    initShipColour();
    
    // Checks what type of basic enemy
    switch(enemyType) {
      case "ELITE":
        this.points = 300;
        this.screenShakeValue = 40;
        break;
      default:
        this.points = 100;
        this.screenShakeValue = 15;
        break;
    }
  }
  
  void update() {
    // Updates from parent class
    super.update();
    
    // Checks health
    checkHealth();
    
    // Death timer
    if (deathTimer > 0) {
      deathTimer--;
    }
    
    if (deathTimer == 0) {
      drawDeath();
      gameManager.score += this.points;
      gameManager.enemies.remove(this);
    }
    
    // Checks if touched player
    if (hitCharacter(player)) {
      gameManager.lastHitEnemy.add(this);
      player.decreaseHealth(enemyPower);
      gameManager.screenShakeTimer = screenShakeValue;
    }
  }
  
  void checkHealth() {
    // Checks health & changes colour depending on damage
    if (health < 0) {
      
      if (isAlive()) {      
        deathTimer = deathAnimationTime;
        this.vel = new PVector(0, 0);
      }
    }
  }
  
  boolean isAlive() {
    return deathTimer == -1;
  }
  
  boolean offScreen() {
    /* Checks if enemy is offscreen */
    return 
    ((pos.x < -size.x/2) || (pos.x > width + size.x/2) ||
    (pos.y < -size.y/2) || (pos.y > height + size.y/2));
  }
  
  String getState() {
    return this.state;
  }
  
  void setState(String newState) {
    this.state = newState;
  }
  
  int getUltValue() {
    return this.ultValue;
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
    initShipColour(); 
  }
  
  void drawMe() {
    // Draws self
    push();
    
    translate(pos.x, pos.y);
    
   // Bounding radial
   if (debug.active && debug.showHitbox) {
     fill(enemyColour);
     ellipse(0, 0, size.x, size.y);
   }
  
    push();
    translate(-size.x + size.x/6, -size.y + size.y/10);
    scale(scaleFactor);
    shape(shipShape);  
    pop();
    
    pop();
  }
  
  void breakPart(String partName) {
    // breaks specific part
    float x = (float) random(-2, 2);
    float y = (float) random(-1, -2);
    
    PVector tempPos = new PVector();
    tempPos = this.pos.copy();
    
    PShape brokenPart = shipShape.getChild(gameManager.enemyShipParts.get(partName));
    gameManager.parts.add(new Part(tempPos, new PVector(x, y), 80, brokenPart, this.scaleFactor * 0.5, PI/20, partRemoveTimer));
  }
  
  void drawDeath() {    
    for (String name : gameManager.enemyShipParts.keySet()){
      breakPart(name);
    }
  }
  
  void initShipColour() {
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
  
  void initShipShape() {
    // Draws ship
    strokeWeight(4);
    stroke(0);
    fill(red);
    
    // Main body 0
    PShape mainBody = createShape();
    mainBody.beginShape();
    mainBody.fill(steelGray);
    mainBody.vertex(200, 0);
    mainBody.vertex(250, 75);
    mainBody.vertex(225, 200);
    mainBody.vertex(225, 300);
    mainBody.vertex(200, 400);
    mainBody.vertex(175, 300);
    mainBody.vertex(175, 200);
    mainBody.vertex(150, 75);
    mainBody.endShape(CLOSE);
    shipShape.addChild(mainBody);
    
    // Main window 1
    PShape mainWindow = createShape();
    mainWindow.beginShape();
    mainWindow.fill(red);
    mainWindow.vertex(175, 100);
    mainWindow.vertex(200, 125);
    mainWindow.vertex(225, 100);
    mainWindow.vertex(225, 125);
    mainWindow.vertex(200, 175);
    mainWindow.vertex(175, 125);
    mainWindow.endShape(CLOSE);
    shipShape.addChild(mainWindow);
    
    // Window roof 2
    PShape windowRoof = createShape();
    windowRoof.beginShape();
    windowRoof.fill(steelGray);
    windowRoof.vertex(200, 25);
    windowRoof.vertex(225, 75);
    windowRoof.vertex(225, 100);
    windowRoof.vertex(200, 125);
    windowRoof.vertex(175, 100);
    windowRoof.vertex(175, 75);
    windowRoof.endShape(CLOSE);
    shipShape.addChild(windowRoof);
    
    // Left inner wing 3
    PShape leftInnerWing = createShape();
    leftInnerWing.beginShape();
    leftInnerWing.vertex(100, 75);
    leftInnerWing.vertex(175, 200);
    leftInnerWing.vertex(175, 300);
    leftInnerWing.vertex(125, 200);
    leftInnerWing.endShape(CLOSE);
    shipShape.addChild(leftInnerWing);
    
    // Right inner wing 4
    PShape rightInnerWing = createShape();
    rightInnerWing.beginShape();
    rightInnerWing.vertex(225, 200);
    rightInnerWing.vertex(300, 75);
    rightInnerWing.vertex(275, 200);
    rightInnerWing.vertex(225, 300);
    rightInnerWing.endShape(CLOSE);
    shipShape.addChild(rightInnerWing);
    
    // Left wing bridge 5
    PShape leftWingBridge = createShape();
    leftWingBridge.beginShape();
    leftWingBridge.fill(steelGray);
    leftWingBridge.vertex(75, 175);
    leftWingBridge.vertex(125, 200);
    leftWingBridge.vertex(150, 250);
    leftWingBridge.vertex(125, 225);
    leftWingBridge.vertex(100, 250);
    leftWingBridge.endShape(CLOSE);
    shipShape.addChild(leftWingBridge);
    
    // left outer wing 6
    PShape leftOuterWing = createShape();
    leftOuterWing.beginShape();
    leftOuterWing.fill(red);
    leftOuterWing.vertex(50, 50);
    leftOuterWing.vertex(75, 175);
    leftOuterWing.vertex(100, 250);
    leftOuterWing.vertex(125, 350);
    leftOuterWing.vertex(25, 200);
    leftOuterWing.endShape(CLOSE);
    shipShape.addChild(leftOuterWing);
    
    // left outer flap 7
    PShape leftOuterFlap = createShape();
    leftOuterFlap.beginShape();
    leftOuterFlap.fill(steelGray);
    leftOuterFlap.vertex(50, 50);
    leftOuterFlap.vertex(25, 200);
    leftOuterFlap.vertex(125, 350);
    leftOuterFlap.vertex(0, 200);
    leftOuterFlap.endShape(CLOSE);
    shipShape.addChild(leftOuterFlap);
    
    // Right wing bridge 8
    PShape rightWingBridge = createShape();
    rightWingBridge.beginShape();
    rightWingBridge.fill(steelGray);
    rightWingBridge.vertex(275, 200);
    rightWingBridge.vertex(325, 175);
    rightWingBridge.vertex(300, 250);
    rightWingBridge.vertex(275, 225);
    rightWingBridge.vertex(250, 250);
    rightWingBridge.endShape(CLOSE);
    shipShape.addChild(rightWingBridge);
    
    // right outer wing 9
    PShape rightOuterWing = createShape();
    rightOuterWing.beginShape();
    rightOuterWing.vertex(350, 50);
    rightOuterWing.vertex(375, 200);
    rightOuterWing.vertex(275, 350);
    rightOuterWing.vertex(300, 250);
    rightOuterWing.vertex(325, 175);
    rightOuterWing.endShape(CLOSE);
    shipShape.addChild(rightOuterWing);
    
    // right outer flap 10
    PShape rightOuterFlap = createShape();
    rightOuterFlap.beginShape();
    rightOuterFlap.fill(steelGray);
    rightOuterFlap.vertex(350, 50);
    rightOuterFlap.vertex(400, 200);
    rightOuterFlap.vertex(275, 350);
    rightOuterFlap.vertex(375, 200);
    rightOuterFlap.endShape(CLOSE);
    shipShape.addChild(rightOuterFlap);
    
    // Adds nose details 11
    PShape noseDetails = createShape();
    noseDetails.beginShape();
    noseDetails.vertex(200, 175);
    noseDetails.vertex(200, 400);
    noseDetails.endShape();
    shipShape.addChild(noseDetails);
  }
}
