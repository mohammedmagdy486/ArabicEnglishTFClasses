//
//  EnglishTF.swift
//  Bahar
//
//  Created by Mohamad Basuony on 09/02/2022.
//

import UIKit

class EnglishTF: AppTextField {
    
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if (((mode.primaryLanguage?.contains("en")) != nil)){
//            if mode.primaryLanguage == "en" {
                return mode
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(validateText), for: .editingChanged)

        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(validateText), for: .editingChanged)

        commonInit()
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(inputModeDidChange),
                                               name: UITextInputMode.currentInputModeDidChangeNotification,
                                               object: nil)
        textAlignment = .left
    }
    
    @objc func inputModeDidChange(_ notification: Notification) {
        guard isFirstResponder else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadInputViews()
        }
    }
    @objc private func validateText() {
        let englishCharacters = CharacterSet(charactersIn: "qwertyuiop[]asdfghjkl;' zxcvbnm`1234567890-= QWERTYUIOP[]ASDFGHJKL;''ZXCVBNM,../?+_)(*&^%$#@!~|\":")
        let currentText = self.text ?? ""
        // check if the text contains any non arabic characters
        if let _ = currentText.rangeOfCharacter(from: englishCharacters.inverted) {
            // Show an error message
            let alertController = UIAlertController(title: "Error".localized(), message: "Text field should contain English characters only".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: nil)
            alertController.addAction(okAction)
            self.text = ""
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

}
