//
//  SheetViewModel.swift
//  MeetCos
//
//  Created by apple on 2023/01/17.
//

import Foundation
import SwiftUI
import AudioToolbox

struct Expense: Identifiable {
    var id = UUID()
    var personNum: Int?
    var laborCosts: Int?
    var estimatedSales: Int?
}

class Expenses: ObservableObject {
    @Published var expenses:[Expense] = [Expense(personNum: 0, laborCosts: 0, estimatedSales: 0)]
}

enum CountWay : String{
    case personNum
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
    
    @Published var totalCost: Int = 0
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    //Pickerで取得した値からカウントダウン残り時間とカウントダウン開始前の最大時間を計算しその値によって時間表示形式も指定する
    func setTimer() {
        //残り時間をPickerから取得した時間・分・秒の値をすべて秒換算して合計して求める
        duration = Double(hourSelection * 3600 + minSelection * 60 + secSelection)
        //Pickerで時間を設定した時点=カウントダウン開始前のため、残り時間=最大時間とする
        maxValue = duration
        
        //時間表示形式を残り時間（最大時間）から指定する
        //60秒未満なら00形式、60秒以上3600秒未満なら00:00形式、3600秒以上なら00:00:00形式
        if duration < 60 {
            displayedTimeFormat = .sec
        } else if duration < 3600 {
            displayedTimeFormat = .min
        } else {
            displayedTimeFormat = .hr
        }
    }
    
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
        case .personNum:
            return "人"
        case .yen:
            return "円"
        }
    }
    
    func ConvertFromIntToPersonNum(num: Int, unit: CountWay) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: num)) ?? "0" + whichCount(unit: unit)
    }
    
    func calculateSession() {
        let totalMinutes = self.ToTotalMinutes()
    }
    
    func save() {

        let session = calculateSession()
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

