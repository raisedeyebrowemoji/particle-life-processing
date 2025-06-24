class Particle {
  
  // Movement
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  // Other properties
  int type;
  
  // Display
  float radius;
  color col;
  
  
  Particle(float x, float y, int type) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    this.type = type;
    float hue = type * 360/config.nTypes;
    this.col = color(hue, 100, 100);
    
    radius = config.radius;
  }
  
  void run() {
    move();
    wrapAround();
    display();
  }
  
  
  void update(ArrayList<Particle> swarm) {
    
    PVector totalForce = new PVector(0, 0);
    
    for (Particle particle: swarm) {
      PVector direction = PVector.sub(particle.position, this.position);
      
      if (direction.x > width*0.5) direction.x -= width;
      if (direction.x < width*-0.5) direction.x += width;
      if (direction.y > height*0.5) direction.y -= height;
      if (direction.y < height*-0.5) direction.y += height;
      
      
      float distance = direction.mag();
      
      if (distance == 0) continue; // takes care of both normalization errors and skips processing self
      
      direction.normalize();
      
      float attraction = interactions.attraction[this.type][particle.type];
      float minDistance = interactions.minDistances[this.type][particle.type];
      float attrRadius = interactions.attrRadii[this.type][particle.type];
      
      if (distance > attrRadius) continue;
      
      
      float mainForceScaling = map(distance, 0, attrRadius, 1, 0);
      PVector mainForce = PVector.mult(direction, attraction*mainForceScaling);
      
      PVector repellingForce = new PVector(0, 0);
      
      
      if (distance <= minDistance) {
        
        attraction = abs(attraction);
        attraction *= -5;
        float repellingForceScaling = map(distance, 0, minDistance, 1, 0);
        
        
        repellingForce =  PVector.mult(direction, attraction*repellingForceScaling);
       
      }
      
      
      
      
      PVector force = PVector.add(mainForce, repellingForce);
      
      //print(force.x);
      
      totalForce.add(force);
    }  
    
    totalForce.mult(config.forceCoef);
    
    applyForce(totalForce);
    
    velocity.mult(1-config.friction);

  }
  
  
  
  
  void move() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration = new PVector(0, 0);
    
    if (velocity.mag() < 0.1) {
      velocity = new PVector(0, 0);
    }
  }
  
  void applyForce(PVector force) {
    // may NOT add mass later I KNOW
    acceleration.add(force);
  }
  
  void wrapAround() {
    position.x = (position.x+width)%width;
    position.y = (position.y+height)%height;
  }
  
  void display() {
    fill(col);
    circle(position.x, position.y, radius);
  }
}
