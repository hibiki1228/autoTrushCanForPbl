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

void setup() {
  // window生成
  size(400, 200);

  // フォント生成
  PFont font = createFont("BIZ UDゴシック", 16, true);
  textFont(font);

  // Start server
  PortNum [0] = 8080; //Client1
  PortNum [1] = 7979; //CLient2
  myServer[0] = new Server(this, PortNum[0]);
  myServer[1] = new Server(this, PortNum[1]);

  // memory IP and Port number
  for(int i = 0; i < MAX_CLIENT; i++) {
    ServerIP[i] = myServer[i].ip( ) + " #" + PortNum[i];
    ClientIP[i] = " ";
    Message [i] = " ";
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
}

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
    }
    State = 1;
  }
}

void clientEvent( Client RecvClient ) {
  int NumBytes = RecvClient.available();
  byte[] myBuffer = RecvClient.readBytes(NumBytes);

  switch( State ) {
    case 0 :
      break;
    case 1 :
      if ( RecvClient == myClient[0] ) {
        byte keyval = myBuffer[0];
        Message[0] = "Received " + str(char(keyval)) + " from ClientA";

        myServer[1].write(keyval);
        Message[1] = "Send " + str(char(keyval)) + " to B.";
      }
      break;
    default :
      break;
  }

  RecvClient.clear();
}
