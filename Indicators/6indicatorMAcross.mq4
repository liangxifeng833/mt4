//+------------------------------------------------------------------+
//|                                            6indicatorMAcross.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//该指标划在主图上，（上边K线是主图，下边图是辅图（macd的图））
//指标就是将给定数组的值填充完就可以了
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot da
/*
#property indicator_label1  "da"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
*/
//--- plot xiao
#property indicator_label2  "xiao"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrYellow
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot up
#property indicator_label3  "up"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrWhite
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot down
#property indicator_label4  "down"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrAqua
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- input parameters
input int      大周期=20;
input int      小周期=10;
//--- indicator buffers
double         daBuffer[];
double         xiaoBuffer[];
double         upBuffer[];
double         downBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,daBuffer);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1,clrRed);
   SetIndexLabel(0,"da");
   SetIndexBuffer(1,xiaoBuffer);
   SetIndexBuffer(2,upBuffer);
   SetIndexBuffer(3,downBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
  SetIndexArrow(2,225);
  SetIndexArrow(3,226);
  //设置K线序列倒叙从下标0开始，默认也是该设置
  //ArraySetAsSeries(xiaoBuffer,true);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//价格跳动一次，该函数执行一次
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
/*
   daBuffer[0] = Low[0];
   daBuffer[1] = Low[1];
   daBuffer[2] = Low[2];
   daBuffer[3] = Low[3];
   daBuffer[4] = Low[4];
   daBuffer[5] = Low[5];*/
   //等待周期够的时候划划线
   if(rates_total<大周期 || rates_total<小周期)
    {
      return(0);
    }
   
   int limit;
   //limit=rates_total-prev_calculated+1;
   limit=rates_total-prev_calculated;
   if(prev_calculated > 0) limit++;
   int i = 0;
   for(i=0; i<limit; i++)
   {
      /*
      if(i%10!=0)
      {
         daBuffer[i] = Low[i];
      }*/
      //画均线
      daBuffer[i] = iMA(NULL,0,大周期,0,MODE_SMA,PRICE_CLOSE,i);
      xiaoBuffer[i] = iMA(NULL,0,小周期,0,MODE_SMA,PRICE_CLOSE,i);
    }
      //画箭头
    for(i=0;i<limit;i++)
    {
      //金叉
      if(xiaoBuffer[i]>daBuffer[i] && xiaoBuffer[i+1]<daBuffer[i+1])
       {
         upBuffer[i]=daBuffer[i]-30*Point;
       }
      //死叉
      if(xiaoBuffer[i]<daBuffer[i] && xiaoBuffer[i+1]>daBuffer[i+1])
       {
         downBuffer[i]=daBuffer[i]+30*Point;
       }
      }
   return(rates_total);
  }
//+------------------------------------------------------------------+
