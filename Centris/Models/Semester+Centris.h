//
//  Semester+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 12/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Semester.h"

@interface Semester (Centris)
+ (Semester *)semesterWithID:(NSString *)semesterID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)semestersInManagedObjectContext:(NSManagedObjectContext *)context; // tested
- (float)averageGrade;                                                          // tested
- (float)progressForDate:(NSDate *)date;                                        // tested
- (NSInteger)weeksLeft:(NSDate *)date;                                          // tested
- (NSInteger)totalEcts;                                                         // tested
//- (NSInteger)finishedEcts;
//- (NSArray *)bookList;
@end
