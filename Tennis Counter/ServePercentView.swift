//
//  ServePercentView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 6/20/24.
//

import SwiftUI

struct ServePercentView: View {
    
    @Binding var servePercent: Float
    
    var body: some View {
        VStack {
            Text("First Serve Percent")
            Text("\(Int(servePercent))%")
        }.background(Color.green)
            .cornerRadius(10)
            .font(.title2)
    }
}

struct ServePercentPView: View {
    
    var servePercent: Float
    
    var body: some View {
        VStack {
            Text("First Serve Percent")
            Text("\(Int(servePercent))%")
        }.background(Color.green)
            .cornerRadius(10)
            .font(.title2)
    }
}

