#import <Foundation/Foundation.h>

@interface Benchmark : NSObject

@property (strong, nonatomic, readonly) NSArray *rawResults;
@property (assign, nonatomic) NSUInteger flushSetSize;

- (void)runWithChannelsCount:(NSUInteger)channelsCount programsCount:(NSUInteger)programsCount;
- (NSTimeInterval)runTime;
- (NSString *)name;

@end
