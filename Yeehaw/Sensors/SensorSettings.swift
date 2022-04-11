//
//  SensorSettings.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/11/22.
//

import SwiftUI

struct SensorSettings: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var sensor: FetchedResults<SavedDevice>.Element
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingConfirmation = false
    var body: some View {
        VStack {
            List {
                Text("\(sensor.deviceName ?? "No Name")")
                Button(action: {
                    isShowingConfirmation = true
                }) {
                    Text("Forget this device")
                }
                .confirmationDialog("Title", isPresented: $isShowingConfirmation, titleVisibility: .hidden) {
                    
                    Button("Forget this device", role: .destructive) {
                        deleteObject()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }
            }
            
        }
        .navigationTitle("\(sensor.deviceName ?? "No Name")")
        .navigationBarTitleDisplayMode(.inline)
    }
    func deleteObject() {
        withAnimation {
            viewContext.delete(sensor)
            print("Device deleted")
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SensorSettings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SensorSettings(sensor: SavedDevice(context: PersistenceController.singular.container.viewContext))
        }
    }
}
