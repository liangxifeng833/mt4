//+------------------------------------------------------------------+
//|                                                        test2.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      double a = 2;
      double b = 0;
      if(Bid > a)
      {
         b = 1;
         b++;
         printf("da");
        
      }else
      {
         b = 2;
         printf("xiao");
      }
   
  }
//+------------------------------------------------------------------+
