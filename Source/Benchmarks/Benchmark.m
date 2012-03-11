#import "Benchmark.h"
#import "Benchmark+Private.h"

@implementation Benchmark

@synthesize rawResults = _rawResults;

- (void)runWithChannelsCount:(NSUInteger)channelsCount programsCount:(NSUInteger)programsCount {
    NSMutableArray *results = [NSMutableArray array];
    NSDate *currentDate = nil;

    // Create the channels
    currentDate = [NSDate date];
    for (NSUInteger channelIndex = 0; channelIndex < channelsCount; channelIndex++) {
        [self createChannelWithIdentifier:channelIndex
                                     name:[NSString stringWithFormat:@"Channel %d", channelIndex]];
    }
    [results addObject:[NSNumber numberWithDouble:[currentDate timeIntervalSinceNow]]];

    // Create the programs
    currentDate = [NSDate date];
    for (NSUInteger programIndex = 0; programIndex < programsCount; programIndex++) {
        [self createProgramWithIdentifier:programIndex
                                     name:[NSString stringWithFormat:@"Program %d", programIndex]];
    }
    [results addObject:[NSNumber numberWithDouble:[currentDate timeIntervalSinceNow]]];

    // Create the broadcasts
    currentDate = [NSDate date];
    for (NSUInteger programIndex = 0; programIndex < programsCount; programIndex++) {
        [self createBroadcastWithChannelIdentifier:programIndex programIdentifier:programIndex % channelsCount];
    }
    [results addObject:[NSNumber numberWithDouble:[currentDate timeIntervalSinceNow]]];

    self.rawResults = [NSArray arrayWithArray:results];
}

- (NSTimeInterval)runTime {
    __block NSTimeInterval runTime = 0.0;

    [self.rawResults enumerateObjectsUsingBlock:^(NSNumber *stepRunTime, NSUInteger idx, BOOL *stop) {
        runTime += stepRunTime.doubleValue;
    }];

    return runTime;
}

- (void)createChannelWithIdentifier:(NSUInteger)identifier name:(NSString *)name {
    // Should be implemented in subclasses
    [self doesNotRecognizeSelector:_cmd];
}

- (void)createProgramWithIdentifier:(NSUInteger)identifier name:(NSString *)name {
    // Should be implemented in subclasses
    [self doesNotRecognizeSelector:_cmd];
}

- (void)createBroadcastWithChannelIdentifier:(NSUInteger)channelIdentifier programIdentifier:(NSUInteger)programIdentifier {
    // Should be implemented in subclasses
    [self doesNotRecognizeSelector:_cmd];
}

@end
