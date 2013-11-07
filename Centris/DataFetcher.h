//
//  DataFetcher.h
//  Centris
//
//  Created by Bjarki Sörens on 10/2/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

// Assignment Key Constants
#define ASSIGNMENT_ID                       @"ID"
#define ASSIGNMENT_TITLE                    @"Title"
#define ASSIGNMENT_DESCRIPTION              @"Description"
#define ASSIGNMENT_ALLOWED_FILE_EXTENSIONS  @"AllowedFileExtensions"
#define ASSIGNMENT_WEIGHT                   @"Weight"
#define ASSIGNMENT_MAX_STUDENTS_IN_GROUP    @"MaxStudentsInGroup"
#define ASSIGNMENT_DATE_PUBLISHED           @"DatePublished"
#define ASSIGNMENT_DATE_CLOSED              @"DateClosed"
#define ASSIGNMENT_GROUP_ID                 @"GroupID"
#define ASSIGNMENT_GRADE                    @"Grade"
#define ASSIGNMENT_STUDENT_MEMO             @"StudentMemo"
#define ASSIGNMENT_TEACHER_MEMO             @"TeacherMemo"
#define ASSIGNMENT_HANDIN_DATE              @"Closes"
// Course Key Constants
#define COURSE_ID                           @"CourseID"
#define COURSE_INSTANCE_ID                  @"ID"
#define COURSE_NAME                         @"Name"
#define COURSE_SEMESTER                     @"Semester"
// User Key Constants
#define USER_FULL_NAME                      @"Person.Name"
#define USER_SSN                            @"Person.SSN"
#define USER_ADDRESS                        @"Person.Address"
#define USER_EMAIL                          @"Person.Email"
#define USER_ECTS_FINISHED                  @"Registration.StudentRegistration.ECTSFinished"
#define USER_ECTS_ACTIVE                    @"Registration.StudentRegistration.ECTSActive"
#define USER_AVERAGE_GRADE                  @"Registration.StudentRegistration.AverageGrade"
#define USER_DEPARTMENT_NAME                @"Registration.DepartmentName"
#define USER_MAJOR_IS                       @"Registration.Major.Name"
#define USER_MAJOR_EN                       @"Registrationn.Major.NameEnglish"
#define USER_MAJOR_CREDITS                  @"Registration.Major.Credits"
#define USER_TYPE                           @"Registraton.StudentTypeName"
// Schedule Key Constants
#define EVENT_START_TIME                    @"StartTime"
#define EVENT_END_TIME                      @"EndTime"
#define EVENT_ID                            @"ID"
#define EVENT_ROOM_NAME                     @"RoomName"
#define EVENT_TYPE_OF_CLASS                 @"TypeOfClass"
#define EVENT_COURSE_NAME                   @"CourseName"
#define EVENT_COURSE_INSTANCE_ID            @"CourseID"


@protocol DataFetcher <NSObject>
// Get
+ (void)getAssignmentsInSemester:(NSString *)semester
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getCoursesInSemester:(NSString *)semester
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getScheduleInSemester:(NSString *)semester
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
// Post
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
