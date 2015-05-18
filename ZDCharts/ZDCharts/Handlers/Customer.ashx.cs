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
        public Tools.JsonResponse GetList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Params["p"];
                if (string.IsNullOrEmpty(pStr))
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
                    var pageList = db.ACLIENTS.OrderBy(p => p.CCODE).Skip(pStart).Take(pLength).ToList();
                    JObject jo = new JObject();
                    jo.Add("data", JToken.FromObject(pageList));
                    jo.Add("recordsTotal", db.ACLIENTS.Count());
                    jo.Add("recordsFiltered", db.ACLIENTS.Count());
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
                }
            }
        }

        public Tools.JsonResponse GetContractByCustomer()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //string pStr = context.Request.Form["customerid"];
                //&& p.Category == "0301" 为方便测试用需要去掉  Take(10) 也要去掉
                var list = db.V_UnfinishedContracts.Where(p => p.NonRmb != 0 && p.Category == "0301").Take(10).ToList();

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
                MODEL.PayInfo payinfo = (MODEL.PayInfo)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonstr, typeof(MODEL.PayInfo));


                var list = db.V_UnfinishedContracts.Where(p => p.NonRmb != 0).Take(10).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };

            }
        }
    }
}