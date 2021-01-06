//+------------------------------------------------------------------+
//|                                                GetMinDiancha.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern int timer=1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string symbols[13]={"USDCZK","USDMXN","USDNOK","USDPLN","USDRUB","USDSEK","USDTHB","USDTRY","USDZAR","USDDKK","USDHKD","USDCNH","USDHUF"};
int diancha[13]; 

int OnInit()
  {
      for(int i=0; i<ArraySize(symbols); i++)
      {
         diancha[i] = 100000;
      }
      EventSetTimer(timer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+


void OnTick()
  {

   
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
      for(int i=0; i< ArraySize(symbols); i++) 
      {
         //printf("i="+symbols[i]);
         int curDiancha = (int)MarketInfo(symbols[i],MODE_SPREAD);
         //printf("点差="+curDiancha);
         if(curDiancha < diancha[i])
         {
            diancha[i] = curDiancha;
         }
      }
      for(int i=0; i<ArraySize(symbols); i++)
      {
         printf("symbols:"+symbols[i]+",######->diancha="+diancha[i]);
      }
      printf("fengeline=====================================================");
  }
//+------------------------------------------------------------------+
