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