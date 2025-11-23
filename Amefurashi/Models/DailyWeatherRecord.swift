
import Foundation
import SwiftUI

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

    var color: Color {
        switch self {
        case .sunny: Color(red: 235/255, green: 176/255, blue: 110/255)      // #EBB06E アプリコット系オレンジ
        case .cloudy: Color(red: 155/255, green: 165/255, blue: 184/255)     // #9BA5B8 グレイッシュブルー
        case .lightRain: Color(red: 107/255, green: 122/255, blue: 159/255)  // #6B7A9F スレートブルー/藤色
        case .heavyRain: Color(red: 90/255, green: 107/255, blue: 140/255)   // #5A6B8C ダークスレートブルー
        }
    }
}

struct DailyWeatherRecord: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let weatherType: WeatherType
}
