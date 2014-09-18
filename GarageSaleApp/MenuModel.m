//
//  MenuModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "MenuModel.h"
#import "MenuItem.h"

@implementation MenuModel

- (NSMutableArray *)getMenuItem
{
    NSMutableArray *menuItemArray = [[NSMutableArray alloc] init];

    MenuItem *item0 = [[MenuItem alloc] init];
    item0.menuTitle = @"Mensajes";
    item0.menuIcon = @"ProductMenuIcon";
    item0.screenType = ScreenTypeMessages;
    [menuItemArray addObject:item0];

    MenuItem *item1 = [[MenuItem alloc] init];
    item1.menuTitle = @"Productos";
    item1.menuIcon = @"ProductMenuIcon";
    item1.screenType = ScreenTypeProduct;
    [menuItemArray addObject:item1];
    
    MenuItem *item2 = [[MenuItem alloc] init];
    item2.menuTitle = @"Clientes";
    item2.menuIcon = @"ClientMenuIcon";
    item2.screenType = ScreenTypeClient;
    [menuItemArray addObject:item2];
    
    MenuItem *item3 = [[MenuItem alloc] init];
    item3.menuTitle = @"Oportunidades";
    item3.menuIcon = @"OpportunityMenuIcon";
    item3.screenType = ScreenTypeOpportunity;
    [menuItemArray addObject:item3];
    
    MenuItem *item4 = [[MenuItem alloc] init];
    item4.menuTitle = @"Configuracion";
    item4.menuIcon = @"AboutMenuIcon";
    item4.screenType = ScreenTypeAbout;
    [menuItemArray addObject:item4];
    
    MenuItem *item5 = [[MenuItem alloc] init];
    item5.menuTitle = @"Acerca de";
    item5.menuIcon = @"AboutMenuIcon";
    item5.screenType = ScreenTypeAbout;
    [menuItemArray addObject:item5];
    

    return menuItemArray;
    
}

@end
