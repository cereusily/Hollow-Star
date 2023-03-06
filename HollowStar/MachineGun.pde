class MachineGun extends Gun {
  // Init fields
  
  MachineGun(PVector pos, PVector vel, ArrayList<Bullet> bulletArr) {
    super(pos, vel, bulletArr);
    
    threshold = 10;
    cooldown = 10;
  }
}
