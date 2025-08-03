import SwiftUI

// 天気の種類を定義するEnum
enum WeatherType: CaseIterable {
    case sunny, cloudy, lightRain, heavyRain

    var iconName: String {
        switch self {
        case .sunny: "sun.max.fill"
        case .cloudy: "cloud.fill"
        case .lightRain: "cloud.drizzle.fill"
        case .heavyRain: "cloud.heavyrain.fill"
        }
    }

    var label: String {
        switch self {
        case .sunny: "晴れ"
        case .cloudy: "曇り"
        case .lightRain: "小雨"
        case .heavyRain: "大雨"
        }
    }
}

struct HomeView: View {
    // 選択されている天気を保持する状態変数
    @State private var selectedWeather: WeatherType? = nil

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

                //----------------- 天気選択ボタンここから -----------------
                HStack(spacing: 15) {
                    ForEach(WeatherType.allCases, id: \.self) { weather in
                        WeatherTypeButton(
                            weather: weather,
                            isSelected: self.selectedWeather == weather,
                            action: {
                                self.selectedWeather = weather
                            }
                        )
                    }
                }
                .padding()
                //----------------- 天気選択ボタンここまで -----------------

                //----------------- 天気登録ボタンここから -----------------
                Button(action: {
                    // TODO: action追加
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("天気を登録する")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 224/255, green: 81/255, blue: 139/255))
                    .cornerRadius(10)
                    .shadow(radius: 4, x: 0, y: 4)
                }
                //----------------- 天気登録ボタンここまで -----------------
            }
            .padding()
            
//        TODO: カードをスクロールできるようにする
        }
    }
}

struct WeatherTypeButton: View {
    let weather: WeatherType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: weather.iconName)
                    .font(.largeTitle)
                    .foregroundColor(Color(red: 224/255, green: 81/255, blue: 139/255))
                Text(weather.label)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(width: 70, height: 70)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color(red: 224/255, green: 81/255, blue: 139/255) : Color.clear, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    HomeView()
}
