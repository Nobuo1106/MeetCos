//
//  CurrencyTextField.swift
//  MeetCos
//
//  Created by apple on 2023/05/13.
//

import SwiftUI
import UIKit

struct CurrencyTextField: UIViewRepresentable {
    @Binding var value: Int
    
    func makeUIView(context: Context) -> UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textAlignment = .right
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        doneButton.tintColor = UIColor(named: "accent-green")
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.textColor = value == 0 ? .gray : UIColor(Color("inputTextColor"))
        
        return textField
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let textField = uiView as? UITextField {
            textField.text = self.value > 0 ? "¥\(self.value)" : "¥0"
            textField.textColor = self.value > 0 ? UIColor(Color("inputTextColor")): UIColor.gray
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CurrencyTextField
        
        init(_ parent: CurrencyTextField) {
            self.parent = parent
        }
        
        @objc func textFieldDidChange(textField: UITextField) {
            var newText = String(textField.text?.filter { "0123456789".contains($0) } ?? "")
            if newText.isEmpty {
                newText = "0"
            }
            let number = Int(newText) ?? 0
            self.parent.value = number
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            textField.text = "¥" + (formatter.string(from: NSNumber(value: number)) ?? "")
            
            textField.textColor = self.parent.value == 0 ? .gray : UIColor(Color("inputTextColor"))
        }
        
        @objc func doneButtonTapped() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTextField(value: .constant(1000))
    }
}
