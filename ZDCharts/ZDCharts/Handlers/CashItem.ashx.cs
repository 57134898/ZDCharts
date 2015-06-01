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
                //string companyid = context.Request.Form["CompanyID"];
                //string companycusotmerid = companyid.Substring(2);
                if (string.IsNullOrEmpty(pStr))
                {
                    JObject jo = new JObject();
                    jo.Add("data", "");
                    jo.Add("recordsTotal", 0);
                    jo.Add("recordsFiltered", 0);
                    //context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
                    return new Tools.JsonResponse() { Code = "0", Msg = "", Data = jo };
                }
                else
                {
                    JArray pJArr = JArray.Parse(pStr);
                    var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                    var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                    int pStart = int.Parse(pageStartJo["value"].ToString());
                    int pLength = int.Parse(pageLengthJo["value"].ToString());
                    var pageList = db.V_CashItem.Where(p => p.Result == "Y" && p.IsFinished == "N").OrderBy(p => p.Cash).Skip(pStart).Take(pLength).ToList();
                    JObject jo = new JObject();
                    jo.Add("data", JToken.FromObject(pageList));
                    int pageTotal = db.V_CashItem.Where(p => p.Result == "Y" && p.IsFinished == "N").Count();
                    jo.Add("recordsTotal", pageTotal);
                    jo.Add("recordsFiltered", pageTotal);
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
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
                    //context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
                    return new Tools.JsonResponse() { Code = "0", Msg = "", Data = jo };
                }
                else
                {
                    JArray pJArr = JArray.Parse(pStr);
                    var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                    var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                    int pStart = int.Parse(pageStartJo["value"].ToString());
                    int pLength = int.Parse(pageLengthJo["value"].ToString());
                    //分页集合
                    var pageList = db.V_Ncode.OrderBy(p => p.ncode).Skip(pStart).Take(pLength).ToList();
                    //总条数
                    int pageTotal = db.V_Ncode.Count();
                    JObject jo = new JObject();
                    jo.Add("data", JToken.FromObject(pageList));
                    jo.Add("recordsTotal", pageTotal);
                    jo.Add("recordsFiltered", pageTotal);
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
            }
        }
        public Tools.JsonResponse FormCommit()
        {
            var userinfo = this.GetUserInfo();
            if (userinfo == null)
                return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
            string str = context.Request.Params["postdata"];
            var cashItem = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.CashItem>(str);
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //WF2 数据更新
                var wf2 = db.WF_Flow2.SingleOrDefault(p => p.ID == cashItem.ID);
                wf2.Cash1 = cashItem.Cash;
                wf2.Note1 = cashItem.Note;
                //wf2.NCodeC = cashItem.NCodeC;
                //wf2.NCodeN = cashItem.NCodeN;
                wf2.IsFinished = "Y";
                //插入数据到CASH
                var cid = db.ACash.Max(p => p.CID) + 1;
                var list = db.WF_Flow1.Where(p => p.CashID == wf2.CashID);
                db.ACash.Add(new DAL.ACash()
                    {
                        CID = cid,
                        ExchangeDate = DateTime.Now,
                        Cash = wf2.Cash1,
                        Note = wf2.Note1,
                        VoucherFlag = false,
                        Ccode = wf2.Ccode,
                        HDW = userinfo.CompanyID,
                        Type = "付款"
                    });
                //插入数据到AFKXX
                foreach (var item in list)
                {
                    db.AFKXX.Add(new DAL.AFKXX()
                    {
                        rmb = item.Rmb,
                        xshth = item.XSHcode,
                        CID = cid,
                        date = DateTime.Now,
                        hth = item.HCode,
                        type = "付款",
                        fkfs = "",
                        fklx = ""
                    });
                }


                // TODO 插入数据到资金池
                //.........



                //保存
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
    }
}