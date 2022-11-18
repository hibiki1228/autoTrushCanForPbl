import processing.net.*;
Client myClient;

int State;
String Message;

void setup() {
  size(400, 200);

  // フォント生成
  PFont font = createFont("BIZ UDゴシック", 16, true);
  textFont(font);

  myClient = new Client(this, "localhost", 7979);

  State = 0;
  Message = " ";
}

void draw() {
  background(#540D93);
  text("クライアントB", 30, 20);
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
      Message = "Recieved " + str(char(myBuffer[0])) + " from A.";
      break;
  }

  c.clear();
}

void keyTyped() {
  switch( State ) {
    case 0 :
      break;
    case 1 :
      Message = "ClientA send " + str(key) + ".";

      byte sendData;
      sendData = byte(key);
      myClient.write(sendData);
      break;
    default :
      break;
  }
}