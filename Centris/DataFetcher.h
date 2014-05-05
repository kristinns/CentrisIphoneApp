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
#define ASSIGNMENT_COURSE_INSTANCE_ID       @"CourseInstanceID"
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
#define ASSIGNMENT_FILES                    @"Files"
// Assignment File Constants
#define ASSIGNMENT_FILE_NAME                @"Filename"
#define ASSIGNMENT_FILE_DATE_UPDATED        @"LastUpdated"
#define ASSIGNMENT_FILE_TYPE                @"Type"
#define ASSIGNMENT_FILE_URL                 @"URL"
// Assignment File Types
#define ASSIGNMENT_FILE_TYPE_DESCRIPTION    @"DescriptionFile"
#define ASSIGNMENT_FILE_TYPE_STUDENT        @"SolutionFile"
#define ASSIGNMENT_FILE_TYPE_TEACHER        @"TeacherFile"
// Course Key Constants
#define COURSE_ID                           @"CourseID"
#define COURSE_INSTANCE_ID                  @"ID"
#define COURSE_NAME                         @"Name"
#define COURSE_SEMESTER                     @"Semester"
#define COURSE_SYLLABUS                     @"Syllabus"
#define COURSE_TEACHING_METHODS             @"TeachingMethods"
#define COURSE_CONTENT                      @"Content"
#define COURSE_ASSESSMENT_METHODS           @"AssessmentMethods"
#define COURSE_LEARNING_OUTCOME             @"LearningOutcome"
#define COURSE_ECTS                         @"ECTS"
#define COURSE_FINAL_GRADE                  @"FinalGrade"
#define COURSE_STATUS                       @"Status"
// User Key Constants
#define CENTRIS_USER_ID                     @"Person.ID"
#define CENTRIS_USER_MOBILE_PHONE           @"Person.MobilePhone"
#define CENTRIS_USER_FULL_NAME              @"Person.Name"
#define CENTRIS_USER_USERNAME               @"Person.Username"
#define CENTRIS_USER_SSN                    @"Person.SSN"
#define CENTRIS_USER_ADDRESS                @"Person.Address"
#define CENTRIS_USER_POSTAL_CODE            @"Person.Postal"
#define CENTRIS_USER_EMAIL                  @"Person.Email"
#define CENTRIS_USER_ECTS_FINISHED          @"Registration.StudentRegistration.ECTSFinished"
#define CENTRIS_USER_ECTS_ACTIVE            @"Registration.StudentRegistration.ECTSActive"
#define CENTRIS_USER_AVERAGE_GRADE          @"Registration.StudentRegistration.AverageGrade"
#define CENTRIS_USER_DEPARTMENT_NAME        @"Registration.DepartmentName"
#define CENTRIS_USER_MAJOR_IS               @"Registration.Major.Name"
#define CENTRIS_USER_MAJOR_EN               @"Registrationn.Major.NameEnglish"
#define CENTRIS_USER_MAJOR_CREDITS          @"Registration.Major.Credits"
#define CENTRIS_USER_TYPE                   @"Registraton.StudentTypeName"
// Schedule Key Constants
#define EVENT_START_TIME                    @"StartTime"
#define EVENT_END_TIME                      @"EndTime"
#define EVENT_ID                            @"ID"
#define EVENT_ROOM_NAME                     @"RoomName"
#define EVENT_TYPE_OF_CLASS                 @"TypeOfClass"
#define EVENT_COURSE_NAME                   @"CourseName"
#define EVENT_COURSE_INSTANCE_ID            @"CourseID"
// Announcement Key Constants
#define ANNOUNCEMENT_TITLE                  @"Title"
#define ANNOUNCEMENT_ID                     @"ID"
#define ANNOUNCEMENT_CONTENT                @"Content"
#define ANNOUNCEMENT_DATE_INSERTED          @"DateInserted"
#define ANNOUNCEMENT_COURSE_ID              @"CourseID"

@protocol DataFetcher <NSObject>
// Get
+ (void)getAssignmentsInSemester:(NSString *)semester
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getAssignmentById:(NSInteger)assignmentId
                 courseId:(NSInteger)courseId
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getCoursesInSemester:(NSString *)semester
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)getCourseMaterialsForCourseID:(NSInteger)courseInstanceID
                   success:(void (^)(AFHTTPRequestOperation *, id))success
                   failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
+ (void)getScheduleInSemester:(NSString *)semester
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getMenuWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getAnnouncementWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Post
+ (void)loginUserWithUsername:(NSString *)email andPassword:(NSString *)password
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
