int amount = 200;
int added = 10;
boolean start;
float masterClock = 0;
float turbulence = 1;

Water w = new Water();

void setup(){
  size(600, 600);
  colorMode(HSB, 100);
  background(0);
  
  // make particles
  color col;
  float x, y, speedx, speedy, r, m;
  
  for(int i  = 0; i<amount; i++){
    
    Particle p;
    do{
    speedx = random(-10,10);
    speedy = 1;
    r = random(5,10);
    m = random(2,5);
    x = random(r, width-r);
    y = random(r, height-r-100);
    col = color(60 + random(-10,10), 100, random(50,100));
    
    p = new Particle(x, y, speedx, speedy, m, r, col);
    }while(w.internalCollision(p));
    
    w.insert(p);
  }
  start = false;
}

void draw(){
  noStroke();
  background(0);

  for(int i = 0; i< w.size; i++){
    
    
    Particle temp = w.particles.get(i);
    
    if(temp.y > height){
      w.delete(temp);
    }
    
    // add gravity
    // if each particle collided with has nowhere else to go
    if(!temp.settled || !w.internalCollision(temp)){
      temp.addYSpeed(0.8);
      if(!temp.settled && temp.y < height-200){
        temp.y = temp.y + temp.speedy; // move down
        temp.x = temp.x + temp.speedx; // move side
      }
      else{
        if(!temp.settled){
          //temp.setYSpeed(temp.speedy*-0.2);
          //temp.setXSpeed(temp.speedx*-0.2);
          w.incrementSettled();
          temp.settled = true;
          temp.posX = temp.x;
          temp.posY = temp.y;
        }
      }
    }
    
    w.calcWaterSpd(temp);
    if(w.internalCollision(temp) && temp.settled){
        w.addTurbulence(turbulence, masterClock, w.getCollided(temp).x, w.getCollided(temp).y);
    }
    
    // add edge collisions
    if(temp.hitXEdge(width)){
      temp.setXSpeed(temp.speedx * -0.5);
    }
    
    if(temp.hitYEdge(height)){
      temp.setYSpeed(temp.speedy * -0.5);
    }
    
    
    // while touching another particle
    if(w.internalCollision(temp)){
      if(!temp.settled && w.getCollided(temp).settled){
        temp.collide(w.getCollided(temp));
        if(turbulence < 0.08){
           turbulence += 0.001;
        }
        else{
          turbulence = 0.1;
        }
      }
      else{
        temp.collide(w.getCollided(temp));
      }
    }
    
    if(temp.speedx < 0.2 && temp.speedx > -0.2){
      temp.setXSpeed(0);
    }
    
    if(temp.speedy < 0.2 && temp.speedy > -0.2){
      temp.setYSpeed(0);
    }
    


    // draw each
    fill(temp.c);
    ellipse(temp.x, 
            temp.y, 
            temp.r*2, 
            temp.r*2);
            
     if(turbulence == 0){
        temp.posX = temp.x;
        temp.posY = temp.y;
     }
  }
  
  turbulence = turbulence*0.99;
  if(turbulence < 0.001){
    turbulence = 0;
  }
  start = true;
  masterClock = masterClock+ 0.01;

  if(masterClock > 1){
    masterClock = 0;

  }

}



void mousePressed(){

  color col;
  float x, y, speedx, speedy, r, m;
  
  for(int i=0; i<added ; i++){
    Particle p;
    speedx = random(-10,10);
    speedy = 1;
    r = random(5,10);
    m = random(2,5);
    x = mouseX;
    y = mouseY;
    col = color(60 + random(-10,10), 100, random(50,100));
    
    p = new Particle(x, y, speedx, speedy, m, r, col);
    w.insert(p);
  }
}
