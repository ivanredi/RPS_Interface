import processing.opengl.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;

// ------------ color from image
int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];



boolean DEBUG_MODE = true;


boolean SHOW_FOG = false;
boolean SHOW_CONNECTING_LINES = false;
boolean SHOW_RAY_LINES = true;

boolean CHANGE_DOT_SIZE = false;



float USER_RADIUS_FOR_TESTING_AND_GRABBING = 10;

int RAY_AMOUNT = 32;


PImage img;


int userSelected = -1;

int currentUserCount = 5; // OSC mode needs 5 users 
int maxUserCount = 5;
User[] users = new User[maxUserCount];


PFont font;

void setup() {
 // size(1024*2, 768*2, OPENGL);
  size(1024, 768, OPENGL);
  background(0, 0, 0);
  // takecolor("blumengruss.jpg"); // for the color palette
  takecolor("shape05_03.jpg"); // for the color palette
  
  
  
  frameRate(30);
  imageMode(CENTER);
  smooth();
  // colorMode(HSB); // red will become black instead of just transparent!
  colorMode(RGB);
  
  

  img = loadImage("blurredDotSmall.png");
  font = loadFont("HelveticaNeue-12.vlw");  
  textFont(font, 40);
  
  if(!DEBUG_MODE) oscP5 = new OscP5(this, 7001);
  if(DEBUG_MODE) currentUserCount = 0;


  for (int i=0; i<maxUserCount; i++) {
    //  println(i);
    users[i] = new User(i, random(width), random(height), users);
    if(DEBUG_MODE) users[i].isActive = true;
  }
  
  
  
  
}

void draw() {
    
  // background(0);
  // tint(255, 255, 255, 3); 
  // image(thescreen, width/2., height/2);


  noStroke();
  fill(0, 0, 0, 10);
  //if(frameCount%2==0) 
  rect(0, 0, width, height);


  //  background(0);
  for (int i=0; i<currentUserCount; i++) {
    users[i].update();
  }


  //  thescreen = get();
} // end void draw




void mouseReleased() {
  userSelected = - 1;
  // background(0);
}




void mousePressed() {

  // find out if mouse over another user
  for (int i=0; i<currentUserCount; i++) {

    if ( users[i].mouseOver() ) {
      userSelected = i;
      break;
    } // end if
  }// end  for (int i=0; i<currentUserCount; i++)

  if (! (mouseX==0 && mouseY==0) ) {
    if ( userSelected == -1 && currentUserCount < maxUserCount) {
      users[currentUserCount].x = mouseX;
      users[currentUserCount].y = mouseY;

      currentUserCount ++;
    }// end if ( userSelected
  }// end if(! (mouseX==0 && mouseY==0) )
}



void mouseDragged() {
  if (userSelected != -1) {
    users[userSelected].x += mouseX-pmouseX;
    users[userSelected].y += mouseY-pmouseY;
  }// if(userSelected != -1)
}





void keyPressed() {

  if (key == 'x') {
    if (currentUserCount > 0) 
    {
      currentUserCount --;
      background(0);
    }
  }

  // -------- DEBUG

  if (key == 'f') {
    SHOW_FOG = !SHOW_FOG;
  }

  if (key=='c') {
    SHOW_CONNECTING_LINES = !SHOW_CONNECTING_LINES;
  }



  if (key == 's') {
    CHANGE_DOT_SIZE = !CHANGE_DOT_SIZE;
  }

  if (key == 'l') {
    SHOW_RAY_LINES = !SHOW_RAY_LINES;
  }

  if (key == 'd') {
    background(0);
  }
}




void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  /*print("### received an osc message.");
   print(" addrpattern: "+theOscMessage.addrPattern());
   println(" typetag: "+theOscMessage.typetag());
   */
  int ID = theOscMessage.get(0).intValue();
  int inOrOut =  theOscMessage.get(1).intValue(); // is tracked or not
  float osc_x = theOscMessage.get(2).floatValue(); 
  float osc_y = theOscMessage.get(3).floatValue();
  float osc_d = theOscMessage.get(3).floatValue(); // nearest distance to next person


 /* if (ID == 0 && inOrOut==1)*/ println("ID is: " + ID +  " inOrOut:" + inOrOut + " , x:" + osc_x + " y:" + osc_y + " d: " + osc_d);

  users[ID].isActive = (inOrOut==1);

  float theX = map(osc_x, 120, -120, 0, width); // this is corrected according to the projection
  float theY = map(osc_y, -120, 120, 0, height); 
  
  float smoothAmount = 0.8;
  users[ID].x = users[ID].x * smoothAmount + theX * (1.0 - smoothAmount);
  users[ID].y = users[ID].y * smoothAmount + theY * (1.0 - smoothAmount);
 
 // users[ID].x = theX;
 // users[ID].y = theY;
}



// color routines ----------------------------------------------------------------

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(numpal))];
}

void takecolor(String fn) {
 // colorMode(RGB);
 PImage b;
   b = loadImage(fn); 
  //image(b,0,0);

  for (int x=0;x<b.width;x++) {
    for (int y=0;y<b.height;y++) {
      println("x " + x + "y " + y);
     color c = b.get(x,y);
     
     boolean exists = false;
      for (int n=0;n<numpal;n++) {
        if (c==goodcolor[n]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        // add color to pal
        if (numpal<maxpal) {
          goodcolor[numpal] = c;
          numpal++;
        }
      }
      
      
    } // end for (int y=0;y<b.height;y++) {
  }
  
  
}


