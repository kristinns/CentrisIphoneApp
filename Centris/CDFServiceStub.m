//
//  CDFServiceStub.m
//  Centris
//
//	This is a service stub API that provides fake data to immitate the actual API.
//	To be used only for developing
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CDFServiceStub.h"

@implementation CDFServiceStub

+ (void)getAssignmentById:(NSInteger)assignmentId courseId:(NSInteger)courseId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    success(nil, nil);
}

+ (void)getMenuWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableDictionary *monday = [[NSMutableDictionary alloc] init];
    [monday setObject:@"2013-12-16T00:00:00" forKey:@"Date"];
    [monday setObject:@"Gratíneruð ýsa með sveppasósu, hrísgrjónum og fersku salati. Ferskt salat með ofnbökuðu rótargrænmeti og kjúkling með hnetudressingu. Ferskt salat með ofnbökuðu rótargrænmeti og hnetudressingu. Kartöflu og sellerírótar súpa." forKey:@"Menu"];
    NSMutableDictionary *tuesday = [[NSMutableDictionary alloc] init];
    [tuesday setObject:@"2013-12-17T00:00:00" forKey:@"Date"];
    [tuesday setObject:@"Spagetti bolognese með hvítlauksbrauði og fersku salati. Tikka masala kjúklingabaunapottréttur með hrísgrjónum og jógúrtsósu. Indversk linsubaunasúpa með ný bökuðu brauði." forKey:@"Menu"];
    NSMutableDictionary *wednesday = [[NSMutableDictionary alloc] init];
    [wednesday setObject:@"2013-12-18T00:00:00" forKey:@"Date"];
    [wednesday setObject:@"Mexikósk kjúklingasúpa með nachos, sýrðum rjóma, osti og ný bökuðu brauði. Grænmetislasagne með hvítlauksbrauði og fersku salati. Sæt kartöflusúpa með rauðu karrý og kókos." forKey:@"Menu"];
    NSMutableDictionary *thursday = [[NSMutableDictionary alloc] init];
    [thursday setObject:@"2013-12-19T00:00:00" forKey:@"Date"];
    [thursday setObject:@"Nautakjöt í drekasósu með hrísgrjónum og fersku salati. Val um 4 tegundir af salati -ferskt salat -sterk kryddað búlgur -bakaðar rauðrófur og epli -papriku salat með rauðlauk og feta osti. Hrísgrjónagrautur með kanillsykri og rúsínum." forKey:@"Menu"];
    NSMutableDictionary *friday = [[NSMutableDictionary alloc] init];
    [friday setObject:@"2013-12-20T00:00:00" forKey:@"Date"];
    [friday setObject:@"Taco veisla: Natahakk, salassósa, sýrður rjómi, ostur, ferskt salat. Taco veisla: steikt grænmeti með pinto baunum, salsa sósa, sýrður rjómi, ostur og ferskt salat. Sveppasúpa með ný bökuðu brauði. " forKey:@"Menu"];
    
    success(nil, @[monday, tuesday, wednesday, thursday, friday]);
}

