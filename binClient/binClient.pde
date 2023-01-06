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
  text("クライアントB" + ", State: " + State, 30, 20);
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
      println("client");

      // trigerを受け取って行う挙動
      if (myBuffer[0] == 1) {
      //   Byte sendData;
        Message = "Recieved trigger " + str(myBuffer[0]) + " ";
      //   // 以下にゴミ箱移動の処理
      //   // if (key == 66) {
      //     sendData = 1;
      //     myClient.write(sendData);
      //     Message = "This is State 2. send 1.";
      //   // } else {
      //   //   sendData = 0;
      //   //   Message = "cannot send 1.";
      //   // }
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


// よくわからんやつ
void keyTyped() {
  switch( State ) {
    case 0 :
      break;
    case 2 :
        Byte sendData;
        // Message = "Recieved trigger " + str(myBuffer[0]) + " ";
        // 以下にゴミ箱移動の処理
        // if (key == 66) {
        if (key < 50) {
          sendData = 1;
        } else {
          sendData = 0;
        }
        myClient.write(sendData);
        Message = "This is State 2. send " + key;
        // } else {
        //   sendData = 0;
        //   Message = "cannot send 1.";
        // }
        State = 3;
      break;
    default :
      break;
  }
  println(State);
}