import SwiftUI

struct SettingsView: View {
    @Binding var interval: Double

    let availableIntervals: [Double] = [5, 10, 15, 30, 60] // in minutes
    
    // This will store the previous interval for animation purposes
    @State private var previousInterval: Double?

    var body: some View {
        Form {
            Section(header: Text("Notification Interval")) {
                Picker("Interval", selection: $interval) {
                    ForEach(availableIntervals, id: \.self) { interval in
                        Text("\(Int(interval)) minutes")
                            .tag(interval) // Bind each interval to a tag
                    }
                }
                .pickerStyle(RadioGroupPickerStyle())
                .onChange(of: interval) { oldValue, newValue in
                    // Trigger animation on interval change
                    withAnimation(.easeInOut(duration: 1.2)) {
                        previousInterval = interval
                    }
                }
                .transition(.scale)  // Apply transition on the Picker
            }
        }
        .padding()
        .frame(width: 300, height: 200)
        .onAppear {
            // Any setup that needs to be done on the view's first appearance
            if previousInterval == nil {
                previousInterval = interval // Set default on first load
            }
        }
        .overlay(
            // Add some animations or feedback on the interval change
            Group {
                if let previousInterval = previousInterval, previousInterval != interval {
                    Text("Change Successful!")
                        .foregroundColor(.green)
                        .font(.footnote)
                        .transition(.opacity)
                        .padding(5)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
            }
            .padding(.top, 40)
        )
    }
}
