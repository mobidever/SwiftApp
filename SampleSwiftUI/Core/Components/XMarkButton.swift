//
//  XMarkButton.swift
//  SampleSwiftUI
//
//  Created by PS on 01/04/24.
//

import SwiftUI

struct XMarkButton: View {
	
//	@Environment(\.presentationMode) var presentationMode
	@Environment(\.dismiss) var dismiss

    var body: some View {
		Button(action: {
			dismiss()
		}, label: {
			Image(systemName: "xmark").font(.headline)
		})
    }
}

#Preview {
    XMarkButton()
}
