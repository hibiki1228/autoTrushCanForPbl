import processing.net.*;
final int MAX_CLIENT = 2; // 最大クライアント数
Server[] myServer = new Server[MAX_CLIENT];
String[] ServerIP = new String[MAX_CLIENT];
int   [] PortNum  = new int[MAX_CLIENT];

Client[] myClient = new Client[MAX_CLIENT];
String[] ClientIP = new String[MAX_CLIENT];

int State;
int numClient;

String[] Message = new String[MAX_CLIENT];
String[] ServerMsg = new String[2];

int cntTrush = 0;

void setup() {
  // window生成
  size(400, 300);

  // フォント生成
  PFont font = createFont("BIZ UDゴシック", 16, true);
  textFont(font);

  // Start server
  PortNum [0] = 8080; //Trush
  PortNum [1] = 7979; //Bin
  myServer[0] = new Server(this, PortNum[0]);
  myServer[1] = new Server(this, PortNum[1]);

  // memory IP and Port number
  for(int i = 0; i < MAX_CLIENT; i++) {
    ServerIP[i] = myServer[i].ip( ) + " #" + PortNum[i];
    ClientIP[i] = " ";
    Message [i] = " ";
    ServerMsg[i] = " ";
  }

  State = 0;
  numClient = 0;
}

void draw() {
  //背景設定
  background(#086C52);

  for(int i = 0; i < MAX_CLIENT; i++) {
    text("Server: " + ServerIP[i] + ", State: " + State, 30, 20 + i * 100);
    text("Client: " + ClientIP[i], 30, 40 + i * 100);
    text(Message[i], 30, 60 + i * 100);
  }

  text(ServerMsg[0], 30,180);
}

// Connect Server
void serverEvent( Server ConServer, Client ConClient ) {
  String[] ClientID = {"A", "B"};

  for(int i = 0; i < MAX_CLIENT; i++) {
    if( ConServer == myServer[i] ) {
    myClient[i] = ConClient;
    ClientIP[i] = ConClient.ip();
    Message [i] = "Connected " + ClientID[i] + ".";
    numClient++;
    }
  }

  if(numClient >= MAX_CLIENT) {
    delay(100);

    for(int i = 0; i < MAX_CLIENT; i++) {
      byte sendData = (byte)0;
      myServer[0].write(sendData);
      myServer[1].write(sendData);
    }
    State = 1;
  }
}

// main func
void clientEvent( Client RecvClient ) {
  int NumBytes = RecvClient.available();
  byte[] myBuffer = RecvClient.readBytes(NumBytes);

  switch( State ) {
    case 0 : // server setting
      break;
    case 1 : // trushから値を受信
      if ( RecvClient == myClient[0] ) {
        byte trigger = myBuffer[0];
        Message[0] = "Received " + str((trigger)) + " from Trush";
        println("S1");
        if (trigger == 1) { //センサーから受け取った値が想定値の場合
          byte is_ok = 1;
          // binに送信準備
          myServer[1].write(is_ok);
          println(myServer[1]);
          Message[1] = "Send " + str(is_ok) + " to bin.";

          State = 2;
        } else if (trigger == 0) {
          Message[1] = "Bin is not for ready.";
        } else {
          Message[1] = "Trigger send error. Trigger is " + str(trigger);
        }
        cntTrush++;
        ServerMsg[0] = "Trush count -> " + cntTrush;
      }
      break;
    case 2 : // ゴミ箱の動作終了待機
      if ( RecvClient == myClient[1] ) {
        byte trigger = myBuffer[0];
        Message[1] = "Received " + str((trigger)) + " from bin";
        if (trigger == 1) {
          int is_ok = 1;
          // binに送信準備
          myServer[0].write(is_ok);
          Message[0] = "Send " + str(is_ok) + " to A.";
          State = 1;
        } else if (trigger == 0) {
          Message[0] = "Trush is waiting...";
        } else {
          Message[1] = "Trigger send error.";
        }
      }
      break;
    default :
      break;
  }

  RecvClient.clear();
}
