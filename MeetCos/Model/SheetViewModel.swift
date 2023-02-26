//
//  SheetViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/17.
//

import Foundation
import SwiftUI
import AudioToolbox


//class Expenses: ObservableObject {
//    @Published var expenses:[Expense]
//    init(expenses: [Expense]) {
//        self.expenses = expenses
//    }
//}

enum CountWay : String{
    case personCount
    case yen
}

enum TimeFormat {
    case hr
    case min
    case sec
}

enum TimerStatus {
    case running
    case pause
    case stopped
}

struct Sound: Identifiable {
    let id: SystemSoundID
    let soundName: String
}

class SheetViewModel: ObservableObject {
    //Pickerで設定した"時間"を格納する変数
    @Published var hourSelection: Int = 0
    //Pickerで設定した"分"を格納する変数
    @Published var minSelection: Int = 0
    //Pickerで設定した"秒"を格納する変数
    @Published var secSelection: Int = 0
    //カウントダウン残り時間
    @Published var duration: Double = 0
    //カウントダウン開始前の最大時間
    @Published var maxValue: Double = 0
    //設定した時間が1時間以上、1時間未満1分以上、1分未満1秒以上によって変わる時間表示形式
    @Published var displayedTimeFormat: TimeFormat = .min
    //タイマーのステータス
    @Published var timerStatus: TimerStatus = .stopped
    //AudioToolboxに格納された音源を利用するためのデータ型でデフォルトのサウンドIDを格納
    @Published var soundID: SystemSoundID = 1151
    //soundIDプロパティの値に対応するサウンド名を格納
    @Published var soundName: String = "Beat"
    //アラーム音オン/オフの設定
    @Published var isAlarmOn: Bool = true
    //バイブレーションオン/オフの設定
    @Published var isVibrationOn: Bool = true
    //プログレスバー表示オン/オフの設定
    @Published var isProgressBarOn: Bool = true
    //エフェクトアニメーション表示オン/オフの設定
    @Published var isEffectAnimationOn: Bool = true
    //設定画面の表示/非表示
    @Published var isSetting: Bool = false
    //1秒ごとに発動するTimerクラスのpublishメソッド
    
    @Published var focus: Bool = false // フォーカス
    @Published var expenses = [Expense(personCount: "0", laborCosts: "0", estimatedSales: "0")]
    @Published var totalCost: Int = 0
    
    //カウントダウン中の残り時間を表示するためのメソッド
    func displayTimer() -> String {
        //残り時間（時間単位）= 残り合計時間（秒）/3600秒
        let hr = Int(duration) / 3600
        //残り時間（分単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒
        let min = Int(duration) % 3600 / 60
        //残り時間（秒単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒 で割った余り
        let sec = Int(duration) % 3600 % 60
        
        //setTimerメソッドの結果によって時間表示形式を条件分岐し、上の3つの定数を組み合わせて反映
        switch displayedTimeFormat {
        case .hr:
            return String(format: "%02d:%02d:%02d", hr, min, sec)
        case .min:
            return String(format: "%02d:%02d", min, sec)
        case .sec:
            return String(format: "%02d", sec)
        }
    }
    
    //スタートボタンをタップしたときに発動するメソッド
    func start() {
        //タイマーステータスを.runningにする
        timerStatus = .running
    }
    
    //一時停止ボタンをタップしたときに発動するメソッド
    func pause() {
        //タイマーステータスを.pauseにする
        timerStatus = .pause
    }
    
    //リセットボタンをタップしたときに発動するメソッド
    func reset() {
        //タイマーステータスを.stoppedにする
        timerStatus = .stopped
        //残り時間がまだ0でなくても強制的に0にする
        duration = 0
    }
    private func whichCount(unit: CountWay) -> String {
        switch unit {
        case .personCount:
            return "人"
        case .yen:
            return "円"
        }
    }
    
    func ConvertFromIntTopersonCount(num: Int, unit: CountWay) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: num)) ?? "0" + whichCount(unit: unit)
    }
    
    func calculateSession() -> Int {
        let totalMinutes: Decimal = Decimal(ToTotalMinutes())
        let totalDecimal: Decimal = expenses.reduce(Decimal.zero) { (result, expense) in
            let personCount = Decimal(string: expense.personCount ?? "0") ?? 0
            let laborCosts = Decimal(string: expense.laborCosts ?? "0") ?? 0
            let estimatedSales = Decimal(string: expense.estimatedSales ?? "0") ?? 0
            let subtotal = result + (personCount * laborCosts + estimatedSales) * Decimal(Int(truncating: totalMinutes as NSNumber) / 60)
            return result + (subtotal.isNaN ? Decimal.zero : subtotal)
        }
        let handler = NSDecimalNumberHandler(roundingMode: .bankers, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let totalInt: Int = NSDecimalNumber(decimal: totalDecimal).rounding(accordingToBehavior: handler).intValue
        return totalInt
    }
    
    func changeTotal() {
        totalCost = calculateSession()
    }
    
    func save() {

        let session = calculateSession()
        let expenses = self.expenses
        // CoreData save
        // coredata.session.save()
        // coredata.group.save()
    }
    
    func returnEmptyStringIfZero(_ input: String) -> String {
        if input == "0" {
            return ""
        }
        return input
    }
    
    private func ToTotalMinutes() -> Int {
        return self.hourSelection * 60 + self.minSelection
    }
    
    func laborCosts(for expense: Expense) -> Binding<String> {
        Binding(
            get: {
                expense.laborCosts ?? "0"
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].laborCosts = newValue
                }
            }
        )
    }
    
    func personCount(for expense: Expense) -> Binding<String> {
        Binding(
            get: {
                expense.personCount ?? "0"
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].personCount = newValue
                }
            }
        )
    }
    
    func estimatedSales(for expense: Expense) -> Binding<String> {
        Binding(
            get: {
                expense.estimatedSales ?? "0"
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].estimatedSales = newValue
                }
            }
        )
    }
}

extension String {
    var isLessThanSix: Bool {
        return self.count <= 6
    }
    
    var isLessThanEight: Bool {
        return self.count <= 8
    }
    
    var isNumeric: Bool {
        return self.range(of: "[^.0-9]", options: .regularExpression) == nil && self != ""
    }
}

