#import "CoreDataBenchmark.h"
#import "Benchmark+Private.h"
#import <CoreData/CoreData.h>
#import "Log.h"

@interface CoreDataBenchmark ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableDictionary *channelObjectIdentifiers;
@property (strong, nonatomic) NSMutableDictionary *programObjectIdentifiers;

@end

@implementation CoreDataBenchmark

@synthesize context = _context;
@synthesize channelObjectIdentifiers = _channelObjectIdentifiers;
@synthesize programObjectIdentifiers = _programObjectIdentifiers;

- (void)runWithChannelsCount:(NSUInteger)channelsCount programsCount:(NSUInteger)programsCount {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TVGuide" withExtension:@"momd"];
    NSURL *storeURL = [[self class] cleanDatabaseURL];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    NSError *error = nil;
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];

    if (error != nil) {
        Log(@"Could not open the Core Data database: %@ (%@)", error, error.userInfo);
        abort();
    }

    context.persistentStoreCoordinator = coordinator;
    context.undoManager = nil;

    self.context = context;
    self.channelObjectIdentifiers = [NSMutableDictionary dictionaryWithCapacity:channelsCount];
    self.programObjectIdentifiers = [NSMutableDictionary dictionaryWithCapacity:programsCount];

    [super runWithChannelsCount:channelsCount programsCount:programsCount];

    [coordinator removePersistentStore:store error:&error];

    if (error != nil) {
        Log(@"Could not close the Core Data database: %@  (%@)", error, error.userInfo);
        abort();
    }

    self.context = nil;
}

- (void)flush {
    NSError *error = nil;
    NSManagedObjectContext *context = self.context;
    NSMutableDictionary *channelObjectIdentifiers = self.channelObjectIdentifiers;
    NSMutableDictionary *programObjectIdentifiers = self.programObjectIdentifiers;
    NSSet *insertedObjects = context.insertedObjects;

//    Log(@"Flushing %d objects", insertedObjects.count);
    [self.context save:&error];

    if (error != nil) {
        Log(@"Could not save the Core Data changes: %@  (%@)", error, error.userInfo);
        abort();
    }

    [insertedObjects enumerateObjectsUsingBlock:^(NSManagedObject *object, BOOL *stop) {
        NSString *entityName = object.entity.name;

        if ([entityName isEqualToString:@"Channel"]) {
            NSString *channelIdentifier = [NSString stringWithFormat:@"%@", [object valueForKey:@"identifier"]];

            [channelObjectIdentifiers setObject:object.objectID forKey:channelIdentifier];
        } else if ([entityName isEqualToString:@"Program"]) {
            NSString *programIdentifier = [NSString stringWithFormat:@"%@", [object valueForKey:@"identifier"]];

            [programObjectIdentifiers setObject:object.objectID forKey:programIdentifier];
        }
    }];
}

- (void)createChannelWithIdentifier:(NSUInteger)identifier name:(NSString *)name {
    NSManagedObject *channel = [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:self.context];

    [channel setValue:[NSNumber numberWithUnsignedInteger:identifier] forKey:@"identifier"];
    [channel setValue:name forKey:@"name"];
}

- (void)createProgramWithIdentifier:(NSUInteger)identifier name:(NSString *)name {
    NSManagedObject *program = [NSEntityDescription insertNewObjectForEntityForName:@"Program" inManagedObjectContext:self.context];

    [program setValue:[NSNumber numberWithUnsignedInteger:identifier] forKey:@"identifier"];
    [program setValue:name forKey:@"name"];
}

- (void)createBroadcastWithChannelIdentifier:(NSUInteger)channelIdentifier programIdentifier:(NSUInteger)programIdentifier {
    NSManagedObject *broadcast = [NSEntityDescription insertNewObjectForEntityForName:@"Broadcast" inManagedObjectContext:self.context];
    NSManagedObject *channel = [self.context objectWithID:[self.channelObjectIdentifiers objectForKey:[NSString stringWithFormat:@"%d", channelIdentifier]]];
    NSManagedObject *program = [self.context objectWithID:[self.programObjectIdentifiers objectForKey:[NSString stringWithFormat:@"%d", programIdentifier]]];

    [broadcast setValue:channel forKey:@"channel"];
    [broadcast setValue:program forKey:@"program"];
}

@end
