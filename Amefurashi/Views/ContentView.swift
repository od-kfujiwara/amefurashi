import SwiftUI

struct ContentView: View {
    @StateObject private var dailyWeatherStorage = DailyWeatherStorage()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
                .environmentObject(dailyWeatherStorage)

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
