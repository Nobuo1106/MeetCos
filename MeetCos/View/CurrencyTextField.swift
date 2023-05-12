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
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        
        let symbolLabel = UILabel()
        symbolLabel.text = "¥"
        symbolLabel.sizeToFit()
        
        textField.leftView = symbolLabel
        textField.leftViewMode = .always
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = "\(value)"
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
            let newText = String(textField.text?.filter { "0123456789".contains($0) } ?? "")
            self.parent.value = Int(newText) ?? 0
        }
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTextField(value: .constant(1000))
    }
}
