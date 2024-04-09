//
//  ContentView.swift
//  Supercharger
//
//  Created by Park Seongheon on 4/5/24.
//

import SwiftUI

struct ContentView: View {
    @State var chargingState = ChargingState()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Image("mbp")
                .resizable()
                .scaledToFit()
                .frame(width: 340)
                .rotation3DEffect(
                    .degrees(1),
                    axis: (x: 0.0, y: 0.0, z: 1.0)
                )
                .offset(x: 80, y: 12)
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(
                        chargingState.currentCapacity > 20 ?
                        LinearGradient(
                            colors: [
                                .init(red: 0, green: 0.4, blue: 0), .green
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                            LinearGradient(
                                colors: [
                                    .init(red: 0.3, green: CGFloat(Double(chargingState.currentCapacity/20)*0.1), blue: 0),
                                    .init(red: 0.5, green: CGFloat(Double(chargingState.currentCapacity/20)*0.3), blue: 0.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                    .frame(width: Double(chargingState.currentCapacity/100)*200)
                Rectangle()
                    .opacity(0.1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(width: 200, height: 100)
            .rotation3DEffect(
                .degrees(36),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .offset(x: 75, y: 74)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundStyle(.green)
                        Rectangle()
                            .frame(width: 10, height: 0)
                        Text("Supercharging")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                    }
                    Rectangle()
                        .frame(width: 0, height: 20)
                    Text("Time Remaining")
                        .font(.system(size: 14))
                    Text("35 min")
                        .font(.system(size: 34))
                        .fontWeight(.medium)
                    Rectangle()
                        .frame(width: 0, height: 6)
                    Text("\(chargingState.currentCapacity) %")
                        .contentTransition(.numericText())
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        Text("66 kW")
                            .font(.system(size: 20))
                        Spacer()
                        Text("275 mi/h")
                            .font(.system(size: 20))
                        Spacer()
                        Text("+31 kWh")
                            .font(.system(size: 20))
                    }
                    .frame(width: 320)
                }
                Rectangle()
                    .frame(width: 100, height: 0)
            }
            .padding()
            .frame(width: 800, height: 450)
            .onReceive(timer) { _ in
                chargingState.getPowerStatus()
                chargingState.calculateWattHours()
            }
        }
    }
}

#Preview {
    ContentView()
}
