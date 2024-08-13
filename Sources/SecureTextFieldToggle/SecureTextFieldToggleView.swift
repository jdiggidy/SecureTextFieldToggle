//
//  SecureTextFieldToggleView.swift
//
//
//  Created by Jeremy Barger on 6/25/24.
//

import SwiftUI

/// The identity of the TextField and the SecureField.
enum Field: Hashable {
    case showPasswordField
    case hidePasswordField
}

/// This view supports a secured field with show / hide functionality.
///
/// We have managed show / hide functionality by using
/// A SecureField to hide the text, and
/// A TextField to show the text.


struct SecuredTextFieldView: View {

    /// Options for opacity of the fields.
    enum Opacity: Double {

        case hide = 0.0
        case show = 1.0

        /// Toggle the field opacity.
        mutating func toggle() {
            switch self {
            case .hide:
                self = .show
            case .show:
                self = .hide
            }
        }
    }

    /// The property wrapper type that can read and write a value that
    /// SwiftUI updates as the placement of focus.
    @FocusState private var focusedField: Field?

    /// The show / hide state of the text.
    @State private var isSecured: Bool = true

    /// The opacity of the SecureField.
    @State private var hidePasswordFieldOpacity = Opacity.show

    /// The opacity of the TextField.
    @State private var showPasswordFieldOpacity = Opacity.hide

    /// The text value of the SecureFiled and TextField which can be
    /// binded with the @State property of the parent view of SecuredTextFieldView.
    @Binding var text: String
    
    /// Parent view of this SecuredTextFieldView.
    /// Also this is a struct and structs are value type.
    @State var parent: SecureTextFieldParentProtocol

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                secureTextField

                Button(action: {
                    performToggle()
                }, label: {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(.gray)
                })
            }
        }
        .onAppear {
            self.parent.hideKeyboard = hideKeyboard
        }
    }

    /// Secured field with the show / hide capability.
    var secureTextField: some View {
        Group {
            SecureField("Password", text: $text)
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .hidePasswordField)
                .opacity(hidePasswordFieldOpacity.rawValue)
            
            TextField("Password", text: $text)
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .showPasswordField)
                .opacity(showPasswordFieldOpacity.rawValue)
        }
    }
    
    /// This supports the parent view to perform hide the keyboard.
    func hideKeyboard() {
        self.focusedField = nil
    }
    
    /// Perform the show / hide toggle by changing the properties.
    private func performToggle() {
        isSecured.toggle()

        if isSecured {
            focusedField = .hidePasswordField
        } else {
            focusedField = .showPasswordField
        }

        hidePasswordFieldOpacity.toggle()
        showPasswordFieldOpacity.toggle()
    }
}

//#Preview {
//    SecuredTextFieldView(text: <#Binding<String>#>, parent: <#any SecureTextFieldParentProtocol#>)
//}
