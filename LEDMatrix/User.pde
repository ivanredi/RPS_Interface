class User {

void keyPressed() {
if (key >= '1' && key <= '5') {
  noStroke();
  fill(255);
  text("User "+key,50,50);
  }
}

void keyReleased(){
  noStroke();
  fill(0);
  text("User "+key,50,50);
}

void drawTarget(float xloc, float yloc, int size, int num) {
  float grayvalues = 255/num;
  float steps = size/num;
  for (int i = 0; i < num; i++) {
    fill(i*grayvalues);
    ellipse(xloc, yloc, size - i*steps, size - i*steps);
  }
}


}

  


