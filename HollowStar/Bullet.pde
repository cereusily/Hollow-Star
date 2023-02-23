class Bullet {
  /* Class to manage bullets fired */
  
  PVector pos;
  PVector vel;
  
  float bulletSpeed = 1.0;
  int bulletWidth;
  int bulletHeight;
  color bulletOuterColour;
  color bulletInnerColour;
  
  String state = "BLUE";
  color stateColour;
  
  Bullet(PVector initPos, PVector initVel, int bWidth, int bHeight) {
    pos = initPos;
    vel = initVel;
   
    bulletWidth = bWidth;
    bulletHeight = bHeight;
    
    bulletInnerColour = color(255);
  }
  
  void update() {
    move();
    updateBulletColour();
  }
  
  void updateBulletColour() {
    // Updates ship color to state color
    switch(state){
      case "BLUE":
        stateColour = blue;
        break;
      case "RED":
        stateColour = red;
        break;
    } 
    bulletOuterColour = stateColour; 
  }
  
  void move() {
    pos.add(vel);
  }
  
  void setState(String newState) {
    this.state = newState;
  }
  
  String getState() {
    return this.state;
  }
  
  boolean offScreen() {
    /* Checks if bullet is offscreen */
    return 
    ((pos.x < -bulletWidth/2) || (pos.x > width + bulletWidth/2) ||
    (pos.y < -bulletHeight/2) || (pos.y > height + bulletHeight/2));
  }
  
  void removeSelf() {
    player.playerBullets.remove(this);
  }

  void drawMe() {
    push();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    strokeWeight(2);
    fill(bulletInnerColour);
    stroke(bulletOuterColour);
    ellipse(0, 0, bulletWidth, bulletHeight);
    pop();
  }
}
