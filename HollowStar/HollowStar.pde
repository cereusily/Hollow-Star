color silver = color(238,238,238);
color steelGray = color(113, 121, 126);
color blueGray = color(102, 153, 204);
color orange = color(252, 163, 17);
color blue = color(4, 118, 208);
color red = color (255, 100, 90);
color black = color(0, 0, 0);
color green = color(144, 238, 144);
  
Player player;

// Game manager
GameManager gameManager = new GameManager();

// Scene manager
SceneManager sceneManager = new SceneManager();

// Debug tool + cheats inside
Debug debug = new Debug(false);


void setup() {
  
  // Sets up window & background
  fullScreen();
  background(0);

  // Init assest from GameManager;
  gameManager.initAssets();
}

void draw() {
  // no cursor
  noCursor();
  
  // Displays menu and runs game once menu is closed
  if (gameManager.menuOn) {    
    gameManager.displayMenu();
  }
  else if (!gameManager.gameStart) {
    gameManager.restart();
    gameManager.gameStart = true;
  }
  else {
    // Runs game
    runGame();
    
    // Plays intro scene
    if (!sceneManager.tutorialSceneOver) {
      sceneManager.playTutorialScene();
    }
    else if (!sceneManager.introSceneOver && sceneManager.tutorialSceneOver) {
      sceneManager.playIntroScene();
    }  
    else {} // do nothing
  }
}

void runGame() {
  /* Runs main game loop */
  if (gameManager.isActive) {

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
      
      // Win condition
      if (gameManager.waveNum >= gameManager.finalWaveNum) {
        // Updates stars state
        gameManager.updateStars();
        
        // Updates enemies state
        gameManager.updateEnemies();
        
        // Boss dead scene
        if (gameManager.enemies.size() == 0 && gameManager.bossDead) {  // If all enemies are dead and the boss spawned
          sceneManager.bossDeathSceneOver = false;
          sceneManager.playBossDeathScene();
        }
        if (sceneManager.bossDeathSceneOver && sceneManager.finalSceneOver) {
          gameManager.displayEndGame();
        }
      }
      
      else {
        // Everything else
        // Will freeze game if player dies
        if (player.isAlive()) {
          // Updates stars state
          gameManager.updateStars();
          
          // Updates enemies state
          gameManager.updateEnemies();
          
          // Updates wave time
          gameManager.updateWaveTime();
  
          
          // Respawns fleet if wave is ongoing
          if (sceneManager.introSceneOver && !gameManager.waveOver && sceneManager.tutorialSceneOver) {
            gameManager.respawnFleet();
          }
          
          // if wave over & no more enemies, spawn boss
          else {
            if (sceneManager.introSceneOver) {
              if (gameManager.enemies.size() == 0 && !sceneManager.bossSceneOver) {
                sceneManager.playBossScene();  // Plays boss scene
              }
        
              else if (gameManager.enemies.size() == 0 && !gameManager.bossSpawned) {
                gameManager.addBossEnemy();  // Waits until all enemies are gone
                gameManager.bossSpawned = true;  // Toggles off boss spawned
              }
              
              else if (gameManager.enemies.size() == 0 && gameManager.bossDead) {  // If all enemies are dead and the boss spawned
                sceneManager.playBossDeathScene();
              }
              else {}  // Do nothing
            }
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
            gameManager.waveMaxTime = gameManager.waveInitTime;
          }
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
