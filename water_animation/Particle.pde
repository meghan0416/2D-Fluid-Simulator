class Particle{
  float x, y; // position

  float speedx, speedy; // velocity
  float vector; // resultant velocity vector
  float mass;
  float r; // radius
  color c; // color
  boolean settled;
  float posX, posY; // settled position
  
  Particle(float xloc, float yloc, float sx, float sy, float m, float rad, color col){
    x = xloc;
    y = yloc;
    posX = x;
    posY = y;

    mass = m;
    speedx = sx;
    speedy = sy;
    settled = false;
    
    r = rad;
    c = col;
    this.vector = sqrt( (speedx * speedx) + (speedy * speedy) );
  }
  
  void addXSpeed(float sx){
    this.speedx = speedx + sx;
    this.vector = sqrt( (speedx * speedx) + (speedy * speedy) );
    if(!settled){
      posX = x;
      posY = y;
    }
  }
  
  void addYSpeed(float sy){
    this.speedy = speedy + sy;
    this.vector = sqrt( (speedx * speedx) + (speedy * speedy) );
    if(!settled){
      posX = x;
      posY = y;
    }
  }
  
  void setXSpeed(float sx){
    this.speedx = sx;
    this.vector = sqrt( (speedx * speedx) + (speedy * speedy) );
    if(!settled){
      posX = x;
      posY = y;
    }
  }
  
  void setYSpeed(float sy){
    this.speedy = sy;
    this.vector = sqrt( (speedx * speedx) + (speedy * speedy) );
    if(!settled){
      posX = x;
      posY = y;
    }
  }
  
  void move(float mx, float my){
    x = x+mx;
    y = y+my;
    if(!settled){
      posX = x;
      posY = y;
    }
    return;
  }
   //returns component of p's velocity along this particle's velocity
  float vectorComponent(Particle p){
    float dotProd = speedx * p.speedx + speedy * p.speedy;
    float denom = p.vector * vector;
    
    float cosAngle = dotProd/denom;
    
    float component = p.vector*cosAngle;
    
    return component;
  }
  
  void collide(Particle p){
    // assuming head on collision
    float newx, newy, pnewx, pnewy;
    newx = (p.speedx * (p.mass*2)/(p.mass + mass)) - (speedx * (p.mass-mass)/(p.mass+mass));
    newy = (p.speedy * (p.mass*2)/(p.mass + mass)) - (speedy * (p.mass-mass)/(p.mass+mass));
    
    pnewx = (speedx * (mass*2)/(p.mass + mass)) - (p.speedx * (mass-p.mass)/(p.mass+mass));
    pnewy = (speedy * (mass*2)/(p.mass + mass)) - (p.speedy * (mass-p.mass)/(p.mass+mass));
    
    setXSpeed(newx);
    setYSpeed(newy);
    p.setXSpeed(pnewx);
    p.setYSpeed(pnewy);
    if(!settled){
      posX = x;
      posY = y;
    }
  }
  
  boolean hitXEdge(int w){
    boolean result = false;
    
    if(x-r <= 0 || x+r >= w){
      result = true;
    }
    
    return result;
  }
  
  boolean hitYEdge(int h){
    boolean result = false;
    
    if(y-r <= 0 || y+r >= h){
      result = true;
    }
    
    return result;
  }
  

  
  boolean hit(Particle p){
    float distance = dist(p.x, p.y, x, y);
    boolean result = false;
    if(distance < (r + p.r + 5)){
      result = true;
    }
    else{
      result = false;
    }
    
    return result;
  }
  
  boolean equals(Particle p){
    if(x == p.x && y == p.y && speedx == p.speedx && speedy == p.speedy && r == p.r){
      return true;
    }
    return false;
  }
}
