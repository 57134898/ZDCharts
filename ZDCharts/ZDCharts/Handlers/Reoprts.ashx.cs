using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Reoprts 的摘要说明
    /// </summary>
    public class Reoprts : Tools.ABSHttpHandler
    {

        public Tools.JsonResponse GetData1()
        {
            string sql = string.Format(@"
DECLARE @MYEAR INT
DECLARE @MMONTH INT
DECLARE @BCODE VARCHAR(10)
SET @MYEAR={1}
SET @MMONTH={2}
SELECT I.BCODE bcode,REPLACE(REPLACE(REPLACE(B.BNAME, '沈阳铸锻工业有限公司', ''), '分公司', ''),'（原模型公司）','') bname,
SUBSTRING(I.ACODE,1,6) acode,A.aname,
SUM((I.VDC+1)/2*RMB-(1-I.VDC)/2*RMB) balrmb 
FROM {0}.dbo.IVOUCHER I INNER JOIN {0}.dbo.ACODE A ON SUBSTRING(I.ACODE,1,6)=A.ACODE INNER JOIN {0}.dbo.BCODE B ON I.BCODE=B.BCODE
WHERE YEAR=@MYEAR AND MONTH <=@MMONTH AND I.ACODE LIKE '1221%' AND SUBSTRING(I.ACODE,1,6)<122104 AND B.BCODE<0130
GROUP BY I.BCODE,B.BNAME,SUBSTRING(I.ACODE,1,6),A.ANAME
", COMN.MyVars.CWDB
 , DateTime.Now.Year
 , DateTime.Now.Month);
            System.Data.DataTable dt = DBHelper.ExecuteDataTable(sql);
            List<string> list_company = new List<string>();
            JArray list1 = new JArray();
            JArray list2 = new JArray();
            JArray list3 = new JArray();
            List<MODEL.Bal> listBal = new List<MODEL.Bal>();
            foreach (System.Data.DataRow r in dt.Rows)
            {
                if (this.UserInfo.RoleID == "01")
                {
                    listBal.Add(new MODEL.Bal()
                    {
                        acode = r["acode"].ToString(),
                        aname = r["aname"].ToString(),
                        bcode = r["bcode"].ToString(),
                        bname = r["bname"].ToString(),
                        balrmb = Math.Round(decimal.Parse(r["balrmb"].ToString()) * (-1) / 10000, 2)
                    });
                }
                else
                {
                    if (r["bcode"].ToString() == this.UserInfo.CompanyID)
                    {
                        listBal.Add(new MODEL.Bal()
                        {
                            acode = r["acode"].ToString(),
                            aname = r["aname"].ToString(),
                            bcode = r["bcode"].ToString(),
                            bname = r["bname"].ToString(),
                            balrmb = Math.Round(decimal.Parse(r["balrmb"].ToString()) * (-1) / 10000, 2)
                        });
                    }
                }
            }

            var newlist = listBal
                   .GroupBy(p => new { p.bcode, p.bname })
                   .Select(p => new { bcode = p.Key.bcode, bname = p.Key.bname, total = p.Sum(q => q.balrmb) }).ToList();
            JArray jArr = new JArray();
            if (UserInfo.RoleID == "01")
            {
                JObject jo_sum = new JObject();
                jo_sum.Add("bcode", string.Empty);
                jo_sum.Add("bname", "合计");
                jo_sum.Add("total", newlist.Sum(p => p.total).ToString("N"));
                jo_sum.Add("cash", listBal.Where(p => p.acode == "122101").Sum(p => p.balrmb).ToString("N"));
                jo_sum.Add("note", listBal.Where(p => p.acode == "122102").Sum(p => p.balrmb).ToString("N"));
                jArr.Add(jo_sum);
            }
            foreach (var item in newlist)
            {

                JObject jo = new JObject();
                jo.Add("bcode", item.bcode);
                jo.Add("bname", item.bname);
                jo.Add("total", item.total.ToString("N"));
                var cash = listBal.SingleOrDefault(p => p.bcode == item.bcode && p.acode == "122101").balrmb;
                var note = listBal.SingleOrDefault(p => p.bcode == item.bcode && p.acode == "122102").balrmb;
                jo.Add("cash", cash.ToString("N"));
                jo.Add("note", note.ToString("N"));
                jArr.Add(jo);
                if (item.bcode != "0101")
                {
                    list_company.Add(item.bname);
                    list1.Add(item.total);
                    list2.Add(cash);
                    list3.Add(note);
                }
            }
            JObject data1 = new JObject();
            data1.Add("list1", list1);
            data1.Add("list2", list2);
            data1.Add("list3", list3);
            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jArr, Data0 = list_company, Data1 = data1 };
        }
    }
}