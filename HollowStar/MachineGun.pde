class MachineGun extends Gun {
  // Init fields
  float speed; 
  
  MachineGun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    super(pos, vel, bulletArr);
    
    // Size init; power is default =1 
    this.size = new PVector(30, 30);
    
    speed = 10;
    
    threshold = 10;
    cooldown = 0;
  }

  void shoot(String state) {
    // Shoot gun
    if (cooldown == threshold) {
      cooldown = 0;
      
      float angle = atan2(player.pos.y - this.pos.y, player.pos.x - this.pos.x);
      
      PVector bulletV = new PVector(cos(angle) * speed, sin(angle) * speed);
      
      Bullet newBullet = new Bullet(new PVector(pos.x + bulletV.x * vel.x, pos.y + bulletV.y * vel.y), new PVector(bulletV.x * vel.x, bulletV.y * vel.y), size);
      newBullet.setState(state);
      
      bulletArr.add(newBullet);
    }
  }
}
