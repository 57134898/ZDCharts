using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Finance 的摘要说明
    /// </summary>
    public class Finance : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetBalanceBy1221()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                JObject jo = new JObject();
                jo.Add("rmb", 150.12);
                jo.Add("note", 10);
                jo.Add("total", 160.12);
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo.ToString() };
            }
        }
    }
}