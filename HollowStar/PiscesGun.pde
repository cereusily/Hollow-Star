class PiscesGun extends Gun {
  // Init fields
  
  PVector vel = new PVector(0, -10);
  PVector size;
  
  PiscesGun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    // Inits all attributes
    super(pos, vel, bulletArr);
    
    this.power = 1;
    this.size = new PVector(10, 30);
    
    threshold = 7;
    cooldown = 0;
  }
  
  void shoot(String state) {
    // Checks if gun is off cooldown
    if (cooldown == threshold) {
      Bullet newBulletLeft = new Bullet(new PVector(pos.x - 22, pos.y), vel, size);
      Bullet newBulletRight = new Bullet(new PVector(pos.x + 22, pos.y), vel, size);
      
      // Sets bullets to player state
      newBulletLeft.setState(state);
      newBulletRight.setState(state);  
      
      newBulletLeft.power = this.power;
      newBulletRight.power = this.power;
      
      // adds bullets
      bulletArr.add(newBulletLeft);
      bulletArr.add(newBulletRight);  
      
      // resets cooldown
      cooldown = 0;
    }
  }
}
