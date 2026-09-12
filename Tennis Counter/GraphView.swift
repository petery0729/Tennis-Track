//
//  GraphView.swift
//  Tennis Counter
//
//  Created by Peter Yavichev on 7/24/24.
//

import SwiftUI
import Charts

struct GraphPView: View {
    var data: [PercentPoint]
    var textx: String
    var texty: String
    var body: some View {
        if data.isEmpty {
            Text("No Data Yet")
                .background(Color.green)
                .cornerRadius(10)
        }
        else {
            Chart {
                ForEach(data) { d in
                    LineMark(x: .value(textx, d.point), y: .value(texty, d.percent))
                }
            }
            .foregroundStyle(.white)
            .frame(width: 125,height: 125)
            .background(Color.green)
            .chartYScale(range: .plotDimension(padding: 10))
            .chartXAxisLabel(textx, alignment: .bottom)
            .chartYAxisLabel(texty, alignment: .top)
            .padding()
            .cornerRadius(10)
        }
    }
}

//#Preview {
//    GraphView()
//}
