using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// WFFlow 的摘要说明
    /// </summary>
    public class WFFlow : Tools.ABSHttpHandler
    {
        public override void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var fList = db.V_Flows.ToList();
                context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(fList));
            }
        }
    }
}