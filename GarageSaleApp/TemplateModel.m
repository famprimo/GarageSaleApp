//
//  TemplateModel.m
//  GarageSaleApp
//
//  Created by Federico Amprimo on 17/12/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "TemplateModel.h"
#import "AppDelegate.h"

@implementation TemplateModel

- (NSMutableArray*)getTemplates;
{
    // Array to hold the listing data
    NSMutableArray *templates = [[NSMutableArray alloc] init];
    NSDateFormatter *formatFBdates = [[NSDateFormatter alloc] init];
    [formatFBdates setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];    // 2014-09-27T16:41:15+0000
    
    // Create template #1
    Template *tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00001";
    tempTemplate.title = @"Aviso comprador";
    tempTemplate.text = @"Hola #COMPRADOR. La dueña de es #DUENO y su teléfono es #D-TELEFONO. Coordina con #D-ELELLA cuando puedes ir a verlo, yo ya le avisé que #D-LALO vas a llamar. En caso lo llegues a comprar necesito que por favor me mandes un mensajito avisándome. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"C";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];

    // Create template #2
    tempTemplate = [[Template alloc] init];
    
    tempTemplate.template_id = @"00002";
    tempTemplate.title = @"Sistema de trabajo";
    tempTemplate.text = @"Hola #COMPRADOR. Te cuento cuál es nuestro sistema de trabajo..... Para poder publicar tus cosas necesito que me mandes las fotos de cada cosa junto con el precio de venta, una pequeña descripción que incluya el estado en que se encuentra, tus teléfonos y distrito. La publicación es gratis y en caso se venda algo a través nuestro cobramos una comisión de 10% del precio de venta final y debe de estar incluido en el precio que nos das. Para qué la publicación sea aprobada los precios tienen que ser atractivos. Cuando una persona se interesa en un producto tuyo le damos tu teléfono por el inbox previa revisión de su perfil, por lo general son personas conocidas o referidas. Para el pago de la comisión tenemos una cuenta BCP donde puedes depositarnos o transferirnos. Si tienes alguna duda escríbeme. Saludos, Giuliana";
    tempTemplate.type = @"C";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];
    
    // Create template #3
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00003";
    tempTemplate.title = @"Interés inicial";
    tempTemplate.text = @"Si está disponible. Para poder mandarte los datos al inbox necesito que por favor aceptes mi solicitud de amistad y me avises una vez que lo hagas :)";
    tempTemplate.type = @"C";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];
    
    // Create template #4
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00004";
    tempTemplate.title = @"Confirmación de visita";
    tempTemplate.text = @"Hola #COMPRADOR. Cómo estás? Quería que por favor me cuentes si llegaste a ir por el #PRODUCTO. Espero tus comentarios. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"C";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];
    
    // Create template #5
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00005";
    tempTemplate.title = @"Envío de cuenta";
    tempTemplate.text = @"Te paso nuestra cuenta para que puedas hacer el abono de la comisión (10%). BCP ahorros soles # 194-22457272-0-11 a nombre de Maria Giuliana Ugarelli Reinafarje.  Acuérdate de avisarme a penas lo hagas para saber que es tuyo y sacarte de la lista de pendientes.  Puede ser transferencia por internet o depósito (de preferencia en Agente y no en agencia).  Un beso, Giuliana";
    tempTemplate.type = @"O";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];
    
    // Create template #6
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00006";
    tempTemplate.title = @"Confirmación de venta";
    tempTemplate.text = @"Hola #DUENO. Cómo estás? Quería que por favor me cuentes si fueron a ver el #PRODUCTO y llegaste a venderlo para coordinar lo de la comisión. Espero tus comentarios. Gracias. Saludos, Giuliana";
    tempTemplate.type = @"O";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];
    
    // Create template #7
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00007";
    tempTemplate.title = @"Venta de ropa";
    tempTemplate.text = @"Si es ropa, no cobramos comisión, pero cobramos por nuestros servicios el 5% del precio de venta y debe ser abonado en nuestra cuenta BCP antes de la publicación y es muy independiente de si se vende o no el producto";
    tempTemplate.type = @"C";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];
    
    // Create template #8
    tempTemplate = [[Template alloc] init];
    tempTemplate.template_id = @"00008";
    tempTemplate.title = @"Sistema de aviso";
    tempTemplate.text = @"En este caso lo que hacemos es poner un aviso y en la descripción ponemos tu teléfono para que te contacten directamente. No cobramos comisión por venta, pero cobramos un monto de s/. 30 por nuestros servicios. Si te interesa avísame para pasarte nuestro número de cuenta BCP. Un beso, Giuliana";
    tempTemplate.type = @"C";
    tempTemplate.updated_time = [formatFBdates dateFromString:@"2014-05-01T10:00:00+0000"];
    tempTemplate.agent_id = @"00001";
    
    // Add template to the array
    [templates addObject:tempTemplate];

    
    // Set last template ID
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastTemplateID = 8;
    
    // Return the producct array as the return value
    return templates;
}


