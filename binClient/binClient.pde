import processing.net.*;
Client myClient;

int State;
String Message;
String status;

void setup() {
  size(400, 200);

  // フォント生成
  PFont font = createFont("BIZ UDゴシック", 16, true);
  textFont(font);

  myClient = new Client(this, "localhost", 7979);

  State = 0;
  Message = "Connecting server...";
  status = "";
}

void draw() {
  background(#540D93);
  text("ゴミ箱" + ", State: " + State, 30, 20);
  text(Message, 30, 40);
  text(status, 30, 60);
}

void clientEvent( Client c ) {
  int NumBytes = c.available();
  byte[] myBuffer = c.readBytes(NumBytes);

  switch(State) {
    case 0 :
      Message = "Connected server" + str(myBuffer[0]);
      status = "waiting...";
      State = 1;
      break;
    case 1 :
      // trigerを受け取って行う挙動
      if (myBuffer[0] == 1) {
        Message = "Recieved trigger " + str(myBuffer[0]) + " ";
        status = "Moving!";
        State = 2;
      } else {
        Message = "Trigger is not 1. : " + str(myBuffer[0]);
      }
      break;
    case 2 :
      break;
    default :
      break;
  }


  c.clear();
}

void keyTyped() {
  switch( State ) {
    case 0 :
      break;
    case 2 :
        Byte sendData;
        if (key < 50) {
          sendData = 1;
          status = "Waiting...";
          State = 1;
        } else {
          sendData = 0;
        }
        myClient.write(sendData);
        Message = "Send " + key;
      break;
    default :
      break;
  }
}