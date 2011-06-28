//
//  RootViewController.m
//  BluetoothChat
//
//  Created by Matheus Brum on 28/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define kBallonViewTexto 1
#define kContentTexto 2
#define kMessageTexto 3

#import "RootViewController.h"
#import "Celula.h"

@implementation RootViewController


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(void)conectar{
    if (conectado==NO) {
		BTpicker = [[GKPeerPickerController alloc] init];
		BTpicker.delegate = self;
		BTpicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
		[BTpicker show];  
	}else {
		[currentSession disconnectFromAllPeers];
	}
}
-(void)enviar{
    if (conectado) {
		if ([campoTexto.text length] != 0) {
			NSMutableData *message = [[NSMutableData alloc] init];
			NSKeyedArchiver *archiver =[[NSKeyedArchiver alloc] initForWritingWithMutableData:message];
			[archiver encodeObject:[NSString stringWithString:campoTexto.text] forKey:@"Texto"];
			[archiver finishEncoding];
			[currentSession sendDataToAllPeers: message withDataMode:GKSendDataReliable error:NULL];
		
			[self adicionarTexto:campoTexto.text fuiEu:YES];
			campoTexto.text=@"";
		}
	}
}
-(void)adicionarTexto:(NSString *)texto fuiEu:(BOOL)f{
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:
                            texto,@"Texto",
                            [NSNumber numberWithBool:f],@"FuiEu", nil];
	NSArray *insertIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0],nil];	
    [self.tableView beginUpdates];
    [superArray addObject:dict];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
	if ([self.tableView numberOfRowsInSection:0]>0) {
		NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([superArray count] - 1) inSection:0];
		[self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}
-(void)atualizarBarra{
    if (conectado==NO) {
        UIBarButtonItem *spaco=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *conect=[[UIBarButtonItem alloc]initWithTitle:@"Conectar" style:UIBarButtonItemStyleDone target:self action:@selector(conectar)];
        self.toolbarItems=[NSArray arrayWithObjects:spaco,conect,spaco, nil];

    }else{
      //  UIBarButtonItem *send=[[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(enviar)];
        if (!campoTexto) {
            campoTexto=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 295, 35)];
            campoTexto.borderStyle = UITextBorderStyleRoundedRect;
            campoTexto.textColor = [UIColor blackColor];
            campoTexto.delegate=self;
            campoTexto.font = [UIFont systemFontOfSize:20.0];
            campoTexto.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
            campoTexto.keyboardType = UIKeyboardTypeAlphabet;
            campoTexto.keyboardAppearance = UIKeyboardAppearanceDefault;
            campoTexto.returnKeyType = UIReturnKeySend;
            campoTexto.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        UIBarButtonItem *campoT=[[UIBarButtonItem alloc]initWithCustomView:campoTexto];
        self.toolbarItems=[NSArray arrayWithObjects:campoT, nil];

    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO animated:NO];
    self.tableView.allowsSelection=NO;
    superArray=[[NSMutableArray alloc]init];
    self.tableView.backgroundColor=[UIColor colorWithRed:0.827 green:0.855 blue:0.918 alpha:1.000];
    [self atualizarBarra];
    self.title=@"AppleManiacos";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - UITextField 
