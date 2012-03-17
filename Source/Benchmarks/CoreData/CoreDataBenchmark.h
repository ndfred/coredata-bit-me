#import "Benchmark.h"

@interface CoreDataBenchmark : Benchmark

@property (assign, nonatomic) BOOL resetCacheOnFlush;

- (id)initWithRelationShipsEnabled:(BOOL)relationshipsEnabled;

@end