+ (void)getAssignmentsInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableArray *assignments = [[NSMutableArray alloc] init];
    
    /*
     COURSEINSTANCE ID'S
        Inngangur   22363
        Forritun    22212
        Strjál      22218
        Tölvuhögun  22219
        Verklausnir 22220
     */
    
    /* INNGANGUR 22363 ASSIGNMENTS */
    // assignment 1 HANDED IN, GRADED
    NSMutableDictionary *assignment1 = [[NSMutableDictionary alloc] init];
    [assignment1 setObject:[NSNumber numberWithInteger:1] forKey:@"ID"];
    [assignment1 setObject:@"1. Essay" forKey:@"Title"];
    [assignment1 setObject:@"<p>Write a short paper (approximately 2-3 pages) about a person who has contributed to computer science. You may choose to write about any one of the persons mentioned in the slides, or you could pick someone which isn't mentioned there, but in that case you need to get a permission (basically so we can ensure that the person in question is somewhat connected to computer science!).</p>\r\n<p>The paper should be roughly 2-3 pages long (excluding the front page), students should use their own judgement with regards to spacing, font sizes etc. You should pick your own style, i.e. APA, MLA etc, and stick to it.</p>\r\n<p>You may write in either Icelandic or English, just stick to either language.</p>\r\n<p>You should use at least 2&nbsp;sources (other than Wikipedia), and at least one of them should be a regular book (not just a web page). However, the book may be in electronic form (for instance, found at books.google.com).</p>\r\n<p>Hand in a single document, either in Microsoft Word format (.doc,.docx), Open Document Format (.odt), .pdf or .html.</p>" forKey:@"Description"];
    NSMutableArray *l1 = [[NSMutableArray alloc] init];
    [l1 addObject:@"doc"];
    [l1 addObject:@"docx"];
    [l1 addObject:@"pdf"];
    [assignment1 setObject:l1 forKey:@"AllowedFileExtensions"];
    [assignment1 setObject:[NSNumber numberWithFloat:5.0f] forKey:@"Weight"];
    [assignment1 setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
    [assignment1 setObject:@"2013-11-05T15:00:00" forKey:@"DatePublished"];
    [assignment1 setObject:@"2013-11-15T23:59:00" forKey:@"DateClosed"];
    [assignment1 setObject:[NSNumber numberWithInteger:22363] forKey:@"CourseInstanceID"];
    [assignment1 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment1 setObject:[NSNumber numberWithFloat:10.0f] forKey:@"Grade"];
    [assignment1 setObject:@"Easy peasy" forKey:@"StudentMemo"];
    [assignment1 setObject:@"Great job!" forKey:@"TeacherMemo"];
    [assignment1 setObject:@"2013-11-12T23:44:20" forKey:@"Closes"];
    
    // assignment 2 HANDED IN, GRADED
    NSMutableDictionary *assignment2 = [[NSMutableDictionary alloc] init];
    [assignment2 setObject:[NSNumber numberWithInteger:2] forKey:@"ID"];
    [assignment2 setObject:@"2. Computations in real life" forKey:@"Title"];
    [assignment2 setObject:@"<h3>First practical assignment</h3>\r\n<p>1. Keep a diary for one day, and record everything you do. For each activity, try to determine if some computation was involved, either in the activity itself, or in the required infrastructure.</p>\r\n<p>2. Which of your activities did you follow mechanically? For instance, is there a lot of thinking involved in brushing your teeth? Do you always brush your teeth the same way? If not, why?</p>\r\n<p>&nbsp;</p>\r\n<p>Hand in a single text document (with the .txt extension), containing your answers to these questions.</p>" forKey:@"Description"];
    NSMutableArray *l2 = [[NSMutableArray alloc] init];
    [l2 addObject:@"txt"];
    [l2 addObject:@"zip"];
    [l2 addObject:@"rar"];
    [assignment2 setObject:l2 forKey:@"AllowedFileExtensions"];
    [assignment2 setObject:[NSNumber numberWithFloat:5.0f] forKey:@"Weight"];
    [assignment2 setObject:[NSNumber numberWithInteger:1] forKey:@"MaxStudentsInGroup"];
    [assignment2 setObject:@"2013-11-25T15:00:00" forKey:@"DatePublished"];
    [assignment2 setObject:@"2013-12-05T23:59:59" forKey:@"DateClosed"];
    [assignment2 setObject:[NSNumber numberWithInteger:22363] forKey:@"CourseInstanceID"];
    [assignment2 setObject:[NSNumber numberWithInteger:585999] forKey:@"GroupID"];
    [assignment2 setObject:[NSNumber numberWithFloat:8.5f] forKey:@"Grade"];
    [assignment2 setObject:@"Computations are fundamental thing" forKey:@"StudentMemo"];
    [assignment2 setObject:@"Yes it is! But your solution was bad" forKey:@"TeacherMemo"];
    [assignment2 setObject:@"2013-12-05T23:44:20" forKey:@"Closes"];
    
    // assignment 3 NOT HANDED IN, NOT GRADED
    NSMutableDictionary *assignment3 = [[NSMutableDictionary alloc] init];
    [assignment3 setObject:[NSNumber numberWithInteger:3] forKey:@"ID"];
    [assignment3 setObject:@"Skilaverkefni 1" forKey:@"Title"];
    [assignment3 setObject:@"Do some algorithm that calculates the latency of cat meows when zero gravity is applied to the cats tail." forKey:@"Description"];
    NSMutableArray *l3 = [[NSMutableArray alloc] init];
    [l3 addObject:@"txt"];
    [l3 addObject:@"zip"];
    [l3 addObject:@"rar"];
    [assignment3 setObject:l3 forKey:@"AllowedFileExtensions"];
    [assignment3 setObject:[NSNumber numberWithFloat:15.0f] forKey:@"Weight"];
    [assignment3 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment3 setObject:@"2013-12-10T15:00:00" forKey:@"DatePublished"];
    [assignment3 setObject:@"2013-12-17T23:59:00" forKey:@"DateClosed"];
    [assignment3 setObject:[NSNumber numberWithInteger:22363] forKey:@"CourseInstanceID"];
    [assignment3 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment3 setObject:[NSNull null] forKey:@"Grade"];
    [assignment3 setObject:[NSNull null] forKey:@"StudentMemo"];
    [assignment3 setObject:[NSNull null] forKey:@"TeacherMemo"];
    [assignment3 setObject:[NSNull null] forKey:@"Closes"];
    /* END OF INNGANGUR ASSIGNMENTS */
    
    /* FORRITUN 22212 ASSIGNMENTS */
    // assignment 4 HANDED IN, GRADED
    NSMutableDictionary *assignment4 = [[NSMutableDictionary alloc] init];
    [assignment4 setObject:[NSNumber numberWithInteger:4] forKey:@"ID"];
    [assignment4 setObject:@"Dæmatímaverkefni 1" forKey:@"Title"];
    [assignment4 setObject:@"Do something with Java. Burn it, I don't care. Just don't come complaining when you can't pass anything by reference." forKey:@"Description"];
    NSMutableArray *l4 = [[NSMutableArray alloc] init];
    [l4 addObject:@"txt"];
    [l4 addObject:@"zip"];
    [l4 addObject:@"rar"];
    [assignment4 setObject:l4 forKey:@"AllowedFileExtensions"];
    [assignment4 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment4 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment4 setObject:@"2013-11-20T15:00:00" forKey:@"DatePublished"];
    [assignment4 setObject:@"2013-11-28T23:59:00" forKey:@"DateClosed"];
    [assignment4 setObject:[NSNumber numberWithInteger:22212] forKey:@"CourseInstanceID"];
    [assignment4 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment4 setObject:[NSNumber numberWithFloat:10.0f] forKey:@"Grade"];
    [assignment4 setObject:@"Great assignment!" forKey:@"StudentMemo"];
    [assignment4 setObject:@"Perfect" forKey:@"TeacherMemo"];
    [assignment4 setObject:@"2013-11-25T23:00:00" forKey:@"Closes"];
    
    // assignment 5, HANDED IN, GRADED
    NSMutableDictionary *assignment5 = [[NSMutableDictionary alloc] init];
    [assignment5 setObject:[NSNumber numberWithInteger:5] forKey:@"ID"];
    [assignment5 setObject:@"Dæmatímaverkefni 2" forKey:@"Title"];
    [assignment5 setObject:@"See page 67 in the text book. Use if and for for flow control. Yes, that's a double for. It's an eight!" forKey:@"Description"];
    NSMutableArray *l5 = [[NSMutableArray alloc] init];
    [l5 addObject:@"txt"];
    [l5 addObject:@"zip"];
    [l5 addObject:@"rar"];
    [assignment5 setObject:l5 forKey:@"AllowedFileExtensions"];
    [assignment5 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment5 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment5 setObject:@"2013-12-05T15:00:00" forKey:@"DatePublished"];
    [assignment5 setObject:@"2013-12-10T23:59:00" forKey:@"DateClosed"];
    [assignment5 setObject:[NSNumber numberWithInteger:22212] forKey:@"CourseInstanceID"];
    [assignment5 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment5 setObject:[NSNumber numberWithFloat:9.3f] forKey:@"Grade"];
    [assignment5 setObject:@"Great assignment!" forKey:@"StudentMemo"];
    [assignment5 setObject:@"Perfect" forKey:@"TeacherMemo"];
    [assignment5 setObject:@"2013-12-09T23:00:00" forKey:@"Closes"];
    
    // assignment 6 NOT HANDED IN, NOT GRADED
    NSMutableDictionary *assignment6 = [[NSMutableDictionary alloc] init];
    [assignment6 setObject:[NSNumber numberWithInteger:6] forKey:@"ID"];
    [assignment6 setObject:@"Skilaverkefni 1" forKey:@"Title"];
    [assignment6 setObject:@"Do some algorithm that calculates the latency of cat meows when zero gravity is applied to the cats tail." forKey:@"Description"];
    NSMutableArray *l6 = [[NSMutableArray alloc] init];
    [l6 addObject:@"txt"];
    [l6 addObject:@"zip"];
    [l6 addObject:@"rar"];
    [assignment6 setObject:l6 forKey:@"AllowedFileExtensions"];
    [assignment6 setObject:[NSNumber numberWithFloat:15.0f] forKey:@"Weight"];
    [assignment6 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment6 setObject:@"2013-12-10T15:00:00" forKey:@"DatePublished"];
    [assignment6 setObject:@"2013-12-17T23:59:00" forKey:@"DateClosed"];
    [assignment6 setObject:[NSNumber numberWithInteger:22212] forKey:@"CourseInstanceID"];
    [assignment6 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment6 setObject:[NSNull null] forKey:@"Grade"];
    [assignment6 setObject:[NSNull null] forKey:@"StudentMemo"];
    [assignment6 setObject:[NSNull null] forKey:@"TeacherMemo"];
    [assignment6 setObject:[NSNull null] forKey:@"Closes"];
    /* END OF FORRITUN ASSIGNMENTS */
    
    /* STRJÁL 22218 ASSIGNMENTS */
    // assignment 7, HANDED IN, GRADED
    NSMutableDictionary *assignment7 = [[NSMutableDictionary alloc] init];
    [assignment7 setObject:[NSNumber numberWithInteger:7] forKey:@"ID"];
    [assignment7 setObject:@"Dæmaskammtur 1" forKey:@"Title"];
    [assignment7 setObject:@"Think about Dijkstra people!" forKey:@"Description"];
    NSMutableArray *l7 = [[NSMutableArray alloc] init];
    [l7 addObject:@"txt"];
    [l7 addObject:@"zip"];
    [l7 addObject:@"rar"];
    [assignment7 setObject:l7 forKey:@"AllowedFileExtensions"];
    [assignment7 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment7 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment7 setObject:@"2013-11-20T15:00:00" forKey:@"DatePublished"];
    [assignment7 setObject:@"2013-11-28T23:59:00" forKey:@"DateClosed"];
    [assignment7 setObject:[NSNumber numberWithInteger:22218] forKey:@"CourseInstanceID"];
    [assignment7 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment7 setObject:[NSNumber numberWithFloat:9.2f] forKey:@"Grade"];
    [assignment7 setObject:@"This was easy. I paid attention in class" forKey:@"StudentMemo"];
    [assignment7 setObject:@"Very good. Keep up the good work" forKey:@"TeacherMemo"];
    [assignment7 setObject:@"2013-11-27T23:00:00" forKey:@"Closes"];
    
    // assignment 8, HANDED IN, GRADED
    NSMutableDictionary *assignment8 = [[NSMutableDictionary alloc] init];
    [assignment8 setObject:[NSNumber numberWithInteger:8] forKey:@"ID"];
    [assignment8 setObject:@"Dæmaskammtur 2" forKey:@"Title"];
    [assignment8 setObject:@"Reduce the matrix and follow the white rabbit!" forKey:@"Description"];
    NSMutableArray *l8 = [[NSMutableArray alloc] init];
    [l8 addObject:@"txt"];
    [l8 addObject:@"zip"];
    [l8 addObject:@"rar"];
    [assignment8 setObject:l8 forKey:@"AllowedFileExtensions"];
    [assignment8 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment8 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment8 setObject:@"2013-12-05T15:00:00" forKey:@"DatePublished"];
    [assignment8 setObject:@"2013-12-10T23:59:00" forKey:@"DateClosed"];
    [assignment8 setObject:[NSNumber numberWithInteger:22218] forKey:@"CourseInstanceID"];
    [assignment8 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment8 setObject:[NSNumber numberWithFloat:7.9f] forKey:@"Grade"];
    [assignment8 setObject:@"This was harder. I was sleeping in the last class!" forKey:@"StudentMemo"];
    [assignment8 setObject:@"Pick up the pace young man." forKey:@"TeacherMemo"];
    [assignment8 setObject:@"2013-12-04T23:00:00" forKey:@"Closes"];
    
    // assignment 9, HANDED IN, GRADED
    NSMutableDictionary *assignment9 = [[NSMutableDictionary alloc] init];
    [assignment9 setObject:[NSNumber numberWithInteger:9] forKey:@"ID"];
    [assignment9 setObject:@"Dæmaskammtur 3" forKey:@"Title"];
    [assignment9 setObject:@"You are on a weighted path to success!" forKey:@"Description"];
    NSMutableArray *l9 = [[NSMutableArray alloc] init];
    [l9 addObject:@"txt"];
    [l9 addObject:@"zip"];
    [l9 addObject:@"rar"];
    [assignment9 setObject:l9 forKey:@"AllowedFileExtensions"];
    [assignment9 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment9 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment9 setObject:@"2013-12-10T15:00:00" forKey:@"DatePublished"];
    [assignment9 setObject:@"2013-12-15T23:59:00" forKey:@"DateClosed"];
    [assignment9 setObject:[NSNumber numberWithInteger:22218] forKey:@"CourseInstanceID"];
    [assignment9 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment9 setObject:[NSNumber numberWithFloat:5.1f] forKey:@"Grade"];
    [assignment9 setObject:@"I'm failing!" forKey:@"StudentMemo"];
    [assignment9 setObject:@"See me in my office. You need to change how you are learning." forKey:@"TeacherMemo"];
    [assignment9 setObject:@"2013-12-14T23:00:00" forKey:@"Closes"];
    
    // assignment 10 NOT HANDED IN, NOT GRADED
    NSMutableDictionary *assignment10 = [[NSMutableDictionary alloc] init];
    [assignment10 setObject:[NSNumber numberWithInteger:10] forKey:@"ID"];
    [assignment10 setObject:@"Dæmaskammtur 4" forKey:@"Title"];
    [assignment10 setObject:@"Very short notice. Sorry, but my cat was a bitch so I couldn't get to it before now." forKey:@"Description"];
    NSMutableArray *l10 = [[NSMutableArray alloc] init];
    [l10 addObject:@"txt"];
    [l10 addObject:@"zip"];
    [l10 addObject:@"rar"];
    [assignment10 setObject:l6 forKey:@"AllowedFileExtensions"];
    [assignment10 setObject:[NSNumber numberWithFloat:15.0f] forKey:@"Weight"];
    [assignment10 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment10 setObject:@"2013-12-15T15:00:00" forKey:@"DatePublished"];
    [assignment10 setObject:@"2013-12-16T23:59:00" forKey:@"DateClosed"];
    [assignment10 setObject:[NSNumber numberWithInteger:22218] forKey:@"CourseInstanceID"];
    [assignment10 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment10 setObject:[NSNull null] forKey:@"Grade"];
    [assignment10 setObject:[NSNull null] forKey:@"StudentMemo"];
    [assignment10 setObject:[NSNull null] forKey:@"TeacherMemo"];
    [assignment10 setObject:[NSNull null] forKey:@"Closes"];
    /* END OF STRJÁL ASSIGNMENTS */
    
    /* TÖLVUHÖGUN  22219 ASSIGNMENTS */
    // assignment 11, HANDED IN, GRADED
    NSMutableDictionary *assignment11 = [[NSMutableDictionary alloc] init];
    [assignment11 setObject:[NSNumber numberWithInteger:11] forKey:@"ID"];
    [assignment11 setObject:@"Dæmatími 1 - Mary vélin" forKey:@"Title"];
    [assignment11 setObject:@"Proud mary, keep on rolling." forKey:@"Description"];
    NSMutableArray *l11 = [[NSMutableArray alloc] init];
    [l11 addObject:@"txt"];
    [l11 addObject:@"zip"];
    [l11 addObject:@"rar"];
    [assignment11 setObject:l11 forKey:@"AllowedFileExtensions"];
    [assignment11 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment11 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment11 setObject:@"2013-11-20T15:00:00" forKey:@"DatePublished"];
    [assignment11 setObject:@"2013-11-28T23:59:00" forKey:@"DateClosed"];
    [assignment11 setObject:[NSNumber numberWithInteger:22219] forKey:@"CourseInstanceID"];
    [assignment11 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment11 setObject:[NSNumber numberWithFloat:10.0f] forKey:@"Grade"];
    [assignment11 setObject:@"I like Mary." forKey:@"StudentMemo"];
    [assignment11 setObject:@"Mary likes you <3." forKey:@"TeacherMemo"];
    [assignment11 setObject:@"2013-11-27T23:00:00" forKey:@"Closes"];
    
    // assignment 12, HANDED IN, GRADED
    NSMutableDictionary *assignment12 = [[NSMutableDictionary alloc] init];
    [assignment12 setObject:[NSNumber numberWithInteger:11] forKey:@"ID"];
    [assignment12 setObject:@"Skilaverkefni 1 - 101011100101" forKey:@"Title"];
    [assignment12 setObject:@"Proud mary, keep on rolling." forKey:@"Description"];
    NSMutableArray *l12 = [[NSMutableArray alloc] init];
    [l12 addObject:@"txt"];
    [l12 addObject:@"zip"];
    [l12 addObject:@"rar"];
    [assignment12 setObject:l11 forKey:@"AllowedFileExtensions"];
    [assignment12 setObject:[NSNumber numberWithInteger:25] forKey:@"Weight"];
    [assignment12 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment12 setObject:@"2013-12-05T15:00:00" forKey:@"DatePublished"];
    [assignment12 setObject:@"2013-12-10T23:59:00" forKey:@"DateClosed"];
    [assignment12 setObject:[NSNumber numberWithInteger:22219] forKey:@"CourseInstanceID"];
    [assignment12 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment12 setObject:[NSNumber numberWithFloat:9.0f] forKey:@"Grade"];
    [assignment12 setObject:@"101010101011010101011101" forKey:@"StudentMemo"];
    [assignment12 setObject:@"1010101010010 010101010 010010" forKey:@"TeacherMemo"];
    [assignment12 setObject:@"2013-12-08T23:00:00" forKey:@"Closes"];
    /* END OF TÖLVUHÖGUN ASSIGNMENTS */
    
    /* VERKLAUSNIR 22220 ASSIGNMENTS */
    // assignment 13, HANDED IN, GRADED
    NSMutableDictionary *assignment13 = [[NSMutableDictionary alloc] init];
    [assignment13 setObject:[NSNumber numberWithInteger:13] forKey:@"ID"];
    [assignment13 setObject:@"1. Hugsað upphátt í pörum" forKey:@"Title"];
    [assignment13 setObject:@"Hugsið, og þér munið hugsa." forKey:@"Description"];
    NSMutableArray *l13 = [[NSMutableArray alloc] init];
    [l13 addObject:@"txt"];
    [l13 addObject:@"zip"];
    [l13 addObject:@"rar"];
    [assignment13 setObject:l13 forKey:@"AllowedFileExtensions"];
    [assignment13 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment13 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment13 setObject:@"2013-11-20T15:00:00" forKey:@"DatePublished"];
    [assignment13 setObject:@"2013-11-28T23:59:00" forKey:@"DateClosed"];
    [assignment13 setObject:[NSNumber numberWithInteger:22220] forKey:@"CourseInstanceID"];
    [assignment13 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment13 setObject:[NSNumber numberWithFloat:8.5f] forKey:@"Grade"];
    [assignment13 setObject:@"Ég huxa." forKey:@"StudentMemo"];
    [assignment13 setObject:@"Flott." forKey:@"TeacherMemo"];
    [assignment13 setObject:@"2013-11-27T23:00:00" forKey:@"Closes"];
    
    // assignment 14, HANDED IN, GRADED
    NSMutableDictionary *assignment14 = [[NSMutableDictionary alloc] init];
    [assignment14 setObject:[NSNumber numberWithInteger:14] forKey:@"ID"];
    [assignment14 setObject:@"2. Leikir og spil" forKey:@"Title"];
    [assignment14 setObject:@"Í það minnsta kerti og spil." forKey:@"Description"];
    NSMutableArray *l14 = [[NSMutableArray alloc] init];
    [l14 addObject:@"txt"];
    [l14 addObject:@"zip"];
    [l14 addObject:@"rar"];
    [assignment14 setObject:l14 forKey:@"AllowedFileExtensions"];
    [assignment14 setObject:[NSNumber numberWithInteger:5] forKey:@"Weight"];
    [assignment14 setObject:[NSNumber numberWithInteger:2] forKey:@"MaxStudentsInGroup"];
    [assignment14 setObject:@"2013-12-05T15:00:00" forKey:@"DatePublished"];
    [assignment14 setObject:@"2013-12-10T23:59:00" forKey:@"DateClosed"];
    [assignment14 setObject:[NSNumber numberWithInteger:22220] forKey:@"CourseInstanceID"];
    [assignment14 setObject:[NSNull null] forKey:@"GroupID"];
    [assignment14 setObject:[NSNumber numberWithFloat:9.3f] forKey:@"Grade"];
    [assignment14 setObject:@":S" forKey:@"StudentMemo"];
    [assignment14 setObject:@"Vel leikið." forKey:@"TeacherMemo"];
    [assignment14 setObject:@"2013-12-08T23:00:00" forKey:@"Closes"];
    /* END OF VERKLAUSNIR 22220 ASSIGNMENTS */
    
    [assignments addObject:assignment1];
    [assignments addObject:assignment2];
    [assignments addObject:assignment3];
    [assignments addObject:assignment4];
    [assignments addObject:assignment5];
    [assignments addObject:assignment6];
    [assignments addObject:assignment7];
    [assignments addObject:assignment8];
    [assignments addObject:assignment9];
    [assignments addObject:assignment10];
    [assignments addObject:assignment11];
    [assignments addObject:assignment12];
    [assignments addObject:assignment13];
    [assignments addObject:assignment14];
    success(nil, assignments);
}

