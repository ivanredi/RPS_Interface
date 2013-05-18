class Ray {

  int ID;
  float x1, y1, x4, y4;

  // ------------------------------- angle
  float angDiff;
  float baseAngle; // this should be the angle that is calculated from angDiff and ID

  float sinValue;
  float sinCounter = random(360);
  float sinCounterSpeed = random(0.005, 0.02);
  float angleVaryAmount = 30;

  // ------------------------------- radius
  // float maxRad =  300; // random !!!
  float maxRad =  random(200, 300); // random !!! // was: 100..200
  float rad = random(maxRad); // starts at the center of the circle

  // float growSpeed = random(2, 5);
  float growSpeed = random(0.5, 0.8);
  float sinVal;

  // ------------------------------- color values
  float mappedRadToColorVal;
  float alphaVal;

  // ------------------------------- vector to return the location of the end point (x4, y4)
  PVector rayVec = new PVector();


// ----------- color from the palette

   color myColor = somecolor();


  // ------------------------------- CONSTRUCTOR
  Ray(int _ID, float _x, float _y) {
    ID = _ID;
    x1 = _x;
    y1 = _y;

    angDiff = 360./RAY_AMOUNT;
    baseAngle = angDiff * ID;
  }// end constructor


  // -------------------------------  getEndPos: retruns the current position of the elements 
  PVector getEndPos() {
    rayVec.x = x4;
    rayVec.y = y4;
    return rayVec;
  }


  void update(float _x, float _y) {

    // ---------------------- draw the blurred dot 
    mappedRadToColorVal =  map( rad, 0, maxRad, 255, 50);
    alphaVal = map( rad, 0, maxRad, 255, 50); // num !!! 255 as starting alpha


    // ------------------------------ update sinCounter: calculate the sinValue to add to the baseAngle
    if (sinCounter < 359) {
      sinCounter += sinCounterSpeed;
    }
    else {
      sinCounter -= 360;
    }

    sinValue = sin(sinCounter); // values between -1 and +1

    // ---------------------- calculate start and end of rays
    x1 = _x;
    y1 = _y;

    float theAngle = ( baseAngle + (sinValue*angleVaryAmount) );

    x4 = x1 + rad * sin( theAngle * PI/180 );
    y4 = y1 + rad * cos( theAngle * PI/180 );



    // ---------------------------------------------------- fog 
    if (SHOW_FOG) {

     // tint(255, 255, mappedRadToColorVal, alphaVal); // HSB red
     //  tint(255, 0, 0, alphaVal); // HSB red
     // tint(  red(myColor), green(myColor), blue(myColor), 10 ); // RGB: color from image
   tint(255, 255, 255, 5); // RGB: white

      if (CHANGE_DOT_SIZE) {
        // float w = map(rad, 0, maxRad, 500, 100); // 500 is the original size of blurredDotSmall.jpg
        float w = map(rad, 0, maxRad, 300, 10);
        image(img, x4, y4, w, w);
      }
      else {
        image(img, x4, y4);
      }
    }




    // ---------------------------------------------------- ray lines
    if (SHOW_RAY_LINES) {

      /*
      if (SHOW_FOG) {
       stroke(0, 0, mappedRadToColorVal, alphaVal); // HSB: white
       }
       else {
       
       stroke(255, 255, mappedRadToColorVal, alphaVal); // HSB red
       }
       */

      // RAYS LINES
     //  stroke(0, 0, mappedRadToColorVal, alphaVal); // HSB: white
     stroke(mappedRadToColorVal, mappedRadToColorVal, mappedRadToColorVal, alphaVal); // RGB: white
      line(x1, y1, x4, y4);

      // ARCS
      noFill();
     //  stroke(255, 255, mappedRadToColorVal, alphaVal); // HSB red
     
     //  stroke(0, 0, mappedRadToColorVal, alphaVal); // HSB: white
       stroke(mappedRadToColorVal, mappedRadToColorVal, mappedRadToColorVal, alphaVal); // RGB: white

      // arc(x4, y4, rad, rad, radians(-theAngle+90 -20), radians(-theAngle+90 + 20) );// this would be correct, but boring
      arc(x4, y4, rad, rad, radians(theAngle - 30), radians(theAngle + 30) );
      
      
     // stroke(0, 0, mappedRadToColorVal, alphaVal*0.25); // HSB: white
      stroke(mappedRadToColorVal, mappedRadToColorVal, mappedRadToColorVal, alphaVal*0.25); // RGB: white
      ellipse(x4, y4, rad*0.55, rad*0.55);
    }

    // SMALL DOTS at the end of the ray lines
    noFill();
    ellipse(x4, y4, 3, 3);


    // --------------------- increase radius
    if (rad<maxRad) {
      rad += growSpeed;
    }
    else {
      // rayIsTouchingAnotherRay = false; // should not be necessary...
      rad = 0;
    }
  } // end update
} // end class

