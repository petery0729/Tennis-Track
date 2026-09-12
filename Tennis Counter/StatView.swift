//
//  StatView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/8/24.
//

import SwiftUI


struct StatPView: View {
    
    var data: Float
    var total: Float
    
    var text: String
    
    var body: some View {
        VStack {
            HStack {
                Text("\(text): \(Int(data))")
                
            }
            if data != 0 {
                Text("\(Int((data/total)*100))%")
            }
            else {
                Text("0%")
            }
        }.background(Color.green)
            .cornerRadius(10)
            .font(.title2)
    }
}
