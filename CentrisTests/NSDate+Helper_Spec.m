//
//  NSDate+Helper_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 25/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "NSDate+Helper.h"

SPEC_BEGIN(NSDateHelperSpec)

describe(@"NSDate Helper", ^{
    __block NSDate *customDate = nil;
    __block NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    beforeEach(^{
        // Create some date
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:2013];
        [comps setMonth:1];
        [comps setDay:1];
        [comps setHour:12];
        [comps setMinute:00];
        [comps setSecond:00];
        customDate = [gregorian dateFromComponents:comps];
    });
    
    it(@"should add minutes correctly", ^{
        customDate = [customDate dateByAddingMintues:5];
        NSDateComponents *comps = [customDate dateComponentForDateWithCalendar:gregorian];
        [[theValue([comps minute]) should] equal:theValue(5)];
    });
    
    it(@"should add hours correctly", ^{
        customDate = [customDate dateByAddingHours:1];
        NSDateComponents *comps = [customDate dateComponentForDateWithCalendar:gregorian];
        [[theValue([comps hour]) should] equal:theValue(13)];
    });
    
    it(@"should add days correctly", ^{
        customDate = [customDate dateByAddingDays:1];
        NSDateComponents *comps = [customDate dateComponentForDateWithCalendar:gregorian];
        [[theValue([comps day]) should] equal:theValue(2)];
    });
    
    it(@"should add weeks correctly", ^{
        customDate = [customDate dateByAddingWeeks:1];
        NSDateComponents *comps = [customDate dateComponentForDateWithCalendar:gregorian];
        [[theValue([comps week]) should] equal:theValue(2)];
    });
    
    it(@"should convert string to date correctly without a given format", ^{
        NSString *dateString = @"2013-1-1T12:00:00";
        NSDate *checkDate = [NSDate dateFromString:dateString withFormat:nil];
        NSDateComponents *comps = [checkDate dateComponentForDateWithCalendar:gregorian];
        [[theValue([comps year]) should] equal:theValue(2013)];
        [[theValue([comps month]) should] equal:theValue(1)];
        [[theValue([comps day]) should] equal:theValue(1)];
        [[theValue([comps hour]) should] equal:theValue(12)];
        [[theValue([comps minute]) should] equal:theValue(00)];
        [[theValue([comps second]) should] equal:theValue(00)];
    });
    
    it(@"should convert date to string correctly without a given format", ^{
        NSString *suspectedDateString = @"2013-01-01T12:00:00";
        NSString *actualDateString = [customDate stringFromDateWithFormat:nil];
        [[theValue([actualDateString isEqualToString:suspectedDateString]) should] beTrue];
    });
    
    it(@"should convert date to string correctly with a given format", ^{
        NSString *suspectedDateString = @"12:00";
        NSString *actualDateString = [customDate stringFromDateWithFormat:@"HH:mm"];
        [[theValue([actualDateString isEqualToString:suspectedDateString]) should] beTrue];
    });
    
    it(@"should give a date range for the whole day", ^{
        NSDictionary *checkDic = [customDate dateRangeForTheWholeDay];
        NSString *dateFromString = [checkDic[@"from"] stringFromDateWithFormat:nil];
        NSString *dateToString = [checkDic[@"to"] stringFromDateWithFormat:nil];
        [[theValue([dateFromString isEqualToString:@"2013-01-01T00:00:00"]) should] beTrue];
        [[theValue([dateToString isEqualToString:@"2013-01-01T23:59:59"]) should] beTrue];
    });
    
    it(@"should give a date range from a given time in the day to the midnight", ^{
        NSDictionary *checkDic = [customDate dateRangeToMidnightFromDate];
        NSString *dateFromString = [checkDic[@"from"] stringFromDateWithFormat:nil];
        NSString *dateToString = [checkDic[@"to"] stringFromDateWithFormat:nil];
        [[theValue([dateFromString isEqualToString:@"2013-01-01T12:00:00"]) should] beTrue];
        [[theValue([dateToString isEqualToString:@"2013-01-01T23:59:59"]) should] beTrue];
    });
    
    it(@"should give a date range from a given time in the day to the next morning", ^{
        NSDictionary *checkDic = [customDate dateRangeToNextMorning];
        NSString *dateFromString = [checkDic[@"from"] stringFromDateWithFormat:nil];
        NSString *dateToString = [checkDic[@"to"] stringFromDateWithFormat:nil];
        [[theValue([dateFromString isEqualToString:@"2013-01-01T12:00:00"]) should] beTrue];
        [[theValue([dateToString isEqualToString:@"2013-01-02T10:05:00"]) should] beTrue];
    });
});

SPEC_END










