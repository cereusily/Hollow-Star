color silver = color(238,238,238);
color steelGray = color(113, 121, 126);
color blueGray = color(102, 153, 204);
color orange = color(252, 163, 17);
color blue = color(120, 133, 161);

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
  
int shipWidth = 400;
Player player;
Enemy enemyOne;

int enemyWidth = 100;
int numEnemies = 10;

ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

void debug() {
  println(player.playerBullets.size());
}

void setup() {
  
  // Sets up window & background
  size(1200, 1200);
  background(0);

  // Initializes player & inits PShape group
  player = new Player(new PVector(width/2.25, height/1.5), new PVector(), 3, 160, 160, 0.2);
  player.initShipShape();
  
  // Initializes enemies
  for (int i = 0; i < numEnemies; i++) {
    addNewEnemy();
  }
}

void draw() {
  /* Runs main game loop */
  checkEvents();
  
  // Updates player movements
  player.update();
  
  // Updates player bullets
  for (int i = 0; i < player.playerBullets.size(); i++) {
    Bullet currPlayerBullet = player.playerBullets.get(i);
    
    currPlayerBullet.update();
    
    // Removes bullets if offscreen
    if (currPlayerBullet.offScreen()) {
      player.playerBullets.remove(i);
    }
  }
  
  // Updates star sprites
  for (int i = 0; i < stars.size(); i++) {
    Star currStar = stars.get(i);
    
    currStar.update();
    
    // Removes stars if offscreen
    if (currStar.offScreen()) {
      stars.remove(i);
    }
  }
  
  // Updates enemy sprites
  for (int i = 0; i < enemies.size(); i++) {
    Enemy currEnemy = enemies.get(i);
    
    currEnemy.update();
    
    // Removes stars if offscreen
    if (currEnemy.offScreen()) {
      enemies.remove(i);
    }
  }
  
  // Updates screen with changes
  updateScreen();
  
  // Debug
  debug();
}

// Stores states for keys
void keyPressed() {
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
    }
    if (keyCode == RIGHT) {
      moveRight = true;
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

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      moveUp = false;
    }
    if (keyCode == DOWN) {
      moveDown = false;
    }
    if (keyCode == LEFT) {
      moveLeft = false;
    }
    if (keyCode == RIGHT) {
      moveRight = false;
    }
  }
  // Player bullets
  if (key == ' ') {
    holdFire = false;
  }
}

void fireBullet() {
  /* Creates new bullet and adds to playerBullet list */ // -> +/-35 for outer guns
  Bullet newBulletLeft = new Bullet(new PVector(player.pos.x - 22, player.pos.y), new PVector(0, -10));
  Bullet newBulletRight = new Bullet(new PVector(player.pos.x + 22, player.pos.y), new PVector(0, -10));
  
  player.playerBullets.add(newBulletLeft);
  player.playerBullets.add(newBulletRight);
}

void bulletCoolDown() {
  /* Checks bullet cool down time */
  int passedCoolDownTime = millis() - bulletCoolDownStartTime;
  
  if (passedCoolDownTime > bulletCoolDownTime) {
    fireBullet();
    bulletCoolDownStartTime = millis();
  }
}

void addStar() {
  /* Creates new star to star array */
  int x = (int) random(0, width);  // => spawn star at random x axis
  int starSpeed = (int) random(0, starMaxSpeed);
  
  Star newStar = new Star(new PVector(x, 0), new PVector(0, starSpeed));
  stars.add(newStar);
}

void starCoolDown() {
  /* Checks star cool down time */
  int passedCoolDownTime = millis() - starCoolDownStartTime;
  
  if (passedCoolDownTime > starCoolDownTime) {
    addStar();
    starCoolDownStartTime = millis();
  }
}

void addNewEnemy() {
  // Adds new enemy
  int bx = (int) random(enemyWidth/2, width - enemyWidth/2);
  
  enemies.add(new Enemy(new PVector(bx, 0), new PVector(0, 2), 3, enemyWidth, enemyWidth, 1));
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
    bulletCoolDown();
  }
}

void updateScreen() {
  /* Updates sprites and background on screen */
  background(0);
  
  // Adds stars
  starCoolDown();
  
  // Updates player bullet sprites
  for (int i = 0; i < player.playerBullets.size(); i++) {
    Bullet currPlayerBullet = player.playerBullets.get(i);
    currPlayerBullet.drawMe();
  }
  
  // Updates star sprites
  for (int i = 0; i < stars.size(); i++) {
    Star currStar = stars.get(i);
    currStar.drawMe();
  }
    
  // Update player sprites
  player.drawMe();
  
  // Updates enemy sprites
  for (int i = 0; i < enemies.size(); i++) {
    Enemy currEnemy = enemies.get(i);
    currEnemy.drawMe();
  }
}
