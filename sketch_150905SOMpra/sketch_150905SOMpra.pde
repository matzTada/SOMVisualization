/*
http://gaya.jp/spiking_neuron/som.htm
 practice of SOM (self organizing map)
 data is 3 dimensional vector and mapped into the 2 dimensional color cell
 (x, y) is used for index
 */


int NUM = 25;

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
  size(600, 600);

  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      w[i][j] = color(random(0, 255), random(0, 255), random(0, 255));
      fill(w[i][j]);
      rect(i * width / NUM, j * height / NUM, width / NUM, width / NUM);
      noFill();
      print(hex(w[i][j]) + " ");
    }
    println(" ");
  }

  println("start");
}

void draw() {
  //draw all cell
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      fill(w[i][j]);
      rect(i * width / NUM, j * height / NUM, width / NUM, width / NUM);
      noFill();
    }
  }

  //draw smallest cell
  stroke(x);
  strokeWeight(5);
  rect(tempI * width / NUM, tempJ * height / NUM, width / NUM, width / NUM);
  strokeWeight(5);
  rect((tempI-1) * width / NUM, (tempJ-1) * height / NUM, 3 * width / NUM, 3 * width / NUM);
  noStroke();
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
      if (tempI + i >= 0 && tempI + i < NUM && tempJ + j >= 0 && tempJ + j < NUM) {
        tempRed = (1 - h) * red(w[tempI + i][tempJ + j]) + h * red(x);
        tempGreen = (1 - h) * green(w[tempI + i][tempJ + j]) + h * green(x);
        tempBlue = (1 - h) * blue(w[tempI + i][tempJ + j]) + h * blue(x);
        w[tempI + i][tempJ + j] = color(tempRed, tempGreen, tempBlue);
      }
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