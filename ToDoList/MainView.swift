import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct TaskGroup: Identifiable {
    let id = UUID()
    var name: String
    var tasks: [Task]
    var color: Color
}

struct MainView: View {
    @State private var taskGroups: [TaskGroup] = [
        TaskGroup(name: "Default", tasks: [
            Task(title: "Buy groceries"),
            Task(title: "Finish project"),
            Task(title: "Call mom")
        ], color: .blue)
    ]
    @State private var newTaskTitle = ""
    @State private var isGroupAddMode = false
    @State private var newGroupName = ""
    @State private var newGroupColor = Color.blue
    @State private var showingCompletedTasks = false
    @State private var editingGroup: TaskGroup?
    @State private var editGroupName = ""
    @State private var editGroupColor: Color = .blue

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.purple.opacity(0.2)

                    VStack {
                        Spacer()
                        Text("My To-Do List")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.purple)

                        AnimatedProgressView(taskGroups: taskGroups)
                            .frame(width: 250, height: 250)
                            .padding()

                        Text("\(Int(overallCompletionPercentage * 100))% Complete")
                            .font(.headline)
                            .foregroundColor(.purple)
                        Spacer()
                    }
                }
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()

                List {
                    ForEach(taskGroups) { group in
                        Section(header:
                            HStack {
                                Text(group.name).foregroundColor(group.color)
                                Spacer()
                                Text("\(completedTasksCount(in: group))/\(group.tasks.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Menu {
                                    Button("Edit") {
                                        editingGroup = group
                                        editGroupName = group.name
                                        editGroupColor = group.color
                                    }
                                    Button("Delete", role: .destructive) {
                                        deleteGroup(group)
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.gray)
                                }
                            }
                        ) {
                            ForEach(group.tasks.filter { showingCompletedTasks ? true : !$0.isCompleted }) { task in
                                TaskRow(task: task, toggleCompletion: { toggleTask(task, in: group) })
                                    .transition(.slide)
                                    .animation(.default, value: task.isCompleted)
                            }
                            .onDelete { indexSet in
                                deleteTask(at: indexSet, in: group)
                            }
                            
                            HStack {
                                TextField("New task for \(group.name)", text: $newTaskTitle)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                Button(action: { addTask(to: group) }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(group.color)
                                        .imageScale(.large)
                                }
                            }
                        }
                    }
                }
                .animation(.default, value: taskGroups.count)

                VStack {
                    Toggle("Add New Group", isOn: $isGroupAddMode)
                        .toggleStyle(SwitchToggleStyle(tint: .purple))
                        .padding(.horizontal)

                    if isGroupAddMode {
                        HStack {
                            TextField("Group name", text: $newGroupName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            ColorPicker("", selection: $newGroupColor)
                                .labelsHidden()
                            
                            Button(action: addNewGroup) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.purple)
                                    .imageScale(.large)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.slide)
                    } else {
                        HStack {
                            TextField("New task", text: $newTaskTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: addTaskToDefaultGroup) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.purple)
                                    .imageScale(.large)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.slide)
                    }
                }
                .animation(.default, value: isGroupAddMode)
                .padding(.vertical)

                Toggle("Show Completed Tasks", isOn: $showingCompletedTasks)
                    .padding(.horizontal)
            }
            .navigationBarHidden(true)
            .sheet(item: $editingGroup) { group in
                GroupEditView(group: group, name: $editGroupName, color: $editGroupColor, onSave: { updatedName, updatedColor in
                    updateGroup(group, name: updatedName, color: updatedColor)
                    editingGroup = nil
                })
            }
        }
    }

    private var overallCompletionPercentage: Double {
        let totalTasks = taskGroups.reduce(0) { $0 + $1.tasks.count }
        let completedTasks = taskGroups.reduce(0) { $0 + $1.tasks.filter { $0.isCompleted }.count }
        return totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }

    private func completedTasksCount(in group: TaskGroup) -> Int {
        group.tasks.filter { $0.isCompleted }.count
    }

    private func addNewGroup() {
        guard !newGroupName.isEmpty else { return }
        withAnimation {
            taskGroups.append(TaskGroup(name: newGroupName, tasks: [], color: newGroupColor))
            newGroupName = ""
            newGroupColor = .blue
            isGroupAddMode = false
        }
    }

    private func addTaskToDefaultGroup() {
        guard !newTaskTitle.isEmpty else { return }
        withAnimation {
            if let index = taskGroups.firstIndex(where: { $0.name == "Default" }) {
                taskGroups[index].tasks.append(Task(title: newTaskTitle))
            } else {
                taskGroups.append(TaskGroup(name: "Default", tasks: [Task(title: newTaskTitle)], color: .blue))
            }
            newTaskTitle = ""
        }
    }

    private func addTask(to group: TaskGroup) {
        guard !newTaskTitle.isEmpty else { return }
        withAnimation {
            if let index = taskGroups.firstIndex(where: { $0.id == group.id }) {
                taskGroups[index].tasks.append(Task(title: newTaskTitle))
            }
            newTaskTitle = ""
        }
    }

    private func deleteTask(at offsets: IndexSet, in group: TaskGroup) {
        withAnimation {
            if let index = taskGroups.firstIndex(where: { $0.id == group.id }) {
                taskGroups[index].tasks.remove(atOffsets: offsets)
            }
        }
    }

    private func toggleTask(_ task: Task, in group: TaskGroup) {
        withAnimation {
            if let groupIndex = taskGroups.firstIndex(where: { $0.id == group.id }),
               let taskIndex = taskGroups[groupIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                taskGroups[groupIndex].tasks[taskIndex].isCompleted.toggle()
            }
        }
    }

    private func deleteGroup(_ group: TaskGroup) {
        withAnimation {
            taskGroups.removeAll { $0.id == group.id }
        }
    }

    private func updateGroup(_ group: TaskGroup, name: String, color: Color) {
        if let index = taskGroups.firstIndex(where: { $0.id == group.id }) {
            taskGroups[index].name = name
            taskGroups[index].color = color
        }
    }
}

