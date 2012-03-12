#import "Benchmark.h"

@interface Benchmark (Private)

@property (strong, nonatomic, readwrite) NSArray *rawResults;

+ (NSURL *)cleanDatabaseURL;

- (void)flush;
- (void)createChannelWithIdentifier:(NSUInteger)identifier name:(NSString *)name;
- (void)createProgramWithIdentifier:(NSUInteger)identifier name:(NSString *)name;
- (void)createBroadcastWithChannelIdentifier:(NSUInteger)channelIdentifier programIdentifier:(NSUInteger)programIdentifier;

@end
