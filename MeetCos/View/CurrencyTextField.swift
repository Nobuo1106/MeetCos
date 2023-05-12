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
        let container = UIView()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        textField.textAlignment = .right
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        
        let symbolLabel = UILabel()
        symbolLabel.text = "¥"
        symbolLabel.sizeToFit()
        
        textField.leftView = symbolLabel
        textField.leftViewMode = .always
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        doneButton.tintColor = UIColor(named: "accent-green")
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        
        // Update text color based on value
        textField.textColor = value == 0 ? .gray : .black
        symbolLabel.textColor = value == 0 ? .gray : .black
        
        container.addSubview(symbolLabel)
        container.addSubview(textField)

        // Set up constraints to keep the symbol label on the left
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let textField = uiView.subviews.compactMap({ $0 as? UITextField }).first,
           let symbolLabel = uiView.subviews.compactMap({ $0 as? UILabel }).first {
            textField.text = "\(value)"
            symbolLabel.textColor = self.value > 0 ? UIColor.black : UIColor.gray
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
            let newText = String(textField.text?.filter { "0123456789".contains($0) } ?? "")
            self.parent.value = Int(newText) ?? 0
            
            textField.textColor = self.parent.value == 0 ? .gray : .black
            
            if let symbolLabel = textField.leftView as? UILabel {
                symbolLabel.textColor = self.parent.value == 0 ? .gray : .black
            }
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
