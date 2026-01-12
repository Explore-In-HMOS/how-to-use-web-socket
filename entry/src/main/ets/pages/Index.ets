import { webSocketManager } from '../services/WebSocketService';

@Entry
@Component
struct Index {

  build() {
    RelativeContainer() {
      Text(webSocketManager.text)
        .id('HelloWorld')
        .fontSize('14fp')
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          webSocketManager.setupWebSocket();
        })
    }
    .height('100%')
    .width('100%')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.base_background_gradient_start'), 0.0],
        [$r('app.color.base_background_gradient_end'), 1]]
    })
  }
}