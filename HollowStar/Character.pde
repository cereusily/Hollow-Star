

class Character {
  
  PVector pos;
  PVector vel;
  PVector size;
  
  int health;
  int charWidth;
  int charHeight;
  
  float scaleFactor;
  float rotateFactor;
  
  // Inits character
  Character(PVector pos, PVector vel, int health, PVector size, float scaleFactor) {
    this.pos = pos;
    this.vel = vel;
    this.health = health;
    this.size = size;
    this.scaleFactor = scaleFactor;
  }
  
  void update() {
    // updates characters' movement & collision
    move();
    checkCollide();
  }
  
  void move() {
    // Moves character by adding velocity to position
    pos.add(vel);
  }
  
  void accelerate(PVector acc) {
    // Increases velocity by adding acceleration
    vel.add(acc);
  }
  
  void drawMe() {
    // Default drawing
    push();
    translate(pos.x, pos.y);
    ellipse(0, 0, 50, 50);
    pop();
  }
  
  void checkCollide() {
    // handles collisions
    if (pos.x < -size.x/2) pos.x = width + size.x/2;
    if (pos.x > width + size.x/2) pos.x = -size.x/2;
    if (pos.y < -size.y/2) pos.y = height + size.y/2;
    if (pos.y > height + size.y/2) pos.y = -size.y/2;
  }
  
  boolean hitCharacter(Character other) {
    // Checks if character got hit
    boolean hit = false;
    
    if (dist(this.pos.x, this.pos.y, other.pos.x, other.pos.y) < this.size.x/2) {
      hit = true;
    }
    return hit;
  }
  
  void decreaseHealth(int dmg) {
    this.health -= dmg;
  }
}
