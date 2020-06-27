#property copyright "瞬间的光辉QQ:215607364"
#property link      "http://www.zhinengjiaoyi.com"
extern datetime 挂单本地电脑时间=0;
extern int 挂单价距离当时现价点数=200;
extern int 挂单有效分钟数=10;
extern double 挂单下单量=0.1;
extern int 挂单止损点数=200;
extern int 挂单止盈点数=200;
extern int 挂单成交后移动止损点数=200;
extern int magic=405215;
datetime dangshi=0;
int sells=0;
int buys=0;
int init()
  {
   DrawLabel("will1","智能交易网www.zhinengjiaoyi.com,瞬间的光辉QQ：215607364",2,13,"宋体",9,Aqua,0);
   dangshi=TimeLocal();
   return(0);
  }
int deinit()
  {
   return(0);
  }
int start()
  {
    if(挂单成交后移动止损点数>0)
     {
       yidong();
     }
    if(挂单本地电脑时间==0)
      {
         while(sells==0 || buys==0)
          {
             if(sellstop(挂单下单量,挂单止损点数,挂单止盈点数,Symbol()+"sell",Bid-挂单价距离当时现价点数*Point,magic,TimeLocal()+挂单有效分钟数*60)>0)
               {
                  sells=1;
               }
             if(buystop(挂单下单量,挂单止损点数,挂单止盈点数,Symbol()+"buy",Bid+挂单价距离当时现价点数*Point,magic,TimeLocal()+挂单有效分钟数*60)>0)
               {
                  buys=1;
               }
              Sleep(1000);
          }
      }
    else
      {
        if(挂单本地电脑时间<=dangshi)
          {
            Alert("这个挂单时间已经过了还怎么挂单");
          }
        else
          {
             if(挂单本地电脑时间<=TimeLocal())
               {
                 while(sells==0 || buys==0)
                  {
                     if(sellstop(挂单下单量,挂单止损点数,挂单止盈点数,Symbol()+"sell",Bid-挂单价距离当时现价点数*Point,magic,TimeLocal()+挂单有效分钟数*60)>0)
                       {
                          sells=1;
                       }
                     if(buystop(挂单下单量,挂单止损点数,挂单止盈点数,Symbol()+"buy",Bid+挂单价距离当时现价点数*Point,magic,TimeLocal()+挂单有效分钟数*60)>0)
                       {
                          buys=1;
                       }
                      Sleep(1000);
                  }
               }
          }
      }
   return(0);
  }
void yidong()
  {
    for(int i=0;i<OrdersTotal();i++)//移动止损通用代码,次代码会自动检测buy和sell单并对其移动止损
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
                if(OrderType()==0 && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                  {
                     if((Bid-OrderOpenPrice()) >=Point*挂单成交后移动止损点数)
                      {
                         if(OrderStopLoss()<(Bid-Point*挂单成交后移动止损点数) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*挂单成交后移动止损点数,0,0,Green);
                           }
                      }      
                  }
                if(OrderType()==1 && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                  {
                    if((OrderOpenPrice()-Ask)>=(Point*挂单成交后移动止损点数))
                      {
                         if((OrderStopLoss()>(Ask+Point*挂单成交后移动止损点数)) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*挂单成交后移动止损点数,0,0,Red);
                           }
                      }
                  }
               }
         }
  }
void DrawLabel(string name,string text,int X,int Y,string FontName,int FontSize,color FontColor,int zhongxin)
{
   if(ObjectFind(name)!=0)
   {
    ObjectDelete(name);
    ObjectCreate(name,OBJ_LABEL,0,0,0);
      ObjectSet(name,OBJPROP_CORNER,zhongxin);
      ObjectSet(name,OBJPROP_XDISTANCE,X);
      ObjectSet(name,OBJPROP_YDISTANCE,Y);
    }  
   ObjectSetText(name,text,FontSize,FontName,FontColor);
   WindowRedraw();
}
int buystop(double Lots,double sun,double ying,string comment,double price,int magic,datetime shijian)
  {
    int kaidanok=0;
    int kaiguan=0;
    int ticket=0;
      for(int i=0;i<OrdersTotal();i++)
         {
             if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                 if((OrderComment()==comment) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)  
                   {
                     kaiguan=1;                     
                   } 
                }
         }
      if(kaiguan==0)
        {
          if((sun!=0)&&(ying!=0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,price-sun*Point,price+ying*Point,comment,magic,shijian,White);
            }
          if((sun==0)&&(ying!=0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,0,price+ying*Point,comment,magic,shijian,White);
            }
           if((sun!=0)&&(ying==0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,price-sun*Point,0,comment,magic,shijian,White);
            }
           if((sun==0)&&(ying==0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,0,0,comment,magic,shijian,White);
            }
            kaidanok=ticket;
        }
      return(kaidanok);  
  }
int sellstop(double Lots,double sun,double ying,string comment,double price,int magic,datetime shijian)
    {
    int kaidanok=0;
    int kaiguan=0;
    int ticket=0;
      for(int i=0;i<OrdersTotal();i++)
         {
             if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                 if((OrderComment()==comment) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)    
                   {
                     kaiguan=1;                     
                   } 
                }
         }
      if(kaiguan==0)
        {
           if((sun!=0)&&(ying!=0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,price+sun*Point,price-ying*Point,comment,magic,shijian,Red);
             }
           if((sun==0)&&(ying!=0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,0,price-ying*Point,comment,magic,shijian,Red);
             }
           if((sun!=0)&&(ying==0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,price+sun*Point,0,comment,magic,shijian,Red);
             }
           if((sun==0)&&(ying==0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,0,0,comment,magic,shijian,Red);
             }
           kaidanok=ticket;
        }
      return(kaidanok);  
   }