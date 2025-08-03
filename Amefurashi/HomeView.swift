import SwiftUI

/// 天気の種類、アイコン名、ラベルを管理するEnum
enum WeatherType: CaseIterable {
    case sunny, cloudy, lightRain, heavyRain

    /// 天気アイコンのシステムイメージ名
    var iconName: String {
        switch self {
        case .sunny: "sun.max.fill"
        case .cloudy: "cloud.fill"
        case .lightRain: "cloud.drizzle.fill"
        case .heavyRain: "cloud.heavyrain.fill"
        }
    }

    /// 天気の日本語ラベル
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
    /// 選択されている天気を保持する状態変数
    @State private var selectedWeather: WeatherType? = nil

    var body: some View {
        NavigationView { // NavigationViewで全体を囲む
            ZStack {
                // 背景
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    // MARK: - ユーザー名表示
                    HStack {
                        Text("風太郎") // 仮のユーザー名
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)

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

                    // MARK: - 天気選択ボタン
                    HStack(spacing: 15) {
                        // 全ての天気タイプのボタンを動的に生成
                        ForEach(WeatherType.allCases, id: \.self) { weather in
                            WeatherTypeButton(
                                weather: weather,
                                isSelected: self.selectedWeather == weather,
                                action: {
                                    // ボタンタップで選択状態を更新
                                    self.selectedWeather = weather
                                }
                            )
                        }
                    }
                    .padding()

                    // MARK: - 天気登録ボタン
                    Button(action: {
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
                } 
                .padding()
            }
            .navigationTitle("ホーム") // ナビゲーションバーのタイトル
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: ハンバーガーメニューのアクション
                    }) {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
        }
    }   
}

/// 天気の種類を選択するためのボタンビュー
struct WeatherTypeButton: View {
    let weather: WeatherType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                // 天気アイコン
                Image(systemName: weather.iconName)
                    .font(.largeTitle)
                    .foregroundColor(Color(red: 224/255, green: 81/255, blue: 139/255))
                // 天気ラベル
                Text(weather.label)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(width: 70, height: 70)
            .background(Color.white)
            .cornerRadius(10)
            // 選択状態に応じて枠線を表示
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
