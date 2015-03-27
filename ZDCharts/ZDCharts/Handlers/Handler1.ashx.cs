using Newtonsoft.Json.Linq;
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

            JArray jArr = new JArray(new string[] { "老刘", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子" });
            JObject opt = new JObject();
            opt.Add("tooltip", new JObject(new JProperty("show", true)));
            opt.Add("legend", new JObject(new JProperty("data", new JArray("销量lol"))));
            opt.Add("xAxis", new JArray(new JObject(new JProperty("type", "category"), new JProperty("data", jArr))));
            opt.Add("yAxis", new JArray(new JObject(new JProperty("type", "value"))));
            opt.Add("series", new JArray(new JObject(new JProperty("name", "销量"), new JProperty("type", "bar"), new JProperty("data", new JArray(5, 20, 40, 10, 10, 20)))));
            context.Response.Write(opt.ToString());
        }


        //        var option = {
        //    tooltip: {
        //        show: true
        //    },
        //    legend: {
        //        data: ['销量']
        //    },
        //    xAxis: [
        //        {
        //            type: 'category',
        //            data: []
        //        }
        //    ],
        //    yAxis: [
        //        {
        //            type: 'value'
        //        }
        //    ],
        //    series: [
        //        {
        //            "name": "销量",
        //            "type": "bar",
        //            "data": [5, 20, 40, 10, 10, 20]
        //        }
        //    ]
        //};
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}