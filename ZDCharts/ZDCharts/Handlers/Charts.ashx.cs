using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Charts 的摘要说明
    /// </summary>
    public class Charts : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetData1()
        {
            List<string> list1 = new List<string>();
            List<decimal?> list2 = new List<decimal?>();
            List<decimal?> list3 = new List<decimal?>();
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var list = db.V_Chart1.ToList();
                foreach (var item in list)
                {
                    list1.Add(item.bname);
                    list2.Add(item.cash);
                    list3.Add(item.note);
                }
            }
            JObject jo = new JObject();
            jo.Add("list1", JArray.FromObject(list1));
            jo.Add("list2", JArray.FromObject(list2));
            jo.Add("list3", JArray.FromObject(list3));
            //Array arr = new Array[] { list1, list2, list3 };
            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };

        }
    }
}