using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// CashItem 的摘要说明
    /// </summary>
    public class CashItem : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["p"];
                int status = int.Parse(string.IsNullOrEmpty(context.Request.Form["status"]) ? "1000" : context.Request.Form["status"]);
                JArray pJArr = JArray.Parse(pStr);
                var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                int pStart = int.Parse(pageStartJo["value"].ToString());
                int pLength = int.Parse(pageLengthJo["value"].ToString());

                var searchObj = pJArr.SingleOrDefault(p => p["name"].ToString() == "search");
                var searchTxt = searchObj["value"]["value"].ToString();
                JObject jo = new JObject();
                int pageTotal = 0;
                MODEL.UserInfo user = this.UserInfo;
                //业务逻辑代码↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
                IQueryable<DAL.V_CashItem> tempList;
                if (string.IsNullOrEmpty(searchTxt))
                {
                    //权限控制 0199 为资金池李慧 01 和02 为副总
                    if (user.RoleID == "0199" || user.RoleID == "01" || user.RoleID == "02")
                    {
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status);
                    }
                    else
                    {
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status && p.Hdw == user.CompanyID);
                    }
                }
                else
                {
                    //权限控制 0199 为资金池李慧 01 和02 为副总
                    if (user.RoleID == "0199" || user.RoleID == "01" || user.RoleID == "02")
                    {
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status && p.CNAME.IndexOf(searchTxt) >= 0 && p.Hdw == user.CompanyID);
                    }
                    else
                    {
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status && p.CNAME.IndexOf(searchTxt) >= 0 && p.Hdw == user.CompanyID);
                    }
                }
                if (tempList.Count() > 0)
                {
                    var pageList = tempList.OrderBy(p => p.Cash).Skip(pStart).Take(pLength).ToList();
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

        public Tools.JsonResponse GetNcodeList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["p"];
                //string companyid = context.Request.Form["CompanyID"];
                //string companycusotmerid = companyid.Substring(2);
                if (string.IsNullOrEmpty(pStr))
                {
                    JObject jo = new JObject();
                    jo.Add("data", "");
                    jo.Add("recordsTotal", 0);
                    jo.Add("recordsFiltered", 0);
                    return new Tools.JsonResponse() { Code = "0", Msg = "", Data = jo };
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
                    IQueryable<DAL.V_Ncode> tempList;
                    if (string.IsNullOrEmpty(searchTxt))
                    {
                        tempList = db.V_Ncode;
                    }
                    else
                    {
                        tempList = db.V_Ncode.Where(p =>
                            p.ncode.IndexOf(searchTxt) >= 0
                         || p.nname.IndexOf(searchTxt) >= 0);
                    }
                    var pageList = tempList.OrderBy(p => p.ncode).Skip(pStart).Take(pLength).ToList();
                    //业务逻辑代码 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                    pageTotal = tempList.Count();
                    jo.Add("data", JToken.FromObject(pageList));
                    jo.Add("recordsTotal", pageTotal);
                    jo.Add("recordsFiltered", pageTotal);
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                    ////分页集合 p.ncode).Skip(pStart).Take(pLength).ToList();
                    ////总条数
                    //var pageList = db.V_Ncode.OrderBy(p =>
                    //int pageTotal = db.V_Ncode.Count();
                    //JObject jo = new JObject();
                    //jo.Add("data", JToken.FromObject(pageList));
                    //jo.Add("recordsTotal", pageTotal);
                    //jo.Add("recordsFiltered", pageTotal);
                    //return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
            }
        }
        public Tools.JsonResponse FormCommit()
        {
            string str = this.GetParam("postdata");
            var cashItem = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.CashItem>(str);

            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {

                //WF2 数据更新
                var wf2 = db.WF_Flow2.SingleOrDefault(p => p.ID == cashItem.ID);
                var wf = db.WF_Flows.SingleOrDefault(p => p.FID == wf2.FlowID);
                //标记审批状态为已经处理完成
                if (wf != null)
                {
                    wf.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsFinished;
                }
                wf2.Cash1 = cashItem.Cash;
                wf2.Note1 = cashItem.Note;
                //wf2.NCodeC = cashItem.NCodeC;
                //wf2.NCodeN = cashItem.NCodeN;
                wf2.IsFinished = "Y";
                //TODO 插入数据到CASH 
                //var cid = db.ACash.Max(p => p.CID) + 1;
                var list = db.WF_Flow1.Where(p => p.CashID == wf2.CashID);
                decimal? total1 = cashItem.Cash + cashItem.Note;
                decimal? total2 = list.Where(p => p.Result == "Y").Sum(p => p.Rmb);
                if (total1 != total2)
                {
                    return new Tools.JsonResponse()
                    {
                        Code = "9100",
                        Msg = "总金额与合同总额不相等",
                        Data = string.Format("合同总金额{0}", total2)
                    };
                }
                //添加现汇申请凭证
                if (cashItem.Cash > 0)
                {
                    string hid_v = string.Empty;
                    var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                    var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                    db.AddCashVoucher(hid, cashItem.Cash, "自动生成付合同款", this.UserInfo.UserName, this.UserInfo.UserName, 3, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", wf2.NCodeC);
                    wf2.CashVoucherID = hid.Value.ToString();
                    //Response.Write(hid.Value.ToString() + "||" + vno.Value.ToString() + "<br/>" + hid_v + "||" + vno_v.ToString());
                }
                //添加票据申请凭证
                if (cashItem.Note > 0)
                {
                    string hid_v = string.Empty;
                    var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                    var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                    db.AddCashVoucher(hid, cashItem.Note, "自动生成付合同款", this.UserInfo.UserName, this.UserInfo.UserName, 4, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", wf2.NCodeN);
                    wf2.NoteVoucherID = hid.Value.ToString();
                }
                //TODO 插入数据到CASH 
                //db.ACash.Add(new DAL.ACash()
                //    {
                //        CID = cid,
                //        ExchangeDate = DateTime.Now,
                //        Cash = wf2.Cash1,
                //        Note = wf2.Note1,
                //        VoucherFlag = false,
                //        Ccode = wf2.Ccode,
                //        HDW = this.UserInfo.CompanyID,
                //        Type = "付款"
                //    });
                //TODO 插入数据到AFKXX
                //foreach (var item in list)
                //{
                //    if (item.Result == "Y")
                //    {
                //        db.AFKXX.Add(new DAL.AFKXX()
                //        {
                //            rmb = item.Rmb,
                //            xshth = item.XSHcode,
                //            CID = cid,
                //            date = DateTime.Now,
                //            hth = item.HCode,
                //            type = "付款",
                //            fkfs = "",
                //            fklx = ""
                //        });
                //    }
                //}
                //保存
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
    }
}