/*
SHADERS WORKSHOP
CONVOLUTION GABRIEL GONZÁLEZ
TUTORIAL AVAILABLE HERE: http://lodev.org/cgtutor/filtering.html
CODE ADDAPTED FROM EXAMPLE DEVELOPPED BY Daniel Shiffman.
CODE AVAILABLE HERE: https://processing.org/examples/convolution.html
*/

PImage img;
int w = 600;

boolean hw = true;
int convolutionHW = 2;
int currentconvolutionHW = 1;
float[][] edgesColor = {{ -1, -1, -1 }, { -1,  9, -1 }, { -1, -1, -1 }};
float[][] edgesBH =  {{ -1, -1, -1 }, { -1,  8, -1 }, {-1, -1, -1 }};
float[][] emboss = {{ -1, -1,  0 }, { -1, 0, 1 }, { 0, 1,  1}};

PShader selShader;

int convolutionSW = 3;
int currentconvolutionSW = 1;
PShader bwShader;
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

void convolutionHW(){
  resetShader();
  int xstart = constrain(mouseX - w/2, 0, img.width);
  int ystart = constrain(mouseY - w/2, 0, img.height);
  int xend = constrain(mouseX + w/2, 0, img.width);
  int yend = constrain(mouseY + w/2, 0, img.height);
  int matrixsize = 3;
  loadPixels();
  for (int x = xstart; x < xend; x++) {
    for (int y = ystart; y < yend; y++ ) {
      color c = convolution(x, y, edgesColor, matrixsize, img, currentconvolutionHW);
      int loc = x + y*img.width;
      pixels[loc] = c;
    }
  }
  updatePixels();
}

void keyPressed() {
  if (key == ' ')
    currentconvolutionHW = currentconvolutionHW < convolutionHW ? currentconvolutionHW+1 : 1;
    currentconvolutionSW = currentconvolutionSW < convolutionSW ? currentconvolutionSW+1 : 1;
  if (key == 's' || key == 'S')
    hw = !hw;
}

color convolution(int x, int y, float[][] edgesColor, int matrixsize, PImage img, int currentconvolutionHW)
{
  float rtotal = 0.0, gtotal = 0.0, btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;

      loc = constrain(loc,0,img.pixels.length-1);

      switch(currentconvolutionHW){
        case 1:
        rtotal += (red(img.pixels[loc]) * edgesBH[i][j]);
        gtotal += (green(img.pixels[loc]) * edgesBH[i][j]);
        btotal += (blue(img.pixels[loc]) * edgesBH[i][j]);
        break;
        case 2:
        rtotal += (red(img.pixels[loc]) * emboss[i][j]);
        gtotal += (green(img.pixels[loc]) * emboss[i][j]);
        btotal += (blue(img.pixels[loc]) * emboss[i][j]);
        break;
        case 3:
        rtotal += (red(img.pixels[loc]) * edgesColor[i][j]);
        gtotal += (green(img.pixels[loc]) * edgesColor[i][j]);
        btotal += (blue(img.pixels[loc]) * edgesColor[i][j]);
        break;
      }
    }
  }
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  return color(rtotal, gtotal, btotal);
}

void convolutionSW() {
  if(currentconvolutionSW == 1) shader(edgesShader);
  else shader(embossShader);
}
