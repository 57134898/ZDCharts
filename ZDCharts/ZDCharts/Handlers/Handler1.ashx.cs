using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Handler1 的摘要说明
    /// </summary>
    public class Handler1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            Newtonsoft.Json.Linq.JArray jArr = new Newtonsoft.Json.Linq.JArray(new string[] { "老刘", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子" });
            context.Response.Write(jArr.ToString());
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}