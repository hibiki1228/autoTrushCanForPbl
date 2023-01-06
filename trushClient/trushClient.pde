import processing.net.*;
Client myClient;

int State;
String Message;

void setup() {
  size(400, 200);

  // フォント生成
  PFont font = createFont("BIZ UDゴシック", 16, true);
  textFont(font);

  myClient = new Client(this, "localhost", 8080);

  State = 0;
  Message = " ";
  println("Ready to go!");
}

void draw() {
  background(#2D3986);
  text("クライアントA" + ", State: " + State, 30, 20);
  text(Message, 30, 40);
}

void clientEvent( Client c ) {
  int NumBytes = c.available();
  byte[] myBuffer = c.readBytes(NumBytes);

  switch(State) {
    case 0 :
      Message = "Connected server" + str(myBuffer[0]);
      State = 1;
      break;
    case 1 :
      break;
    case 2 :
      if (myBuffer[0] == 1) {
        Message = "Received server to reset.";
        State = 1;
      } else if (myBuffer[0] == 0) {
        break;
      } else {
        Message = "error : " + myBuffer[0];
      }
      break;
    default :
      break;
  }

  c.clear();
}

void keyTyped() {
  switch(State) {
    case 0:
      break;
    case 1:
      Message = "ClientA send " + str(key) + ".\n" + "Wait...";

      byte sendData;
      if (key < 50) {
        sendData = 1;
      } else {
        sendData = 0;
      }
      myClient.write(sendData);
      State = 2;
      break;
  }
}