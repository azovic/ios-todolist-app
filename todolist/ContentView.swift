import SwiftUI
import SwiftData

enum TodoFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}

struct ContentView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \Todo.createdAt, order: .reverse) private var todos: [Todo]

    @State private var newTodo = ""
    @State private var selectedFilter: TodoFilter = .all
    
    var filteredTodos: [Todo] {
        switch selectedFilter {
        case .all:
            return todos
        case .active:
            return todos.filter { !$0.isCompleted }
        case .completed:
            return todos.filter { $0.isCompleted }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // MARK: - Add Todo
                HStack(spacing: 12) {
                    TextField("Yeni görev", text: $newTodo)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(TodoFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue)
                                .tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)


                    Button {
                        addTodo()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)

                // MARK: - Todo List
                List {
                    ForEach(filteredTodos) { todo in
                        HStack(spacing: 12) {

                            Image(systemName: todo.isCompleted
                                  ? "checkmark.circle.fill"
                                  : "circle")
                                .foregroundColor(todo.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    toggleTodo(todo)
                                }

                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                                .foregroundColor(todo.isCompleted ? .gray : .primary)

                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Todo List")
        }
    }

    // MARK: - Functions

    private func addTodo() {
        guard !newTodo.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let todo = Todo(title: newTodo)
        context.insert(todo)
        newTodo = ""
    }

    private func toggleTodo(_ todo: Todo) {
        todo.isCompleted.toggle()
    }

    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            context.delete(todos[index])
        }
    }
}

