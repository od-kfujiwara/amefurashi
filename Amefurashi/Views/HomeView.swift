import SwiftUI



struct HomeView: View {
    /// 選択されている天気を保持する状態変数
    @State private var selectedWeather: WeatherType? = nil
    @State private var currentDate = Date()
    @EnvironmentObject var dailyWeatherStorage: DailyWeatherStorage
    @EnvironmentObject var userSettings: UserSettingsStorage

    // ユーザー名編集用のState
    @State private var showingUsernameSheet = false


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - ユーザー名表示
                    HStack {
                        Button(action: {
                            showingUsernameSheet = true
                        }) {
                            HStack {
                                Text(userSettings.username)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Image(systemName: "square.and.pencil")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .sheet(isPresented: $showingUsernameSheet) {
                        UsernameEditSheet(username: $userSettings.username)
                    }

                    Spacer()

                    // MARK: - アメフラシ度表示
                    ZStack(alignment: .center) {
                        Image("cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)

                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text("\(dailyWeatherStorage.rainyDayPercentage)")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.black)
                            Text("%")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 30)
                        .offset(y: 10)
                    }
                    .padding(.vertical, 20)

                    Spacer()

                    // MARK: - 日付選択
                    HStack {
                        Button(action: {
                            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate) ?? self.currentDate
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        .padding(.horizontal)

                        Text(DateFormatters.japaneseFullDate.string(from: currentDate))
                            .font(.headline)

                        Button(action: {
                            self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate) ?? self.currentDate
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(Calendar.current.isDateInToday(currentDate))
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)

                    // MARK: - 天気選択ボタン
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
                    .padding(.vertical, 16)

                    // MARK: - 天気登録ボタン
                    Button(action: {
                        guard let selectedWeather = selectedWeather else {
                            return
                        }

                        let calendar = Calendar.current
                        let today = calendar.startOfDay(for: currentDate)
                        let newRecord = DailyWeatherRecord(date: today, weatherType: selectedWeather)

                        dailyWeatherStorage.saveOrUpdateRecord(newRecord)
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
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: currentDate) { _, newDate in
                selectedWeather = dailyWeatherStorage.getWeatherForDate(newDate)
            }
            .onAppear {
                selectedWeather = dailyWeatherStorage.getWeatherForDate(currentDate)
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
                    .foregroundColor(weather.color)
                // 天気ラベル
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
        .environmentObject(DailyWeatherStorage())
        .environmentObject(UserSettingsStorage())
}
