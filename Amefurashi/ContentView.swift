import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                //----------------- 天気取得ボタンここから -----------------
                Button(action: {
                    // TODO: action追加
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("現在地の天気を取得")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black.opacity(0.8))
                    .cornerRadius(10)
                }
                //----------------- 天気取得ボタンここまで -----------------
                
                Spacer()
                
                //----------------- 天気カードここから -----------------
                if (false) {
                    Text("天気情報がありません")
                        .foregroundColor(.gray)
                } else {
                    VStack {
                        Text("2025/03/02 15:30")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/02d@2x.png")) { image in
                            image
                                .resizable()
                                .frame(width: 120, height: 120)
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(DefaultProgressViewStyle())
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                        }
                        Text("20°C")
                            .font(.system(size: 50))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text("東京都")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("風速: 1.5m/s")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(30)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                //----------------- 天気カードここまで -----------------
                
                Spacer()
            }
            .padding()
            
//        TODO: カードをスクロールできるようにする
        }
    }
}

#Preview {
    ContentView()
}
