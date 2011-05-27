#import "Location.h"

@implementation Location

- (NSString*)description {
	return [NSString stringWithFormat:@"Location (map:'%@';name:'%@';area:'%@';type:'%@';lat:%@;lon:%@;", self.map, self.name, self.area, self.type, self.lat, self.lon];
}

@end
