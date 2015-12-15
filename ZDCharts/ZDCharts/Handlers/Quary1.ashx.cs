using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Quary1 的摘要说明
    /// </summary>
    public class Quary1 : Tools.ABSHttpHandler
    {

        public Tools.JsonResponse GetContractCashList()
        {
            string str = this.GetParam("filter");
            JObject jo = JObject.Parse(str);
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var list = db.WF_Nodes
                    .Where(p => p.EmpID == this.UserInfo.UserID)
                    .Join(db.V_CashItem, p => p.FlowID, q => q.FlowID,
                    (p, q) => new
                    {
                        Nodes = p,
                        CashItems = q
                    }).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
            }
        }
    }
}