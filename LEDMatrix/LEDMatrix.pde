// Matrix of LED Pixels

PFont mono; 
int[] UserID;

float x;
float y;

LEDPixel[] Pixel;
User user = new User();

void setup() {
  size (627,462);
  background(0);
  noStroke();
  smooth();
  mono = createFont("Virtue",24);
  textFont(mono);
  UserID = new int[5];
  for (int i=0; i<5; i++) {
    UserID[i]=0;
  }
}

void draw() {
  if (keyPressed) {
    if (x != mouseX | y != mouseY) {
    user.keyPressed();
    user.drawTarget(x , y, 100, 1);  
    user.drawTarget(mouseX, mouseY, 100, 6);
    x = mouseX;
    y = mouseY;  
    
  }
  } else 
    user.keyReleased();      
    
}




