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
int restartTime = 150;


boolean isActive;
boolean gameOver;
boolean gameStart = false;
boolean bossDead = false;

boolean menuOn;

ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Part> parts = new ArrayList<Part>();
ArrayList<Bullet> lastHitBullet = new ArrayList<Bullet>();
ArrayList<Enemy> lastHitEnemy = new ArrayList<Enemy>();

HashMap<String, Integer> playerShipParts = new HashMap<String, Integer>();
HashMap<String, Integer> enemyShipParts = new HashMap<String, Integer>();

// Game manager
GameManager gameManager = new GameManager();

// Scene manager
SceneManager sceneManager = new SceneManager();

// Debug tool + cheats inside
Debug debug = new Debug(false);


void setup() {
  
  // Sets up window & background
  size(1200, 800);
  background(0);
  
  // Init assest from GameManager;
  gameManager.initAssets();
}

void draw() {
  // Displays menu and runs game once menu is closed
  if (menuOn) {
    gameManager.displayMenu();
  }
  else if (!gameStart) {
    gameManager.restart();
    gameStart = true;
  }
  else {
    // Runs game
    runGame();
    
    // Plays intro scene
    if (!sceneManager.introSceneOver) {
      sceneManager.playIntroScene();
    }  
  }
}

void runGame() {
  /* Runs main game loop */
  if (isActive) {

      push();

      // Clears screen
      background(0);
      
      // Checks screen shake
      gameManager.updateScreenShake();

// <===== General Wave Loop =====> //

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
        
        // Updates wave time
        gameManager.updateWaveTime();
        
        // Respawns fleet if wave is ongoing
        if (!gameManager.waveOver) {
          gameManager.respawnFleet();
        }
        
        // if wave over & no more enemies, spawn boss
        else {
          if (enemies.size() == 0 && !sceneManager.bossSceneOver) {
            sceneManager.playBossScene();  // Plays boss scene
          }
      
          else if (enemies.size() == 0 && !gameManager.bossSpawned) {
            gameManager.addBossEnemy();  // Waits until all enemies are gone
            gameManager.bossSpawned = true;  // Toggles off boss spawned
          }
          
          else if (enemies.size() == 0 && bossDead) {  // If all enemies are dead and the boss spawned
            sceneManager.playBossDeathScene();
          }
          else {}  // Do nothing
        }
      }
      
      else { // Player no longer alive
        if (gameManager.lives > 0) {  // => if have lives, respawn
          // => reset game
          
          // Draws the last bullet hit
          gameManager.drawLastHit();
          
          // Updates player death
          gameManager.updatePlayerDeath();
        }
        else {  // If no more lives, displays game over
          gameManager.displayGameOver();
        }
      }
      
      // Updates parts state
      gameManager.updateParts();
      
      // Updates player bullets state
      gameManager.updatePlayerBullets();
      
      // Updates screen with changes
      updateScreen(); 
    
      pop();
    }

  // Debug
  debug.updateDebug();
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
  
  // display HUD text
  gameManager.displayText();
  
  // Displays ul meter
  gameManager.displayUltMeter();
}
