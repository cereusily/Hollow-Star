class Part extends Bullet {
  // Class that manages parts
  PShape partShape;
  float partScale;
  float rotateFactor;
  float randomRotate;
  float randomRotateDirection;
  int charHeight;
  
  int removeTimer;
  
  Part(PVector pos, PVector vel, int charHeight, PShape partShape, float partScale, float rotateFactor, int removeTimer) {
    // Calls parent function
    super(pos, vel);
    
    // Inits part shape
    this.partShape = partShape;
    this.partScale = partScale;
    this.rotateFactor = rotateFactor;
    this.charHeight = charHeight;
    this.removeTimer = removeTimer;
    randomRotate = (float) random(100, 400);
    
    // Gets either 1 or -1
    randomRotateDirection = ((int) random(0, 2) == 0 ? 1 : -1);
  }
  
  void update() {
    super.update();
    
    // Rotates self
    this.partShape.rotate(PI/(randomRotateDirection * 800));
    
    // counts down timer
    removeTimer--;
    
    // Removes self once timer is done
    if (removeTimer == 0) {
      parts.remove(this);
    }
  }
  
  void drawMe() {
    // Draws self
    push();
    translate(pos.x, pos.y + charHeight/4);
    rotate(rotateFactor);
    scale(partScale);
    shape(partShape);
    pop();
  }
  
}
