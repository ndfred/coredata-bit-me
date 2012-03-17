#import "CoreDataBenchmark.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        CoreDataBenchmark *benchmark = [[CoreDataBenchmark alloc] init];
        CoreDataBenchmark *benchmark2 = [[CoreDataBenchmark alloc] initWithRelationShipsEnabled:NO];

        benchmark.resetCacheOnFlush = YES;
        [benchmark runWithChannelsCount:1 programsCount:1];
        benchmark2.resetCacheOnFlush = YES;
        [benchmark2 runWithChannelsCount:1 programsCount:1];

        return 0;
    }
}
