import Foundation

/// 日付フォーマットのシングルトンコレクション
/// パフォーマンス向上のため、DateFormatterを再利用します
enum DateFormatters {
    /// 日本語の完全な日付形式: "YYYY年M月d日(E)"
    /// 例: "2024年1月15日(月)"
    static let japaneseFullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月d日(E)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()

    /// 日本語の年月形式: "YYYY年M月"
    /// 例: "2024年1月"
    static let japaneseMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()

    /// 日付の数字のみ: "d"
    /// 例: "15"
    static let dayNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}
