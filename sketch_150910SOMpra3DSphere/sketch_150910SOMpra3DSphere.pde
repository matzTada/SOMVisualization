/*
http://gaya.jp/spiking_neuron/som.htm
 practice of SOM (self organizing map)
 data is 3 dimensional vector and mapped into the 2 dimensional color cell
 (x, y) is used for index
 */


int NUM = 10;

color w [][] = new color[NUM][NUM]; //reference vector(map)

color x; //incoming data vector

int tempI = 0;
int tempJ = 0;  

float distance;
float tempDistance;

float h; //ratio of merging the incoming vector
float tempRed;
float tempGreen;
float tempBlue;

void setup() {
  size(600, 600, P3D);
  frameRate(60);

  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      w[i][j] = color(random(0, 255), random(0, 255), random(0, 255));
      print(hex(w[i][j]) + " ");
    }
    println(" ");
  }

  println("start");
}

void draw() {
  background(0);

  //drawAxis
  stroke(255);
  fill(255);
  textSize(20);
  text("x-axis", 500, 0, 0);
  line(0, 0, 0, 500, 0, 0);
  text("y-axis", 0, 500, 0);
  line(0, 0, 0, 0, 500, 0);
  text("z-axis", 0, 0, 500);
  line(0, 0, 0, 0, 0, 500);
  noFill();
  noStroke();

  camera(mouseX - width /2, mouseY - height /2, 200, width / NUM /2, width / NUM / 2, 0, 0, 1, 0);

  //draw all cell
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      pushMatrix();
      translate(
        50 * cos ((float)2 * PI * i / NUM) * sin ((float)PI * j / NUM), 
        50 * sin ((float)2 * PI * i / NUM) * sin ((float)PI * j / NUM), 
        50 * cos ((float)PI * j / NUM));
      fill(w[i][j]);
      sphere(0.1 * width / NUM);
      noFill();
      popMatrix();
    }
  }

  //draw smallest cell
  pushMatrix();
  stroke(x, 100);
  strokeWeight(1);
  translate(
    50 * cos ((float)2 * PI * tempI / NUM) * sin ((float)PI * tempJ / NUM), 
    50 * sin ((float)2 * PI * tempI / NUM) * sin ((float)PI * tempJ / NUM), 
    50 * cos ((float)PI * tempJ / NUM)); 
  sphere(0.2 * width / NUM);
  noStroke();
  popMatrix();

  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      int temptempI = tempI + i;
      int temptempJ = tempJ + j;
      if (tempI + i < 0) temptempI = NUM -1;
      if (tempI + i >= NUM)temptempI = 0;
      if (tempJ + j < 0) temptempJ = NUM - 1;
      if (tempJ + j >= NUM) temptempJ = 0;
      pushMatrix();
      stroke(x, 100);
      strokeWeight(1);
      translate(
        50 * cos ((float)2 * PI * temptempI / NUM) * sin ((float)PI * temptempJ / NUM), 
        50 * sin ((float)2 * PI * temptempI / NUM) * sin ((float)PI * temptempJ / NUM), 
        50 * cos ((float)PI * temptempJ / NUM));
      sphere(0.2 * width / NUM);
      noStroke();
      popMatrix();
    }
  }
}

void keyPressed() {
  println("key pressed: " + key);

  x = color(random(0, 255), random(0, 255), random(0, 255));

  //search nearest reference vector w
  distance = dist(red(w[tempI][tempJ]), green(w[tempI][tempJ]), blue(w[tempI][tempJ]), red(x), green(x), blue(x));
  println("distance between x and w[tempI][tempJ]: " + distance);
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      tempDistance = dist(red(w[i][j]), green(w[i][j]), blue(w[i][j]), red(x), green(x), blue(x));
      if (tempDistance < distance) {
        tempI = i;
        tempJ = j;
        distance = tempDistance;
      }
    }
  }
  println("nearest vector i: " + tempI + " j: " + tempJ + " distance:" + distance);

  //exposure process
  h = 0.3; 

  //w[tempI+-1][tempJ+-1] = (1 - h) * pastW + h * x; //<-I wanna do like this around the
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      int temptempI = tempI + i;
      int temptempJ = tempJ + j;
      if (tempI + i < 0) temptempI = NUM -1;
      if (tempI + i >= NUM)temptempI = 0;
      if (tempJ + j < 0) temptempJ = NUM - 1;
      if (tempJ + j >= NUM) temptempJ = 0;
      tempRed = (1 - h) * red(w[temptempI][temptempJ]) + h * red(x);
      tempGreen = (1 - h) * green(w[temptempI][temptempJ]) + h * green(x);
      tempBlue = (1 - h) * blue(w[temptempI][temptempJ]) + h * blue(x);
      w[temptempI][temptempJ] = color(tempRed, tempGreen, tempBlue);
    }
  }
}



void mouseClicked() {
  println("mouse clicked");
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      w[i][j] = color(random(0, 255), random(0, 255), random(0, 255));
    }
  }
}