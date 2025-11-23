
import Foundation

class DailyWeatherStorage: ObservableObject {
    @Published var dailyRecords: [DailyWeatherRecord] {
        didSet {
            if let encoded = try? JSONEncoder().encode(dailyRecords) {
                UserDefaults.standard.set(encoded, forKey: "dailyWeatherRecords")
            }
        }
    }

    private let calendar = Calendar.current

    init() {
        if let savedRecords = UserDefaults.standard.data(forKey: "dailyWeatherRecords") {
            if let decodedRecords = try? JSONDecoder().decode([DailyWeatherRecord].self, from: savedRecords) {
                self.dailyRecords = decodedRecords
                return
            }
        }
        self.dailyRecords = []
    }

    // MARK: - Business Logic

    /// 雨の日の割合をパーセンテージで計算
    var rainyDayPercentage: Int {
        guard !dailyRecords.isEmpty else { return 0 }
        let rainyDays = dailyRecords.filter {
            $0.weatherType == .lightRain || $0.weatherType == .heavyRain
        }.count
        return Int(Double(rainyDays) / Double(dailyRecords.count) * 100)
    }

    /// 指定した日付の記録が存在するかチェック
    /// - Parameter date: チェックする日付
    /// - Returns: 記録が存在する場合true
    func hasRecordForDate(_ date: Date) -> Bool {
        let targetDay = calendar.startOfDay(for: date)
        return dailyRecords.contains { record in
            calendar.isDate(record.date, inSameDayAs: targetDay)
        }
    }

    /// バリデーション付きで記録を追加
    /// - Parameter record: 追加する記録
    /// - Returns: 追加に成功した場合true、既に記録が存在する場合false
    @discardableResult
    func addRecordIfNeeded(_ record: DailyWeatherRecord) -> Bool {
        guard !hasRecordForDate(record.date) else {
            print("すでにこの日の天気を登録済みです")
            return false
        }
        dailyRecords.append(record)
        return true
    }

    /// カレンダー表示用の天気辞書（高速検索用）
    /// 日付をキーとして天気タイプを取得できます（O(1)）
    var weatherDictionary: [Date: WeatherType] {
        Dictionary(uniqueKeysWithValues: dailyRecords.map {
            (calendar.startOfDay(for: $0.date), $0.weatherType)
        })
    }
}
