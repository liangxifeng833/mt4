#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
extern double 初始下单量=0.1;
extern int 盈利加仓间隔点数=100;
extern double 盈利加仓下倍数=2;
extern int 盈利加仓次=5;
extern int 大周期均线=20;
extern int 小周期均线=10;
extern double 总获利大于几美金全部平仓=100;
extern int magic=1213;
datetime buytime=0;
datetime selltime=0;
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {
   
  }
void OnTick()
  {
     double da0=iMA(NULL,0,大周期均线,0,MODE_SMA,PRICE_CLOSE,0);
     double da1=iMA(NULL,0,大周期均线,0,MODE_SMA,PRICE_CLOSE,1);
     double da2=iMA(NULL,0,大周期均线,0,MODE_SMA,PRICE_CLOSE,2);
     double xiao0=iMA(NULL,0,小周期均线,0,MODE_SMA,PRICE_CLOSE,0);
     double xiao1=iMA(NULL,0,小周期均线,0,MODE_SMA,PRICE_CLOSE,1);
     double xiao2=iMA(NULL,0,小周期均线,0,MODE_SMA,PRICE_CLOSE,2);
     double buyop,buylots;
     int buydanshu=buydanshu(buyop,buylots);
     if(buydanshu==0)
      {
        if(xiao0>da0 && xiao1<da1)
          {
           if(buytime!=Time[0])
            {
              if(buy(初始下单量,0,0,Symbol()+"buy",magic)>0)
               {
                 buytime=Time[0];
               }
            }
          }
      }
     else
      {
        if(xiao0>da0 && buydanshu<盈利加仓次 && (Ask-buyop)>=盈利加仓间隔点数*Point)
         {
           buy(flots(buylots*盈利加仓下倍数),0,0,Symbol()+"buy"+buydanshu,magic);
         }
      }
     double sellop,selllots;
     int selldanshu=selldanshu(sellop,selllots);
     if(selldanshu==0)
      {
        if(xiao0<da0 && xiao1>da1)
          {
            if(selltime!=Time[0])
            {
              if(sell(初始下单量,0,0,Symbol()+"sell",magic)>0)
                {
                  selltime=Time[0];
                }
            }
          }
      }
     else
      {
        if(xiao0<da0 && selldanshu<盈利加仓次 && (sellop-Bid)>=盈利加仓间隔点数*Point)
         {
           
           sell(flots(selllots*盈利加仓下倍数),0,0,Symbol()+"sell"+selldanshu,magic);
         }
      }
     if(xiao0<da0 && xiao1>da1)//死叉，把多单全部平掉
      {
        closebuy();
      }
     if(xiao0>da0 && xiao1<da1)//金叉，把空单全部平掉
      {
        closesell();
      }
     if(buyprofit()>总获利大于几美金全部平仓)
      {
       closebuy();
      }
     if(sellprofit()>总获利大于几美金全部平仓)
      {
       closesell();
      }
  }
double buyprofit()
  {
     double a=0;
     int t=OrdersTotal();
     for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
                 {
                   a=a+OrderProfit()+OrderCommission()+OrderSwap();
                 }
             }
         }  
    return(a);
  }
double sellprofit()
  {
     double a=0;
     int t=OrdersTotal();
     for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
                 {
                   a=a+OrderProfit()+OrderCommission()+OrderSwap();
                 }
             }
         }  
    return(a);
  }
void closebuy()
  { 
    double buyop,buylots;
    while(buydanshu(buyop,buylots)>0)
     {
        int t=OrdersTotal();
        for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
                 {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),300,Green);
                 }
             }
         }
        Sleep(800);
     }
  }
void closesell()
  {
    double sellop,selllots;
    while(selldanshu(sellop,selllots)>0)
     {
        int t=OrdersTotal();
        for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
                 {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),300,Green);
                 }
             }
         }
        Sleep(800);
     }
  }
void buyxiugaitp(double tp)
  {
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
              {
                if(NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(tp,Digits))
                 {
                   OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp,0,Green);
                 }
              }
          }
      }
  }
void sellxiugaitp(double tp)
  {
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
              {
                if(NormalizeDouble(OrderTakeProfit(),Digits)!=NormalizeDouble(tp,Digits))
                 {
                   OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp,0,Green);
                 }
              }
          }
      }
  }
double avgbuyprice()
  {
    double a=0;
    int shuliang=0;
    double pricehe=0;
    for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
              {
               pricehe=pricehe+OrderOpenPrice();
               shuliang++;
              }
          }
      }
    if(shuliang>0)
     {
      a=pricehe/shuliang;
     }
    return(a);
  }
double avgsellprice()
  {
    double a=0;
    int shuliang=0;
    double pricehe=0;
    for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
              {
               pricehe=pricehe+OrderOpenPrice();
               shuliang++;
              }
          }
      }
    if(shuliang>0)
     {
      a=pricehe/shuliang;
     }
    return(a);
  }
double flots(double dlots)
  {
    double fb=NormalizeDouble(dlots/MarketInfo(Symbol(),MODE_MINLOT),0);
    return(MarketInfo(Symbol(),MODE_MINLOT)*fb);
  }
int buydanshu(double &op,double &lots)
  {
     int a=0;
     op=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
              {
                a++;
                op=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  }
 int selldanshu(double &op,double &lots)
  {
     int a=0;
     op=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
              {
                a++;
                op=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  }
int buy(double lots,double sl,double tp,string com,int buymagic)
  {
    int a=0;
    bool zhaodan=false;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com && ma==buymagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
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
int sell(double lots,double sl,double tp,string com,int sellmagic)
  {
    int a=0;
    bool zhaodan=false;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && zhushi==com && ma==sellmagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
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