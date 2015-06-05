using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Expense 的摘要说明
    /// </summary>
    public class Expense : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["p"];
                object oUser = context.Session["user"];
                if (oUser == null)
                    return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
                MODEL.UserInfo user = (MODEL.UserInfo)oUser;
                string companyid = user.CompanyID;
                string companycusotmerid = companyid.Substring(2);
                if (string.IsNullOrEmpty(pStr) || string.IsNullOrEmpty(companyid))
                {
                    JObject jo = new JObject();
                    jo.Add("data", "");
                    jo.Add("recordsTotal", 0);
                    jo.Add("recordsFiltered", 0);
                    context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
                    return new Tools.JsonResponse() { Code = "9000", Msg = "分页参数错误" };
                }
                else
                {
                    JArray pJArr = JArray.Parse(pStr);
                    var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                    var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                    int pStart = int.Parse(pageStartJo["value"].ToString());
                    int pLength = int.Parse(pageLengthJo["value"].ToString());
                    var pageList = db.V_Expense.OrderBy(p => p.FID).Skip(pStart).Take(pLength).ToList();
                    JObject jo = new JObject();
                    jo.Add("data", JToken.FromObject(pageList));
                    int pageTotal = db.V_Expense.Count();
                    jo.Add("recordsTotal", pageTotal);
                    jo.Add("recordsFiltered", pageTotal);
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
            }
        }
        public Tools.JsonResponse Commit()
        {
            string jsonStr = context.Request.Form["formdata"];
            if (jsonStr == null || jsonStr == "")
                return new Tools.JsonResponse() { Code = "9000", Msg = "pendingdata不能为空" };
            object oUser = context.Session["user"];
            if (oUser == null)
                return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
            MODEL.UserInfo user = (MODEL.UserInfo)oUser;
            var flowid = Guid.NewGuid();
            var formdata = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.Expense>(jsonStr);
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var companytotem = db.WF_CompanyToTem.SingleOrDefault(p => p.CompanyID == user.CompanyID && p.DocType == "2");
                var curnode = db.WF_TemRows.SingleOrDefault(p => p.PreID == -1 && p.TemID == companytotem.TemID);
                db.WF_Flows.Add(new DAL.WF_Flows()
                {
                    FID = flowid,
                    CreatedDate = DateTime.Now,
                    Creater = user.UserName,
                    CurNode = curnode.RID,
                    IsFinished = COMN.MyVars.No,
                    TemID = companytotem.TemID,
                    Result = COMN.MyVars.Pending,
                    DocType = "2",
                    FName = formdata.Todo
                });
                db.WF_Flow3.Add(new DAL.WF_Flow3()
                {
                    CompanyID = user.CompanyID,
                    ExchangeDate = DateTime.Now,
                    FlowID = flowid,
                    Rmb = formdata.Rmb,
                    CashItem = formdata.NCode,
                    CashType = formdata.CashType
                });
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
    }
}