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
                if (companyid == "company")
                {
                    companyid = this.UserInfo.CompanyID;
                }
                string sql = string.Format("EXEC [dbo].[GetBalance] @YEAR = {0}, @MONTH = {1} ,@BCODE = N'{2}'", DateTime.Now.Year, DateTime.Now.Month, companyid);
                System.Data.DataTable dt = DBHelper.ExecuteDataTable(sql);
                var bal = db.V_Balance
                    .Where(p => p.Company == companyid)
                    .GroupBy(p => new { p.Company, p.状态 })
                    .Select(p => new { Company = p.Key.Company, state = p.Key.状态, Rmb = p.Sum(m => m.Rmb), Note = p.Sum(m => m.Note), Total = p.Sum(m => m.Total) }).ToList();
                decimal? rmb = 0;
                decimal? note = 0;
                decimal? total = 0;
                decimal? rmb1 = 0;
                decimal? note1 = 0;
                decimal? total1 = 0;
                decimal? rmb2 = 0;
                decimal? note2 = 0;
                decimal? total2 = 0;
                decimal? rmb3 = 0;
                decimal? note3 = 0;
                decimal? total3 = 0;
                decimal? rmb4 = 0;
                decimal? note4 = 0;
                decimal? total4 = 0;
                foreach (var item in bal)
                {
                    if (item.state == "已审批")
                    {
                        rmb1 = item.Rmb;
                        note1 = item.Note;
                        total1 = item.Total;
                    }
                    if (item.state == "未审批")
                    {
                        rmb2 = item.Rmb;
                        note2 = item.Note;
                        total2 = item.Total;
                    }
                    if (item.state == "已生成凭证")
                    {
                        rmb3 = item.Rmb;
                        note3 = item.Note;
                        total3 = item.Total;
                    }
                }
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
                total = rmb + note;
                rmb4 = rmb - rmb1 - rmb2 - rmb3;
                note4 = note - note1 - note2 - note3;
                total4 = total - total1 - total2 - total3;
                //TODO 现金与票据数需要减去 资金系统里的数 取数为 未生成凭证的数，包括已申请 与审批中 与 审批通过数 明天写
                //**************************************
                //**************************************
                //**************************************
                //**************************************
                //**************************************
                //**************************************
                //未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完未完

                JObject jo = new JObject();
                jo.Add("rmb", rmb);
                jo.Add("note", note);
                jo.Add("total", total);

                jo.Add("rmb1", rmb1);
                jo.Add("note1", note1);
                jo.Add("total1", total1);

                jo.Add("rmb2", rmb2);
                jo.Add("note2", note2);
                jo.Add("total2", total2);

                jo.Add("rmb3", rmb3);
                jo.Add("note3", note3);
                jo.Add("total3", total3);

                jo.Add("rmb4", rmb4);
                jo.Add("note4", note4);
                jo.Add("total4", total4);
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo.ToString() };
            }
        }
    }
}