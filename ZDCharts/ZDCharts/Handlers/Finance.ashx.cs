using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Finance 的摘要说明
    /// </summary>
    public class Finance : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetBalanceBy1221()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string companyid = GetParam("companyid");
                string sql = string.Format("EXEC [dbo].[GetBalance] @YEAR = {0}, @MONTH = {1} ,@BCODE = N'{2}'", DateTime.Now.Year, DateTime.Now.Month, companyid);
                System.Data.DataTable dt = DBHelper.ExecuteDataTable(sql);
                decimal rmb = 0;
                decimal note = 0;
                decimal total = 0;
                foreach (System.Data.DataRow r in dt.Rows)
                {
                    if (r[1].ToString() == "122101")
                    {
                        rmb = decimal.Parse(r[3].ToString());
                    }
                    if (r[1].ToString() == "122102")
                    {
                        note = decimal.Parse(r[3].ToString());
                    }
                }
                //TODO 现金与票据数需要减去 资金系统里的数 取数为 未生成凭证的数，包括已申请 与审批中 与 审批通过数 明天写
                //**************************************
                //**************************************
                //**************************************
                //**************************************
                //**************************************
                //**************************************
                //未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完
                total = rmb + note;
                JObject jo = new JObject();
                jo.Add("rmb", rmb);
                jo.Add("note", note);
                jo.Add("total", total);
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo.ToString() };
            }
        }
    }
}