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
                int status = int.Parse(string.IsNullOrEmpty(context.Request.Form["status"]) ? "1000" : context.Request.Form["status"]);
                string companycusotmerid = this.UserInfo.CompanyID.Substring(2);
                if (string.IsNullOrEmpty(pStr))
                {
                    JObject jo = new JObject();
                    jo.Add("data", "");
                    jo.Add("recordsTotal", 0);
                    jo.Add("recordsFiltered", 0);
                    return new Tools.JsonResponse() { Code = "9000", Msg = "分页参数错误" };
                }
                else
                {
                    JArray pJArr = JArray.Parse(pStr);
                    var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                    var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                    int pStart = int.Parse(pageStartJo["value"].ToString());
                    int pLength = int.Parse(pageLengthJo["value"].ToString());
                    var searchObj = pJArr.SingleOrDefault(p => p["name"].ToString() == "search");
                    var searchTxt = searchObj["value"]["value"].ToString();
                    JObject jo = new JObject();
                    int pageTotal = 0;
                    //业务逻辑代码↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
                    IQueryable<DAL.V_Expense> tempList;
                    MODEL.UserInfo user = this.UserInfo;
                    if (string.IsNullOrEmpty(searchTxt))
                    {
                        if (user.RoleID == "0199" || user.RoleID == "01" || user.RoleID == "02")
                        {
                            tempList = db.V_Expense.Where(p => p.ApprovalStatus == status);
                        }
                        else
                        {
                            tempList = db.V_Expense.Where(p => p.ApprovalStatus == status && p.CompanyID == user.CompanyID);
                        }

                    }
                    else
                    {
                        if (user.RoleID == "0199" || user.RoleID == "01" || user.RoleID == "02")
                        {
                            tempList = db.V_Expense.Where(p => p.ApprovalStatus == status && (p.CompanyName.IndexOf(searchTxt) >= 0 || p.FName.IndexOf(searchTxt) >= 0));
                        }
                        else
                        {
                            tempList = db.V_Expense.Where(p => p.ApprovalStatus == status && (p.CompanyName.IndexOf(searchTxt) >= 0 || p.FName.IndexOf(searchTxt) >= 0) && p.CompanyID == user.CompanyID);
                        }

                    }

                    if (tempList.Count() > 0)
                    {
                        var pageList = tempList.OrderBy(p => p.FID).Skip(pStart).Take(pLength).ToList();
                        jo.Add("data", JToken.FromObject(pageList));
                    }
                    else
                    {
                        jo.Add("data", string.Empty);
                    }


                    //业务逻辑代码 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                    pageTotal = tempList.Count();
                    jo.Add("recordsTotal", pageTotal);
                    jo.Add("recordsFiltered", pageTotal);
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
            }
        }
        public Tools.JsonResponse Commit()
        {
            string jsonStr = context.Request.Form["formdata"];

            var flowid = Guid.NewGuid();
            var formdata = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.Expense>(jsonStr);
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var companytotem = db.WF_CompanyToTem.SingleOrDefault(p => p.CompanyID == this.UserInfo.CompanyID && p.DocType == "2");
                var curnode = db.WF_TemRows.SingleOrDefault(p => p.PreID == -1 && p.TemID == companytotem.TemID);
                db.WF_Flows.Add(new DAL.WF_Flows()
                {
                    FID = flowid,
                    CreatedDate = DateTime.Now,
                    Creater = this.UserInfo.UserName,
                    CurNode = curnode.RID,
                    IsFinished = COMN.MyVars.No,
                    TemID = companytotem.TemID,
                    Result = COMN.MyVars.Pending,
                    DocType = "2",
                    FName = formdata.Todo,
                    ApprovalStatus = COMN.MyVars.ApprovalStatus_IsStarted
                });
                db.WF_Flow3.Add(new DAL.WF_Flow3()
                {
                    CompanyID = this.UserInfo.CompanyID,
                    ExchangeDate = DateTime.Now,
                    FlowID = flowid,
                    Rmb = formdata.Rmb,
                    RmbType = formdata.RmbType
                });
                foreach (var item in formdata.RList)
                {
                    db.WF_Flow4.Add(new DAL.WF_Flow4()
                    {
                        FlowID = flowid,
                        NCode = COMN.MyFuncs.GetCodeFromStr(item.NCode, '-'),
                        Result = "O",
                        Rmb = item.Rmb,
                        Todo = item.Todo
                    });
                }
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
    }
}