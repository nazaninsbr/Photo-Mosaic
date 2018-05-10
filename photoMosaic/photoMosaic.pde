PImage target; 
PImage smallerTarget;
PImage [] allImages;
float[] brightness;
PImage [] brightImages;
int scalefactor = 8; 
int w, h; 

File[] listFiles(String dir){
  File file = new File(dir);
  if (file.isDirectory()){
    File[] files = file.listFiles();
    return files;
  }else {
   return null; 
  }
}

void setup(){
  size(600, 862);
  target = loadImage("../images/target.jpg");
  
  File[] files = listFiles(sketchPath("../images/all"));
  //printArray(files[0].toString());
  allImages = new PImage[files.length-1];
  brightness = new float[allImages.length];
  for(int i=0; i<allImages.length; i++){
    String filename = files[i+1].toString();
    if(filename.endsWith(".jpg") || filename.endsWith(".jpeg") || filename.endsWith(".png") ) {
      PImage img = loadImage(filename);
      allImages[i] = createImage(scalefactor, scalefactor, RGB);
      allImages[i].copy(img, 0, 0, img.width, img.height, 0, 0, scalefactor, scalefactor);
      allImages[i].loadPixels();
      float avg = 0;
      for(int j=0; j<allImages[i].pixels.length; j++){
        float b = brightness(allImages[i].pixels[j]);
        avg += b;
      }
      avg /= allImages[i].pixels.length;
      brightness[i] = avg;
   }
  }
  
  brightImages = new PImage[256];
  for(int i=0; i<brightImages.length; i++){
    float record = 256; 
    brightImages[i] = allImages[0];
    for(int j=0; j<allImages.length; j++){
      float diff = abs(i - brightness[j]);
      if (diff < record){
        record = diff; 
        brightImages[i] = allImages[j];
      }
    }
  }
  
  
  w = target.width/scalefactor;
  h = target.height/scalefactor;

  
  smallerTarget = createImage(w, h, RGB);
  smallerTarget.copy(target, 0, 0, target.width, target.height, 0, 0, w, h);
}

void draw(){
  background(0);
  smallerTarget.loadPixels();
  for (int x=0; x<w; x++){
    for(int y=0; y<h; y++){
      int index = x + y*w;
      color c = smallerTarget.pixels[index];
      int val = int(brightness(c));
      //fill(c);
      //noStroke();
      //rect(x*scalefactor, y*scalefactor, scalefactor, scalefactor);
      int keepGoing = 1;
      while(keepGoing==1){
        if(brightImages[val] != null){ 
          image(brightImages[val], x*scalefactor, y*scalefactor, scalefactor, scalefactor);
          keepGoing = 0; 
        } else {
          val += 1;
        }
      }
    }
  }
  save("../results/result5.jpg");
  //image(smallerTarget, 0, 0);
  noLoop();
}