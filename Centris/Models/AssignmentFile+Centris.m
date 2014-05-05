//
//  AssignmentFile+Centris.m
//  Centris
//
//  Created by Bjarki Sörens on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentFile+Centris.h"
#import "Assignment.h"
#import "CDDataFetcher.h"
#import "DataFetcher.h"
#import "NSDate+Helper.h"

@implementation AssignmentFile (Centris)

+ (void)addAssignmentFilesForAssignment:(Assignment *)assignment withAssignmentFiles:(NSArray *)assignmentsFileInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    // erase all files that exist before (for update purposes)
    [self removeAssignmentFilesForAssignment:assignment inManagedObjectContext:context];
    for (NSDictionary *fileInfo in assignmentsFileInfo) {
        AssignmentFile *file = [NSEntityDescription insertNewObjectForEntityForName:@"AssignmentFile" inManagedObjectContext:context];
        file.fileName = fileInfo[ASSIGNMENT_FILE_NAME];
        file.type = fileInfo[ASSIGNMENT_FILE_TYPE];
        file.url = fileInfo[ASSIGNMENT_FILE_URL];
        file.lastUpdate = [NSDate dateFromString:fileInfo[ASSIGNMENT_FILE_DATE_UPDATED] withFormat:nil];
        file.isInAssignment = assignment;
    }
}

+ (void)removeAssignmentFilesForAssignment:(Assignment *)assignment inManagedObjectContext:(NSManagedObjectContext *)context
{
    if ([assignment.hasFiles count]) {
        for (AssignmentFile *file in assignment.hasFiles) {
            [context deleteObject:file];
        }
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", error);
        }
    }
}

@end
