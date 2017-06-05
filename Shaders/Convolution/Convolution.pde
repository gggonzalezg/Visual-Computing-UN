/*
* SHADERS WORKSHOP --> HARDWARE VS. SOFTWARE CONVOLUTIONS
* GABRIEL GIOVANNI GONZALEZ GALINDO
* CONVOULTION KERNELS TUTORIAL AVAILABLE HERE: http://lodev.org/cgtutor/filtering.html
* CODE ADDAPTED FROM EXAMPLE DEVELOPPED BY Daniel Shiffman.
* CODE AVAILABLE HERE: https://processing.org/examples/convolution.html
*/
PImage img;
int w = 240;
boolean hw = true;
int currentconvolution = 1;
PShader selShader;
int fcount, lastm;
float frate;
int fint = 3;

int convolutionSW = 3;
float[][] edgesColor = {{ -1, -1, -1 }, { -1,  9, -1 }, { -1, -1, -1 }};
float[][] edgesBH =  {{ -1, -1, -1 }, { -1,  8, -1 }, {-1, -1, -1 }};
float[][] emboss = {{ -1, -1,  0 }, { -1, 0, 1 }, { 0, 1,  1}};
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
  if(hw) convolutionHW();
  else convolutionSW();
}

void keyPressed() {
  if (key == ' '){
    if (hw) currentconvolution = currentconvolution < convolutionSW ? currentconvolution+1 : 1;
    else currentconvolution = currentconvolution < convolutionHW ? currentconvolution+1 : 1;
  }
  if (key == 's' || key == 'S')
  hw = !hw;
}

void convolutionHW(){
  resetShader();
  int matrixsize = 3;
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
    println("fps: " + frate);
  }
  fill(0);
  text("fps: " + frate, 10, 20);
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

      switch(currentconvolution){
        case 1:
        rtotal +=  (red(img.pixels[loc]) * edgesBH[i][j]);
        gtotal +=  (green(img.pixels[loc]) * edgesBH[i][j]);
        btotal +=  (blue(img.pixels[loc]) * edgesBH[i][j]);
        factor = 1.0;
        bias = 1.0;
        break;
        case 2:
        rtotal += (red(img.pixels[loc]) * emboss[i][j]);
        gtotal += (green(img.pixels[loc]) * emboss[i][j]);
        btotal += (blue(img.pixels[loc]) * emboss[i][j]);
        factor = 1.0;
        bias = 128.0;
        break;
        case 3:
        rtotal += (red(img.pixels[loc]) * edgesColor[i][j]);
        gtotal += (green(img.pixels[loc]) * edgesColor[i][j]);
        btotal += (blue(img.pixels[loc]) * edgesColor[i][j]);
        factor = 1.0;
        bias = 1.0;
        break;
      }
    }
  }
  rtotal = constrain(factor*rtotal+bias, 0, 255);
  gtotal = constrain(factor*gtotal+bias, 0, 255);
  btotal = constrain(factor*btotal+bias, 0, 255);
  return color(rtotal, gtotal, btotal);
}

void convolutionSW() {
  if(currentconvolution == 1) shader(edgesShader);
  else shader(embossShader);
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate);
  }
  fill(0);
  text("fps: " + frate, 10, 20);
}
