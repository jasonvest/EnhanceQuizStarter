//
//  QuestionModel.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 5/31/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

///Struct to hold necessary data for trivia questions
struct QuestionModel {
    let question: String
    let choices: [String]
    let answer: String
    
    init(question: String, choices: [String], answer: String) {
        self.question = question
        self.choices = choices
        self.answer = answer
    }
}
