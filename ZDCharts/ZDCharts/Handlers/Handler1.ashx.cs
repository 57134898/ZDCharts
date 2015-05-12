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
            var list = new List<MODEL.CashDraft>();
            for (int i = 0; i < 1500; i++)
            {
                list.Add(new MODEL.CashDraft() { ID = "A" + i.ToString(), Name = "JACK" + i.ToString() });
            }
            JObject jo = new JObject();
            jo.Add("data", JToken.FromObject(list));
            jo.Add("draw", 6);
            jo.Add("recordsTotal", 1500);
            jo.Add("recordsFiltered", 1500);
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
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