color silver = color(238,238,238);
color steelGray = color(113, 121, 126);
color blueGray = color(102, 153, 204);
color orange = color(252, 163, 17);
color blue = color(4, 118, 208);
color red = color (255, 100, 90);
  
int shipWidth = 100;
Player player;
Enemy enemyOne;

int enemyWidth = 80;
int numEnemies = 10;

float screenShake = 3;
float screenShakeTimer;
float screenJitter;
int timeSlow = 1;

int score;

float playerDeathTimer;

ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Bullet> explosionParticles = new ArrayList<Bullet>();
ArrayList<Part> parts = new ArrayList<Part>();

GameManager gameManager = new GameManager();

HashMap<String, Integer> playerShipParts = new HashMap<String, Integer>();
HashMap<String, Integer> enemyShipParts = new HashMap<String, Integer>();


void debug() {
  println(explosionParticles.size());
}

void displayText() {
  textFont(gameManager.font);
  textSize(30);
  fill(255);
  text("HI SCORE: " + str(score), 10, 50);
}

void setup() {
  
  // Sets up window & background
  size(1200, 1000);
  background(0);
  
  // Init assest from GameManager;
  gameManager.initAssets();
  
}

void draw() {
  /* Runs main game loop */
  push();
  
  // Calculates screen jitter
  if (screenShakeTimer > 0) {
    screenJitter = random(-screenShake, screenShake);
    translate(screenJitter, screenJitter);
    screenShakeTimer--;
  }
  
  // Checks for player input
  gameManager.checkEvents();
  
  // Updates player state
  gameManager.updatePlayer();
  
  // Updates player bullets state
  gameManager.updatePlayerBullets();
  
  // Will freeze game if player dies
  if (player.isAlive()) {
    // Updates stars state
    gameManager.updateStars();
    
    // Updates enemies state
    gameManager.updateEnemies();
    
    // Respawns fleet
    gameManager.respawnFleet();
  }
  
  // Updates parts state
  gameManager.updateParts();
  
  // Updates particles states
  gameManager.updateExplosionParticles();
  
  // Updates screen with changes
  updateScreen();

  // Debug
  gameManager.debug();

  pop();
}

// Stores states for keys
void keyPressed() {
  gameManager.checkKeyPressed();
}

void keyReleased() {
  gameManager.checkKeyReleased();
}

void updateScreen() {
  /* Updates sprites and background on screen */
  background(0);
  
  // Adds stars
  if (gameManager.starOffCoolDown()) {
    gameManager.addStar();
  };
  
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
  if (player.isAlive()) {
    player.drawMe();
  }
  
  // Updates enemy sprites
  for (int i = 0; i < enemies.size(); i++) {
    Enemy currEnemy = enemies.get(i);
    currEnemy.drawMe();
  }
  
  // Updates parts sprites
  if (parts != null) {
    for (int i = 0; i < parts.size(); i++) {
      Part currPart = parts.get(i);
      currPart.drawMe();
    }
  }
  
  // Updates explosion particles
  if (explosionParticles != null) {
    for (int i = 0; i < explosionParticles.size(); i++) {
      Bullet currParticle = explosionParticles.get(i);
      currParticle.drawMe();
    }
  }
    // display text
  displayText();
}
