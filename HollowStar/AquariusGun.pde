class AquariusGun extends Gun {
  // Init fields
  
  AquariusGun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    super(pos, vel, bulletArr);
    
    // Size init; power is default =1 
    this.size = new PVector(30, 30);
    
    // Thresholds & cooldowns
    threshold = 110;
    cooldown = 10;
  }
  
  void shoot(String state) {
    // Shoots only if cooldown
    if (cooldown == threshold) {
      float angle = 0;
      cooldown = 0;
      
      // While less than a circle
      while (angle <= TWO_PI) {
        Bullet newBullet = new Bullet(new PVector(pos.x + sin(angle) * vel.x, pos.y + cos(angle) * vel.y), new PVector(sin(angle) * vel.x, cos(angle) * vel.y), size);
        newBullet.setState(state);
        newBullet.power = this.power;
        angle += PI/18;  // => 1 degree
        bulletArr.add(newBullet);
      }
    }
  }
}
