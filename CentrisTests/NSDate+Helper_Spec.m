//
//  NSDate+Helper_Spec.m
//  Centris
//
//  Created by Bjarki Sörens on 25/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "Kiwi.h"
#import "NSDate+Helper.h"

SPEC_BEGIN(MathSpec)

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
        NSDateComponents *comps = [NSDate dateComponentForDate:customDate withCalendar:gregorian];
        [[theValue([comps minute]) should] equal:theValue(5)];
    });
    
});

SPEC_END
