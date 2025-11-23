
import Foundation

class DailyWeatherStorage: ObservableObject {
    @Published var dailyRecords: [DailyWeatherRecord] {
        didSet {
            if let encoded = try? JSONEncoder().encode(dailyRecords) {
                UserDefaults.standard.set(encoded, forKey: "dailyWeatherRecords")
            }
        }
    }

    init() {
        if let savedRecords = UserDefaults.standard.data(forKey: "dailyWeatherRecords") {
            if let decodedRecords = try? JSONDecoder().decode([DailyWeatherRecord].self, from: savedRecords) {
                self.dailyRecords = decodedRecords
                return
            }
        }
        self.dailyRecords = []
    }
}
