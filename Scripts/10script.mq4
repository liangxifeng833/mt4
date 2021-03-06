//+------------------------------------------------------------------+
//|                                                     10script.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| 发邮件,
//  FTP上传交易报告,获取网页数据,发送信息到android或者iPhone手机
//  请求api接口等等    
//  liangxifeng 2020-08-06                            |
//+------------------------------------------------------------------+
void OnStart()
  {
      //发送邮件,使用该函数需要在工具->选项->电邮中配置发送和收件信息
      //配置完成后，执行该函数即可发送邮件。
      //SendMail("测试邮件标题","测试文件内容");
      
      
      //FTP上传文件到远程服务器,需要现在工具->选项->FTP中配置
      //然后使用SendFTP()函数上传指定文件test.txt到FTP根目录下，NULL代表根
      //SendFTP("test.txt",NULL);
      
      //将test文本发送到手机中,需要配置 具->选项->通知
      //SendNotification("孙立娜你在干什么？");
      
      //请求api接口
      char post[];
      char result[];
      string headers = "";
      //请求服务器函数,执行前需要先选择->工具->选项->EA交易，勾选允许WebRequest请求的URL,并把需要请求的url配置进去
      int res = WebRequest("GET","http://www.baidu.com",NULL,NULL,3000,post,0,result,headers  ); 
      if (res == -1) 
      {
         Alert("网址不存在或者打不开");
         Print("Error in WebRequest. Error code  =",GetLastError()); 
      }
      else 
      {
         Alert("网页内容为："+CharArrayToString(result,0,WHOLE_ARRAY,CP_ACP) );
      }
   
  }
//+------------------------------------------------------------------+