struct TaskRow: View {
    let task: Task
    let toggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .animation(.spring(), value: task.isCompleted)
            Text(task.title)
                .strikethrough(task.isCompleted)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: toggleCompletion)
    }
}

struct AnimatedProgressView: View {
    let taskGroups: [TaskGroup]
    @State private var animationTrigger = false

    var body: some View {
        ZStack {
            ForEach(Array(taskGroups.enumerated()), id: \.element.id) { index, group in
                let progress = groupProgress(for: group)
                Circle()
                    .trim(from: 0, to: animationTrigger ? progress : 0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(group.color)
                    .rotationEffect(Angle(degrees: -90))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                    .frame(width: CGFloat(200 - index * 40), height: CGFloat(200 - index * 40))
                    .animation(.spring(response: 1, dampingFraction: 0.8, blendDuration: 0.5).delay(Double(index) * 0.1), value: animationTrigger)
            }

            VStack {
                Text(String(format: "%.0f%%", overallProgress() * 100))
                    .font(.title)
                    .bold()
                Text(nextTaskTitle())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            animationTrigger = true
        }
        .onChange(of: taskGroups.count) { _ in
            animationTrigger = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animationTrigger = true
            }
        }
    }

    private func groupProgress(for group: TaskGroup) -> CGFloat {
        let completedTasks = group.tasks.filter { $0.isCompleted }.count
        return group.tasks.isEmpty ? 0 : CGFloat(completedTasks) / CGFloat(group.tasks.count)
    }

    private func overallProgress() -> Double {
        let totalTasks = taskGroups.reduce(0) { $0 + $1.tasks.count }
        let completedTasks = taskGroups.reduce(0) { $0 + $1.tasks.filter { $0.isCompleted }.count }
        return totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }

    private func nextTaskTitle() -> String {
        for group in taskGroups {
            if let nextTask = group.tasks.first(where: { !$0.isCompleted }) {
                return nextTask.title
            }
        }
        return "All tasks completed!"
    }
}

struct GroupEditView: View {
    let group: TaskGroup
    @Binding var name: String
    @Binding var color: Color
    let onSave: (String, Color) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Group Name", text: $name)
                ColorPicker("Group Color", selection: $color)
            }
            .navigationTitle("Edit Group")
            .navigationBarItems(
                leading: Button("Cancel") {
                    onSave(group.name, group.color)
                },
                trailing: Button("Save") {
                    onSave(name, color)
                }
            )
        }
    }
}

#Preview {
    MainView()
}
