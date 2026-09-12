import SwiftUI

struct ConfirmBackView: View {
    @Environment(\.presentationMode) var presentationMode // For controlling dismissal
    @State private var showAlert = false // To toggle the confirmation alert

    var body: some View {
        NavigationView {
            VStack {
                Text("This is the current view.")
                    .font(.title)
                    .padding()

                Spacer()
            }
            .navigationTitle("Confirm Back")
            .navigationBarBackButtonHidden(true) // Hide default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showAlert = true // Show the alert when the back button is pressed
                    }) {
                        Image(systemName: "chevron.backward") // Custom back button
                            .font(.title3)
                        Text("Back")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Do you want to go back?"),
                    primaryButton: .destructive(Text("Yes")) {
                        presentationMode.wrappedValue.dismiss() // Go back
                    },
                    secondaryButton: .cancel(Text("No")) // Stay on the current view
                )
            }
        }
    }
}

struct ConfirmBackView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmBackView()
    }
}
