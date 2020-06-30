//+------------------------------------------------------------------+
//|                                                    AutoOrder.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs


//外部输入参数订单id
//extern int magic = "订单id";
//extern string note = "注释";
//判断一根K线只开一单
datetime t = 0;

//+------------------------------------------------------------------+
//| mt4最先执行的初始化函数                               |
//+------------------------------------------------------------------+
int OnInit()
  {
      /*
     //bool t=OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,0,"buy",255,0,Red);
     int resA = OrderSend(Symbol(),OP_BUY,0.01,Ask,3,Ask-100*Point, Ask+100*Point,"duo=1",1234567,0,White);
     printf("开多单结果="+resA);
     int res = OrderSend(Symbol(),OP_SELL,0.01,Bid,3,(Bid+200*Point),(Bid-200*Point),"kong-1",1234567,0,Red);
     //int res = OrderSend(Symbol(),OP_SELL,0.01,Bid,10,0,0,"hello-lxf",123456,0,Red);
     printf("开空单结果="+res);*/ 
//---
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

     return;
  }


//+------------------------------------------------------------------+
//| 价格变动一次执行该函数                                           |
//+------------------------------------------------------------------+

void OnTick()
  {
//---
     //获取当前货币对D1时间周期1号K线的最高价，也就是说昨天的最高价
     double hightD1 = iHigh(NULL,1440,1);
     //获取当前货币对D1时间周期1号K线的最底价，也就是说昨天的最底价
     double lowD1 = iLow(NULL,1440,1);
     

     double m60Open = iOpen(NULL,60,0); //当前1小时图开盘价
     double m60Close =  iClose(NULL,60,0); //当前1小时图收盘价
     
     double m30Open = iOpen(NULL,30,0); //当前30分钟图开盘价
     double m30Close =  iClose(NULL,30,0); //当前30分钟图收盘价
     
     double newLots = 0.01; //下单手数
     
     printf(TimeLocal()+"昨天D1最高价="+hightD1+",昨天D1最低价="+lowD1+",1小时开盘价="+m60Open+",1小时收盘价="+m60Close+",30分钟图开盘价="+m30Open+",30分钟图收盘价="+m30Close);
    // OrderSend(Symbol(),OP_BUY,0.01,Ask,3,(Ask-0.30),(Ask+0.30),"My order",16384,0,clrGreen);

     //1根k线只开一单
     if(t!=Time[0])
     {
         int ordersTotal =  OrdersTotal(); //订单总数
         ordersTotal++;
         string zhushi = Symbol()+ordersTotal;
         //int a = buy(newLots,200,200,zhushi,ordersTotal);
         //int b = sell(newLots,200,200,zhushi,ordersTotal);
         //printf("注释="+Symbol()+zhushi);
         //如果1小时图收盘价>开盘价 且 1小时图收盘价 > 昨天最高价 且 30分钟收盘>开盘，则开多单
         if (m60Close > m60Open && m60Close > hightD1 && m30Close > m30Open) 
         {   
             if(buy(newLots,200,200,zhushi,ordersTotal)>0)
             {
                  //t=当前K线开盘时间
                  t=Time[0];
             }
         }      
         //如果1小时图收盘价<开盘价 且 1小时图收盘价 < 昨天最底价 且 30分钟收盘<开盘，则开空
         if (m60Close < m60Open && m60Close < lowD1 && m30Close < m30Open) 
         {
             if (sell(newLots,200,200,zhushi,ordersTotal) > 0) 
             {
                  t=Time[0];
             }
         }
     }  
  }
