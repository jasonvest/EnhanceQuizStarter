//
//  QuizModel.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 5/31/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

///Struct for the quiz to hold the assigned questions
struct Quiz    {
    let questions: [Question]

    init(questions: [Question]) {
        self.questions = questions
    }
}
