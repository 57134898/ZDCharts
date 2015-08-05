using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Customer 的摘要说明
    /// </summary>
    public class Customer : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetContractListByCompany()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["p"];

                string userjson = context.Request.Form["UserInfo"];
                MODEL.UserInfo userinfo = (MODEL.UserInfo)Newtonsoft.Json.JsonConvert.DeserializeObject(userjson, typeof(MODEL.UserInfo));
                string companyid = userinfo.CompanyID;

                if (string.IsNullOrEmpty(pStr) || string.IsNullOrEmpty(companyid))
                {
                    JObject jo = new JObject();
                    jo.Add("data", "");
                    jo.Add("recordsTotal", 0);
                    jo.Add("recordsFiltered", 0);
                    //context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
                    return new Tools.JsonResponse() { Code = "9000", Msg = "分页参数错误" };
                }
                else
                {
                    JArray pJArr = JArray.Parse(pStr);
                    var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                    var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                    int pStart = int.Parse(pageStartJo["value"].ToString());
                    int pLength = int.Parse(pageLengthJo["value"].ToString());
                    //.Where(p => p.CompanyID == companyid)
                    var pageList = db.V_Flow_GB_Customer.Where(p => p.CompanyID == companyid).OrderByDescending(p => p.CreatedDate).Skip(pStart).Take(pLength).ToList();

                    JObject jo = new JObject();
                    jo.Add("data", JToken.FromObject(pageList));
                    int pageTotal = db.V_Flows.Where(p => p.CompanyID == companyid).Count();
                    jo.Add("recordsTotal", pageTotal);
                    jo.Add("recordsFiltered", pageTotal);
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
            }
        }
        public Tools.JsonResponse GetList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["p"];
                string companyid = this.UserInfo.CompanyID;
                string companycusotmerid = companyid.Substring(2);
                JArray pJArr = JArray.Parse(pStr);
                var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                int pStart = int.Parse(pageStartJo["value"].ToString());
                int pLength = int.Parse(pageLengthJo["value"].ToString());
                var searchObj = pJArr.SingleOrDefault(p => p["name"].ToString() == "search");
                var searchTxt = searchObj["value"]["value"].ToString();
                int pageTotal = 0;
                JObject jo = new JObject();
                //业务逻辑代码↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
                IQueryable<DAL.ACLIENTS> tempList;
                if (string.IsNullOrEmpty(searchTxt))
                {
                    tempList = db.ACLIENTS.Where(p => p.CCODE.StartsWith("02" + companycusotmerid));
                }
                else
                {
                    tempList = db.ACLIENTS.Where(p => p.CCODE.StartsWith("02" + companycusotmerid) && (p.CNAME.IndexOf(searchTxt) >= 0 || p.CCODE.IndexOf(searchTxt) >= 0));
                }
                if (tempList.Count() > 0)
                {
                    var pageList = tempList.OrderBy(p => p.CCODE).Skip(pStart).Take(pLength).ToList();
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

        public Tools.JsonResponse GetContractByCustomer()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["CustomerID"];
                //&& p.Category == "0301" 为方便测试用需要去掉  Take(10) 也要去掉
                var list = db.V_UnfinishedContracts.Where(p => p.NonRmb != 0 && p.CustomerID == pStr).ToList();

                foreach (var item in list)
                {
                    var xslist = db.AWX.Where(p => p.WXHTH == item.HCODE).ToList();
                    if (xslist != null)
                    {
                        item.XSHCODE = Newtonsoft.Json.JsonConvert.SerializeObject(xslist.Select(p => p.XSHTH)).ToString();

                    }
                }
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
            }
        }

        public Tools.JsonResponse DoPay()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string jsonstr = context.Request.Form["PayInfo"];
                string jsonstr1 = context.Request.Form["UserInfo"];
                MODEL.PayInfo payinfo = (MODEL.PayInfo)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonstr, typeof(MODEL.PayInfo));
                MODEL.UserInfo userinfo = this.UserInfo;//(MODEL.UserInfo)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonstr1, typeof(MODEL.UserInfo));
                var cashid = Guid.NewGuid();
                var flowid = Guid.NewGuid();
                var companytotem = db.WF_CompanyToTem.SingleOrDefault(p => p.CompanyID == userinfo.CompanyID && p.DocType == "1");
                var curnode = db.WF_TemRows.SingleOrDefault(p => p.PreID == -1 && p.TemID == companytotem.TemID);
                db.WF_Flows.Add(new DAL.WF_Flows()
                {
                    FID = flowid,
                    CreatedDate = DateTime.Now,
                    Creater = userinfo.UserName,
                    CurNode = curnode.RID,
                    IsFinished = COMN.MyVars.No,
                    TemID = companytotem.TemID,
                    Result = COMN.MyVars.Pending,
                    DocType = "1",
                    ApprovalStatus = COMN.MyVars.ApprovalStatus_IsStarted
                });

                db.WF_Flow2.Add(new DAL.WF_Flow2()
                {
                    CashID = cashid,
                    Ccode = payinfo.CustomerID,
                    Cash = payinfo.Rmb,
                    Note = payinfo.Note,
                    ExchangeDate = DateTime.Parse(payinfo.PayDate),
                    Hdw = userinfo.CompanyID,
                    FlowID = flowid,
                    NCodeC = payinfo.NCodeC,
                    NCodeN = payinfo.NCodeN,
                    IsFinished = "N"
                });
                foreach (var item in payinfo.List)
                {
                    db.WF_Flow1.Add(new DAL.WF_Flow1()
                    {
                        FlowID = flowid,
                        CashID = cashid,
                        HCode = item.HCODE,
                        Rmb = item.CurRmb,
                        XSHcode = item.XSHCODE,
                        Result = COMN.MyVars.Pending
                    });
                }
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };

            }
        }
    }
}