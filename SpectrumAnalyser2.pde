import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput input;
FFT fft;

int numPoints;
float power;
float x;
int bg = 0;

void setup() {
  size(displayWidth/2, displayHeight/2);
  background(bg);
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 1024);
  fft = new FFT(input.bufferSize(), input.sampleRate());
  numPoints = fft.specSize();
  noStroke();
  colorMode(HSB);
}

void draw() {

  //fill(0,10);
  //rect(0,0,width,height);
  fft.forward(input.mix); 
  numPoints = fft.specSize();
  fill(bg);
  rect(x,0,1,height); //overwriting current "band"
  for (int i=0; i < numPoints; i++) {
    //how loud is this frequency band?
    power = fft.getBand(i) * 100;
    if (power > 0) {
      power = (log(power)/ log(10) * 0.66);

      //does it nog have a negative power?
      fill(power * 255, power * 255,100,power * 255);
      float startingpointy = 10;
      if (i != 0) {
        startingpointy = (sqrt(i*(3.5 * width))) + startingpointy; //calculating the height of the new rect
      }
      if (power > 0.1) rect(x, height - startingpointy, 1, (100/(i+1)+1));
    }
  }
  x += 1; // to the right to the right...
  println(x);
  if (x > width) {
    
   x = 0; 
  }
}

