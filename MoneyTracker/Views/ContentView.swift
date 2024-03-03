//
//  ContentView.swift
//  MoneyTracker
//
//  Created by Vishal Kashyap on 03/03/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // AUTO CONTEXT INJECTED FROM OUR MODEL. We already confirms.
    @Environment(\.modelContext) private var modelContext
    // after any update of content it will refresh similar to ReactJS.
    @Query(sort: \Expense.date) var expenses: [Expense]
    // More query methods are available - eg:
    // @Query(filter: #Predicate<Expense> { $0.value > 1000 },sort: \Expense.date) var expenses: [Expense]
    @State private var isShowingItemSheet = false
    @State private var expenseToEdit: Expense?

    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { item in
                    ExpenseCell(expense: item)
                        .onTapGesture {
                            expenseToEdit = item
                        }
                }
                .onDelete { indexSet in
                    withAnimation {
                        for index in indexSet {
                            // Query will be auto refresh after deleting the method
                            modelContext.delete(expenses[index])
                            // we can force save here -
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddExpenseSheet()
            }
            // Called when state updates `expenseToEdit`.
            .sheet(item: $expenseToEdit) { expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay(content: {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list.")
                    }, actions: {
                        Button("Add Expenses") {
                            isShowingItemSheet = true
                        }
                    })
                    .offset(y: -60)
                }
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expense.self, inMemory: true)
}

// Cells in mainscreen.
struct ExpenseCell: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "INR"))
        }
    }
}

// For adding a new item.
struct AddExpenseSheet:View {
    // Content of our model - to save the data 
    // We already created container so our whole app has it.
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Float = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    // Dismiss view, no need to save anything.
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        // Created new object with these details for saving.
                        let expense = Expense(name: name, date: date, value: Double(value))
                        // Any change in model, leads to auto save.
                        modelContext.insert(expense)
                        // Wohoo! We saved our data.
                        dismiss()
                        
                    }
                }
            }
        }
    }
}

// For updating exisiting item.
struct UpdateExpenseSheet:View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
