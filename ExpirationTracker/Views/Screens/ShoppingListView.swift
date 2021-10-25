//
//  ShoppingListView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/8/21.
//

import SwiftUI

struct ShoppingListView: View {
    @State private var editMode = EditMode.inactive
    @State var items: [FoodItem] = [FoodItem]()
    
    @State var isAdding: Bool = false
    
    @EnvironmentObject var env : AppEnvironmentData

    var body: some View {
        ZStack {
            NavigationView {
                    List {
                        if (items.count > 0) {
                            ForEach(items) { item in
                                    ShoppingItemView(item: item)
                                        .frame(height: 100)
                                        .tag(item.type)
                            }
                            .onDelete(perform: onDelete)
                        } else {
                            Text("No items")
                        }
                        
                    }
                    .navigationBarTitle("Grocery List")
                    .navigationBarItems(leading: EditButton(), trailing: addButton)
                    .animation(.spring())
                    .environment(\.editMode, $editMode)
                
            }.actionSheet(isPresented: $isAdding) {
                ActionSheet(title: Text("Add an item:"),
                            message: Text("List of available items:"),
                            buttons: getPopupButtons()
                )
            }
            
            ContinueButton(contFunc: contFunc).contentShape(Rectangle())
        }.onAppear {
            items = ScanManager.getInstance().shoppingList
        }
    }
    
    private var addButton: some View {
           switch editMode {
           case .inactive:
               return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
           default:
               return AnyView(EmptyView())
           }
    }
    
    func onAdd() {
        isAdding = true
    }
    
    func onDelete(offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func getPopupButtons() -> [Alert.Button] {
        var arr = [Alert.Button]()
        
        for option in FoodInfo.foodItems {
            arr.append(.default(Text(option), action: {
                isAdding = false
                items.append(FoodItem(_type: option))
            }))
        }
        
        arr.append(.cancel(Text("Cancel"), action: {
            isAdding = false;
        }))
        
        return arr;
    }
    
    func contFunc() {
        if (items.count > 0) {
            StorageManager.getInstance().addItems(newItems: items)
            StorageManager.overwriteStoredItems()
        }
        self.env.currentPage = .Home
        StorageManager.getInstance().updatePantryView()
    }
}

struct Prev: View {
    @State var items = [FoodItem(_type: "Milk"), FoodItem(_type: "Apple"), FoodItem(_type: "Tomato")]

    var body: some View {
        ShoppingListView(items: items)
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        Prev()
    }
}
