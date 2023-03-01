class TaurusGun extends Gun {
  // Init fields
  int durability;
  
  TaurusGun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    // Inits all attributes
    super(pos, vel, bulletArr);
    
    // Init size and power ;)
    this.size = new PVector(150, 170);
    this.power = 4;
    
    threshold = 5;
    cooldown = 0;
    durability = 50;
  }
  
  void shoot(String state) {
    Bullet taurusShot = new Bullet(new PVector(pos.x, pos.y), vel, size);
    
    // Sets bullet state & power
    taurusShot.setState(state);
    taurusShot.power = this.power;
    taurusShot.durability = this.durability;
    
    bulletArr.add(taurusShot);
  }
}