+ (void)getCoursesInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableArray  *courseInstArray = [[NSMutableArray alloc] init];
    
    // T-109-INTO
    NSMutableDictionary *courseInst1 = [[NSMutableDictionary alloc] init];
    [courseInst1 setObject:[NSNumber numberWithInt:22363] forKey:@"ID"];
    [courseInst1 setObject:@"T-109-INTO" forKey:@"CourseID"];
    [courseInst1 setObject:@"Inngangur að tölvunarfræði" forKey:@"Name"];
    [courseInst1 setObject:@"20113" forKey:@"Semester"];
    [courseInst1 setObject:@"Some syllabus" forKey:@"Syllabus"];
    [courseInst1 setObject:@"Some content" forKey:@"Content"];
    [courseInst1 setObject:@"Some assessment methods" forKey:@"AssessmentMethods"];
    [courseInst1 setObject:@"Some learning outcome" forKey:@"LearningOutcome"];
    [courseInst1 setObject:@"Some teaching methods" forKey:@"TeachingMethods"];
    [courseInstArray addObject:courseInst1];
    
    // T-111-PROG
    NSMutableDictionary *courseInst2 = [[NSMutableDictionary alloc] init];
    [courseInst2 setObject:[NSNumber numberWithInt:22212] forKey:@"ID"];
    [courseInst2 setObject:@"T-111-PROG" forKey:@"CourseID"];
    [courseInst2 setObject:@"Forritun" forKey:@"Name"];
    [courseInst2 setObject:@"20113" forKey:@"Semester"];
    [courseInst2 setObject:@"Some syllabus" forKey:@"Syllabus"];
    [courseInst2 setObject:@"Some content" forKey:@"Content"];
    [courseInst2 setObject:@"Some assessment methods" forKey:@"AssessmentMethods"];
    [courseInst2 setObject:@"Some learning outcome" forKey:@"LearningOutcome"];
    [courseInst2 setObject:@"Some teaching methods" forKey:@"TeachingMethods"];
    [courseInstArray addObject:courseInst2];
    
    // T-117-STR1
    NSMutableDictionary *courseInst3 = [[NSMutableDictionary alloc] init];
    [courseInst3 setObject:[NSNumber numberWithInt:22218] forKey:@"ID"];
    [courseInst3 setObject:@"T-117-STR1" forKey:@"CourseID"];
    [courseInst3 setObject:@"Strjál Stærðfræði I" forKey:@"Name"];
    [courseInst3 setObject:@"20113" forKey:@"Semester"];
    [courseInst3 setObject:@"Some syllabus" forKey:@"Syllabus"];
    [courseInst3 setObject:@"Some content" forKey:@"Content"];
    [courseInst3 setObject:@"Some assessment methods" forKey:@"AssessmentMethods"];
    [courseInst3 setObject:@"Some learning outcome" forKey:@"LearningOutcome"];
    [courseInst3 setObject:@"Some teaching methods" forKey:@"TeachingMethods"];
    [courseInstArray addObject:courseInst3];
    
    // T-107-TOLH
    NSMutableDictionary *courseInst4 = [[NSMutableDictionary alloc] init];
    [courseInst4 setObject:[NSNumber numberWithInt:22219] forKey:@"ID"];
    [courseInst4 setObject:@"T-107-TOLH" forKey:@"CourseID"];
    [courseInst4 setObject:@"Tölvuhögun" forKey:@"Name"];
    [courseInst4 setObject:@"20113" forKey:@"Semester"];
    [courseInst4 setObject:@"Some syllabus" forKey:@"Syllabus"];
    [courseInst4 setObject:@"Some content" forKey:@"Content"];
    [courseInst4 setObject:@"Some assessment methods" forKey:@"AssessmentMethods"];
    [courseInst4 setObject:@"Some learning outcome" forKey:@"LearningOutcome"];
    [courseInst4 setObject:@"Some teaching methods" forKey:@"TeachingMethods"];
    [courseInstArray addObject:courseInst4];
    
    // T-110-VERK
    NSMutableDictionary *courseInst5 = [[NSMutableDictionary alloc] init];
    [courseInst5 setObject:[NSNumber numberWithInt:22220] forKey:@"ID"];
    [courseInst5 setObject:@"T-110-VERK" forKey:@"CourseID"];
    [courseInst5 setObject:@"Verkefnalausnir" forKey:@"Name"];
    [courseInst5 setObject:@"20113" forKey:@"Semester"];
    [courseInst5 setObject:@"Some syllabus" forKey:@"Syllabus"];
    [courseInst5 setObject:@"Some content" forKey:@"Content"];
    [courseInst5 setObject:@"Some assessment methods" forKey:@"AssessmentMethods"];
    [courseInst5 setObject:@"Some learning outcome" forKey:@"LearningOutcome"];
    [courseInst5 setObject:@"Some teaching methods" forKey:@"TeachingMethods"];
    [courseInstArray addObject:courseInst5];
    
    // Finally, return courseInstArray
    success(nil, courseInstArray);
}

