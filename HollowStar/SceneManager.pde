class SceneManager {
  /* Class that manages the cutscenes */
  Timer timer;
  boolean timerStarted;
  boolean introSceneOver = false;
  boolean bossSceneOver = false;
  boolean bossDeathSceneOver  = false;
  
  String lineOne;
  String lineTwo;
  String lineThree;
  
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
        lineOne = "WARNING! NEW ANOMALY DETECTED";
        lineTwo = "HOLLOW STAR DETECTED.";
        lineThree = "COMPLETE YOUR OBJECTIVE.";
        break;
      case 1:
        lineOne = "WARNING! ANOMALY DETECTED";
        lineTwo = "UPGRADED HOLLOW STAR DETECTED";
        lineThree = "COMPLETE YOUR OBJECTIVE";
        break;
      default:
        lineOne = "WARNING WARNING WARNING";
        lineTwo = "HOLLOW STAR UPGRADES CONTINUES";
        lineThree = "COMPLETE YOUR OBJECTIVE";
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
    fill(red);
    rectMode(CENTER);
    rect(width/2, height/2 - 20, width, 80);
        
    // Text settings
    setText();
    
    // Plays first line
    if (timer.getCurrentTime() < 2_000) {
      text("WARNING! ADDITIONAL ANOMALIES DETECTED", width/2, height/2);
    }
    else if (timer.getCurrentTime() < 4_500) {
      text("MULTIPLE HOLLOW STARS DETECTED.", width/2, height/2);
    }
    else if (timer.getCurrentTime() < 6_500) {
      text("CONTINUE YOUR OBJECTIVE.", width/2, height/2);
    }
    else {
      bossDeathSceneOver = true;
      timerStarted = false;
      gameManager.bossSpawned = false;
      bossDead = false;
      gameManager.resetWaveTime();
      timer.reset();
    }
    pop();
    
  }
}
