/*
* SHADERS WORKSHOP --> HARDWARE VS. SOFTWARE CONVOLUTIONS
* GABRIEL GIOVANNI GONZALEZ GALINDO
* CONVOULTION KERNELS TUTORIAL AVAILABLE HERE: http://lodev.org/cgtutor/filtering.html
* CODE ADDAPTED FROM EXAMPLE DEVELOPPED BY Daniel Shiffman.
* CODE AVAILABLE HERE: https://processing.org/examples/convolution.html
*/
PImage img;
boolean sw = true, applyFilter = false;
int currentconvolution = 1;
PShader selShader;
int fcount, lastm;
float frate;
int fint = 3, n = 1;

int convolutionSW = 4;
float[][] edgesColor = {{ -1, -1, -1 }, { -1,  9, -1 }, { -1, -1, -1 }};
float[][] edgesBH =  {{ -1, -1, -1 }, { -1,  8, -1 }, {-1, -1, -1 }};
float[][] emboss = {{ -1, -1,  0 }, { -1, 0, 1 }, { 0, 1,  1}};
float[][] emboss5 = {{ -1, -1, -1, -1, 0}, { -1, -1, -1, 0, 1}, {-1, -1, 0, 1, 1}, {-1, 0, 1, 1, 1}, {0, 1, 1, 1, 1}};
float[][] kernel;
float factor = 1.0;
float bias =1.0;

int convolutionHW = 2;
PShader edgesShader;
PShader embossShader;

void setup() {
  size(1000, 650, P2D);
  img = loadImage("bogota.jpg");
  edgesShader = loadShader("edgesfrag.glsl");
  embossShader = loadShader("embossfrag.glsl");
  frameRate(1000);
}

void draw() {
  image(img, 0, 0);
  switch(currentconvolution){
    case 1:
    kernel= edgesBH;
    factor = 1.0;
    bias = 1.0;
    break;
    case 2:
    kernel= emboss;
    factor = 1.0;
    bias = 128.0;
    break;
    case 3:
    kernel= edgesColor;
    factor = 1.0;
    bias = 1.0;
    break;
    case 4:
    kernel= emboss5;
    factor = 1.0;
    bias = 128.0;
    break;
  }

  if(applyFilter){
    if(sw){
      for (int i = 0 ; i < n; i++)
        convolutionSW();
    }
    else{
      for (int i = 0 ; i < n; i++)
        convolutionHW();
    }
  }
}

void keyPressed() {
  if (key == ' '){
    if (sw) currentconvolution = currentconvolution < convolutionSW ? currentconvolution+1 : 1;
    else currentconvolution = currentconvolution < convolutionHW ? currentconvolution+1 : 1;
  }
  if(key == 's' || key == 'S')
    sw = !sw;
  if(key == 'a' || key == 'A')
    n++;
  if(key == 'd' || key == 'D')
    n--;
  if(key == 'r' || key == 'R')
    n = 1;
}

void mousePressed() {
  applyFilter = !applyFilter;
}

void convolutionSW(){
  resetShader();
  int matrixsize = kernel.length;
  loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      color c = convolution(x, y, edgesColor, matrixsize, img, currentconvolution);
      int loc = x + y*img.width;
      pixels[loc] = c;
    }
  }
  updatePixels();
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate + "  It: " + n + "  Software(" + currentconvolution + ")");
  }
}


color convolution(int x, int y, float[][] edgesColor, int matrixsize, PImage img, int currentconvolution)
{
  float rtotal = 0.0, gtotal = 0.0, btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      loc = constrain(loc,0,img.pixels.length-1);

      rtotal +=  (red(img.pixels[loc]) * kernel[i][j]);
      gtotal +=  (green(img.pixels[loc]) * kernel[i][j]);
      btotal +=  (blue(img.pixels[loc]) * kernel[i][j]);
    }
  }
  rtotal = constrain(factor*rtotal+bias, 0, 255);
  gtotal = constrain(factor*gtotal+bias, 0, 255);
  btotal = constrain(factor*btotal+bias, 0, 255);
  return color(rtotal, gtotal, btotal);
}

void convolutionHW() {
  if(currentconvolution == 1){
    filter(edgesShader);

    fcount += 1;
    int m = millis();
    if (m - lastm > 1000 * fint) {
      frate = float(fcount) / fint;
      fcount = 0;
      lastm = m;
      println("fps: " + frate + "  It: " + n + "  Hardware(" + currentconvolution + ")");
    }
    fill(0);
    text("fps: " + frate, 10, 20);
  }
  else{
    filter(embossShader);

    fcount += 1;
    int m = millis();
    if (m - lastm > 1000 * fint) {
      frate = float(fcount) / fint;
      fcount = 0;
      lastm = m;
      println("fps: " + frate + "  It: " + n + "  Hardware(" + currentconvolution + ")");
    }
  }
}
