

class Bullet {
  /* Class to manage bullets fired */
  
  PVector pos;
  PVector vel;
  PVector size;
  
  int power;

  color bulletOuterColour;
  color bulletInnerColour;
  int colourWeight = 2;
  
  String state = "BLUE";
  color stateColour;
  
  Bullet(PVector initPos, PVector initVel, PVector initSize) {
    pos = initPos;
    vel = initVel; 
    size = initSize;
    
    // Sets inner colour of bullet
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
  
  boolean hit(Character c) {
    return (abs(pos.x - c.pos.x) < size.x/2 + c.size.x/2 && abs(pos.y - c.pos.y) < size.y/2 + c.size.x/2);
  }
  
  String getState() {
    return this.state;
  }
  
  boolean offScreen() {
    /* Checks if bullet is offscreen */
    return 
    ((pos.x < -size.x/2) || (pos.x > width + size.x/2) ||
    (pos.y < -size.y/2) || (pos.y > height + size.y/2));
  }
  
  void removeSelf(ArrayList<Bullet> bulletArr) {
    bulletArr.remove(this);
  }

  void drawMe() {
    push();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    strokeWeight(colourWeight);
    fill(bulletInnerColour);
    stroke(bulletOuterColour);
    ellipse(0, 0, size.x, size.y);
    pop();
  }
}