//+------------------------------------------------------------------+

 /**
  *平仓
  * param zhushi 注释
  * param mag 订单id
  */
  void close(string zhushi,int mag)
  {
    int a=OrdersTotal(); //订单总数
    for(int i=a-1;i>=0;i--)
      {
        //选中订单 
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         {
           //找到要平仓的订单
           if(OrderComment()==zhushi && OrderMagicNumber()==mag)
             {
               /**
               * 第一个参数：OrderTicket 订单编号
               * 第二个参数：平仓手数，OrderLots()/2代表平一半，OrderLots()代表全部平仓
               * 第三个参数：平仓价格（当前的卖/买价）
               * 第四个参数：滑点 50
               * 第五个参数：颜色（K线中表示）
               */
               OrderClose(OrderTicket(),OrderLots()/2,OrderClosePrice(),50,Green);
             }
         }
      }
  }
//+------------------------------------------------------------------+
/**
* 开多单
* 第一个参数 lots 下单手数
* 第二个参数 sl 止损价格 0不设止损
* 第三个参数 tp 止盈价格 0不设止盈
* 第四个参数 com 注释
* 第五个参数 buymagic 自定义订单编号（id）
* 返回值：开单成功=订单号，开单失败=-1
*/
int buy(double lots,double sl, double tp, string com, int buymagic) 
{
   printf(TimeLocal()+"开多单----");
   int a = 0;
   bool zhaodao = false; //是否找到已经存在的订单，找到就不允许重复开单了
   //循环所有的单子 OrdersTotal()就是当前的订单数量
   for( int i=0; i<=OrdersTotal();i++)
   {
      //OrderSelect()选中订单，
      //第一个参数是序号，
      //第二个参数SELECT_BY_POS是序号模式，
      //第三个参数代表选择现在的单子还是历史单子MODE_TRADES（现在的单子）
      //如果选到了单子
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true) 
      {
         //获取选中订单的信息
         int ti = OrderTicket(); //获取订单编号(系统生成的)
         //double op = OrderOpenPrice(); //开盘价
         //double sl = OrderStopLoss() //止损价格
         //double lots = OrderLots(); //下单手数量
         string zhushi = OrderComment(); //注释
         int ma = OrderMagicNumber(); //订单号（自定义的）
         //如果当前货币对下，都是买单，注释和订单id相等情况下就代表找到了已经存在的订单
         if(OrderSymbol() == Symbol() && OrderType() == OP_BUY &&  zhushi == com && ma == buymagic)
         {
            zhaodao = true;
            break;
         }
      }
   }
   //如果没有找到就继续开单
    if(zhaodao==false)
      {
        if(sl!=0 && tp==0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
         }
        if(sl==0 && tp!=0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,Ask+tp*Point,com,buymagic,0,White);
         }
        if(sl==0 && tp==0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,com,buymagic,0,White);
         }
        if(sl!=0 && tp!=0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,White);
         } 
      }
      printf(TimeLocal()+"多单返回结果="+a+",zhaodao="+zhaodao);
   return(a);
}
/**
* 开空单
* 返回值：开单成功=订单号，开单失败=-1
*/
int sell(double lots,double sl, double tp, string com, int sellmagic) 
{
   printf(TimeLocal()+"开空单----lots="+lots+",sl="+sl+",tp="+tp+",com="+com+",sellmagic="+sellmagic);
   int a = 0;
   bool zhaodao = false;
   for( int i=0; i<=OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true) 
      {
         string zhushi = OrderComment();
         int ma = OrderMagicNumber();
         if(OrderSymbol() == Symbol() && OrderType() == OP_SELL && zhushi == com && ma == sellmagic)
         {
            zhaodao = true;
            break;
         }
      }
   }
    if(zhaodao==false)
      {
        if(sl==0 && tp!=0)
         {
           a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,Bid-tp*Point,com,sellmagic,0,Red);
         }
        if(sl!=0 && tp==0)
         {
           a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Red);
         }
        if(sl==0 && tp==0)
         {
           a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,0,com,sellmagic,0,Red);
         }
        if(sl!=0 && tp!=0)
         {
           a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,Bid-tp*Point,com,sellmagic,0,Red);
         }
      }
      printf(TimeLocal()+"空单返回结果="+a+",zhaodao="+zhaodao);
   return(a);
}

