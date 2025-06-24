class Interactions {
  float[][] attraction;
  float[][] minDistances;
  float[][] attrRadii;

  void init() {
    attraction = new float[config.nTypes][config.nTypes];
    minDistances = new float[config.nTypes][config.nTypes];
    attrRadii = new float[config.nTypes][config.nTypes];
  }

  void setAttraction(int type1, int type2, float value) { attraction[type1][type2] = value; } // xo i even need this lamo
  void setMinDistance(int type1, int type2, float value) { minDistances[type1][type2] = value; }
  void setAttrRadius(int type1, int type2, float value) { attrRadii[type1][type2] = value; }

  void randomizeAttraction() {
    for (int t1 = 0; t1 < config.nTypes; t1++) {
      for (int t2 = 0; t2 < config.nTypes; t2++) {
        setAttraction(t1, t2, random(config.attractionRandomLimits[0], config.attractionRandomLimits[1]));
      }
    }
  }

  void randomizeMinDistances() {
    for (int t1 = 0; t1 < config.nTypes; t1++) {
      for (int t2 = 0; t2 < config.nTypes; t2++) {
        setMinDistance(t1, t2, random(config.minDistanceRandomLimits[0], config.minDistanceRandomLimits[1]));
      }
    }
  }

  void randomizeAttrRadii() {
    for (int t1 = 0; t1 < config.nTypes; t1++) {
      for (int t2 = 0; t2 < config.nTypes; t2++) {
        setAttrRadius(t1, t2, random(config.attrRadiusRandomLimits[0], config.attrRadiusRandomLimits[1]));
      }
    }
  }
}

class Config {
  int nTypes;
  int nParticles;

  float forceCoef;
  float friction;

  float[] attractionRandomLimits;
  float[] minDistanceRandomLimits;
  float[] attrRadiusRandomLimits;

  float radius;
  
  int wWidth;
  int wHeight;

  HashMap<String, Consumer<String>> handlers = new HashMap<String, Consumer<String>>();

  Config() {
    handlers.put("Types", v -> nTypes = int(v));
    handlers.put("Particles", v -> nParticles = int(v));
    
    handlers.put("Friction", v -> friction = float(v));
    handlers.put("Force coefficient", v -> forceCoef = float(v));
    
    handlers.put("Width", v -> wWidth = int(v));
    handlers.put("Height", v -> wHeight = int(v));
    
    handlers.put("Particle radius", v -> radius = float(v));
    

    handlers.put("Attraction value", v -> {
      String[] tokens = split(v, ", ");
      attractionRandomLimits = new float[2];
      for (int i = 0; i < tokens.length; i++) {
        attractionRandomLimits[i] = float(trim(tokens[i]));
      }
    });

    handlers.put("Min distance", v -> {
      String[] tokens = split(v, ", ");
      minDistanceRandomLimits = new float[2];
      for (int i = 0; i < tokens.length; i++) {
        minDistanceRandomLimits[i] = float(trim(tokens[i]));
      }
    });

    handlers.put("Attraction radius", v -> {
      String[] tokens = split(v, ", ");
      attrRadiusRandomLimits = new float[2];
      for (int i = 0; i < tokens.length; i++) {
        attrRadiusRandomLimits[i] = float(trim(tokens[i]));
      }
    });
  }

  void read(String fileName) {
    String[] lines = loadStrings(fileName);
    for (String line : lines) {
      if (line.trim().length() == 0 || line.startsWith("---")) continue;
      String[] parts = split(line, ": ");
      if (parts.length != 2) continue;

      String name = trim(parts[0]);
      String value = trim(parts[1]);

      if (handlers.containsKey(name)) {
        handlers.get(name).accept(value);
      }
    }
  }
}

Config config = new Config();
Interactions interactions = new Interactions();
