//
//  PickerView.swift
//  MeetCos
//
//  Created by apple on 2023/02/18.
//

import SwiftUI

struct TimePickerView: View {
    @EnvironmentObject var viewModel: TimePickerViewModel
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var hours = [Int](0 ..< 24)
    var minutes = [Int](0 ..< 60)
    var seconds = [Int](0 ..< 60)

    var body: some View {
        // ZStackでPickerとレイヤーで重なるようにボタンを配置
        ZStack {
            // 時間、分、秒のPickerとそれぞれの単位を示すテキストをHStackで横並びに
            HStack {
                // 時間単位のPicker
                Picker(selection: $viewModel.hourSelection, label: Text("hour")) {
                    ForEach(0 ..< 11) { index in
                        Text("\(index)").font(.system(size: 14))
                            .tag(index)
                    }
                }
                // 上下に回転するホイールスタイルを指定
                .pickerStyle(WheelPickerStyle())
                .frame(width: screenWidth * 0.15, height: screenWidth * 0.3)
                .clipped()
                Text("時間")
                    .font(.headline)
                    .font(.system(size: 14))

                Picker(selection: $viewModel.minSelection, label: Text("分")) {
                    ForEach(0 ..< 60) { index in
                        Text("\(minutes[index])").font(.system(size: 14))
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: screenWidth * 0.15, height: screenWidth * 0.3)
                Text("分")
                    .font(.headline)
                    .font(.system(size: 14))
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    @State private static var isTimerActive = false
    static var previews: some View {
        let timePickerVM = TimePickerViewModel()
        TimePickerView()
            .environmentObject(timePickerVM)
            .previewLayout(.sizeThatFits)
    }
}