- (NSMutableArray*)getTemplatesFromType:(NSString*)templateType;
{
    NSMutableArray *templateArray = [[NSMutableArray alloc] init];
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Template *templateToReview = [[Template alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayTemplates.count; i=i+1)
    {
        templateToReview = [[Template alloc] init];
        templateToReview = (Template *)mainDelegate.sharedArrayTemplates[i];
        
        if ([templateToReview.type isEqual:templateType])
        {
            [templateArray addObject:templateToReview];
        }
    }
    return templateArray;
}


- (NSString*)getNextTemplateID;
{
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.lastTemplateID = mainDelegate.lastTemplateID + 1;
    
    NSString *nextID = [NSString stringWithFormat:@"00000000%d", mainDelegate.lastTemplateID];
    nextID = [nextID substringFromIndex:[nextID length] - 5];
    
    return nextID;
}


- (BOOL)addNewTemplate:(Template*)newTemplate;
{
    BOOL updateSuccessful = YES;
    
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [mainDelegate.sharedArrayTemplates addObject:newTemplate];
    
    return updateSuccessful;
}


- (void)updateTemplate:(Template*)templateToUpdate;
{
    // To have access to shared arrays from AppDelegate
    AppDelegate *mainDelegate;
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Template *templateToReview = [[Template alloc] init];
    
    for (int i=0; i<mainDelegate.sharedArrayTemplates.count; i=i+1)
    {
        templateToReview = [[Template alloc] init];
        templateToReview = (Template *)mainDelegate.sharedArrayTemplates[i];
        
        if ([templateToReview.template_id isEqual:templateToUpdate.template_id])
        {
            [mainDelegate.sharedArrayTemplates replaceObjectAtIndex:i withObject:templateToUpdate];
            break;
        }
    }
}

- (void)updateTemplate:(Template*)templateToUpdate withArray:(NSMutableArray*)arrayTemplates;
{
    Template *templateToReview = [[Template alloc] init];
    
    for (int i=0; i<arrayTemplates.count; i=i+1)
    {
        templateToReview = [[Template alloc] init];
        templateToReview = (Template *)arrayTemplates[i];
        
        if ([templateToReview.template_id isEqual:templateToUpdate.template_id])
        {
            [arrayTemplates replaceObjectAtIndex:i withObject:templateToUpdate];
            break;
        }
    }
}

- (NSString*)changeKeysForText:(NSString*)textToReview usingBuyer:(Client*)clientBuyer andOwner:(Client*)clientOwner andProduct:(Product*)relatedProduct;
{
    NSMutableString *reviewedText = [NSMutableString stringWithString:textToReview];
    NSRange keyRange;

    if ([clientBuyer.client_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#COMPRADOR"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientBuyer.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-TELEFONO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientBuyer.phone1];
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-LALO"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"lo"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"la"];
            }
        }
        
        keyRange = [reviewedText rangeOfString:@"#C-ELELLA"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"el"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"ella"];
            }
        }
    }
    
    if ([clientOwner.client_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#DUENO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-TELEFONO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.phone1];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-ZONA"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:clientOwner.zone];
        }
        
        keyRange = [reviewedText rangeOfString:@"#D-LALO"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"lo"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"la"];
            }
        }
 
        keyRange = [reviewedText rangeOfString:@"#D-ELELLA"];
        if (keyRange.location != NSNotFound)
        {
            if ([clientBuyer.sex isEqualToString:@"M"])
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"el"];
            }
            else
            {
                [reviewedText replaceCharactersInRange:keyRange withString:@"ella"];
            }
        }
       
    }
    
    if ([relatedProduct.product_id length] > 0)
    {
        keyRange = [reviewedText rangeOfString:@"#PRODUCTO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:relatedProduct.name];
        }
        
        keyRange = [reviewedText rangeOfString:@"#PRECIO"];
        if (keyRange.location != NSNotFound)
        {
            [reviewedText replaceCharactersInRange:keyRange withString:[NSString stringWithFormat:@"%f", relatedProduct.price]];
        }
    }    
    
    return [NSString stringWithString:reviewedText];
}

@end
