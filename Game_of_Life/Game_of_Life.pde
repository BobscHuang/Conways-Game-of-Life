boolean[][] cellsNow;
boolean[][] cellsNext;

int cellX = 50;
int cellY = 50;

float padding = 50;
int blinksPerSecond = 10;

float cellSizeX;
float cellSizeY;

int frameNumber;

boolean start;

float buttonXStart = 450;
float buttonYStart = padding / 2;
float buttonWStart = 150;
float buttonHStart = 40;

float buttonXReset = 650;
float buttonYReset = padding / 2;
float buttonWReset = 150;
float buttonHReset = 40;

//Sets up initial values
void setup(){
  size(1500, 1500);
  
  frameNumber = 0;
  
  start = false;
  cellsNow = new boolean[cellX][cellY];
  cellsNext = new boolean[cellX][cellY];
  
  cellSizeX = (width - padding * 2) / cellX;
  cellSizeY = (height - padding * 2) / cellY;
  
  setCellBlank();
  //setCellValuesRandomly();
  frameRate(120);
  updateCell();
}

//Draws the visuals
void draw(){
  background(255, 255, 0);
  
  textAlign(LEFT);
  textSize(30);
  fill(0);
  text("Frame: " + frameNumber, 25, 35);
  
  rectMode(CENTER);
  strokeWeight(2);
  fill(0);
  stroke(255, 0, 0);
  rect(buttonXStart, buttonYStart, buttonWStart, buttonHStart);
  rect(buttonXReset, buttonYReset, buttonWReset, buttonHReset);
  
  textAlign(CENTER, CENTER);
  fill(255);
  if (start == false){
    text("Start", buttonXStart, buttonYStart - 5);
  }
  else{
    text("Stop", buttonXStart, buttonYStart - 5);
  }
  text("Reset", buttonXReset, buttonYReset - 5);
  
  rectMode(CORNER);
  strokeWeight(1);
  stroke(0);
  for (int i = 0; i < cellsNow.length; i++){
    for (int j = 0; j < cellsNow[0].length; j++){
      
      if (cellsNow[i][j] == true){fill(0);}
      else {fill(255);}
      float x = padding + i * cellSizeX;
      float y = padding + j * cellSizeY;
      rect(x, y, cellSizeX, cellSizeY);
    }
  }
  if (start == true){
    updateCell();
    cellReplacement();
    frameNumber++;
  }
}

//Replaces values in cellsNow with values from cellsNext
void cellReplacement(){
  for (int i = 0; i < cellsNow.length; i++){
    for (int j = 0; j < cellsNow[0].length; j++){
      cellsNow[i][j] = cellsNext[i][j];
    }
  }
}

//Fills cellsNow with falses
void setCellBlank(){
  for (int i = 0; i < cellsNow.length; i++){
    for (int j = 0; j < cellsNow[0].length; j++){
      cellsNow[i][j] = false;
    }
  }
}

//Updates cellsNext with information of next generation
void updateCell(){
  for (int i = 0; i < cellsNow.length; i++){
    for (int j = 0; j < cellsNow[0].length; j++){
      int aliveNeighbours = countLivingNeighbours(i, j);
      //println(aliveNeighbours);
      
      if (cellsNow[i][j] == true){
        if (aliveNeighbours == 2 || aliveNeighbours == 3){
          cellsNext[i][j] = true;
        }
        else{
          cellsNext[i][j] = false;
        }
      }
      else{
        if (aliveNeighbours == 3){
          cellsNext[i][j] = true;
        }
      }
    }
  }
}

//Triggers mouse click events
void mouseClicked(){
  if (start == false){
    if ((mouseX > padding && mouseX < width - padding) && (mouseY > padding && mouseY < height - padding)){
      int [] indexes = getClickIndex();
      if (cellsNow[indexes[0]][indexes[1]] == true){
        cellsNow[indexes[0]][indexes[1]] = false;
      }
      else{
        cellsNow[indexes[0]][indexes[1]] = true;
      }
    }
  }
  if ((mouseX > buttonXStart - buttonWStart / 2 && mouseX < buttonXStart + buttonWStart / 2) && (mouseY > buttonYStart - buttonHStart / 2 && mouseY < buttonYStart + buttonHStart / 2)){
    if (start == true){
      start = false;
      frameRate(120);
    }
    else{
      start = true;
      frameRate(blinksPerSecond);
    }
    
  }
  if ((mouseX > buttonXReset - buttonWReset / 2 && mouseX < buttonXReset + buttonWReset / 2) && (mouseY > buttonYReset - buttonHReset / 2 && mouseY < buttonYReset + buttonHReset / 2)){
    setup();
  }
}

//Gets array index of clicked location
int [] getClickIndex(){
  int indexX = int((mouseX - padding) / cellSizeX);
  int indexY = int((mouseY - padding) / cellSizeY);
  int [] indexes = {indexX, indexY};
  return indexes;
}

//Counts number(s) of live neighbours 
int countLivingNeighbours(int x, int y){
  int count = 0;
  
  for (int i = -1; i <= 1; i++){
    for (int j = -1; j <= 1; j++){
      
      try {
        if ((cellsNow[x + j][y + i] == true) && (j != 0 || i != 0)){
        count++;
        }
      }
      catch (ArrayIndexOutOfBoundsException e){}
    }
  }
  return count;
}

//Sets random initial values for cellsNow
void setCellValuesRandomly(){
  for (int i = 0; i < cellsNow.length; i++){
    
    for (int j = 0; j < cellsNow[0].length; j++){
      int x = round(random(0,1));
      
      if (x == 0){cellsNow[i][j] = true;}
      
      else{cellsNow[i][j] = false;}
    }
  }
}