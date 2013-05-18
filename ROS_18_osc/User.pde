class User {

  // -------------------------- general fields
  int ID;
  float x, y;
  boolean isActive = false;

  // -------------------------- array of Rays (so that every Ray can have it's own direction)
  Ray[] rays = new Ray[RAY_AMOUNT];


  // -------------------------- fields for the menu
  float userRad = USER_RADIUS_FOR_TESTING_AND_GRABBING;
  // boolean active = false;
  User[] others;
  int closestNeighbourID;
  float minDist;
  float alphaVal = 20;


  // -------------------------- fields for checking the rays of other users
  float userMinDistanceToCheckRays = 500;
  float rayMinDistanceToEachOther = 80;


  User(int _ID, float _x, float _y, User[] _others) {

    ID = _ID;
    x = _x;
    y = _y;
    others = _others;

    // -------------------------- menu
    closestNeighbourID = ID;  

    // -------------------------- create the Ray array
    for (int i=0; i<RAY_AMOUNT; i++) {
      rays[i] = new Ray(i, x, y);
    }
  }


  void update() {
    if (isActive) {
      if (DEBUG_MODE) displayMenu();

      if (DEBUG_MODE) {
        fill(0, 0, 255); // HSB: white 
        text("ID: "+ ID, x, y);
      }


      // ---------------------------------------------------- update rays
      for (int i=0; i<RAY_AMOUNT; i++) {
        rays[i].update(x, y);
      }

      // ---------------------------------------------------- loop through all the other users
      //  _this_ rays are checking the rays of the _other_ user
      //  if the end points are close, then some ELEMENT should be drawn as a visual feedback
      for (int i=ID+1; i<currentUserCount; i++) {
        // first check if the other user is close, if yes, then the rays of the users should be checked

        if (i==ID) continue; // the user should not check itself
        if ( !others[i].isActive ) continue;


        float user_dh = abs(x - others[i].x);
        if (user_dh < userMinDistanceToCheckRays) {
          // also check dv:

          float user_dv = abs(y - others[i].y);
          if (user_dv < userMinDistanceToCheckRays) {

            // ----------------------------------------------------
            // HERE: users are close enogh, so the rays can now be checked
            // TEST: VISUAL FEEDBACK on upper left corner if users are close enough

            fill(0, 255, 255);
            if (DEBUG_MODE) ellipse(50, 50, 10, 10);

            // ---------------------------------------------------- THIS rays check OTHER rays
            for (int r=0; r<RAY_AMOUNT; r++) { // this loops through own rays
              // this, ray number i has position: getEndPos()

              for (int s=0; s<RAY_AMOUNT; s++) {
                // others, ray number j has postion: others[j].getEndPos();

                // vector from THIS end of ray to OTHER end of ray ("ends" are: x4, y4)
                PVector  v1 = rays[r].getEndPos();
                PVector  v2 = others[i].rays[s].getEndPos();
                //float d = v1.dist(v2);
                float dsq = (v1.x-v2.x)*(v1.x-v2.x) + (v1.y-v2.y)*(v1.y-v2.y);

                // ---------------------------------------------------- RAY-ENDs ARE CLOSE to each other!
                if (dsq < rayMinDistanceToEachOther*rayMinDistanceToEachOther) {



                  // ---------------------------------------------------- VISUAL FEEDBACK: 
                  //  // draw the CONTACT ELEMENT directly here:

                  // DRAW THIS:
                  float tempAlpha = rays[r].alphaVal; 
                  float tempMappedRadToColorVal = rays[r].mappedRadToColorVal;

                  // SMALL ELLIPSE
                  stroke(255, 255, 255, tempAlpha); // RGB: white
                  noFill();
                  ellipse( v1.x, v1.y, 3, 3); 

                  



                  // draw blurred dot
                  
                  
                  //tint(255, 255, 255, 10); // RGB: white
                   color c_this = rays[r].myColor;
                   tint(  red(c_this), green(c_this), blue(c_this), 10 );
                   
                  
                  image(img, v1.x, v1.y, 500, 500);


                  // draw OTHER
                  tempAlpha = others[i].rays[s].alphaVal;
                  tempMappedRadToColorVal = others[i].rays[s].mappedRadToColorVal;



                  // SMALL ELLIPSE
                  stroke(255, 255, 255, tempAlpha); // RGB: white
                  noFill();
                  ellipse( v1.x, v1.y, 3, 3); 

                  // draw blurred dot
                  //tint(255, 255, 255, 10); // RGB: white
                  color c_other = others[i].rays[s].myColor;
                   tint(  red(c_other), green(c_other), blue(c_other), 10 );
                  
                  image(img, v2.x, v2.y, 500, 500);
                }
              } // end for(int j=0; j<RAY_AMOUNT; j++)
            } // end for(int i=0; i<RAY_AMOUNT; i++)

            // ----------------- end if loop through rays
          }// end if(user_dv < userMinDistanceToCheckRays)
        } // end if(user_dh < userMinDistanceToCheckRays)
      }// end for(i=0; i<currentUserCount; i++)
    } // end if(isActive){
  } // end void update()



  void drawBlurredEllipse(float _x, float _y, float _size, float _tempAlpha) {

    fill(0, 0, 255, _tempAlpha/10.); // HSB: white
    noStroke();

    ellipse(_x, _y, _size, _size);
    ellipse(_x, _y, _size*0.5, _size*0.5);
    ellipse(_x, _y, _size*0.4, _size*0.4);
    ellipse(_x, _y, _size*0.3, _size*0.3);
    ellipse(_x, _y, _size*0.2, _size*0.2);
  }




  // -----------------------------------------
  // MENU
  // -----------------------------------------

  void displayMenu() {

    noFill();
    stroke(255, 255, 255, alphaVal);
    ellipse(x, y, userRad*2, userRad*2);

    checkShortestDist();

    if (SHOW_CONNECTING_LINES) {  
      stroke(255, alphaVal);
      line(x, y, users[closestNeighbourID].x, users[closestNeighbourID].y);
    }
  }

  void checkShortestDist() {

    minDist = -1;
    for (int i=0; i< currentUserCount; i++) {
      if (i==ID) continue;

      float tempD = dist(x, y, others[i].x, others[i].y);

      if (minDist < 0  || tempD < minDist) 
      { 
        closestNeighbourID = i; // set closet neighbourID
        minDist = tempD;
      }
    }

    // println("ID" + ID + "got closest neighbour " + closestNeighbourID);

    //  return( minDist );
  } // end checkShortestDist

  boolean mouseOver() {
    if ( mouseX > x-userRad && mouseX < x+userRad && mouseY > y-userRad && mouseY < y+userRad  ) {
      return true;
    }
    else {
      return false;
    }
  }// end boolean mouseOVer



  // ----------------------------------------- END MENU
} // end class User

