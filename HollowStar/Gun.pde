abstract class Gun {
  // Init fields
  
  float cooldown;
  float threshold;
  
  PVector pos;
  PVector vel;
  PVector size;
  
  int bulletWidth;
  int bulletLength;
  
  ArrayList<Bullet> bulletArr;
  
  int power;
  
  Gun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    this.pos = pos;
    this.vel = vel;
    this.bulletArr = bulletArr;
    
    // Default bullet size
    this.size = new PVector(15, 15);
    
  }

  void shoot(ArrayList<Bullet> bulletArr) {
    // Shoots bullet is cooldown is off
    if (cooldown == threshold) {
      Bullet newBullet = new Bullet(this.pos, this.vel, this.size);
      newBullet.power = this.power;
      bulletArr.add(newBullet);
    }
  }
  
  void recharge() {
    if (cooldown < threshold) {
      cooldown++;
    }
  }
}
