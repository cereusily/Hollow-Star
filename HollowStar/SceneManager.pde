class SceneManager {
  /* Class that manages the cutscenes */
  Timer timer;
  boolean timerStarted;
  boolean tutorialSceneOver = false;
  
  boolean tutorialEnemySpawned = false;
  boolean tutorialEnemyKilled = false;
  
  
  boolean introSceneOver = false;
  boolean bossSceneOver = false;
  boolean bossDeathSceneOver  = false;
  boolean finalSceneOver = false;
  
  String lineOne;
  String lineTwo;
  String lineThree;
  String lineFour;
  
  SceneManager() {
    // Creates new timer to manage timing
    timer = new Timer();
  }
  
  void setText() {
    /* Function that sets text */
    textSize(48);
    fill(255);
    textAlign(CENTER);
  }
  
  void playTutorialScene() {
    /* Plays tutorial scene when called */
    push();
    
    // text settings
    setText();
    
    if (!timerStarted) {
      timer.begin();
      timerStarted = true;
    }
    
    if (timer.getCurrentTime() < 2_000) {
      text("PRESS SPACE BAR TO FIRE.", width/2, height/2); 
    }
    else if (timer.getCurrentTime() < 5_500) {
      text("WASD/ARROW KEYS TO MOVE.", width/2, height/2); 
    }
    else if (timer.getCurrentTime() < 10_500) {
      if (gameManager.players.size() > 0) {
        Player player = gameManager.players.get(0);
        
        // Give player ultimate
        player.ultimateMeter = player.ultimateMaxMeter;
      }
      text("PRESS X TO FIRE ULTIMATE.", width/2, height/2); 
    }
    else if (timer.getCurrentTime() < 15_000) {
      // shift key explanation
      text("PRESS SHIFT TO SHIFT POLARITY.", width/2, height/2); 
      player.ultimateMeter = 0;
    }
    else if (timer.getCurrentTime() < 17_500) {
      // shift key explanation
      text("OPPOSITE POLARITIES DEAL ADDITIONAL DAMAGE.", width/2, height/2); 
    }
    else if (timer.getCurrentTime() < 19_500) {
      text("YOU ABSORB MATCHING POLARITY BULLETS.", width/2, height/2); 
    }
    else if (timer.getCurrentTime() < 22_000) {
      text("COLLISIONS WILL STILL DESTROY YOUR SHIP.", width/2, height/2); 
    }
    else {
      tutorialSceneOver = true;
      timerStarted = false;
      timer.reset();
    }
    pop();
  }
  
  
  void playIntroScene() {
    /* Plays intro scene when called */
    push();
    
    // Text settings
    setText();
    
    // Starts timer
    if (!timerStarted) {
      timer.begin();
      timerStarted = true;
    }
    
    // Plays first line
    if (timer.getCurrentTime() < 2_000) {
      text("THE GALAXY IS IN DANGER", width/2, height/2); 
    }
    else if (timer.getCurrentTime() < 4_500) {
      text("MISSION: DESTROY THE HOLLOW STAR", width/2, height/2);
    }
    else {
      introSceneOver = true;
      timerStarted = false;
      timer.reset();
    }
    pop();
  }
  
  void playBossScene() {
    /* Plays boss scene */
    push();
    
    // Starts timer
    if (!timerStarted) {
      timer.begin();
      timerStarted = true;
    }
    fill(red);
    rectMode(CENTER);
    rect(width/2, height/2 - 20, width, 80);
        
    // Text settings
    setText();
    
    // Text
    switch (gameManager.waveNum) {
      case 0:
        lineOne = "WARNING! NEW ANOMALY DETECTED.";
        lineTwo = "HOLLOW STAR DETECTED. COMPLETE THE OBJECTIVE:";
        lineThree = "OBJECTIVE: DESTROY THE HOLLOW STAR.";
        break;
      case 1:
        lineOne = "WARNING! AN ANOMALY DETECTED.";
        lineTwo = "UPGRADED HOLLOW STAR DETECTED.";
        lineThree = "OBJECTIVE: DESTROY THE UPGRADED HOLLOW STAR.";
        break;
      case 2:
        lineOne = "WARNING! WARNING! WARNING!";
        lineTwo = "FINAL HOLLOW STAR DETECTED.";
        lineThree = "OBJECTIVE: DESTROY THE FINAL HOLLOW STAR.";
        break;
      default:
        lineOne = "WARNING WARNING WARNING";
        lineTwo = "HOLLOW STAR UPGRADES CONTINUES";
        lineThree = "COMPLETE THE OBJECTIVE.";
        break;
    }
    
    // Plays first line
    if (timer.getCurrentTime() < 2_000) {
      text(lineOne, width/2, height/2);
    }
    else if (timer.getCurrentTime() < 4_500) {
      text(lineTwo, width/2, height/2);
    }
    else if (timer.getCurrentTime() < 6_500) {
      text(lineThree, width/2, height/2);
    }
    else {
      bossSceneOver = true;
      timerStarted = false;
      timer.reset();
    }

    pop();
    
  }
  
  void playBossDeathScene() {
    /* Plays boss death */
    push();
    
    // Starts timer
    if (!timerStarted) {
      timer.begin();
      timerStarted = true;
    }
    fill(green);
    rectMode(CENTER);
    rect(width/2, height/2 - 20, width, 80);
        
    // Text settings
    setText();
    
    switch (gameManager.waveNum) {
      case 1:
        lineOne = "HOLLOW STAR DESTROYED. OBJECTIVE CLEARED.";
        lineTwo = "SCANNING FOR ANOMALIES...";
        lineThree = "UPDATE! MULTIPLE HOLLOW STARS DETECTED.";
        lineFour = "CONTINUE THE OBJECTIVE.";
        break;
      case 2:
        lineOne = "SECOND HOLLOW STAR DESTROYED.";
        lineTwo = "SCANNING FOR ANOMALIES...";
        lineThree = "UPDATE! FINAL HOLLOW STAR FOUND.";
        lineFour = "COMPLETE THE OBJECTIVE.";
        break;
      case 3:
        lineOne = "FINAL HOLLOW STAR DESTROYED.";
        lineTwo = "NO ADDITIONAL HOLLOW STARS DETECTED.";
        lineThree = "GALACTIC REGION SECURED.";
        lineFour = "OBJECTIVE COMPLETE.";
        finalSceneOver = true;
        break;
      default:
        lineOne = "HOLLOW STAR DESTROYED. OBJECTIVE CLEARED.";
        lineTwo = "WARNING! ADDITIONAL ANOMALIES DETECTED.";
        lineThree = "MULTIPLE HOLLOW STARS DETECTED.";
        lineFour = "CONTINUE THE OBJECTIVE.";
        break;
    }
    
    
    // Plays first line
    if (timer.getCurrentTime() < 2_000) {
      text(lineOne, width/2, height/2);
    }
    else if (timer.getCurrentTime() < 4_500) {
      text(lineTwo, width/2, height/2);
    }
    else if (timer.getCurrentTime() < 6_500) {
      text(lineThree, width/2, height/2);
    }
    else if (timer.getCurrentTime() < 8_500) {
      text(lineFour, width/2, height/2);
    }
    else {
      bossDeathSceneOver = true;
      timerStarted = false;
      gameManager.bossSpawned = false;
      gameManager.bossDead = false;
      gameManager.resetWaveTime();
      timer.reset();
    }
    pop();
    
  }
}
