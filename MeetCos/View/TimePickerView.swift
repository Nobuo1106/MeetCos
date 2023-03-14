//
//  PickerView.swift
//  MeetCos
//
//  Created by apple on 2023/02/18.
//

import SwiftUI


struct TimePickerView: View {
    //TimeManagerのインスタンスを作成
    @EnvironmentObject var viewModel: SheetViewModel
    //デバイスのスクリーンの幅
    let screenWidth = UIScreen.main.bounds.width
    //デバイスのスクリーンの高さ
    let screenHeight = UIScreen.main.bounds.height
    //設定可能な時間単位の数値
    var hours = [Int](0..<24)
    //設定可能な分単位の数値
    var minutes = [Int](0..<60)
    //設定可能な秒単位の数値
    var seconds = [Int](0..<60)
    
    var body: some View {
        //ZStackでPickerとレイヤーで重なるようにボタンを配置
        ZStack{
            //時間、分、秒のPickerとそれぞれの単位を示すテキストをHStackで横並びに
            HStack {
                //時間単位のPicker
                Picker(selection: self.$viewModel.hourSelection, label: Text("hour")) {
                    ForEach(0..<11) { index in
                        Text("\(index)" )
                            .tag(index )
                    }
                }
                .onChange(of: viewModel.hourSelection) { newValue in
                   print("changed to \(viewModel.hourSelection)")
                    viewModel.changeTotal()
               }
                //上下に回転するホイールスタイルを指定
                .pickerStyle(WheelPickerStyle())
                .onAppear {
                    viewModel.hourSelection = 0 // set default value
                }
                //ピッカーの幅をスクリーンサイズ x 0.1、高さをスクリーンサイズ x 0.4で指定
                .frame(width: self.screenWidth * 0.1, height: self.screenWidth * 0.4)
                //上のframeでクリップし、フレームからはみ出す部分は非表示にする
                .clipped()
                //時間単位を表すテキスト
                Text("時間")
                    .font(.headline)
                
                //分単位のPicker
                Picker(selection: self.$viewModel.minSelection, label: Text("分")) {
                    ForEach(0..<60) { index in
                        Text("\(self.minutes[index])" )
                            .tag(index )
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .onAppear {
                    viewModel.minSelection = 0 // set default value
                }
                .frame(width: self.screenWidth * 0.1, height: self.screenWidth * 0.4)
                .clipped()
                //分単位を表すテキスト
                Text("分")
                    .font(.headline)
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView()
            .environmentObject(SheetViewModel())
            .previewLayout(.sizeThatFits)
    }
}
