import java.util.HashMap;
import java.util.function.Consumer;


ArrayList<Particle> particles;

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  
  particles = new ArrayList<Particle>();
  
  
  config.read("config.txt"); interactions.init();
  windowResize(config.wWidth, config.wHeight);
  randomize();
  spawnParticles();
  
}

void spawnParticles() {
  int currentType = 0;
  for (int i = 0; i < config.nParticles; i++) {
    Particle particle = new Particle(random(width), random(height), currentType);
    particles.add(particle);
    currentType = (currentType+1) % config.nTypes;
  }
}

void draw() {
  background(0);
  for (Particle particle: particles) {
    particle.update(particles);
    particle.run();
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {config.read("config.txt");} 
  if (key == 'r' || key == 'R') randomize();
  if (key == 's' || key == 'S') {particles = new ArrayList<Particle>(); spawnParticles();}
  if (key == 'p') {println(interactions.attraction[0][0]); println(interactions.minDistances[0][0]); println(interactions.attrRadii[0][0]);}
}


void randomize() {
  interactions.init();
  interactions.randomizeAttraction();
  interactions.randomizeMinDistances();
  interactions.randomizeAttrRadii();
}
