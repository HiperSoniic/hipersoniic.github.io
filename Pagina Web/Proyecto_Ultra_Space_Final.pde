import ddf.minim.*;
import processing.serial.*;
Minim minim;
AudioPlayer Sonido, Choque;

char valor;
int DistUlt;
int IncomingDistance;
int i;
int mse =0;
int se =0;
int min = 0;
int f_size = 14;
PImage fondo;
int fondox, fondoy;
PImage OvniImg;
PImage fondo0;
PImage fondo1;
PImage fondo2;
PImage explosion;
PImage explosionovni;
float aumX= width;
float aumY= height;
float movfondoX= 0;
PImage sprite;
//Estados de juego
boolean tiempo=false, gamestarted=false, CargarJuego=false;
boolean gamePausado = true;

Bala bala;
Pelotita [] p;
Serial myPort;
String DataIn;  
Rect p1 = new Rect();
Rect p2 = new Rect();
Rect p3 = new Rect();
Rect p4 = new Rect();
Rect p5 = new Rect();
Rect p6 = new Rect();
Rect p7 = new Rect();
int numDePelot = 30;
float birdy = 46;
float birdx = 56;
float gravedad;
//the speed of the pipes
int vel;
//score and game state
boolean perder = false;
int puntaje = 0;
int mayorPuntuacion = 0;
int point = 1;

ArrayList <Proyectil> misiles;
ArrayList <Enemigo>  banda;

void setup() {
  size(1080, 720);
  vel= 2;
  p1.x = width + 50;
  p2.x = width + 220;
  p3.x = width + 370;
  p4.x = width + 539;
  p5.x = width + 708;
  p6.x = width + 877;
  p7.x = width + 1046;
  minim =new Minim(this);
  Sonido = minim.loadFile("musica.wav");
  Choque = minim.loadFile("explosion.wav");
  //musica = new SoundFile(this, "musica.wav");
  //musica.loop();
  //Sonido.play();
  // Sonido.loop();
  //sonexplosion = new SoundFile(this, "explosion.wav");
  //fondo0 = loadImage ("Fondo0.png");
  //fondo1 = loadImage ("Fondo1.png");
  //fondo2 = loadImage ("Fondo2.png");
  OvniImg= loadImage("OvniFlappy.png");
  fondo = loadImage ("Fondo.png");
  sprite = loadImage ("BalaSprite.png");
  explosion = loadImage ("Explosion.png");
  explosionovni = loadImage ("explosionovni.png");
  OvniImg.resize (30, 30);

  myPort = new Serial(this, "COM7", 9600);
  myPort.bufferUntil(10);
  p = new Pelotita[numDePelot];
  for (int i = 0; i < numDePelot; i++) {
    p[i] = new Pelotita();
  }

  i = 0;
  misiles = new ArrayList <Proyectil>();
  banda = new ArrayList<Enemigo>();
}
void serialEvent (Serial myPort) {
  DataIn = myPort.readString();
  println(DataIn);
  IncomingDistance = int(trim(DataIn));
  println("Distancia de aproximación="+IncomingDistance);
  if (IncomingDistance>2 && IncomingDistance<100 ) { 
    DistUlt = IncomingDistance; //save the value only if its in the range 1 to 100 } }
  }
}

