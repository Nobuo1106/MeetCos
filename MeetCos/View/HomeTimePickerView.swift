//
//  HomeTimePickerView.swift
//  MeetCos
//
//  Created by apple on 2023/03/25.
//

import SwiftUI

struct HomeTimePickerView: View {
    @Binding var hourSelection: Int
    @Binding var minSelection: Int

    private let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            HStack {
                Picker(selection: self.$hourSelection, label: Text("hour")) {
                    ForEach(0..<11) { index in
                        Text("\(index)")
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: self.screenWidth * 0.2, height: self.screenWidth * 0.4)
                .clipped()
                Text("時間")
                    .font(.headline)

                Picker(selection: self.$minSelection, label: Text("分")) {
                    ForEach(0..<60) { index in
                        Text("\(index)")
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: self.screenWidth * 0.2, height: self.screenWidth * 0.4)
                Text("分")
                    .font(.headline)
            }
        }
    }
}

//struct HomeTimePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTimePickerView()
//    }
//}
