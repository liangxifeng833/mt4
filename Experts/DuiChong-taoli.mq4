#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern int sp=56;
extern int timer=10;
extern double lost=0.01;
extern int orderLiveTimer=30;
double magic=444555;
 
/**
* USDHKD fanyong taoli
**/
int OnInit()
  {
   EventSetTimer(timer); //timer 秒执行一次
   return(INIT_SUCCEEDED);
  }
  
void OnTimer()
{ 
   double buyop,buylots,sellop,selllots;
   int buydanshu=buydanshu(buyop,buylots);
   int selldanshu=selldanshu(sellop,selllots);
   int vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   
   if(vspread<=sp)
     {  
       printf( "curTime="+(int)TimeCurrent()+","+"order openTime = "+dct()+",cha="+ (TimeCurrent()-dct()));
       if( TimeCurrent()-dct() >= orderLiveTimer) 
       {
         closeall();
       }
       //printf(Symbol()+TimeLocal()+"buy--sp="+sp+",lost="+lost);
       int magicNew = MathRand();
       string zhushi = Symbol()+magicNew;  
       buy(lost,0,0,zhushi,(int)magicNew);
       sell(lost,0,0,zhushi,(int)magicNew);
     }
     
    
}  
  
void OnDeinit(const int reason)
  {
  }
void OnTick()
  {

     
  }

//--开单函数-------------------------------------------------------------------------------------
int buy(double lots,double sl,double tp,string com,int buymagic)
  {
    int a=0;
    bool zhaodan=false;
    /*
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            //if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com && ma==buymagic)
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY )
              {
                zhaodan=true;
                break;
              }
          }
      }*/
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
    /*
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            //if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && zhushi==com && ma==sellmagic)
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
              {
                zhaodan=true;
                break;
              }
          }
      }
     */
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
 //-------检索单数
int buydanshu(double &op,double &lots)
  {
     int a=0;
     op=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            //if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==magic)
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY )
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
            //if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==magic)
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
              {
                a++;
                op=OrderOpenPrice();
                lots=OrderLots();
              }
          }
      }
    return(a);
  } 
void closeall()
  { 
    double buyop,buylots;
    while(buydanshu(buyop,buylots)>0)
     {
        int t=OrdersTotal();
        for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderSymbol()==Symbol())
                 {
                    if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),300,Green)==false) printf ("error:",GetLastError());
                 }
             }
         }
        Sleep(800);
     }
  }

double dct() 
{ 
int da=0;
for(int cnt=0; cnt < OrdersTotal(); cnt++)
  {
    OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
    if(OrderSymbol()==Symbol())
    {  
      da=OrderOpenTime();
      //printf("da==== order opentTime="+OrderOpenPrice());
      return(da);
    }    
  }    
return(da);
}