// This function is immitating the post request. Given an email (and password when ready), the fetcher
// should try to login the user and get user details back.
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSMutableDictionary *info = nil;
	
	if ([@"kristinns11" isEqualToString:email]) {
		info = [[NSMutableDictionary alloc] init];
		NSMutableDictionary * person = [[NSMutableDictionary alloc] init];
		[person setObject:@"Tröllhólum 12" forKey:@"Address"];
		[person setObject:@"kristinns11@ru.is" forKey:@"Email"];
        [person setObject:@"kristinns11" forKey:@"Username"];
		[person setObject:@"18748" forKey:@"ID"];
		[person setObject:@"8657231" forKey:@"MobilePhone"];
		[person setObject:@"Kristinn Svansson" forKey:@"Name"];
		[person setObject:@"800" forKey:@"Postal"];
		[person setObject:@"2402912319" forKey:@"SSN"];
		[info setObject:person forKey:@"Person"];
		
		NSMutableDictionary *registration = [[NSMutableDictionary  alloc] init];
		NSMutableDictionary *studentRegistration = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *major = [[NSMutableDictionary alloc] init];
		
		[registration setObject:@"Tölvunarfræðideild" forKey:@"DepartmentName"];
		[registration setObject:@"Staðarnám" forKey:@"StudentTypeName"];
		
		[studentRegistration setObject:[NSNumber numberWithInteger:18] forKey:@"ECTSActive"];
		[studentRegistration setObject:[NSNumber numberWithInteger:72] forKey:@"ECTSFinished"];
		[studentRegistration setObject:[NSNumber numberWithDouble:9] forKey:@"AverageGrade"];
		[registration setObject:studentRegistration forKey:@"StudentRegistration"];
		
		[major setObject:@"BSc í tölvunarfræði" forKey:@"Name"];
		[major setObject:@"BSc in Computer Science" forKey:@"NameEnglish"];
		[major setObject:[NSNumber numberWithInteger:180] forKey:@"Credits"];
		[registration setObject:major forKey:@"Major"];
		
		[info setObject:registration forKey:@"Registration"];
		

	} else if ([@"bjarkim11" isEqualToString:email]) {
		info = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
		[person setObject:@"Ljósheimum 2" forKey:@"Address"];
		[person setObject:@"bjarkim11@ru.is" forKey:@"Email"];
        [person setObject:@"bjarkim11" forKey:@"Username"];
		[person setObject:@"18703" forKey:@"ID"];
		[person setObject:@"8698649" forKey:@"MobilePhone"];
		[person setObject:@"Bjarki Sörens Madsen" forKey:@"Name"];
		[person setObject:@"104" forKey:@"Postal"];
		[person setObject:@"0805903269" forKey:@"SSN"];
		[info setObject:person forKey:@"Person"];
		
		NSMutableDictionary *registration = [[NSMutableDictionary  alloc] init];
		NSMutableDictionary *studentRegistration = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *major = [[NSMutableDictionary alloc] init];
		
		[registration setObject:@"Tölvunarfræðideild" forKey:@"DepartmentName"];
		[registration setObject:@"Staðarnám" forKey:@"StudentTypeName"];
		
		[studentRegistration setObject:[NSNumber numberWithInteger:24] forKey:@"ECTSActive"];
		[studentRegistration setObject:[NSNumber numberWithInteger:66] forKey:@"ECTSFinished"];
		[studentRegistration setObject:[NSNumber numberWithDouble:7.5] forKey:@"AverageGrade"];
		[registration setObject:studentRegistration forKey:@"StudentRegistration"];
		
		[major setObject:@"BSc í tölvunarfræði" forKey:@"Name"];
		[major setObject:@"BSc in Computer Science" forKey:@"NameEnglish"];
		[major setObject:[NSNumber numberWithInteger:180] forKey:@"Credits"];
		[registration setObject:major forKey:@"Major"];
		
		[info setObject:registration forKey:@"Registration"];
	}
	else {
		return failure(nil, nil);
	}
	
	success(nil, info);
}

