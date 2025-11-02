//
//  TaskList.swift
//  ListView
//
//  Created by Sayaka Sasaki on 2025/11/02.
//

import Foundation

struct ExampleTask {
    let taskList = [
        "掃除",
        "洗濯",
        "料理",
        "買い物",
        "読書",
        "運動"
    ]
}
//カスタム構造体Task
//エンコード、デコードが可能なようにCodableに準拠
struct Task: Codable, Identifiable {
    var id = UUID()  //ユニーク(一意)なIDを自動で生成
    var taskItem: String
}