void draw() {
  //////////BOTON/////////
  //while (myPort.available()>0) {
  //  int lectura=myPort.read();
  //  valor=char(lectura);
  //  if (valor=='a') {
  //    for (int i = misiles.size()-1; i>=0; i-- ) {
  //      Proyectil p = misiles.get(i);
  //      p.mover();
  //      p.mostrar();
  //      if (p.pos.x>width) {
  //        misiles.remove(i);
  //      }
  //    }
  //    for (int i = banda.size()-1; i>=0; i-- ) {
  //      Enemigo e = banda.get(i);
  //      e.mover();
  //      e.mostrar();

  //      if ( dist (e.pos.x, e.pos.y, birdx, birdy )<e.largo) { 
  //        perder=true;
  //      }

  //      for (int j = misiles.size()-1; j>=0; j-- ) {
  //        Proyectil p = misiles.get(j);
  //        if ( dist (p.pos.x, p.pos.y, e.pos.x, e.pos.y )<e.largo) { 
  //          println(misiles.size(), banda.size());
  //          image (explosionovni, e.pos.x, e.pos.y);
  //          banda.remove(i);
  //          misiles.remove(j);
  //          Choque.play();
  //          Choque.rewind();
  //        }
  //      }
  //    }
  //  }
  //////////BOTON/////////
    image(fondo, fondox, fondoy);
    image(fondo, fondox + fondo.width, fondoy);
    fondox = fondox -1;
    if (fondox < -fondo.width)
    {
      fondox = 0;
    }
    if (gamestarted == false) {
      textAlign(CENTER, CENTER);
      textSize(f_size + 35);
      text("Ultra Space", width/2, height / 2 - 180);
      textSize(f_size);
      text("Presiona click 1 vez para comenzar el juego", width / 2, height / 2 + 75);  
      Sonido.pause();
      //text("", width / 2 - 100, height / 2 + 200);
    }

    //image (fondo0, 0, 0);
    //image (fondo1, movfondoX-=0.5, 0);
    //image (fondo2, movfondoX, 0); 
    //image (fondo1, 0, 0);
    //image (fondo2, 0, 0); 
    //if (movfondoX==500) {
    //  image (fondo1, -100, 0);
    //  image (fondo2, -100, 0);
    //}
    for (int i = 0; i < numDePelot; i++) {
      p[i].mostrar();
      p[i].mover();
    }
    p1.Rect2();
    p2.Rect2();
    p3.Rect2();
    p4.Rect2();
    p5.Rect2();
    p6.Rect2();
    p7.Rect2();
    //nave_enemiga.mover();
    //nave_enemiga2.mover();
    //nave_enemiga.mostrar();
    //if (nave_enemiga2.nacer()) {
    //  nave_enemiga2= new  NaveEnemiga();
    //}
    //if (nave_enemiga.nacer()) {
    //  nave_enemiga= new  NaveEnemiga();
    //}


    //ellipse(birdx, birdy, 20,20);
    jugar();
    success(p1);
    success(p2);
    success(p3);
    success(p4);
    success(p5);
    success(p6);
    success(p7);

    //TIEMPO/////////////////////////
    if (tiempo==true) {
      textAlign(CENTER);
      textSize(30);
      if (mse <=59) {
        text(min+":"+se, width/2, 20);
        mse = mse+1;
      } 
      if (mse >= 59) {
        se=se+1;
        println(se);
        mse = 0; 
        text(min+":"+se, width/2, 20);
        println(se);
      } else if (se >=59) {
        se = 0;
        min = min+1;
        text(min+":"+se, width/2, 20);
      }
    }}
    //TIEMPO///////////////////////////
    //if (Key_w == true) {
    //  {
    //    birdy = birdy-8;
    //  }
    //}
    //if (IncomingDistance>10)
    //{
    //  //birdy -= jumpForce;
    //  birdy -= gravedad;
    //} else
    //{
    //  birdy += gravedad;
    //}

    //for (int i = misiles.size()-1; i>=0; i-- ) {
    //  Proyectil p = misiles.get(i);
    //  p.mover();
    //  p.mostrar();
    //  if (p.pos.x>width) {
    //    misiles.remove(i);
    //  }
    //}
    //for (int i = banda.size()-1; i>=0; i-- ) {
    //  Enemigo e = banda.get(i);
    //  e.mover();
    //  e.mostrar();

    //  for (int j = misiles.size()-1; j>=0; j-- ) {
    //    Proyectil p = misiles.get(j);
    //    if ( dist (p.pos.x, p.pos.y, e.pos.x, e.pos.y )<e.largo) { 
    //      banda.remove(i);
    //      misiles.remove(j);
    //    }
    //  }
    //}
    //if (random(25)<1)banda.add(new Enemigo(width, random(height)));
  


  void jugar() {

    if (CargarJuego == true) {
      if (perder == false)
      {

        tiempo = true;
        if ((se==30||se==59) && (mse==0)) {
          vel += 1;
          //Enemigo e;
          //e.vel +=0.5;
        }
        //if (mayorPuntuacion > 2) {
        //  vel = 100;
        //}
        for (int i = misiles.size()-1; i>=0; i-- ) {
          Proyectil p = misiles.get(i);
          p.mover();
          p.mostrar();
          if (p.pos.x>width) {
            misiles.remove(i);
          }
        }
        for (int i = banda.size()-1; i>=0; i-- ) {
          Enemigo e = banda.get(i);
          e.mover();
          e.mostrar();

          if ( dist (e.pos.x, e.pos.y, birdx, birdy )<e.largo) { 
            perder=true;
          }

          for (int j = misiles.size()-1; j>=0; j-- ) {
            Proyectil p = misiles.get(j);
            if ( dist (p.pos.x, p.pos.y, e.pos.x, e.pos.y )<e.largo) { 
              println(misiles.size(), banda.size());
              image (explosionovni, e.pos.x, e.pos.y);
              banda.remove(i);
              misiles.remove(j);
              Choque.play();
              Choque.rewind();
            }
          }
        }
        if (random(25)<1)banda.add(new Enemigo(width, random(height)));
        image (explosion, birdx-10000, birdy-600000, aumX=100, aumY=100);
        image (sprite, birdx-50, birdy-30);
        gravedad = 5;
        vel = 2;
        p1.x -= vel;
        p2.x -= vel;
        p3.x -= vel;
        p4.x -= vel;
        p5.x -= vel;
        p6.x -= vel;
        p7.x -= vel;
        if (Key_w == true) {
          {
            birdy = birdy-8;
          }
        }
        if (IncomingDistance>10)
        {
          //birdy -= jumpForce;
          birdy -= gravedad;
        } else
        {
          birdy += gravedad;
        }
        textSize(24);
        fill(255, 255, 255);
        textAlign(LEFT);
        text("Puntaje : "+ puntaje, width/8, 30);
      }

      if (perder == true)
      {
        Sonido.pause();
        Sonido.rewind();
        for (int i = banda.size()-1; i>=0; i-- ) {
          Enemigo e = banda.get(i);
          e.mover();
          e.mostrar();
        }
        tiempo = false;

        gravedad = 0;
        vel = 0;
        p1.x -= vel;
        p2.x -= vel;
        p3.x -= vel;
        p4.x -= vel;
        p5.x -= vel;
        p6.x -= vel;
        p7.x -= vel;
        image (explosion, birdx-100, birdy-60, aumX+=1, aumY+=1);
        if (aumX==110)
        {
          birdx= -100000;
        }
        if ( mayorPuntuacion < puntaje)
        {
          mayorPuntuacion = puntaje;
        }

        textSize(16);
        fill(200, 102, 0);
        textAlign(CENTER);
        text("Pulsa para volver a jugar", width/2, height/2);
        text("Puntaje: " + puntaje, width/2, height/2 - 20);
        text("Mayor Puntaje: " + mayorPuntuacion, width/2, height/2 - 40);

        if (mousePressed)
        {

          gamePausado = !gamePausado;

          for (int i = banda.size()-1; i>=0; i-- ) {
            //Enemigo e = banda.get(i);
            for (int j = misiles.size()-1; j>=0; j-- ) {
              // Proyectil p = misiles.get(j);
              misiles.remove(j);
            }
            banda.remove(i);
          }
          //TIEMPO/////////////////////////
          if (tiempo==false)
            mse=0;
          min=0;
          se=0;
          {
            textAlign(CENTER);
            textSize(30);
            if (mse <=59) {
              text(min+":"+se, width/2, 20);
              mse = mse+1;
            } 
            if (mse >= 59) {
              se=se+1;
              println(se);
              mse = 0; 
              text(min+":"+se, width/2, 20);
              println(se);
            } else if (se >=59) {
              se = 0;
              min = min+1;
              text(min+":"+se, width/2, 20);
            }
          }
          //TIEMPO///////////////////////////



          delay(900);
          puntaje = 0;
          birdy = 100;
          birdx = 56;
          p1.x = width + 50;
          p2.x = width + 220;
          p3.x = width + 370;
          p4.x = width + 539;
          p5.x = width + 708;
          p6.x = width + 877;
          p7.x = width + 1046;
          p1.arriba = random(height/2);
          p1.abajo = random(height/2);
          p2.arriba = random(height/2);
          p2.abajo = random(height/2);
          p3.arriba = random(height/2);
          p3.abajo = random(height/2);
          p4.arriba = random(height/2);
          p4.abajo = random(height/2);
          p5.arriba = random(height/2);
          p5.abajo = random(height/2);
          p6.arriba = random(height/2);
          p6.abajo = random(height/2);
          p7.arriba = random(height/2);
          p7.abajo = random(height/2);

          perder = false;
        }
      }
    }
  }

  void success(Rect test) {

    if (birdy < test.arriba || birdy > height - test.abajo)
    {
      if (birdx > test.x && birdx < test.x + test.w)
      {
        perder = true;
      }
    }
  }
  void mouseClicked() {

    CargarJuego = true;
    gamestarted = true;
    tiempo = true;
    Sonido.play();
    Sonido.loop();

    gamePausado = !gamePausado;
  }
