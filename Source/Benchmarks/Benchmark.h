#import <Foundation/Foundation.h>

@interface Benchmark : NSObject

@property (strong, nonatomic, readonly) NSArray *rawResults;

- (void)runWithChannelsCount:(NSUInteger)channelsCount programsCount:(NSUInteger)programsCount;
- (NSTimeInterval)runTime;

@end
