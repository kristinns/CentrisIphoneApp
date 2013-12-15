//
//  CourseInstance+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 9/23/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CourseInstance+Centris.h"
#import "Semester+Centris.h"
#import "Assignment+Centris.h"
#import "CDDataFetcher.h"
#import "DataFetcher.h"

@implementation CourseInstance (Centris)

+(CourseInstance *)courseInstanceWithID:(NSInteger)courseID inManagedObjectContext:(NSManagedObjectContext *)context
{
	CourseInstance *instance = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %d", courseID];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];

//    NSString *assertFailMessage = [NSString stringWithFormat:@"there should only be one courseinstance with cousreid: %d", courseID];
//    NSAssert([matches count ] == 1, assertFailMessage);
    instance = [matches lastObject];
	
	return instance;
}

+ (CourseInstance *)addCourseInstanceWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context;
{
    CourseInstance *courseInstance = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", centrisInfo[@"ID"]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];
    
    if (![matches count]) { // no result, proceed with storing
        courseInstance = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance" inManagedObjectContext:context];
        courseInstance.id = centrisInfo[COURSE_INSTANCE_ID];
        courseInstance.courseID = centrisInfo[COURSE_ID];
        courseInstance.name = centrisInfo[COURSE_NAME];
        courseInstance.semester = centrisInfo[COURSE_SEMESTER];
        courseInstance.syllabus = centrisInfo[COURSE_SYLLABUS];
        courseInstance.teachingMethods = centrisInfo[COURSE_TEACHING_METHODS];
        courseInstance.content = centrisInfo[COURSE_CONTENT];
        courseInstance.assessmentMethods = centrisInfo[COURSE_ASSESSMENT_METHODS];
        courseInstance.learningOutcome = centrisInfo[COURSE_LEARNING_OUTCOME];
        courseInstance.ects = [NSNumber numberWithInt:[centrisInfo[COURSE_ECTS] integerValue]];
        courseInstance.finalGrade = centrisInfo[COURSE_FINAL_GRADE] != (id)[NSNull null] ? [NSNumber numberWithFloat:[centrisInfo[COURSE_FINAL_GRADE] floatValue]]: nil;
        courseInstance.status = centrisInfo[COURSE_STATUS];
        Semester *semester = [Semester semesterWithID:centrisInfo[COURSE_SEMESTER] inManagedObjectContext:context];
        if (semester == nil) {
            semester = [NSEntityDescription insertNewObjectForEntityForName:@"Semester" inManagedObjectContext:context];
            semester.id_semester = centrisInfo[COURSE_SEMESTER];
        }
        courseInstance.isInSemester = semester;
    } else {
        courseInstance = [matches lastObject];
        courseInstance.courseID = centrisInfo[COURSE_ID];
        courseInstance.name = centrisInfo[COURSE_NAME];
        courseInstance.semester = [centrisInfo[COURSE_SEMESTER] stringValue];
        courseInstance.syllabus = centrisInfo[COURSE_SYLLABUS];
        courseInstance.teachingMethods = centrisInfo[COURSE_TEACHING_METHODS];
        courseInstance.content = centrisInfo[COURSE_CONTENT];
        courseInstance.assessmentMethods = centrisInfo[COURSE_ASSESSMENT_METHODS];
        courseInstance.learningOutcome = centrisInfo[COURSE_LEARNING_OUTCOME];
        courseInstance.ects = [NSNumber numberWithInt:[centrisInfo[COURSE_ECTS] integerValue]];
        courseInstance.finalGrade = centrisInfo[COURSE_FINAL_GRADE] != (id)[NSNull null] ? [NSNumber numberWithFloat:[centrisInfo[COURSE_FINAL_GRADE] floatValue]]: nil;
        courseInstance.status = centrisInfo[COURSE_STATUS];
    }
    return courseInstance;
}

+ (NSArray *)courseInstancesInManagedObjectContext:(NSManagedObjectContext *)context;
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"CourseInstance"
                                                forKey:@"name"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

- (NSArray *)gradedAssignments
{
    NSMutableArray *gradedAssignments = [[NSMutableArray alloc] init];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateClosed" ascending:YES];
    for (Assignment *assignment in self.hasAssignments) {
        if (assignment.grade != nil) {
            [gradedAssignments addObject:assignment];
        }
    }
    return [gradedAssignments sortedArrayUsingDescriptors:@[descriptor]];
}

- (float)averageGrade
{
    float average = 0.0;
    // get instance
    NSSet *assignments = self.hasAssignments;
    
    // prevent zero devision
    if (![assignments count])
        return 0.0;
    
    for (Assignment *assignment in assignments) {
        if (assignment.grade != nil) {
            average = average + [assignment.grade floatValue];
        }
    }
    return average / ([assignments count]);
}

- (float)totalPercentagesFromAssignments
{
    float percentages = 0.0;
    NSSet *assignments = self.hasAssignments;
    for (Assignment *assignment in assignments) {
        if (assignment.grade != nil) {
            percentages = percentages + [assignment.weight floatValue];
        }
    }
    return percentages;
}

- (float)aquiredGrade
{
    float weightedAverage = 0.0;
    for (Assignment *assignment  in self.hasAssignments) {
        if (assignment.grade != nil) {
            weightedAverage = weightedAverage + (([assignment.weight floatValue] / 100.0) * [assignment.grade floatValue]);
        }
    }
    return weightedAverage;
}

- (float)weightedAverageGrade
{
    return [self totalPercentagesFromAssignments] == 0 ? 0.0 : [self aquiredGrade] / ([self totalPercentagesFromAssignments] / 100.0f);
}

- (BOOL)isPassed
{
    if ([self.status isEqualToString:@"Lokið"] || [self.status isEqualToString:@"Staðið"] ||  [self.status isEqualToString:@"Metið"])
        return YES;
    else
        return NO;
}

- (BOOL)isFailed
{
    if ([self.status isEqualToString:@"Fallin(n)"] || [self.status isEqualToString:@"Fallinn, mætti ekki"] ||  [self.status isEqualToString:@"Ólokið"])
        return YES;
    else
        return NO;
}

- (BOOL)hasResults
{
    if ([self.status isEqualToString:@"Skráð(ur)"])
        return NO;
    else
        return YES;
}

@end























