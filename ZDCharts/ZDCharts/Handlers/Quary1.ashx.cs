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
        public Tools.JsonResponse GetContractCashListByCustomer()
        {
            string str = this.GetParam("filter");
            string companyID = this.GetParam("companyid");
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
                var list = db.WF_Nodes
                                  .Where(p => p.TemRowID == 20 && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                  .Join(db.V_CashItem.Where(p => p.Hdw == companyID)
                                  , p => p.FlowID
                                  , q => q.FlowID,
                                  (p, q) => new
                                  {
                                      Nodes = p,
                                      CashItems = q
                                  })
                                  .GroupBy(p => new { p.CashItems.Ccode, p.CashItems.CNAME })
                                  .Select(p => new
                                  {
                                      CustomerID = p.Key.Ccode,
                                      CustomerName = p.Key.CNAME,
                                      Total = p.Sum(q => q.CashItems.Total)
                                  })
                                  .OrderBy(p => p.CustomerName)
                                  .ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
            }
        }
        public Tools.JsonResponse GetContractCashListByCompany()
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
                                      .Where(p => p.TemRowID == 20 && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                      .Join(db.V_CashItem
                                      , p => p.FlowID
                                      , q => q.FlowID,
                                      (p, q) => new
                                      {
                                          Nodes = p,
                                          CashItems = q
                                      })
                                      .GroupBy(p => new { p.CashItems.CompanyName, p.CashItems.Hdw })
                                      .Select(p => new
                                      {
                                          CompanyID = p.Key.Hdw,
                                          CompanyName = p.Key.CompanyName,
                                          Total = p.Sum(q => q.CashItems.Total)
                                      })
                                      .OrderBy(p => p.CompanyID)
                                      .ToList();

                    if (this.UserInfo.RoleID == "01")
                    {
                        return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
                    }
                    else
                    {
                        return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list.Where(p => p.CompanyID == UserInfo.CompanyID) };
                    }

                }
                else
                {
                    var list = db.WF_Nodes
                                      .Where(p => p.TemRowID == 20 && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                      .Join(db.V_Expense
                                      , p => p.FlowID
                                      , q => q.FID,
                                      (p, q) => new
                                      {
                                          Nodes = p,
                                          Expenses = q
                                      })
                                      .GroupBy(p => new { p.Expenses.CompanyID, p.Expenses.CompanyName })
                                      .Select(p => new
                                      {
                                          CompanyID = p.Key.CompanyID,
                                          CompanyName = p.Key.CompanyName,
                                          Total = p.Sum(q => q.Expenses.Rmb)
                                      })
                                      .OrderBy(p => p.CompanyID)
                                      .ToList();
                    if (this.UserInfo.RoleID == "01")
                    {
                        return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
                    }
                    else
                    {
                        return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list.Where(p => p.CompanyID == UserInfo.CompanyID) };
                    }
                }
            }
        }
        public Tools.JsonResponse GetContractCashList()
        {
            string str = this.GetParam("filter");
            string id = this.GetParam("id");
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
                                      .Where(p => p.TemRowID == 20 && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                      .Join(db.V_CashItem.Where(p => p.Ccode == id)
                                      , p => p.FlowID
                                      , q => q.FlowID,
                                      (p, q) => new
                                      {
                                          Nodes = p,
                                          CashItems = q
                                      })
                                      .Join(db.V_Emps, p => p.Nodes.EmpID, q => q.EmpID,
                                      (p, q) => new
                                      {
                                          Nodes = p.Nodes,
                                          CashItems = p.CashItems,
                                          Emp = q
                                      })
                                      .OrderByDescending(p => p.Nodes.CreatedDate)
                                      .ToList();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
                }
                else
                {
                    var list = db.WF_Nodes
                                      .Where(p => p.TemRowID == 20 && p.Result == result && p.CreatedDate >= date1 && p.CreatedDate <= date2)
                                      .Join(db.V_Expense.Where(p => p.CompanyID == id)
                                      , p => p.FlowID
                                      , q => q.FID,
                                      (p, q) => new
                                      {
                                          Nodes = p,
                                          Expenses = q
                                      })
                                      .Join(db.V_Emps, p => p.Nodes.EmpID, q => q.EmpID,
                                      (p, q) => new
                                      {
                                          Nodes = p.Nodes,
                                          Expenses = p.Expenses,
                                          Emp = q
                                      })
                                      .OrderByDescending(p => p.Nodes.CreatedDate)
                                      .ToList();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
                }
            }
        }
    }
}