+ (void)getScheduleInSemester:(NSString *)semester success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSMutableArray *schedule = [[NSMutableArray alloc] init];
    
    /* Monday Week 1 */
    
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"1", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-09T08:30:00", @"StartTime",
						 @"2013-12-09T10:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"2", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-09T10:20:00", @"StartTime",
						 @"2013-12-09T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"3", @"ID",
						 @"22218", @"CourseID",
						 @"Strjál stærðfræði I", @"CourseName",
						 @"M110", @"RoomName",
						 @"2013-12-09T13:10:00", @"StartTime",
						 @"2013-12-09T14:45:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Tuesday Week 1 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"4", @"ID",
						 @"22219", @"CourseID",
						 @"Tölvuhögun", @"CourseName",
						 @"M105", @"RoomName",
						 @"2013-12-10T10:20:00", @"StartTime",
						 @"2013-12-10T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"5", @"ID",
						 @"22220", @"CourseID",
						 @"Verkefnalausnir", @"CourseName",
						 @"M201", @"RoomName",
						 @"2013-12-10T13:10:00", @"StartTime",
						 @"2013-12-10T16:30:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Wednesday Week 1 */
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"6", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"V101", @"RoomName",
						 @"2013-12-11T08:30:00", @"StartTime",
						 @"2013-12-11T09:15:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"7", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-12-11T09:20:00", @"StartTime",
						 @"2013-12-11T11:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Thursday Week 1 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"8", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M124", @"RoomName",
						 @"2013-12-12T10:20:00", @"StartTime",
						 @"2013-12-12T11:55:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"9", @"ID",
						 @"22218", @"CourseID",
						 @"Strjál stærðfræði I", @"CourseName",
						 @"M110", @"RoomName",
						 @"2013-12-12T14:00:00", @"StartTime",
						 @"2013-12-12T15:40:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    /* Friday Week 1 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"10", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-13T12:20:00", @"StartTime",
						 @"2013-12-13T13:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"11", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M104", @"RoomName",
						 @"2013-12-13T14:00:00", @"StartTime",
						 @"2013-12-13T15:40:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Monday Week 2 */

	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"12", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-16T08:30:00", @"StartTime",
						 @"2013-12-16T10:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"13", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-16T10:20:00", @"StartTime",
						 @"2013-12-16T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"14", @"ID",
						 @"22218", @"CourseID",
						 @"Strjál stærðfræði I", @"CourseName",
						 @"M110", @"RoomName",
						 @"2013-12-16T13:10:00", @"StartTime",
						 @"2013-12-16T14:45:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Tuesday Week 2 */
   
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"15", @"ID",
						 @"22219", @"CourseID",
						 @"Tölvuhögun", @"CourseName",
						 @"M105", @"RoomName",
						 @"2013-12-17T10:20:00", @"StartTime",
						 @"2013-12-17T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];

    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"16", @"ID",
						 @"22220", @"CourseID",
						 @"Verkefnalausnir", @"CourseName",
						 @"M201", @"RoomName",
						 @"2013-12-17T13:10:00", @"StartTime",
						 @"2013-12-17T16:30:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Wednesday Week 2 */
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"17", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"V101", @"RoomName",
						 @"2013-12-18T08:30:00", @"StartTime",
						 @"2013-12-18T09:15:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"18", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-12-18T09:20:00", @"StartTime",
						 @"2013-12-18T11:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Thursday Week 2 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"19", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M124", @"RoomName",
						 @"2013-12-19T10:20:00", @"StartTime",
						 @"2013-12-19T11:55:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"20", @"ID",
						 @"22218", @"CourseID",
						 @"Strjál stærðfræði I", @"CourseName",
						 @"M110", @"RoomName",
						 @"2013-12-19T14:00:00", @"StartTime",
						 @"2013-12-19T15:40:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    /* Friday Week 2 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"21", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-20T12:20:00", @"StartTime",
						 @"2013-12-20T13:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"22", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M104", @"RoomName",
						 @"2013-12-20T14:00:00", @"StartTime",
						 @"2013-12-20T15:40:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Monday Week 3 */
    
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"23", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-23T08:30:00", @"StartTime",
						 @"2013-12-23T10:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"24", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-23T10:20:00", @"StartTime",
						 @"2013-12-23T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"25", @"ID",
						 @"22218", @"CourseID",
						 @"Strjál stærðfræði I", @"CourseName",
						 @"M110", @"RoomName",
						 @"2013-12-23T13:10:00", @"StartTime",
						 @"2013-12-23T14:45:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Tuesday Week 3 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"26", @"ID",
						 @"22219", @"CourseID",
						 @"Tölvuhögun", @"CourseName",
						 @"M105", @"RoomName",
						 @"2013-12-24T10:20:00", @"StartTime",
						 @"2013-12-24T11:55:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"27", @"ID",
						 @"22220", @"CourseID",
						 @"Verkefnalausnir", @"CourseName",
						 @"M201", @"RoomName",
						 @"2013-12-24T13:10:00", @"StartTime",
						 @"2013-12-24T16:30:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Wednesday Week 3 */
	
	[schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"28", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"V101", @"RoomName",
						 @"2013-12-25T08:30:00", @"StartTime",
						 @"2013-12-25T09:15:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"29", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M106", @"RoomName",
						 @"2013-12-25T09:20:00", @"StartTime",
						 @"2013-12-25T11:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    /* Thursday Week 3 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"30", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M124", @"RoomName",
						 @"2013-12-26T10:20:00", @"StartTime",
						 @"2013-12-26T11:55:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"31", @"ID",
						 @"22218", @"CourseID",
						 @"Strjál stærðfræði I", @"CourseName",
						 @"M110", @"RoomName",
						 @"2013-12-26T14:00:00", @"StartTime",
						 @"2013-12-26T15:40:00", @"EndTime",
						 @"Dæmatími",@"TypeOfClass", nil]];
    
    /* Friday Week 3 */
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"32", @"ID",
						 @"22363", @"CourseID",
						 @"Inngangur að tölvunarfræði", @"CourseName",
						 @"M101", @"RoomName",
						 @"2013-12-27T12:20:00", @"StartTime",
						 @"2013-12-27T13:05:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    [schedule addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
						 @"33", @"ID",
						 @"22212", @"CourseID",
						 @"Forritun", @"CourseName",
						 @"M104", @"RoomName",
						 @"2013-12-27T14:00:00", @"StartTime",
						 @"2013-12-27T15:40:00", @"EndTime",
						 @"Fyrirlestur",@"TypeOfClass", nil]];
    
    success(nil, schedule);
}

+ (void )getAnnouncementWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    success(nil, nil);
}
@end
