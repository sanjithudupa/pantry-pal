//
//  PantryView.swift
//  ExpirationTracker
//
//  Created by Sanjith Udupa on 10/10/21.
//

import SwiftUI

struct PantryView: View {
    
    @EnvironmentObject var env : AppEnvironmentData
    
    @State var food_items: [FoodItem] = [FoodItem]()
//        FoodItem(_type: "Milk", _expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
//        FoodItem(_type: "Milk", _expirationDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!),
//        FoodItem(_type: "Milk", _expirationDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
//        FoodItem(_type: "Milk", _expirationDate: Calendar.current.date(byAdding: .day, value: 6, to: Date())!),
//        FoodItem(_type: "Milk", _expirationDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!),
//        FoodItem(_type: "Milk", _expirationDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
//        FoodItem(_type: "Apple", _expirationDate: Calendar.current.date(byAdding: .day, value: 4, to: Date())!),
//        FoodItem(_type: "Grapefruit", _expirationDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!),
//        FoodItem(_type: "Orange Juice", _expirationDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
//        FoodItem(_type: "Watermelon", _expirationDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
//        FoodItem(_type: "Watermelon", _expirationDate: Calendar.current.date(byAdding: .day, value: 6, to: Date())!)
//    ]
    
    @State var groupedItems: [String: [String: [FoodItem]]] = [:]
    
    @State var modalShowing = false
    @State var selectedItems: [FoodItem] = [FoodItem]()
    
    let list: [String] = FoodInfo.foodItems
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("My Pantry")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Text(String(food_items.count) + " items")
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                
                if (food_items.count > 0) {
                    ScrollView() {
                        ForEach(Array(groupedItems.keys), id: \.self) { category in
                            if (Array(groupedItems[category]!.keys).count > 0) {
                                
                                Text(category)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .background(Color.gray.opacity(0.8))
                                
                                UIGrid(columns: 3, list: Array(groupedItems[category]!.keys)) { items in
                                    
                                    Button(action: {
                                        selectedItems = groupedItems[category]![items]!
                                        
                                        modalShowing = true
                                    }) {
                                        PantryItem(items: groupedItems[category]![items]!)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                } else {
                    Spacer()
                    Text("You have no items. Add some!")
                    Image("basket")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                        .saturation(0)
                        .opacity(0.6)
                }
                Spacer()
                    
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .edgesIgnoringSafeArea(.all)
                .opacity(modalShowing ? 0.9 : 0)
                .animation(.spring())
            
            PantryItemModal(showing: $modalShowing, updateView: updateView, items: $selectedItems)
            
            Text("Expiration dates are estimates")
                .offset(y: UIScreen.main.bounds.height/2 - 60)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.env.currentPage = .Camera
                    }) {
                        VStack {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Add Food")
                        }
                    }.padding(.top, 5)
                    .padding(.horizontal, 10)
                }
                Spacer()
            }.onAppear {
                updateView()
                StorageManager.getInstance().updatePantryView = updateView
            }
            
        }.navigationBarHidden(true).navigationBarTitle("")
    }
    
    func updateView() {
        food_items = StorageManager.getInstance().getItems()
        groupedItems = FoodInfo.sortFoodItems(foodItems: food_items)
    }
}

struct PantryItemModal: View {
    @Binding var showing: Bool
    @State var updateView: MethodHandler
    @Binding var items: [FoodItem]
    
    var body: some View {
        ZStack {
            ZStack {
                Color.white
                
                ScrollView() {
                    Spacer()
                    UIGrid(columns: 3, list: items) { item in
                        IndividualPantryItem(item: item, updateView: updateMyView)

                    }
                }.padding()
                
            }
            .cornerRadius(25)
            .shadow(radius: showing ? 25 : 150)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 250, alignment: .center)
            
            if(items.count > 0) {
                Text(items[0].type + ": " + String(items.count) + " total")
                    .font(.title)
                    .offset(y: -125 - 32.5)
            }
            Button(action: {
                showing = false;
            }) {
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(.black)
            }
            .offset(x: -(UIScreen.main.bounds.width * 0.45) + 32.5, y: -125 - 32.5)
        }
        .opacity(showing ? 1 : 0.3)
        .offset(x: 0, y: showing ? 0 : UIScreen.main.bounds.height/2 + 170)
        .animation(.spring())
    }
    
    func updateMyView() {
        showing = false
        updateView()
    }
}


struct IndividualPantryItem: View {
    
    @State var item: FoodItem
    @State var updateView: MethodHandler
    @State var itemState : FoodState = .OK
    
    @State var showingAlert = false
    
    var body: some View {
        VStack {
            Image(item.type.lowercased())
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .onLongPressGesture {
                    showingAlert = true
                }
            Text(itemState == .EXPIRED ? "Expired!" : FoodInfo.formatFoodLabel(date: item.expirationDate))
                .multilineTextAlignment(.center)
                .foregroundColor(itemState == .EXPIRED ? .red : (itemState == .NEARLY_EXPIRED ? .yellow : .green))
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Delete this item?"), message: Text("This will remove the item from your pantry"), primaryButton: .destructive(Text("Yes, delete this " + item.type), action: {
                            StorageManager.getInstance().deleteItem(item: item)
                            updateView()
                            showingAlert = false
                        }),
                        secondaryButton: .cancel())
                }
        }.onAppear {
            itemState = item.getFoodState()
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
