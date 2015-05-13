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
            string pStr = context.Request.Params["p"];
            if (string.IsNullOrEmpty(pStr))
            {
                JObject jo = new JObject();
                jo.Add("data", "");
                jo.Add("recordsTotal", 0);
                jo.Add("recordsFiltered", 0);
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
                return;
            }
            else
            {
                JArray pJArr = JArray.Parse(pStr);
                var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");

                int pStart = int.Parse(pageStartJo["value"].ToString());
                int pLength = int.Parse(pageLengthJo["value"].ToString());

                var list = new List<MODEL.CashDraft>();
                //list.Add(new MODEL.CashDraft() { ID = "A", Name =decimal.Parse("12212.223") });
                for (int i = 0; i < 150; i++)
                {
                    list.Add(new MODEL.CashDraft() { ID = "A" + i.ToString(), Name = (i * 1000).ToString("N4")});
                }
                var pageList = list.OrderBy(p => p.ID).Skip(pStart).Take(pLength).ToList();
                JObject jo = new JObject();
                jo.Add("data", JToken.FromObject(pageList));
                //jo.Add("draw", 2);
                jo.Add("recordsTotal", list.Count);
                jo.Add("recordsFiltered", list.Count);




                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
            }
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