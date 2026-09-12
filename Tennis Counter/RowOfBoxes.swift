//
//  RowOfBoxes.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 11/12/23.
//

import SwiftUI

struct RowOfBoxes: View {
    var text1: String
    var text2: String
    public mutating func addMis() {
        $counter1+=1
        $counter2+=1
    }
    var body: some View {
        HStack {
            Button(action: addMis) {
                VStack {
                    Text("\(text1)")
                    Text("\($counter1)")
                }
            }
            Button(action: addMis) {
                VStack {
                    Text("\(text2)")
                    Text("\($counter2)")
                }
            }
        }
    }
}
