//
//  AIModuleStateMachine.h
//  AIDemo
//
//  Created by fengsl on 2021/5/29.
//

#import <Foundation/Foundation.h>
#import "AIModuleStateItem.h"

NS_ASSUME_NONNULL_BEGIN

//状态管理器
@interface AIModuleStateMachine : NSObject

//关联的cell model
@property (nonatomic, copy) NSString *associatedModuleId;

//出现状态
@property (nonatomic, strong) AIModuleStateItem *beiginState;
//消失状态
@property (nonatomic, strong) AIModuleStateItem *endState;


@end

NS_ASSUME_NONNULL_END
