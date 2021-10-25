//
//  SettingsScreen.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/24/21.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @State var days: String = "3"
    @State var num_recipes: String = "20"
    @State var changed = false
    @State var editMode: EditMode = .active

    
    @State var showingAttribs = false
    @State var confirmingDelete = false

    var body: some View {
        ZStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    HStack(alignment: .center, spacing: 10) {
                        Text("Days before Expiry Warning:")
                        NumberField(text: $days, keyType: UIKeyboardType.phonePad)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            .onReceive(Just(days)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.days = filtered
                                    }
                            }
                            .frame(width: 100)
                    }
                    Divider()
                    HStack(alignment: .center, spacing: 10) {
                        Text("Number of Recipes To Display:")
                        NumberField(text: $num_recipes, keyType: UIKeyboardType.phonePad)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            .frame(width: 82)
                    }
                    Divider()
                    Text("Configure Pantry Item Types")
                        .bold()
//                    EditButton()
                    List {
                        ForEach(Array(PreferencesManager.getInstance().pantry_categories.keys), id: \.self) { category in
                            Text(category)
                            ForEach(PreferencesManager.getInstance().pantry_categories[category]!, id: \.self) { item in
                                FoodItemListElementView(itemType: item)
                            }
                        }
                    }
                    .environment(\.editMode, $editMode)

                HStack {
                    Button(action: {showingAttribs = true}) {
                        Text("Attributions")
                    }
                        .alert(isPresented: $showingAttribs, content: {
                            Alert(
                                title: Text("Attributions:"),
                                message: Text("Food Image Dateset: Klasson, Marcus and Zhang, Cheng and Kjellstrom, Hedvig - A Hierarchical Grocery Store Image Dataset with Visual and Semantic Labels. \n\n Recipes via SuperCook \n\n Food Icons by users: FreePik, Icongeek26, monkik, prettyicons \n\n Created by Sanjith Udupa")
                            )
                        })
                    Button(action: {confirmingDelete = true}) {
                        Text("Clear Data")
                    }.alert(isPresented: $confirmingDelete, content: {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("Clearing app data will delete all stored items as well as reset your settings."),
                            primaryButton: .destructive(Text("Yes, delete."), action: { StorageManager.getInstance().clearData() }),
                            secondaryButton: .cancel(Text("Nevermind."))
                        )
                    }).foregroundColor(.red)
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        PreferencesManager.getInstance().warning_interval = Int(days) ?? 3
                        PreferencesManager.getInstance().recipe_number = Int(num_recipes) ?? 20
                        
                        days = String(PreferencesManager.getInstance().warning_interval)
                        num_recipes = String(PreferencesManager.getInstance().recipe_number)
                        
                        PreferencesManager.getInstance().save()
                        changed = false
                    }) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                            Text("Save")
                        }
                    }.padding()
                    .offset(x: -10, y: -10)
                    .opacity(changed ? 1 : 0)
                    .animation(.spring())
                }
                Spacer()
            }
        }.navigationBarHidden(true).navigationBarTitle("")
        .onAppear {
            PreferencesManager.getInstance().onChange = {
                changed = true
            }
        }
    }
}

struct NumberField: UIViewRepresentable {
    @Binding var text: String
    var keyType: UIKeyboardType
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = keyType

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = " " + text
    }
}

extension UITextField {
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        PreferencesManager.getInstance().onChange()
        self.resignFirstResponder()
    }
}


struct FoodItemListElementView: View {
    @State var itemType: String
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 25)
            Image(itemType.lowercased())
                .resizable().frame(width: 30, height: 30, alignment: .center)
            Text(itemType)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
