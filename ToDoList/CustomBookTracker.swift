//
//  CustomBookTracker.swift
//  ToDoList
//
//  Created by Aditya Medhane on 06/08/24.
//

import SwiftUI
import Foundation

enum BookStatus{
    case read
    case wantToRead
    case currentlyReading
    case didntFinish
    case abandoned
}


struct Book: Identifiable{
    var id = UUID()
    var name:String
    var author: String
    var rating: Int?
    var status: BookStatus
    
    init(id: UUID = UUID(), name: String, author: String, rating: Int? = nil, status: BookStatus) {
        self.id = id
        self.name = name
        self.author = author
        self.rating = rating
        self.status = status
    }
}

struct CustomBookTracker: View {
    @State private var isAddingBook = false
    var body: some View {
        Text("Test")
    }
}

struct AddBookView: View {
    @Binding var isPresented: Bool
    @Binding var book:[Book]
    @State private var newBookTitle: String = ""
    @State private var newBookAuthor: String = ""
    @State private var newBookStatus: BookStatus = .wantToRead
    @State private var newBookRating: Int = 0
    
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Book Information")){
                    TextField("Title", text: $newBookTitle)
                    TextField("Author", text: $newBookAuthor)
                    Picker("Status", selection: $newBookStatus) {
                        Text("Want to Read").tag(BookStatus.wantToRead)
                        Text("Read").tag(BookStatus.read)
                        Text("Didn't Finish").tag(BookStatus.didntFinish)
                        Text("Currently Reading").tag(BookStatus.currentlyReading)
                        Text("Abandoned").tag(BookStatus.abandoned)
                    }
//                    Slider(value: Binding(get: newBookRating, set: newBookRating = $0), in: 0...5, step: 1){
//                        Text("Rating")
//                    }
                    Slider(value: Binding(
                        get: { Double(newBookRating) },
                        set: { newBookRating = Int($0) }
                        ), in: 0...5, step: 1) {
                            Text("Rating")
                        }
                }
            }
            .navigationTitle("Add New Book")
            .navigationBarItems(trailing: Button("Save"){
                let newBook = Book(name: newBookTitle, author: newBookAuthor, status: newBookStatus)
                    book.append(newBook) // Add the new book to the list
                    isPresented = false // Dismiss the sheet
            })
        }
    }
}


#Preview {
    CustomBookTracker()
}
