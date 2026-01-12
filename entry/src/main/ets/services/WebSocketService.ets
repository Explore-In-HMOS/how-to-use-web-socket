import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

@ObservedV2
class WebSocketManager {
  private socket = webSocket.createWebSocket();
  private defaultIpAddress = 'wss://ws.postman-echo.com/raw';
  @Trace isConnected: boolean = false;
  @Trace text: string = 'Please Click to Test Websocket';

  setupWebSocket(): void {
    this.socket.on('open', (err: BusinessError, value: Object) => {
      console.info(`on open, status: ${JSON.stringify(value)}`);
      this.text = 'on open sending message';
      this.socket.send('Hello from HarmonyOS!', (err: BusinessError, value: boolean) => {
        if (!err) {
          console.info('Message sent successfully');
          this.text = 'Message sent successfully';
        } else {
          console.error(`Failed to send message. Err: ${JSON.stringify(err)}`);
          this.text = 'Failed to send message';
        }
      });
    });

    this.socket.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      console.info(`on message, message: ${value}`);
      this.text = `Message came: ${value}`;
      if (value === 'Hello from HarmonyOS!') {
        this.socket.close((err: BusinessError, value: boolean) => {
          if (!err) {
            console.info('Connection closed successfully');
          } else {
            console.error(`Failed to close connection. Err: ${JSON.stringify(err)}`);
          }
        });
      }
    });

    this.socket.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      console.info(`on close, code: ${value.code}, reason: ${value.reason}`);
    });
    this.socket.on('error', (err: BusinessError) => {
      console.error(`on error, error: ${JSON.stringify(err)}`);
    });
    this.socket.connect(this.defaultIpAddress, (err: BusinessError, value: boolean) => {
      if (!err) {
        console.info('Connected to Postman Echo');
      } else {
        console.error(`Connection failed. Err: ${JSON.stringify(err)}`);
      }
    });
  }

  connectLiveSocket(): void {
    if (this.isConnected) {
      console.info('WebSocket already connected');
      return;
    }

    const apiUrl = '';
    this.socket.connect(apiUrl, (err: BusinessError, value: boolean) => {
      if (!err && value) {
        console.info('Connected to WebSocket server');
      } else {
        console.error(`Connection failed. Err: ${JSON.stringify(err)}`);
      }
    });
  }

  disconnectLiveSocket(): void {
    if (!this.isConnected) {
      console.info('WebSocket is not connected');
      return;
    }

    this.socket.close((err: BusinessError, value: boolean) => {
      if (!err && value) {
        console.info('WebSocket disconnected successfully');
      } else {
        console.error(`Disconnection failed. Err: ${JSON.stringify(err)}`);
      }
    });
  }

  sendMessage(message: string): void {
    if (!this.isConnected) {
      console.info('Cannot send message — WebSocket not connected');
      return;
    }

    this.socket.send(message, (err: BusinessError, value: boolean) => {
      if (!err && value) {
        console.info(`Message sent successfully: ${message}`);
      } else {
        console.error(`Send failed. Err: ${JSON.stringify(err)}`);
      }
    });
  }
}

export const webSocketManager = new WebSocketManager();
