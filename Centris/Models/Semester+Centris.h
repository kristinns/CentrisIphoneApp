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
- (float)averageGrade;
- (float)progressForDate:(NSDate *)date;
- (NSInteger)weeksLeft:(NSDate *)date;
- (NSInteger)totalEcts;
//- (NSInteger)finishedEcts;
//- (NSArray *)bookList;
@end
