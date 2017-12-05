//FinalGameJam by Aliyah Owens
// 2 levels
// move using arrow keys
// space bar to punch
// kill as many ghosts as you can

//arrays for animation
PImage[] runLeft = new PImage[7];
PImage[] runRight = new PImage[7];
PImage[] punchLeft = new PImage[6];
PImage[] punchRight = new PImage[6];
PImage[] ghostFly = new PImage[5];
PImage[] ghostFly2 = new PImage[5];

//arrays for lvl1 + lvl2 ghost waves
Ghost[] ghosts = new Ghost[10];  //array for ghosts
Ghost[] ghosts2 = new Ghost[10];  //array for ghosts

boolean faceRight = true;
int x = 1;                //counter for wolf animations
int g = 1;                //counter for ghost animations
int wolfY = 430;          //wolf Y position

boolean right, left, space = false;
Wolf wolf = new Wolf(); 
Ghost ghost = new Ghost();

//sound files
import processing.sound.*;
SoundFile punch, escape, music;

//game trackers
int level = 1;
int kills =0;
int misses = 0;

void setup() {
  size(1000,500);
  smooth();
  frameRate(10);
  
  for(int i=1; i<7; i++) {
    runLeft[i] = loadImage("run-left"+i+".png");
    runRight[i] = loadImage("run-right"+i+".png");
    if (i<6) {
      punchLeft[i] = loadImage("punch-left"+i+".png");
      punchRight[i] = loadImage("punch-right"+i+".png");  
    }
    if (i<5) {
      ghostFly[i] = loadImage("ghost"+i+".png");
      ghostFly2[i] = loadImage("ghost2"+i+".png");
    }
  }
  for (int i=0; i<ghosts.length; i++) {
     ghosts[i] = new Ghost(); 
  }
  for (int i=0; i<ghosts.length; i++) {
     ghosts2[i] = new Ghost(); 
  }
  
  punch = new SoundFile(this, "punch.mp3");
  escape = new SoundFile(this, "escape.mp3");
  music = new SoundFile(this, "music.mp3");
  music.loop();                              //backgournd music
  
}

void draw() {
  
  imageMode(CENTER);
  
  //game over state
  if (level==3) {
    background(#4D4D4D);
    fill(#FFFFFF);
    textAlign(CENTER);
    textSize(30);
    text("GAME OVER",500,300);
    textSize(24);
    text("Ghosts Killed: "+kills ,500,350);
    text("Ghosts Escaped: "+misses ,500,400);
    
  } else {
      background(#0f0a0a);
      fill(#dfd7d7);
      noStroke();
      rect(0,230,1000,40);
  }
  
  if (level == 1) {
    //generate ghosts lvl 1
    for (int i=0; i<ghosts.length; i++) {
       ghosts[i].moveLevel1();  
       
       //when ghost is hit
       if (ghosts[i].getPosition() > wolf.getPosition() 
             && ghosts[i].getPosition() < wolf.getPosition()+80
             && space && faceRight) {
              punch.play();
              ghosts[i].hit();  
              kills++;
               fill(#14C412);
               noStroke();
               rect(0,230,1000,40);
       }
       
       //escaped ghost feedback
       if (ghosts[i].getPosition() < wolf.getPosition()
             && ghosts[i].getPosition() > wolf.getPosition()-60) {
           escape.play();
           fill(#AF0909);
           noStroke();
           rect(0,230,1000,40);
       }
      
       //check in wolf is at end of level  
       if (wolf.getPosition() >= 995) {
          wolfY = 170;  //move wolf up to level 2
          faceRight = false; //turn wolf around
          level = 2; 
       } 
    } 
  }
  if (level == 2) {
     for (int i=0; i<ghosts2.length; i++) {
        ghosts2[i].moveLevel2();  
     
       //when ghost is hit
       if (ghosts2[i].getPosition() < wolf.getPosition() 
             && ghosts2[i].getPosition() > wolf.getPosition()-80
             && space && !faceRight) {
              punch.play();
              ghosts2[i].hit();
              kills++;
              fill(#14C412);
              noStroke();
              rect(0,230,1000,40);
       }
       
       //escaped ghost feedback
       if (ghosts2[i].getPosition() > wolf.getPosition()
             && ghosts2[i].getPosition() < wolf.getPosition()+60 ) {
           escape.play();
           fill(#AF0909);
           noStroke();
           rect(0,230,1000,40);
       }
       
       //check in wolf is at end of level
       if (wolf.getPosition() < 0) {
           misses = 20 - kills;   //calculate misses
           level = 3;             //level 3, game over state   
       } 
     }   
  }
   
  // idle character  
  if (!keyPressed) {
    if (faceRight) { 
      image(punchRight[1],wolf.getPosition(),wolfY); }
    if (!faceRight) {
      image(punchLeft[1],wolf.getPosition(),wolfY);  
    }
  }
  
  //move right + animation
  if (right) {
   wolf.moveRight(); 
    if (x>6) {
       x = 1; 
    }
   image(runRight[x],wolf.getPosition(),wolfY);
    x++; 
  }
  
  //move left + animation
  if (left) {
    if (x>6) {
       x = 1; 
    }
    wolf.moveLeft(); 
    image(runLeft[x],wolf.getPosition(),wolfY);
    x++; 
  }
  
  //punch
  if (space) { 
    if (x>5) {
       x = 1; 
    } 
    if (!faceRight) {
      image(punchLeft[x],wolf.getPosition(),wolfY);
    } else if (faceRight) {
      image(punchRight[x],wolf.getPosition(),wolfY); 
    }
    x++; 
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
       right = true; 
    }
  if (keyCode == LEFT) {
       left = true; 
    }
  if (keyCode == ' ') {
       space = true; 
    }   
  }
  
void keyReleased() {
  if (keyCode == RIGHT) {
       right = false; 
    }
  if (keyCode == LEFT) {
       left = false; 
    }
  if (keyCode == ' ') {
        space = false; 
    }
  }
  
class Wolf {
  int locationX;
  int speed;
  
  Wolf() {
   locationX = 5; 
   speed = 10; 
  }
  
  void moveRight() {
    faceRight = true;
    locationX += speed;
    if (locationX >1000) {
       locationX = 1000;
    }
  }
  
  void moveLeft() {
    faceRight = false;
    locationX -= speed;
    if (locationX >1000) {
       locationX = 1000;
    }
  }
      
  int getPosition() {
     return locationX; 
  } 
}

class Ghost {
  int locationX;
  int locationY;
  int speed;
  
  Ghost() {
    if (level ==1) {
        locationX = (int)random(1010,1500);
        locationY = 400;
    } if (level ==2) {
        locationY = 200; 
        locationX = (int)random(-500,-50);
    }
    speed = (int)random(5,15);
  }
  
  void moveLevel1() {
    locationX -= speed;
    if (locationX < 0 ) {
     locationX = -100;
    }
    image(ghostFly[g],locationX,locationY);
    g++;
    if (g>4) {
     g =1; 
    } 
  }
  
  void moveLevel2() {
    locationX += speed;
    if (locationX > 995 ) {
     locationX = -100; 
    }
    image(ghostFly2[g],locationX,170);
    g++;
    if (g>4) {
     g =1; 
    } 
  }
    
  void hit() {
    speed =0;
    locationX = -100;
  }
     
  int getPosition() {
    return locationX;  
  }
}