//FinalGameJam by Aliyah Owens
// 2 levels
// move using arrow keys
// space bar to punch
// kill as many ghosts as you can

class Wolf {
  constructor() {
   this.locationX = 5; 
   this.speed = 10; 
  }
  
   moveRight() {
    faceRight = true;
    this.locationX += this.speed;
    if (this.locationX >1000) {
       this.locationX = 1000;
    }
  }
  
  moveLeft() {
    faceRight = false;
    this.locationX -= this.speed;
    if (this.locationX >1000) {
       this.locationX = 1000;
    }
  }
      
  getPosition() {
     return this.locationX; 
  } 
}

class Ghost { 
  constructor(startPoint, speed) {
    if (level ==1) {
        // this.locationX = startPoint // random(1010,1500);
        this.locationY = 400;
    } if (level ==2) {
        this.locationY = 200; 
       // this.locationX = random(-500,-50);
    }
		
		this.locationX = startPoint;
    this.speed = speed;
  }
  
  moveLevel1() {
    this.locationX -= this.speed;
    if (this.locationX < 0 ) {
     this.locationX = -100;
    }
    image(ghostFly[g],this.locationX,this.locationY);
    g++;
    if (g>4) {
     g =1; 
    } 
  }
  
  moveLevel2() {
    this.locationX += this.speed;
    if (this.locationX > 995 ) {
     this.locationX = -100; 
    }
    image(ghostFly2[g],this.locationX,170);
    g++;
    if (g>4) {
     g =1; 
    } 
  }
    
  hit() {
    this.speed =0;
    this.locationX = -100;
  }
     
  getPosition() {
    return this.locationX;  
  }
}

//arrays for animation
var runLeft = new Array(7);
var runRight = new Array(7);
var punchLeft = new Array(6);
var punchRight = new Array(6);
var ghostFly = new Array(5);
var ghostFly2 = new Array(5);

//arrays for lvl1 + lvl2 ghost waves
var ghosts = new Array(10);       //array for ghosts
var ghosts2 = new Array(10);  //array for ghosts

var faceRight = true;
var x = 1;                //counter for wolf animations
var g = 1;                //counter for ghost animations
let wolfY = 430;          //wolf Y position

var right, left, space = false;
let wolf = new Wolf(); 

//sound files
let punch, escape, music;

//game trackers
var level = 1;
var kills = 0;
var misses = 0;

function preload() {
	punch = loadSound("punch.mp3");
  escape = loadSound("escape.mp3");
  music = loadSound("music.mp3");
  
	for(let i=1; i<7; i++) {
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
}

function setup() {
  createCanvas(1000,500);
  smooth();
  frameRate(10);
	
  for (let i=0; i<ghosts.length; i++) {
     ghosts[i] = new Ghost(random(1010, 1500), random(5,15)); 
  }
  for (let i=0; i<ghosts.length; i++) {
     ghosts2[i] = new Ghost(random(-500,-50), random(5,15)); 
  }
	
	music.loop();    
}

function draw() {
  
  imageMode(CENTER);
  
  //game over state
  if (level==3) {
    background('#4D4D4D');
    fill('#FFFFFF');
    textAlign(CENTER);
    textSize(30);
    text("GAME OVER",500,300);
    textSize(24);
    text("Ghosts Killed: "+kills ,500,350);
    text("Ghosts Escaped: "+misses ,500,400);
    
  } else {
      background('#0f0a0a');
      fill('#dfd7d7');
      noStroke();
      rect(0,230,1000,40);
  }
  
  if (level == 1) {
    //generate ghosts lvl 1
    for (let i=0; i<ghosts.length; i++) {
       ghosts[i].moveLevel1();  
       
       //when ghost is hit
       if (ghosts[i].getPosition() > wolf.getPosition() && ghosts[i].getPosition() < wolf.getPosition()+80 && space && faceRight) {
              punch.play();
              ghosts[i].hit();  
              kills++;
               fill('#14C412');
               noStroke();
               rect(0,230,1000,40);
       }
       
       //escaped ghost feedback
       if (ghosts[i].getPosition() < wolf.getPosition() && ghosts[i].getPosition() > wolf.getPosition()-60) {
           escape.play();
           fill('#AF0909');
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
     for (let i=0; i<ghosts2.length; i++) {
        ghosts2[i].moveLevel2();  
     
       //when ghost is hit
       if (ghosts2[i].getPosition() < wolf.getPosition() && ghosts2[i].getPosition() > wolf.getPosition()-80 && space && !faceRight) {
              punch.play();
              ghosts2[i].hit();
              kills++;
              fill('#14C412');
              noStroke();
              rect(0,230,1000,40);
       }
       
       //escaped ghost feedback
       if (ghosts2[i].getPosition() > wolf.getPosition() && ghosts2[i].getPosition() < wolf.getPosition()+60 ) {
           escape.play();
           fill('#AF0909');
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
  if (!right && !left && !space) {
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

function keyPressed() {
  if (keyCode == RIGHT_ARROW) {
       right = true; 
    }
  if (keyCode == LEFT_ARROW) {
       left = true; 
    }
  if (keyCode == 32) {
       space = true; 
    }   
  }
  
function keyReleased() {
  if (keyCode == RIGHT_ARROW) {
       right = false; 
    }
  if (keyCode == LEFT_ARROW) {
       left = false; 
    }
  if (keyCode == 32) {
        space = false; 
    }
  }
  
