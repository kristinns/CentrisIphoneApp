//
//  Semester+Centris.h
//  Centris
//
//  Created by Bjarki Sörens on 12/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Semester.h"

@interface Semester (Centris)
+ (NSArray *)semestersInManagedObjectContext:(NSManagedObjectContext *)context; // tested
- (float)weightedAverageGrade;                                                   // tested
- (float)progressForDate:(NSDate *)date;
//- (NSInteger)totalEcts;
//- (NSInteger)finishedEcts;
//- (NSInteger)weeksLeft;
//- (NSArray *)bookList;
@end
