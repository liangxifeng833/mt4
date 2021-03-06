//+------------------------------------------------------------------+
//|                                                        EAtmp.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int a = 1;     
 
extern double keyPrice = 20;//突破值 
extern double stopProfit = 300;//止盈点
extern double stopLoss = 200;//止损点
 
int OnInit()
  {
      printf("今天是："+DayOfWeek());
      //周一最高价
      double week1High = iHigh(NULL,PERIOD_D1,DayOfWeek()-1);
      //周一最底价
      double week1Low = iLow(NULL,PERIOD_D1,DayOfWeek()-1);
      //周一最高 - 最底价
      double week1ChaPoint =  MathFloor( (week1High-week1Low)/Point );
      printf("本周一最高价="+week1High+",本周一最底价="+week1Low+",本周一最高与最底价之差="+week1ChaPoint);

//---
/*
     //bool t=OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,0,"buy",255,0,Red);
     int resA = OrderSend(Symbol(),OP_BUY,0.01,Ask,300,Ask-100*Point, Ask+100*Point,"duo-2",1234567,0,White);
     printf("开多单结果="+resA);
     int res = OrderSend(Symbol(),OP_SELL,0.01,Bid,300,(Bid+200*Point),(Bid-200*Point),"kong-2",1234567,0,Red);
     //int res = OrderSend(Symbol(),OP_SELL,0.01,Bid,10,0,0,"hello-lxf",123456,0,Red);
     printf("开空单结果="+res); */
   
//---
   return(INIT_SUCCEEDED);
  }
  void OnTimer() 
  {
      double m1OneHigh = iHigh(NULL,1,1); //前1分钟图最高价
      double m1OneLow = iLow(NULL,1,1); //前1分钟图最底价 
      printf(TimeLocal()+":前1分钟最高价="+m1OneHigh+",最底价="+m1OneLow+",使用全局变量方式获取前1分钟最底价="+m1OneLow);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      //OrderSend(Symbol(),OP_BUY,0.01,Ask,50,Ask-200*Point,Ask+200*Point,"duo34",123456,0,White);
      //OrderSend(Symbol(),OP_SELL,0.01,Bid,50,Bid+200*Point,Bid-200*Point,"kong-12",123,0,Red);
//---
   //int res1 = OrderSend(Symbol(),OP_BUY,0.01,Ask,50,Ask-100*Point, Ask+100*Point,"duo-01",123456,0,White);
   //int res2 = OrderSend(Symbol(),OP_SELL,0.01,Bid,50,Bid+100*Point,Bid-100*Point,"kong-02",12321,0,Red);
   //printf(TimeLocal()+"开多单结果="+res1);
   //printf(TimeLocal()+"开空单结果="+res2); 
  }
//+------------------------------------------------------------------+
