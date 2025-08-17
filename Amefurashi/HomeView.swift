import SwiftUI



struct HomeView: View {
    /// 選択されている天気を保持する状態変数
    @State private var selectedWeather: WeatherType? = nil
    @State private var currentDate = Date()
    @StateObject private var dailyWeatherStorage = DailyWeatherStorage()

    private var rainyDayPercentage: Int {
        guard !dailyWeatherStorage.dailyRecords.isEmpty else { return 0 }
        let rainyDays = dailyWeatherStorage.dailyRecords.filter { $0.weatherType == .lightRain || $0.weatherType == .heavyRain }.count
        return Int(Double(rainyDays) / Double(dailyWeatherStorage.dailyRecords.count) * 100)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月d日(E)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }

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
                        Button(action: {
                            // アクションは未実装
                        }) {
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)  

                    Spacer()
                    
                    // MARK: - 雨の日割合表示
                    ZStack {
                        Image("cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                            .offset(y: -20) // 雲のアイコンのみ10ポイント上に移動
                        
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text("\(rainyDayPercentage)") // 数字部分
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.black)
                            Text("%") // %記号部分
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .offset(x: +12)
                    }
                    .offset(y: -40)
                    
                    Spacer()

                    // MARK: - 日付選択
                    HStack {
                        Button(action: {
                            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate) ?? self.currentDate
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        .padding(.horizontal)

                        Text(dateFormatter.string(from: currentDate))
                            .font(.headline)

                        Button(action: {
                            self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate) ?? self.currentDate
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(Calendar.current.isDateInToday(currentDate))
                        .padding(.horizontal)
                    }
                    .padding()
                    .offset(y: -10)

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
                    .offset(y: -30) // 天気選択ボタンを30ポイント上に移動

                    // MARK: - 天気登録ボタン
                    Button(action: {
                        guard let selectedWeather = selectedWeather else {
                            // 天気が選択されていない場合のアラートなど
                            return
                        }

                        let calendar = Calendar.current
                        let today = calendar.startOfDay(for: currentDate)

                        // その日の記録がすでにあるか確認
                        if dailyWeatherStorage.dailyRecords.contains(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                            print("すでに今日の天気を登録済みです")
                            return
                        }

                        let newRecord = DailyWeatherRecord(date: today, weatherType: selectedWeather)
                        dailyWeatherStorage.dailyRecords.append(newRecord)
                        print("天気登録: \(newRecord)")
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
                    .offset(y: -30) // 天気登録ボタンを30ポイント上に移動
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
            .onAppear {
                // dailyWeatherStorageは@StateObjectなので自動的に初期化される
                // dailyRecordsはinitでUserDefaultsからロードされる
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