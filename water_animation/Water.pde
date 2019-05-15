

class Water{
  ArrayList<Particle> particles;
  float turbulence;
  int size;
  int settledAmt;
  
  Water(){
    particles = new ArrayList<Particle>();
    turbulence = 0;
    size = 0;
    settledAmt = 0;
  }
  
  Water(ArrayList<Particle> ps, float t, float d){
    particles = ps;
    turbulence = t;
    size = particles.size();
    settledAmt = 0;
  }
  
  
  void incrementSettled(){
    settledAmt++;
  }
  
  float averageSpd(){
    float avg;
    float sum = 0;
    float temp;
    float sz = particles.size();
    for(int i = 0; i<particles.size(); i++){
      sum += abs(particles.get(i).vector);
    }
    avg = sum/sz;
    return avg;
  }
  
  void setParticles(ArrayList<Particle> ps){
    particles = ps;
    size = particles.size();
    return;
  }
  
  void setTurbulence(float t){
    turbulence = t;
    return;
  }
  
  void insert(Particle p){
    particles.add(p);
    size = size+1;
    return;
  }
  
  void delete(Particle p){
    particles.remove(p);
    size = size-1;
    return;
  }

  
  boolean internalCollision(Particle p){
    for(int i = 0; i<particles.size() ; i++){
      if(p.hit(particles.get(i)) && !p.equals(particles.get(i))){ // check with every other particle
        return true;
      }
      else{
        continue;
      }
    }
    return false;
  }
  
  Particle getCollided(Particle p){
    
    for(int i = 0; i<particles.size() ; i++){
      if(p.hit(particles.get(i)) && !p.equals(particles.get(i))){ // check with every other particle
        return particles.get(i);
      }
      else{
        continue;
      }
    }
    
    return null;
  }
  
  
  void addTurbulence(float t, float clk, float locX, float locY){
    turbulence = t;
    clk = clk * TWO_PI;
    // adds subtle movement throughout
    // uses a clock
    float addx = 0;
    float addy = 0;
    for(int i = 0; i<particles.size(); i++){
      Particle temp = particles.get(i);
      if(temp.settled){
        float offset = radians(dist(temp.posX, temp.posY, locX, locY))*4;
        addx = cos((clk - offset + radians(temp.x)))*t;
        addy = sin((clk - offset - radians(temp.x)))*t;
        
        temp.x = temp.posX + (addx * 200 );
        temp.y = temp.posY - (addy * 200 );

      }
    }
  }
  
  // calculates what the speed of the particle should be based on the particles surrounding it
  void calcWaterSpd(Particle p){
    // go through list, find the nearest particles, calculate "actual" speed of particle
    float sumx = 0;
    float sumy = 0;
    float avgx, avgy;
    float num = 0;
    for(int i = 0; i<particles.size(); i++){
      Particle temp = particles.get(i);
      if(temp.x < p.x+25 && temp.x > p.x-25){ 
        if(temp.y < p.y+25 && temp.y > p.y-25){
          // this particle is within the 25x25 square surrounding the particle
          sumx += temp.speedx;
          sumy += temp.speedy;
          num++;
        }
      }
    }
    
    if(num > 0){
      avgx = sumx/num; 
      avgy = sumy/num;
      
      float newx = (p.speedx * 0.8) + (avgx * 0.2);
      float newy = (p.speedy * 0.8) + (avgy * 0.2);
      
      p.setXSpeed(newx);
      p.setYSpeed(newy);
    }
    
  }
 
}
