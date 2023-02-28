class TaurusGun extends Gun {
  // Init fields
  PVector size;
  
  TaurusGun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    // Inits all attributes
    super(pos, vel, bulletArr);
    
    size = new PVector(150, 170);
    
    this.power = 30;
    
    threshold = 5;
    cooldown = 0;
  }
  
  void shoot(String state) {
    Bullet taurusShot = new Bullet(new PVector(pos.x, pos.y), vel, size);
    
    // Sets bullet state & power
    taurusShot.setState(state);
    taurusShot.power = this.power;
    
    bulletArr.add(taurusShot);
  }
}
