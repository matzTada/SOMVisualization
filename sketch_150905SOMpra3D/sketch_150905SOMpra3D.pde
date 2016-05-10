/* //<>//
 3 dimentional version
 practice of SOM (self organizing map)
 data is 3 dimensional vector and mapped into the 2 dimensional color cell
 (x, y) is used for index
 */

import processing.opengl.*;


int NUM = 5;

color w [][][] = new color[NUM][NUM][NUM]; //reference vector(map)

color x; //incoming data vector

int tempI = 0;
int tempJ = 0;
int tempK = 0;

float distance;
float tempDistance;

float h; //ratio of merging the incoming vector
float tempRed;
float tempGreen;
float tempBlue;


void setup() {
  size(600, 600, P3D);
  frameRate(60);

  translate(0, 0, -500);
  for (int k = 0; k < NUM; k++) {
    for (int j = 0; j < NUM; j++) {
      for (int i = 0; i < NUM; i++) {
        w[i][j][k] = color(random(0, 255), random(0, 255), random(0, 255));
        pushMatrix();
        stroke(0);
        strokeWeight(1);
        fill(w[i][j][k]);
        translate(i * width / NUM /2, j * width / NUM/2, k * width / NUM/2);
        box(0.5 * width / NUM/2, 0.5 * width / NUM/2, 0.5 * width / NUM/2);
        noStroke();
        popMatrix();
      }
    }
  }

  println("start");
}

void draw() {

  background(0);

  camera(mouseX - width /2, mouseY - height /2, 200, width / NUM /2, width / NUM / 2, 0, 0, 1, 0);

  translate(0, 0, -200);

  for (int k = 0; k < NUM; k++) {
    for (int j = 0; j < NUM; j++) {
      for (int i = 0; i < NUM; i++) {
        pushMatrix();
        stroke(0);
        strokeWeight(1);
        fill(w[i][j][k]);
        translate(i * width / NUM/2, j * width / NUM/2, k * width / NUM/2);
        box(0.5 * width / NUM/2, 0.5 * width / NUM/2, 0.5 * width / NUM/2);
        noFill();
        noStroke();
        popMatrix();
      }
    }
  }

  //draw smallest cell
  pushMatrix();
  stroke(x);
  strokeWeight(5);
  translate(tempI * width / NUM/2, tempJ * width / NUM/2, tempK * width / NUM/2);
  box(0.5 * width / NUM/2, 0.5 * width / NUM/2, 0.5 * width / NUM/2);
  noStroke();
  popMatrix();

  for (int k = tempK - 1; k <= tempK + 1; k++) {
    for (int j = tempJ - 1; j <= tempJ + 1; j++) {
      for (int i = tempI - 1; i <= tempI + 1; i++) {
        pushMatrix();
        stroke(x);
        strokeWeight(5);
        translate(i * width / NUM/2, j * width / NUM/2, k * width / NUM/2);
        box(0.5 * width / NUM/2, 0.5 * width / NUM/2, 0.5 * width / NUM/2);
        noStroke();
        popMatrix();
      }
    }
  }
}

void keyPressed() {
  println("key pressed");
  x = color(random(0, 255), random(0, 255), random(0, 255));

  //search nearest reference vector w
  distance = dist(red(w[tempI][tempJ][tempK]), green(w[tempI][tempJ][tempK]), blue(w[tempI][tempJ][tempK]), red(x), green(x), blue(x));
  println("distance between x and w[tempI][tempJ][tempK]: " + distance);
  for (int k = 0; k < NUM; k++) {
    for (int j = 0; j < NUM; j++) {
      for (int i = 0; i < NUM; i++) {
        tempDistance = dist(red(w[i][j][k]), green(w[i][j][k]), blue(w[i][j][k]), red(x), green(x), blue(x));
        if (tempDistance < distance) {
          tempI = i;
          tempJ = j;
          tempK = k;
          distance = tempDistance;
        }
      }
    }
  }
  println("nearest vector i: " + tempI + " j: " + tempJ + " k: " + tempK + " distance:" + distance);

  //exposure process
  h = 0.3; 

  //w[tempI+-1][tempJ+-1] = (1 - h) * pastW + h * x; //<-I wanna do like this around the
  for (int k = -1; k <= 1; k++) {
    for (int j = -1; j <= 1; j++) {
      for (int i = -1; i <= 1; i++) {
        if (tempI + i >= 0 && tempI + i < NUM 
          && tempJ + j >= 0 && tempJ + j < NUM
          && tempK + k >= 0 && tempK + k < NUM) {
          tempRed = (1 - h) * red(w[tempI + i][tempJ + j][tempK + k]) + h * red(x);
          tempGreen = (1 - h) * green(w[tempI + i][tempJ + j][tempK + k]) + h * green(x);
          tempBlue = (1 - h) * blue(w[tempI + i][tempJ + j][tempK + k]) + h * blue(x);
          w[tempI + i][tempJ + j][tempK + k] = color(tempRed, tempGreen, tempBlue);
        }
      }
    }
  }
}

void mouseClicked() {
  println("mouse clicked");
  for (int k = 0; k < NUM; k++) {
    for (int j = 0; j < NUM; j++) {
      for (int i = 0; i < NUM; i++) {
        w[i][j][k] = color(random(0, 255), random(0, 255), random(0, 255));
      }
    }
  }
}