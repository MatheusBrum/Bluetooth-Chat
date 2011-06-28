//
//  Celula.h
//  BluetoothChat
//
//  Created by Matheus Brum on 28/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Celula : UITableViewCell{
  IBOutlet  UIImageView *balao;
   IBOutlet UILabel *label;
    
}
@property (nonatomic,retain)  IBOutlet UIImageView *balao;
@property (nonatomic,retain) IBOutlet UILabel *label;

@end
