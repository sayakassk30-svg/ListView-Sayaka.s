//
//  ContentView.swift
//  ListView
//
//  Created by Sayaka Sasaki on 2025/11/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FirstView()
        //SecondView()
    }
}
struct FirstView: View {
    //”TasksDataというキーでUserDefaultsに保存されたものを監視”
    @AppStorage("TasksData") private var tasksData = Data()
    
    // タスクを入れておくための配列
    @State var tasksArray: [Task] = []
    
    //画面生成時にtasksDataをデコードした値をtasksArrayに入れる
    init() {
        if let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData){_tasksArray = State(initialValue: decodedTasks)
            print(tasksArray)
    }
}
    
    var body: some View {
        NavigationStack{//画面の管理等に使用する
            NavigationLink {
                SecondView(tasksArray: $tasksArray)
                    .navigationTitle(Text("Add Task"))
            } label: {
                Text("Add New Task")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
            }
            
            
            List{
                //tasksArrayの中身をリストに表示
                ForEach(tasksArray) { task in
                    Text(task.taskItem)
                }
                .onMove { from, to in
                    //リストを並べ変えたときに実行する処理
                    replaceRow(from, to)
                }
                
                //  削除機能を追加
                .onDelete { indexSet in
                                    deleteRow(at: indexSet)
                                }
            }
            //ナビゲーションバーに編集ボタンを追加
            .toolbar(content: {
                EditButton()
            })
            
            .navigationTitle("Task List")
        }
        .padding()
    }
    
    //並び替え処理と並び替え後の保存
    func replaceRow(_ from: IndexSet, _ to: Int ){
        tasksArray.move(fromOffsets: from, toOffset: to)//配列内での並び替え
        if let encodedArray = try? JSONEncoder().encode(tasksArray){
            tasksData = encodedArray
        }
    }
    //  削除処理
        func deleteRow(at offsets: IndexSet) {
            tasksArray.remove(atOffsets: offsets)
            saveTasks()
        }
        
        //  共通の保存処理
        func saveTasks() {
            if let encodedArray = try? JSONEncoder().encode(tasksArray) {
                tasksData = encodedArray
            }
        }
}


//タスク追加画面の構造体
struct SecondView: View {
    //前の画面に戻るための変数dismissを定義
    @Environment(\.dismiss) private var dismiss
    
    //テキストフィールドに入力された文字を格納する変数
    @State private var task: String = ""
    
    @Binding var tasksArray:[Task]
    
    var body: some View {
        //タスクを入力するフィールド
        TextField("Enter your task", text: $task)
            .textFieldStyle(.roundedBorder)
            .padding()
        
        //タスクの追加ボタン
        Button {
            //ボタンを押した時の処理
            addTask(newTask: task)//入力されたタスクの追加・保存
            task=""//テキストフィールドの初期化
            print(tasksArray)//tasksarrayの中身をコンソールに出力
            
        } label: {
            Text("Add")
        }
        .buttonStyle(.borderedProminent)
        .tint(.brown)
        .padding()
        
        Spacer()
    }
    //タスク追加（保存）の関数
    func addTask(newTask: String){
        //テキストフィールドが空白ではない時だけ処理 ではない→！
        if !newTask.isEmpty {
            let task = Task(taskItem: newTask)//Taskインスタンス化
            var array = tasksArray
            array.append(task)
            
            
            //エンコードがうまくいったらUserDefoltsに保存
            if let encodedData = try? JSONEncoder().encode(array) {
                UserDefaults.standard.setValue(encodedData, forKey: "TasksData")
                tasksArray = array
                dismiss()//前の画面に戻る（来た道を）
            }
        }
    }
    
    
    
}

//
//#Preview("SecondView") {
//    SecondView()
//}

#Preview("FirstView") {
    FirstView()
}

#Preview {
    ContentView()
}
