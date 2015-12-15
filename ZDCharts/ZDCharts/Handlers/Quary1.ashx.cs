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
            DateTime date1;
            if (jo["date1"] == null || string.IsNullOrEmpty(jo["date1"].ToString()))
            {
                date1 = DateTime.Now.AddDays(-3);
            }
            else
            {
                date1 = DateTime.Parse(jo["date1"].ToString());
            }
            DateTime date2;
            if (jo["date2"] == null || string.IsNullOrEmpty(jo["date2"].ToString()))
            {
                date2 = DateTime.Now;
            }
            else
            {
                date2 = DateTime.Parse(jo["date1"].ToString());
            }
            string ctype = jo["ctype"].ToString();
            string cstatus = jo["cstatus"].ToString();
            string result = string.Empty;
            if (cstatus == "同意")
            {
                result = "Y";
            }
            else
            {
                result = "N";
            }
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                if (ctype == "合同")
                {
                    var list = db.WF_Nodes
                                      .Where(p => p.EmpID == this.UserInfo.UserID && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                      .Join(db.V_CashItem
                                      , p => p.FlowID
                                      , q => q.FlowID,
                                      (p, q) => new
                                      {
                                          Nodes = p,
                                          CashItems = q
                                      })
                                      .OrderByDescending(p => p.Nodes.CreatedDate)
                                      .ToList();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
                }
                else
                {
                    var list = db.WF_Nodes
                                      .Where(p => p.EmpID == this.UserInfo.UserID && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                      .Join(db.V_Expense
                                      , p => p.FlowID
                                      , q => q.FID,
                                      (p, q) => new
                                      {
                                          Nodes = p,
                                          Expenses = q
                                      })
                                      .OrderByDescending(p => p.Nodes.CreatedDate)
                                      .ToList();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
                }
            }
        }
    }
}