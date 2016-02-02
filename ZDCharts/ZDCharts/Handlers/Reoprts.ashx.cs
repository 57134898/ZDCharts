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
 , DateTime.Now.Month == 1 ? DateTime.Now.Year - 1 : DateTime.Now.Year
 , DateTime.Now.Month == 1 ? 12 : DateTime.Now.Month - 1);
            System.Data.DataTable dt = DBHelper.ExecuteDataTable(sql);
            List<MODEL.Bal> listBal = new List<MODEL.Bal>();
            foreach (System.Data.DataRow r in dt.Rows)
            {
                listBal.Add(new MODEL.Bal()
                {
                    acode = r["acode"].ToString(),
                    aname = r["aname"].ToString(),
                    bcode = r["bcode"].ToString(),
                    bname = r["bname"].ToString(),
                    balrmb = decimal.Parse(r["balrmb"].ToString())
                });
            }

            var newlist = listBal
                   .GroupBy(p => new { p.bcode, p.bname })
                   .Select(p => new { bcode = p.Key.bcode, bname = p.Key.bname, total = p.Sum(q => q.balrmb) }).ToList();
            JArray jArr = new JArray();
            foreach (var item in newlist)
            {
                JObject jo = new JObject();
                jo.Add("bcode", item.bcode);
                jo.Add("bname", item.bcode);
                jo.Add("total", item.total.ToString("N"));
                jo.Add("cash", listBal.SingleOrDefault(p => p.bcode == item.bcode && p.acode == "122101").balrmb.ToString("N"));
                jo.Add("note", listBal.SingleOrDefault(p => p.bcode == item.bcode && p.acode == "122102").balrmb.ToString("N"));
                jArr.Add(jo);
            }
            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jArr };
        }
    }
}