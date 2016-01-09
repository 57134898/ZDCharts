using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Charts 的摘要说明
    /// </summary>
    public class Charts : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetData1()
        {
            string syear = GetParam("year");
            string smonth = GetParam("month");
            int year = int.Parse(syear);
            List<string> list1 = new List<string>();
            List<decimal?> list2 = new List<decimal?>();
            List<decimal?> list3 = new List<decimal?>();
            List<decimal?> list4 = new List<decimal?>();
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                if (smonth == "全部")
                {
                    var list = db.V_Chart1.Where(p => p.myear == year).ToList();
                    foreach (var item in list)
                    {
                        list1.Add(item.bname);
                        list2.Add(item.cash);
                        list3.Add(item.note);
                        list4.Add(item.total);
                    }
                }
                else
                {
                    int month = int.Parse(smonth);
                    var list = db.V_Chart1.Where(p => p.myear == year && p.mmonth == month).ToList();
                    foreach (var item in list)
                    {
                        list1.Add(item.bname);
                        list2.Add(item.cash);
                        list3.Add(item.note);
                        list4.Add(item.total);
                    }
                }

            }
            JObject jo = new JObject();
            jo.Add("list1", JArray.FromObject(list1));
            jo.Add("list2", JArray.FromObject(list2));
            jo.Add("list3", JArray.FromObject(list3));
            jo.Add("list4", JArray.FromObject(list4));
            //Array arr = new Array[] { list1, list2, list3 };
            if (this.UserInfo.RoleID == "01")
            {
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
            }
            else
            {
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = string.Empty };
            }
        }
        public Tools.JsonResponse GetData2()
        {
            string syear = GetParam("year");
            int year = int.Parse(syear);
            string smonth = GetParam("month");
            string company = GetParam("company");
            JArray jArr1 = new JArray();
            JArray jArr2 = new JArray();
            JArray jArr3 = new JArray();
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {

                foreach (var item in db.V_Chart2
                    .Where(delegate(DAL.V_Chart2 p)
                        {
                            if (smonth == "全部")
                            {
                                if (company == "全部")
                                {
                                    if (p.myear == year)
                                        return true;
                                }
                                else
                                {
                                    company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                                    if (p.myear == year && p.companyid == company)
                                        return true;
                                }
                            }
                            else
                            {
                                int month = int.Parse(smonth);
                                if (company == "全部")
                                {
                                    if (p.myear == year && p.mmonth == month)
                                        return true;
                                }
                                else
                                {
                                    company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                                    if (p.myear == year && p.companyid == company && p.mmonth == month)
                                        return true;
                                }
                            }
                            return false;
                        }
                        )
                    .GroupBy(p => new { p.rmbtype })
                    .Select(p => new { RmbType = p.Key.rmbtype, Total = p.Sum(q => q.wf3rmb) })
                    .ToList())
                {
                    jArr1.Add(item.RmbType);
                    JObject jo = new JObject();
                    jo.Add("value", item.Total);
                    jo.Add("name", item.RmbType);
                    jArr2.Add(jo);
                }
                foreach (var item in db.V_Chart2.Where(delegate(DAL.V_Chart2 p)
                {
                    if (smonth == "全部")
                    {
                        if (company == "全部")
                        {
                            if (p.myear == year)
                                return true;
                        }
                        else
                        {
                            company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                            if (p.myear == year && p.companyid == company)
                                return true;
                        }
                    }
                    else
                    {
                        int month = int.Parse(smonth);
                        if (company == "全部")
                        {
                            if (p.myear == year && p.mmonth == month)
                                return true;
                        }
                        else
                        {
                            company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                            if (p.myear == year && p.companyid == company && p.mmonth == month)
                                return true;
                        }
                    }
                    return false;
                })
                                      .GroupBy(p => new { p.ncodegroup, p.ncodegroupname })
                                      .Select(p => new { NCodeGroup = p.Key.ncodegroup, NCodeGName = p.Key.ncodegroupname, Total = p.Sum(q => q.wf4rmb) })
                                      .ToList())
                {
                    jArr1.Add(item.NCodeGName);
                    JObject jo = new JObject();
                    jo.Add("value", item.Total);
                    jo.Add("name", item.NCodeGName);
                    jArr3.Add(jo);
                }



                JObject joo = new JObject();
                joo.Add("list1", jArr1);
                joo.Add("list2", jArr2);
                joo.Add("list3", jArr3);
                if (this.UserInfo.RoleID == "01")
                {
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = joo };
                }
                else
                {
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = string.Empty };
                }
            }
        }
    }
}