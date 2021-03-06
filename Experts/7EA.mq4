//+------------------------------------------------------------------+
//|                                                          7EA.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern int magic = 123;
datetime t = 0;
//+------------------------------------------------------------------+
//| mt4最先执行的初始化函数                               |
//+------------------------------------------------------------------+
int OnInit()
  {
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
   
  }
//+------------------------------------------------------------------+
//| 每个价格波动，就执行一次                                             |
//+------------------------------------------------------------------+
void OnTick() 
  {
//---
   printf("================hello=============");
   //Time[0]就是0号K的开盘时间
   //该判断就代表一根K线只开一张单-------start
   if(t != Time[0]){
      if (sell(0.1,100, 100,Symbol()+"kong",magic)>0) {
         t=Time[0];
      }
   }
   //该判断就代表一根K线只开一张单-------start
   
   //如果当前收盘价<开盘价
   //if(Close[0] < Open[0])
   {
      //Symbol代表拖到的当前货币对名称
      //buy(0.1,100, 100,Symbol()+"duo",magic);
      //sell(0.1,100, 100,Symbol()+"kong",magic);
      /*
      if(1==1)
      {
         close("EURUSDduo",magic);
      }*/
   }
      /*
       * 开单函数
       * 注意：开单后会生成要给OrderTicket的订单编号由系统自动生成，我们开单的时候有一个入参(倒数第三个)代表的是订单id，是自定义的。
       * 第一个参数：货币多名称，Symbol()，托到哪个货币对，就是哪个货币对名,
       * 第二个参数：买单还是卖单，OP_BUY开一个买单
       * 第三个参数：下单手数，开0.1手,
       * 第四个参数：开单的价格，Ask代表当前买价,
       * 第五个参数：允许划点数，10代表滑10个点,比如：下单时买价格=1.0123,下单成功买家就不是这个值了,允许在10个点之间变动
       * 第六个参数：止损价格 Ask-100*Point，当前间买价-100点
       * 第七个参数：止盈价格 Ask+100*Point，当前卖价+100点
       * 第八个参数：注释：duo (设置后不可修改)
       * 第九个参数：订单id,(设置后不可修改)
       * 第十个参数：挂单有效期，本例子中是立刻开单，不涉及挂单，所以这里设置为0,无期限；
       * 第十一个：开单颜色，在K线图中的标记。
       * 返回值说明：开单成功返回订单号，开单不成功返回-1s
       */
       //OrderSend(Symbol(),OP_BUY,0.1,Ask,10,Ask-100*Point, Ask+100*Point,"duo",123456,0,White);
      //OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
   
  }
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
   int a = 0;
   bool zhaodao = false; //是否找到已经存在的订单，找到就不允许重复开单了
   //循环所有的单子 OrdersTotal()就是当前的订单数量
   for( int i=0; i<OrdersTotal();i++)
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
   return(a);
}
/**
* 开空单
* 返回值：开单成功=订单号，开单失败=-1
*/
int sell(double lots,double sl, double tp, string com, int sellmagic) 
{
   int a = 0;
   bool zhaodao = false;
   for( int i=0; i<OrdersTotal();i++)
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
   return(a);
}
