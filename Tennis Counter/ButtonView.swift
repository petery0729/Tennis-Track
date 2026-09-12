//
//  ButtonViews.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 6/20/24.
//

import SwiftUI

struct ButtonView: View {
    
    @Binding var data: Int
    
    var body: some View {
        Text("\(data)")
        .font(.title)
    }
}
struct ButtonPView: View {
    
    var data: Int
    
    var body: some View {
        Text("\(data)")
        .font(.title)
        .foregroundStyle(Color.white)
    }
}

struct ButtonN: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.title2)
            .cornerRadius(10)
    }
}

struct DividerC: View {
    var body: some View {
        Rectangle()
            .background(Color.blue)
            .frame(height:1)
    }
}

struct ButtonsmView: View {
    
    @Binding var data: Float
    @Binding var isAnimated: Bool
    
    var body: some View {
        VStack {
            Text("\(Int(data))")
                .background(Color.green)
                    .cornerRadius(10)
                    .font(.title2)
                    .frame(width: 80, height: 16)
                    .padding(.top)
            Text("+")
                .background(Color.green)
                    .cornerRadius(10)
                    .font(.title2)
                    .frame(width: 80, height: 12)
                    .padding(.bottom)
        }
        .background(Color.green)
        .cornerRadius(10)
        .font(.title2)
        .scaleEffect(isAnimated ? 1.2:1.0)
    }
}

struct ButtonSView: View {
    
    var data: Float
    
    var body: some View {
        Text("\(Int(data))")
        .font(.title2)
        .frame(width: 80, height: 32)
        .padding(.vertical)
        .background(Color.green)
        .cornerRadius(10)
    }
}

struct ButtonSIView: View {
    
    var data: Int
    
    var body: some View {
        Text("\(Int(data))")
            .background(Color.green)
            .cornerRadius(10)
            .font(.title2)
            .frame(width: 80, height: 16)
            .padding(.top)
    }
}

