import SwiftUI

struct ContentView: View {
    @StateObject private var dailyWeatherStorage = DailyWeatherStorage()
    @StateObject private var userSettings = UserSettingsStorage()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
                .environmentObject(dailyWeatherStorage)
                .environmentObject(userSettings)

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }
                .environmentObject(dailyWeatherStorage)
        }
    }
}

#Preview {
    ContentView()
}
