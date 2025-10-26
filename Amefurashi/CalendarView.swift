import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var dailyWeatherStorage: DailyWeatherStorage
    @State private var currentMonth = Date()

    private let calendar = Calendar.current
    private let weekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]

    // 月のフォーマッター
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }

    // 月の日数を取得
    private func getDaysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }

        var days: [Date?] = []
        var currentDate = monthFirstWeek.start

        // カレンダーグリッドを埋めるために最大42日分（6週間）
        for _ in 0..<42 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return days
    }

    // 指定した日付の天気記録を取得
    private func getWeatherForDate(_ date: Date) -> WeatherType? {
        return dailyWeatherStorage.dailyRecords.first { record in
            calendar.isDate(record.date, inSameDayAs: date)
        }?.weatherType
    }

    // 日付が現在の月に属しているかチェック
    private func isInCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 月の選択ヘッダー
                HStack {
                    Button(action: {
                        if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
                            currentMonth = newMonth
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Text(monthFormatter.string(from: currentMonth))
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
                            currentMonth = newMonth
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
                .padding()

                // 曜日ヘッダー
                HStack(spacing: 0) {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(
                                symbol == "日" ? .red :
                                symbol == "土" ? .blue : .primary
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                // カレンダーグリッド
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                    ForEach(getDaysInMonth().indices, id: \.self) { index in
                        if let date = getDaysInMonth()[index] {
                            CalendarDayCell(
                                date: date,
                                isInCurrentMonth: isInCurrentMonth(date),
                                weatherType: getWeatherForDate(date),
                                isToday: calendar.isDateInToday(date)
                            )
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("カレンダー")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// カレンダーの日付セル
struct CalendarDayCell: View {
    let date: Date
    let isInCurrentMonth: Bool
    let weatherType: WeatherType?
    let isToday: Bool

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(dayNumber)
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(
                    !isInCurrentMonth ? .gray.opacity(0.3) :
                    isToday ? .white : .primary
                )

            if let weather = weatherType, isInCurrentMonth {
                Image(systemName: weather.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 224/255, green: 81/255, blue: 139/255))
            } else {
                Spacer()
                    .frame(height: 20)
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(
            isToday ?
                Color(red: 224/255, green: 81/255, blue: 139/255).opacity(0.8) :
                Color.white
        )
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday ? Color(red: 224/255, green: 81/255, blue: 139/255) : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    CalendarView()
        .environmentObject(DailyWeatherStorage())
}
