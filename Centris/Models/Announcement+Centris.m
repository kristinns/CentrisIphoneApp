//
//  Announcement+Centris.m
//  Centris
//
//  Created by Kristinn Svansson on 14/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Announcement+Centris.h"
#import "CourseInstance+Centris.h"
#import "CDDataFetcher.h"
#import "DataFetcher.h"
#import "NSDate+Helper.h"

@implementation Announcement (Centris)

+ (Announcement *)announcementWithID:(NSInteger)announcementID inManagedObjectContext:(NSManagedObjectContext *)context
{
	Announcement *announcement = nil;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %d", announcementID];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"Announcement"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];
    
    announcement = [matches lastObject];
	
	return announcement;
}

+ (Announcement *)addAnnouncementWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Announcement *announcement = nil;
    
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [NSNumber numberWithInteger:[centrisInfo[@"ID"] integerValue]]];
    NSArray *matches = [CDDataFetcher fetchObjectsFromDBWithEntity:@"Announcement"
                                                            forKey:@"id"
                                                     sortAscending:NO
                                                     withPredicate:pred
                                            inManagedObjectContext:context];
    
    if (![matches count]) { // no result, proceed with storing
        announcement = [NSEntityDescription insertNewObjectForEntityForName:@"Announcement" inManagedObjectContext:context];
        announcement.id = centrisInfo[ANNOUNCEMENT_ID];
        announcement.title = centrisInfo[ANNOUNCEMENT_TITLE];
        announcement.content = centrisInfo[ANNOUNCEMENT_CONTENT];
        announcement.read = NO;
        announcement.dateInserted = [NSDate convertToDate:centrisInfo[ANNOUNCEMENT_DATE_INSERTED] withFormat:nil];
        announcement.isInCourseInstance = [CourseInstance courseInstanceWithID:[centrisInfo[ANNOUNCEMENT_COURSE_ID] integerValue] inManagedObjectContext:context];
    } else {
        return [matches lastObject];
    }
    return announcement;
}

+ (NSArray *)announcementsInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [CDDataFetcher fetchObjectsFromDBWithEntity:@"Announcement"
                                                forKey:@"dateInserted"
                                         sortAscending:NO
                                         withPredicate:nil
                                inManagedObjectContext:context];
}

@end
