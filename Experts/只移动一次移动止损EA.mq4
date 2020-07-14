//+------------------------------------------------------------------+
//|                                           只移动一次移动止损.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
extern int 移动止损点数=200;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   yidong();
   return(0);
  }
void yidong()
  {
     for(int i=0;i<OrdersTotal();i++)//移动止损通用代码,次代码会自动检测buy和sell单并对其移动止损
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
                if(OrderType()==0 && OrderSymbol()==Symbol())
                  {
                     if((Bid-OrderOpenPrice()) >=Point*移动止损点数)
                      {
                         if(NormalizeDouble(OrderStopLoss(),Digits)!=NormalizeDouble(Bid-Point*移动止损点数,Digits))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*移动止损点数,OrderTakeProfit(),0,Green);
                           }
                      }      
                  }
                if(OrderType()==1 && OrderSymbol()==Symbol())
                  {
                    if((OrderOpenPrice()-Ask)>=(Point*移动止损点数))
                      {
                         if(NormalizeDouble(OrderStopLoss(),Digits)!=NormalizeDouble(Ask+Point*移动止损点数,Digits))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*移动止损点数,OrderTakeProfit(),0,Red);
                           }
                      }
                  }
              }
         }
   }