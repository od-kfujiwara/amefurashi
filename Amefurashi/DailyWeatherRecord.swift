
import Foundation

enum WeatherType: String, Codable, CaseIterable {
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

struct DailyWeatherRecord: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let weatherType: WeatherType
}
