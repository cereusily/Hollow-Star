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

float screenShake;
float screenShakeTimer;
float screenJitter;

int score;

int playerDeathTimer = -1;
int restartTime = 80;

boolean isActive;
boolean gameOver;

ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Part> parts = new ArrayList<Part>();

GameManager gameManager = new GameManager();

HashMap<String, Integer> playerShipParts = new HashMap<String, Integer>();
HashMap<String, Integer> enemyShipParts = new HashMap<String, Integer>();

Debug debug = new Debug(false);


void displayText() {
  textFont(gameManager.font);
  textSize(30);
  fill(255);
  text("HI SCORE: " + str(score), 20, 50);
  text("LIVES: " + str(gameManager.lives), width - 175, 50);
}

void setup() {
  
  // Sets up window & background
  size(1200, 800);
  background(0);
  
  // Init assest from GameManager;
  gameManager.initAssets();
  
}

void draw() {
  /* Runs main game loop */
  
  if (isActive) {
    push();
  
    // Clears screen
    background(0);
    
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
    
    // Will freeze game if player dies
    if (player.isAlive()) {
      // Updates stars state
      gameManager.updateStars();
      
      // Updates enemies state
      gameManager.updateEnemies();
      
      // Respawns fleet if wave is ongoing
      if (!gameManager.waveOver) {
        gameManager.respawnFleet();
      }
      // if wave over, spawn boss
      else {
        if (enemies.size() == 0 && !gameManager.bossSpawned) {
          gameManager.addBossEnemy();  // Waits until all enemies are gone
          gameManager.bossSpawned = true;  // Toggles off boss spawned
        }
      } 
    }
    else {
      // Player is dead; game over
      if (gameManager.lives > 0) {  // => if have lives, respawn
        // => reset game
        //gameManager.lives -= 1;
        
        if (playerDeathTimer == -1) {
          playerDeathTimer = restartTime;
        }
        
        if (playerDeathTimer > 0) {
          playerDeathTimer--;
        }
        
        if (playerDeathTimer == 0) {
          gameManager.lives -= 1;
          gameManager.restart();
        }
      }
      else {
        // => displays game over
        textAlign(CENTER);
        text("GAME OVER", width/2, 400);
        textSize(12);
        text("< PRESS ENTER/RETURN TO CONTINUE >", width/2, 450);
        textAlign(LEFT);
        gameOver = true;
      } 
    }
    
    // Updates parts state
    gameManager.updateParts();
    
    // Updates player bullets state
    gameManager.updatePlayerBullets();
    
    // Updates screen with changes
    updateScreen();
    
    // Debug
    debug.drawDebug();
  
    pop();
  }
}

// Stores states for keys
void keyPressed() {
  gameManager.checkKeyPressed();
}

void keyReleased() {
  gameManager.checkKeyReleased();
}

void updateScreen() {
  /* Updates miscellaneous sprites background on screen */
  
  // Adds stars
  if (gameManager.starOffCoolDown()) {
    gameManager.addStar();
  };
    
  // Update player sprites
  if (player.isAlive()) {
    player.drawMe();
  }
  
  // Updates wave time
  gameManager.updateWaveTime();
  
    // display text
  displayText();
  
  // Debug
  debug.updateDebug();
}
