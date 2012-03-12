#import "Benchmark.h"
#import "Benchmark+Private.h"
#import "Log.h"

@interface Benchmark ()

@property (strong, nonatomic, readwrite) NSArray *rawResults;

@end

@implementation Benchmark

@synthesize rawResults = _rawResults;
@synthesize flushSetSize = _flushSetSize;

+ (NSURL *)cleanDatabaseURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *databaseURL = [documentsURL URLByAppendingPathComponent:@"TVGuide.db"];

    [fileManager removeItemAtURL:databaseURL error:nil];

    return databaseURL;
}

- (id)init {
    self = [super init];

    if (self != nil) {
        self.flushSetSize = 100;
    }

    return self;
}

- (void)runWithChannelsCount:(NSUInteger)channelsCount programsCount:(NSUInteger)programsCount {
    NSMutableArray *results = [NSMutableArray array];
    NSDate *currentDate = nil;
    NSUInteger flushSetSize = self.flushSetSize;

    Log(@"Running benchmark %@", self);

    Log(@"Creating %d channels", channelsCount);
    currentDate = [NSDate date];
    for (NSUInteger channelIndex = 0; channelIndex < channelsCount; channelIndex++) {
//        Log(@"Creating channel %d", channelIndex);
        [self createChannelWithIdentifier:channelIndex
                                     name:[NSString stringWithFormat:@"Channel %d", channelIndex]];

        if (channelIndex % flushSetSize == flushSetSize - 1) {
            [self flush];
        }
    }
    [self flush];
    [results addObject:[NSNumber numberWithDouble:- [currentDate timeIntervalSinceNow]]];

    Log(@"Creating %d programs", programsCount);
    currentDate = [NSDate date];
    for (NSUInteger programIndex = 0; programIndex < programsCount; programIndex++) {
//        Log(@"Creating program %d", programIndex);
        [self createProgramWithIdentifier:programIndex
                                     name:[NSString stringWithFormat:@"Program %d", programIndex]];

        if (programIndex % flushSetSize == flushSetSize - 1) {
            [self flush];
        }
    }
    [self flush];
    [results addObject:[NSNumber numberWithDouble:- [currentDate timeIntervalSinceNow]]];

    Log(@"Creating %d broadcasts", programsCount);
    currentDate = [NSDate date];
    for (NSUInteger programIndex = 0; programIndex < programsCount; programIndex++) {
//        Log(@"Creating broadcast with channel %d and program %d", programIndex % channelsCount, programIndex);
        [self createBroadcastWithChannelIdentifier:programIndex % channelsCount programIdentifier:programIndex];

        if (programIndex % flushSetSize == flushSetSize - 1) {
            [self flush];
        }
    }
    [self flush];
    [results addObject:[NSNumber numberWithDouble:- [currentDate timeIntervalSinceNow]]];

    self.rawResults = [NSArray arrayWithArray:results];

    Log(@"Ran benchmark %@ in %lf seconds (%@)", self, self.runTime, results);
}

- (NSTimeInterval)runTime {
    __block NSTimeInterval runTime = 0.0;

    [self.rawResults enumerateObjectsUsingBlock:^(NSNumber *stepRunTime, NSUInteger idx, BOOL *stop) {
        runTime += stepRunTime.doubleValue;
    }];

    return runTime;
}

- (void)flush {
    // Should be implemented in subclasses
    [self doesNotRecognizeSelector:_cmd];
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
