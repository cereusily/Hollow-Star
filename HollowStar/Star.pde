class Star extends Bullet {
  /* Class that manages star object */ 
  
  Star(PVector initPos, PVector initVel) {
    
    // Inits from parent bullet class
    super(initPos, initVel, new PVector(2, 2));
  }
  
  void drawMe() {
    // Draws star
    push();
    
    translate(pos.x, pos.y);
    noStroke();
    fill(255);
    
    ellipse(0, 0, 2, 2);
    strokeWeight(1);
    line(0, 0, 0, -1);
    
    pop();
  }
  
}
