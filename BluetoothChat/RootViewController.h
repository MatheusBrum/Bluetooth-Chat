//
//  RootViewController.h
//  BluetoothChat
//
//  Created by Matheus Brum on 28/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface RootViewController : UITableViewController<GKSessionDelegate,GKPeerPickerControllerDelegate,UITextFieldDelegate>{
    GKSession *currentSession;
	GKPeerPickerController *BTpicker;
	bool conectado;
    CGFloat animatedDistance;	
    NSMutableArray *superArray;
    
    UITextField *campoTexto;
}
-(void)conectar;
-(void)enviar;
-(void)adicionarTexto:(NSString *)texto fuiEu:(BOOL)f;
-(void)atualizarBarra;
@end
