//
//  QuizModel.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 5/31/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

struct QuizModel    {
    let questions: [QuestionModel]

    init(questions: [QuestionModel]) {
        self.questions = questions
    }
}
