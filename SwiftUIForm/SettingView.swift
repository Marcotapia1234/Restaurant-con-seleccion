//
//  SettingView.swift
//  SwiftUIForm
//
//  Created by Simon Ng on 19/8/2020.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedOrder = DisplayOrderType.alphabetical
    @State private var showCheckInOnly = false
    @State private var maxPriceLevel = 5
    
    @EnvironmentObject var settingStore: SettingStore
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ORDEN DE PREFERENCIA")) {
                    Picker(selection: $selectedOrder, label: Text("LISTADO ORDEN")) {
                        ForEach(DisplayOrderType.allCases, id: \.self) {
                            orderType in
                            Text(orderType.text)
                        }
                    }
                }
                
                Section(header: Text("FILTROS")) {
                    Toggle(isOn: $showCheckInOnly) {
                        Text("SOLO VISITADOS")
                    }
                    
                    Stepper(onIncrement: {
                        self.maxPriceLevel += 1
                        
                        if self.maxPriceLevel > 5 {
                            self.maxPriceLevel = 5
                        }
                    }, onDecrement: {
                        self.maxPriceLevel -= 1
                        
                        if self.maxPriceLevel < 1 {
                            self.maxPriceLevel = 1
                        }
                    }) {
                        Text("Mostrar \(String(repeating: "$", count: maxPriceLevel)) o menos")
                    }
                }
            }
            
            
            .navigationBarTitle("Suscribir")
            
            .navigationBarItems(leading:
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Salir")
                        .foregroundColor(.black)
                })
                
                , trailing:

                Button(action: {
                    self.settingStore.showCheckInOnly = self.showCheckInOnly
                    self.settingStore.displayOrder = self.selectedOrder
                    self.settingStore.maxPriceLevel = self.maxPriceLevel
                    self.presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("Guardar")
                        .foregroundColor(.black)
                })
            )
            
        }
        .onAppear {
            self.selectedOrder = self.settingStore.displayOrder
            self.showCheckInOnly = self.settingStore.showCheckInOnly
            self.maxPriceLevel = self.settingStore.maxPriceLevel
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(SettingStore())
    }
}
