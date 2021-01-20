//
//  TextfieldViews.swift
//  HelloWorld
//
//  Created by Larry N on 12/10/20.
//

import SwiftUI

struct TextFieldView: View {
  
  enum FieldType {
    case name
    case email
    case password
    case number
  }
  
  var type = FieldType.name
  var placeholder: String
  var image: String
  var binding: Binding<String>
  
  var body: some View {
    HStack(spacing: 15) {
      Image(systemName: image)
        .frame(width:20)
      
      switch type {
      case .email:
        TextField(placeholder, text: binding)
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      case .name:
        TextField(placeholder, text: binding)
      case .password:
        SecureField(placeholder, text: binding)
      case .number:
        TextField(placeholder, text: binding)
          .keyboardType(.numberPad)
      }
    }
    .padding()
  }
}
