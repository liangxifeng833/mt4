#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
/**
* 在界面上添加按钮输入框等控件并执行代码
**/
int OnInit()
  {
   anniu("closeall",Red,15,15,"平所有货币市价单");
   anniu("delgua",Red,15,35,"删除所有货币挂单");
   anniu("closeallben",Red,15,55,"平本货币市价单");
   anniu("delguaben",Red,15,75,"删除本货币挂单");
   
   biaoqian("3","请输入一个止盈价格:",15,100,11,White);
   shurukuang("tp",Black,160,95);
   anniu("tpm",Red,220,95,"把所有本货币对多单止盈改为这个价格");
   //shurukuang("nihao",Black,15,35);
   //biaoqian("3","你好dsamg",15,55,10,White);
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {

  }
void OnTick()
  {

  }
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
      //按下按钮触发事件
      if(id==CHARTEVENT_OBJECT_CLICK) 
       {
         if(sparam=="closeall")
          {
            //Alert("平仓按钮按下");
            closeall();
          }
         if(sparam=="delgua")
          {
            delgua();
          } 
         if(sparam=="closeallben")
          {
            //Alert("平仓按钮按下");
            closeallben();
          }
         if(sparam=="delguaben")
          {
            //删除本货币对所有挂单
            delguaben();
          } 
         /**
         * 点击 所有本货币对多单止盈改为这个价格 按钮
         * 获取输入框 tp 的值
         * 将修改本货币对所有多单止盈价格 修改为 输入框的值
         **/
         if(sparam=="tpm") 
          {
            //获取输入框 tp 的值
            string tp=ObjectGetString(0,"tp",OBJPROP_TEXT);
            //将所有多单的止盈价格 修改为 输入框的值
            modify(StringToDouble(tp));
            //Alert("输入框的文字为:"+tp);
          } 
          ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
       }
  }
/**
* 修改本货币对所有多单止盈
**/
void modify(double tp)
  {
       int t=OrdersTotal();
       for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderSymbol()==Symbol())
                {
                  double p=MarketInfo(OrderSymbol(),MODE_POINT);
                  if(OrderType()==0) //多单
                    {
                      OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tp,Green);
                    }
                }
             }
         }
  }
   
/**
* 删除本货币挂单
**/
void delguaben()
  {
       int t=OrdersTotal();
       for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderType()>1 && OrderSymbol()==Symbol())
                 {
                   OrderDelete(OrderTicket());
                 }
             }
         }
  }
  
/**
* 平本货币市价单  
**/
void closeallben()
  {
       int t=OrdersTotal();
       for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderType()<=1 && OrderSymbol()==Symbol())
                 {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green);
                 }
             }
         }
  }
/**
* 删除所有货币对的挂单
**/  
void delgua()
  {
       int t=OrdersTotal();
       for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderType()>1)
                 {
                   OrderDelete(OrderTicket());
                 }
             }
         }
  }
   
/**
* 平仓所有货币对市价单
**/
void closeall()
  {
       int t=OrdersTotal();
       for(int i=t-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
             {
               if(OrderType()<=1)
                 {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Green);
                 }
             }
         }
  }
/**
* 划标签
* name=标签名字
* neirong = 文字内容
* x,y
* daxxiao = 尺寸
* yanse= 颜色
**/
void biaoqian(string name,string neirong,int x,int y,int daxiao,color yanse)
  {
    if(ObjectFind(name)<0)
     {
        ObjectCreate(name,OBJ_LABEL,0,0,0);
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        ObjectSet(name,OBJPROP_XDISTANCE,x);
        ObjectSet(name,OBJPROP_YDISTANCE,y);
        ObjectSet(name,OBJPROP_CORNER,0);
     }
    else
     {
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        WindowRedraw();
     }
  }
  
/**
* 划按钮函数
* name = 按钮名字
* yanse = 颜色
* x=坐标x (相对窗口左上角)
* y=坐标y (相对窗口左上角)
* text = 按钮上面的文字
* chagndu = 按钮长度
**/
void anniu(string name,color yanse,int x,int y,string text,int changdu=0)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,yanse);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrDarkGray);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   if(changdu==0)
    {
      int as=StringLen(text);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,as*17);
    }
   else
    {
      ObjectSetInteger(0,name,OBJPROP_XSIZE,changdu);
    }
   ObjectSetInteger(0,name,OBJPROP_YSIZE,20);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrBlue);
   //ObjectSetInteger(0,name,OBJPROP_CORNER,0);
  }
/**
* 划输入框
* name=名字
* yanse=输入框内字体颜色
* x,y 坐标
**/
void shurukuang(string name,color yanse,int x,int y)
  {
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
//--- set object size
   ObjectSetInteger(0,name,OBJPROP_XSIZE,60);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,20);

   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
//--- set the type of text alignment in the object
   ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_LEFT);
//--- enable (true) or cancel (false) read-only mode
   ObjectSetInteger(0,name,OBJPROP_READONLY,false);
//--- set the chart's corner, relative to which object coordinates are defined
   //ObjectSetInteger(0,name,OBJPROP_CORNER,0);
//--- set text color
   ObjectSetInteger(0,name,OBJPROP_COLOR,yanse);
   //--- set background color
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrAliceBlue);
//--- set border color
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrBlue);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetString(0,name,OBJPROP_TEXT,"");
  }