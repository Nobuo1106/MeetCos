//
//  SheetViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/17.
//

import Foundation
import SwiftUI
import AudioToolbox
import CoreData
import Combine

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

class SheetViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    //Pickerで設定した"時間"を格納する変数
    @Published var hourSelection: Int = 0
    //Pickerで設定した"分"を格納する変数
    @Published var minSelection: Int = 0
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
    @Published var expenses = [Expense(personCount: "0", hourlyWage: "0", hourlyProfit: "0")]
    @Published var totalCost: Int = 0
    private var groups: [Group] = []
    
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
            let hourlyWage = Decimal(string: expense.hourlyWage ?? "0") ?? 0
            let hourlyProfit = Decimal(string: expense.hourlyProfit ?? "0") ?? 0
            let subtotal = (personCount * hourlyWage + hourlyProfit) * totalMinutes / 60
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
        let context = PersistenceController.shared.container.viewContext
        
        context.perform {
            let session = Session(context: context)
            session.sessionId = Session.latestSessionId
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
            
            let now = Date()
            session.createdAt = formatter.string(from: now)
            session.updatedAt = formatter.string(from: now)
            
            var groups = [Group]()
            
            for expense in self.expenses {
                let group = expense.toGroup(sessionId: session.sessionId)
                groups.append(group)
            }
            
            session.groups = Set(groups)
            
            do {
                try context.save()
                print("Session and groups saved")
            } catch {
                print("Error saving session and groups: \(error.localizedDescription)")
                context.rollback()
            }
        }
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
    
    func hourlyWage(for expense: Expense) -> Binding<String> {
        Binding(
            get: {
                expense.hourlyWage ?? "0"
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].hourlyWage = newValue
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
    
    func hourlyProfit(for expense: Expense) -> Binding<String> {
        Binding(
            get: {
                expense.hourlyProfit ?? "0"
            },
            set: { [self] newValue in
                if let index = self.expenses.firstIndex(where: { $0.id == expense.id }) {
                    expenses[index].hourlyProfit = newValue
                }
            }
        )
    }
    
    func fetchGroups() {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        PersistenceController.shared.fetchItems(fetchRequest: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Fetch completed")
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { items in
                print("Fetched items: \(items)")
                // do something with the fetched items
            })
            .store(in: &cancellables)
    }
}

