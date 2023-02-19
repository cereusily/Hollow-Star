class Bullet {
  /* Class to manage bullets fired */
  
  PVector pos;
  PVector vel;
  
  float bulletSpeed = 1.0;
  int bulletWidth = 10;
  int bulletHeight = 30;
  color bulletOuterColour = color(255, 0, 0);
  color bulletInnerColour = color(255);
  
  Bullet(PVector initPos, PVector initVel) {
    this.pos = initPos;
    this.vel = initVel;
  }
  
  void update() {
    move();
  }
  
  void move() {
    pos.add(vel);
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
    fill(bulletInnerColour);
    stroke(bulletOuterColour);
    strokeWeight(1);
    ellipse(0, 0, bulletWidth, bulletHeight);
    pop();
  }
}