-(void)textFieldDidBeginEditing:(UITextField *)textField{
	static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
    static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
    static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
    static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0){
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }else{
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.navigationController.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.navigationController.view setFrame:viewFrame];
    [UIView commitAnimations];    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    CGRect viewFrame = self.navigationController.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.navigationController.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self enviar];
    return YES;
}
#pragma mark - Tableview 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [superArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    Celula *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.balao.tag=kBallonViewTexto;
    cell.label.tag=kContentTexto;
    cell.label.backgroundColor=[UIColor clearColor];
    cell.label.numberOfLines=0;
    cell.label.lineBreakMode=UILineBreakModeWordWrap;
    cell.label.font=[UIFont systemFontOfSize:16.0f];
    UIView *mensagem=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    mensagem.tag=kMessageTexto;
    [mensagem addSubview:cell.balao];
    [mensagem addSubview:cell.label];
    mensagem.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:mensagem];
    
    NSString *texto = [[superArray objectAtIndex:indexPath.row]objectForKey:@"Texto"];
    CGSize tamanho=[texto sizeWithFont:[UIFont systemFontOfSize:16.0f]constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
    UIImage *imagemBalao;
    if ([[[superArray objectAtIndex:indexPath.row]valueForKey:@"FuiEu"]boolValue]==YES) {
        cell.balao.frame=CGRectMake(320.0f-(tamanho.width + 28.0), 3.0f, tamanho.width+28.0f, tamanho.height+15.0f);
        cell.balao.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        imagemBalao=[[UIImage imageNamed:@"Balloon_1.png"]stretchableImageWithLeftCapWidth:15.0 topCapHeight:35.0];
        cell.label.frame=CGRectMake(302.0f-(tamanho.width-0.5f),8.0f, tamanho.width+5.0f, tamanho.height);
        cell.label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    }else {
        cell.balao.frame=CGRectMake(0.0, 3.0f, tamanho.width+28.0f, tamanho.height+15.0f);
        cell.balao.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
        imagemBalao=[[UIImage imageNamed:@"Balloon_2.png"]stretchableImageWithLeftCapWidth:20.0 topCapHeight:30.0];
        cell.label.frame=CGRectMake(16.0f,8.0f, tamanho.width+5.0f, tamanho.height);
        cell.label.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    }
    cell.balao.image=imagemBalao;
    cell.label.text=texto;
    return cell;
}
/* CODIGO SEM ARC:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		UIImageView *balao;
		UILabel *label;
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
			tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
			balao=[[UIImageView alloc]init];
			balao.tag=kBallonViewTexto;
			label=[[UILabel alloc]init];
			label.tag=kContentTexto;
			label.backgroundColor=[UIColor clearColor];
			label.numberOfLines=0;
			label.lineBreakMode=UILineBreakModeWordWrap;
			label.font=[UIFont systemFontOfSize:16.0f];
			UIView *mensagem=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
			mensagem.tag=kMessageTexto;
			[mensagem addSubview:balao];
			[mensagem addSubview:label];
			mensagem.autoresizingMask=UIViewAutoresizingFlexibleWidth;
			[cell.contentView addSubview:mensagem];
			[mensagem release];
			[label release];
			[balao release];
		}else {
			balao=(UIImageView *)[[cell.contentView viewWithTag:kMessageTexto]viewWithTag:kBallonViewTexto];
			label=(UILabel *)[[cell.contentView viewWithTag:kMessageTexto]viewWithTag:kContentTexto];
		}
    NSString *texto = [[superArray objectAtIndex:indexPath.row]objectForKey:@"Texto"];
		CGSize tamanho=[texto sizeWithFont:[UIFont systemFontOfSize:16.0f]constrainedToSize:CGSizeMake(240.0f, 480.0f) lineBreakMode:UILineBreakModeWordWrap];
		UIImage *imagemBalao;
		if ([[[superArray objectAtIndex:indexPath.row]valueForKey:@"FuiEu"]boolValue]==YES) {
			balao.frame=CGRectMake(320.0f-(tamanho.width + 28.0), 3.0f, tamanho.width+28.0f, tamanho.height+15.0f);
			balao.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
			imagemBalao=[[UIImage imageNamed:@"quadrado1s.png"]stretchableImageWithLeftCapWidth:15.0 topCapHeight:35.0];
			label.frame=CGRectMake(302.0f-(tamanho.width-0.5f),8.0f, tamanho.width+5.0f, tamanho.height);
			label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
		}else {
			balao.frame=CGRectMake(0.0, 3.0f, tamanho.width+28.0f, tamanho.height+15.0f);
			balao.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
			imagemBalao=[[UIImage imageNamed:@"quadrado2s.png"]stretchableImageWithLeftCapWidth:20.0 topCapHeight:30.0];
			label.frame=CGRectMake(16.0f,8.0f, tamanho.width+5.0f, tamanho.height);
			label.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
		}
		balao.image=imagemBalao;
		label.text=texto;
		
    return cell;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark - GKPeerPickerController 

-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSKeyedUnarchiver *archiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSString *str=[archiver decodeObjectForKey:@"Texto"];
    [self adicionarTexto:str fuiEu:NO];
}
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session {
    currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	picker.delegate = nil;
    [picker dismiss];
}
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    picker.delegate = nil;
	conectado=NO;
}
-(void)session:(GKSession *)session peer:(NSString *)peerID  didChangeState:(GKPeerConnectionState)state {
    if (state==GKPeerStateConnected) {
        conectado=YES;
        
    }else{
        conectado=NO;
        
    }
    [self atualizarBarra];
}

@end
