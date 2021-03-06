//+------------------------------------------------------------------+
//|                                                GetMinDiancha.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern int timer=2;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string symbols[17]={"USDCZK","USDCZK","USDCNH","USDDKK","USDHKD","USDHUF","USDMXN","USDNOK","USDPLN","USDRUB","USDSEK","USDSGD","USDTRY","USDZAR","USDCHF","USDJPY","USDCAD"};
int dianchaMin[17];
int dianchaMax[17]; 
datetime minTime[17];
datetime maxTime[17];

int OnInit()
  {
      for(int i=0; i<ArraySize(symbols); i++)
      {
         dianchaMin[i] = 100000;
         dianchaMax[i] = 0;
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
         if(curDiancha < dianchaMin[i])
         {
            dianchaMin[i] = curDiancha;
            minTime[i] = TimeLocal();
         }
         if(curDiancha > dianchaMax[i])
         {
            dianchaMax[i] = curDiancha;
            maxTime[i] = TimeLocal();
         }
      }
      for(int i=0; i<ArraySize(symbols); i++)
      {
         printf(symbols[i]+","+minTime[i]+"=>"+dianchaMin[i]+","+maxTime[i]+"=>"+dianchaMax[i]);
      }
      printf("fengeline============================================================");
  }
//+------------------------------------------------------------------+
