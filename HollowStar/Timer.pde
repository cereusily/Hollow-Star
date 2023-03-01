class Timer {
  // Class that manages a timer
  
  int startTime;
  int passedTime;
  boolean isActive;
  
  // Constructor
  Timer() {
    isActive = false;
    passedTime = 0;
  }
  
  // Gets current time
  int getCurrentTime() {
    return isActive ? (millis() - startTime) : passedTime;
  }
  
  // Starts timer
  void begin() {
    isActive = true;
    startTime = millis();
  }
  
  // Calls start again to reset
  void reset() {
    begin();
  }
  
  // Keeps track of passed time
  void pause() {
    if (isActive) {
      passedTime = millis() - startTime;
      isActive = false;
    }
  }
  
  // Is called after stop to keep track
  void keepRunning() {
    if (!isActive) {
      startTime = millis() - passedTime;
      isActive = true;
    }
  }
}
