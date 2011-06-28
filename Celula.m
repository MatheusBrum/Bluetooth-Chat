//
//  Celula.m
//  BluetoothChat
//
//  Created by Matheus Brum on 28/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Celula.h"

@implementation Celula
@synthesize label,balao;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
