#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
/**
* 当价格到达指定价格发消息到手机
* autohr:liangxifeng
* date:2020-09-25
**/
extern double myBid = 1; //买价
extern double myAsk = 1; //卖价
int i = 0;
enum symbol
{
   大于等于=1,
   小于等于=2,
};
extern symbol 符号;

int OnInit()
  {
   Print("选择的符号="+符号);
   //SendNotification("当前货币对："+Symbol()+",价格达到了指定值,myBid="+myBid+",myAsk="+myAsk);
   EventSetTimer(5); //2秒执行一次
   return(INIT_SUCCEEDED);
  }

void OnTimer()
{
      int send = 0;

      if(符号 == 1) // >=
      {
         if(Bid >= myBid || Ask >= myBid)
          {
            send = 1;
            i++;
            printf("价格达到指定值,myBid="+myBid+",myAsk="+myAsk+",次数="+i);
          }      
      }
      if(符号 == 2) // <=
      {
         if(Bid <= myAsk || Ask <= myAsk)
         {
            send = 1;
            i++;
            printf("价格达到指定值,myBid="+myBid+",myAsk="+myAsk+",次数="+i);
         }
      }
      if(send == 1 && i<3 ) //只发送三次
      {
         SendNotification("当前货币对："+Symbol()+",价格达到了指定值,myBid="+myBid+",myAsk="+myAsk);
      } 
        
}

void OnDeinit(const int reason)
  {

   
  }

void OnTick()
  {

  }

