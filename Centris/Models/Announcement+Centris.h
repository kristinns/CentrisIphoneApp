//
//  Announcement+Centris.h
//  Centris
//
//  Created by Kristinn Svansson on 14/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Announcement.h"

@interface Announcement (Centris)
+ (Announcement *)announcementWithID:(NSInteger)announcementID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Announcement *)addAnnouncementWithCentrisInfo:(NSDictionary *)centrisInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)announcementsInManagedObjectContext:(NSManagedObjectContext *)context;
@end
