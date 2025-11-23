import SwiftUI

struct ContentView: View {
    @StateObject private var dailyWeatherStorage = DailyWeatherStorage()
    @StateObject private var userSettings = UserSettingsStorage()
    @State private var selectedTab = 0
    @State private var selectedDateFromCalendar: Date?

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedDateFromCalendar: $selectedDateFromCalendar)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
                .tag(0)
                .environmentObject(dailyWeatherStorage)
                .environmentObject(userSettings)

            CalendarView(selectedTab: $selectedTab, selectedDate: $selectedDateFromCalendar)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }
                .tag(1)
                .environmentObject(dailyWeatherStorage)
        }
    }
}

#Preview {
    ContentView()
}
