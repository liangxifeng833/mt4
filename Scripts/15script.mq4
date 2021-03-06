#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//注意：这个一定要有，代表加载script的时候，需要手动 "勾选允许更改信号设置"
#property show_inputs
/**
* 使用程序的方式跟单。依据市场信号
* 需要在mt5网站上注册账号并登陆，同时在mt4软件以相同的账号登陆才可以
*/
void OnStart()
  {
    //获取市场中所有的信号
    int total=SignalBaseTotal();
    for(int i=0;i<total;i++)
      {
        //选中信号
        if(SignalBaseSelect(i)==true)
          {
            //获取信号id
            int id=SignalBaseGetInteger(SIGNAL_BASE_ID);
            //获取信号名称
            string name=SignalBaseGetString(SIGNAL_BASE_NAME);
            //获取信号订阅价格
            double price=SignalBaseGetDouble(SIGNAL_BASE_PRICE);
            //获取信号的交易次数
            int trade=SignalBaseGetInteger(SIGNAL_BASE_TRADES);
            //如果是免费 且 交易次数>0，则跟单
            if(price==0 && trade>0)
             {
               printf(id+"|"+name);
               //设置同意条款
               SignalInfoSetInteger(SIGNAL_INFO_TERMS_AGREE,1);
               //同意启动实时信号订阅
               SignalInfoSetInteger(SIGNAL_INFO_SUBSCRIPTION_ENABLED,1);
               //同意复制止损和获利水平,跟单的时止损和止盈与信号保持一致
               SignalInfoSetInteger(SIGNAL_INFO_COPY_SLTP,1);
               //不需要确认下单，也就是说跟单的时候，不需要人工确认
               SignalInfoSetInteger(SIGNAL_INFO_CONFIRMATIONS_DISABLED,1);
               //设置仓位百分比 这里是余额的20%
               SignalInfoSetInteger(SIGNAL_INFO_DEPOSIT_PERCENT,20);
               //净值少入4500美金的时候，停止跟单
               SignalInfoSetDouble(SIGNAL_INFO_EQUITY_LIMIT,4500);
               //最大允许点差 = 1.5
               SignalInfoSetDouble(SIGNAL_INFO_SLIPPAGE,1.5);
               //如果订阅失败，则打印error
               if(SignalSubscribe(id)==false)
                {
                  printf("订阅失败,原因："+GetLastError());
                }else
                {
                  printf("订阅成功,信号名="+name+"，交易次数="+trade);
                }
               break;
             }
          }
      }
  }
