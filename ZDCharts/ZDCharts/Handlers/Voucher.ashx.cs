using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Voucher 的摘要说明
    /// </summary>
    public class Voucher : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse AddExpenseVoucher()
        {

            string str = this.GetParam("postdata");
            JObject postdatajson = JObject.Parse(str);
            int id = int.Parse(postdatajson.GetValue("ID").ToString());
            decimal rmb1 = decimal.Parse(postdatajson.GetValue("Cash").ToString());
            decimal note1 = decimal.Parse(postdatajson.GetValue("Note").ToString());
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var flow = db.V_Expense.SingleOrDefault(p => p.ID == id);
                DAL.WF_Flow3 wf3 = db.WF_Flow3.SingleOrDefault(p => p.FlowID == flow.FID);
                //TODO 生成凭证到资金池

                //添加现汇申请凭证
                if (flow.Rmb > 0)
                {
                    //-- 生成凭证头ID
                    string sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[DBO].[HVOUCHER]", COMN.MyVars.CWDB);
                    string hid = DBHelper.ExecuteScalar(sql).ToString().PadLeft(16, '0');
                    //-- 生成凭证号 根据年,月,凭证类型
                    sql = string.Format("SELECT	ISNULL((SELECT MAX(VNO)+1 FROM {0}.[DBO].[HVOUCHER] WHERE [year] = {1} AND [month] = {2} AND [vtype] = 3),1)", COMN.MyVars.CWDB, DateTime.Now.Year, DateTime.Now.Month);
                    string vno = DBHelper.ExecuteScalar(sql).ToString();
                    sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[dbo].[ivoucher]", COMN.MyVars.CWDB);
                    int vid = int.Parse(DBHelper.ExecuteScalar(sql).ToString());
                    //--	添加凭证头
                    sql = string.Format(@"INSERT INTO {0}.dbo.hvoucher([id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck],[vexpl],[modifydate])
                                                   VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}');",
                                        new object[]{COMN.MyVars.CWDB
                                    ,hid
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,3
                                    ,vno
                                    ,"01"
                                    ,DateTime.Now.ToShortDateString()
                                    ,0
                                    ,this.UserInfo.UserName
                                    ,this.UserInfo.UserName
                                    ,flow.FName
                                    ,DateTime.Now.ToShortDateString()});

                    //--	添加凭证行
                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                                        new object[] { COMN.MyVars.CWDB 
                                    ,hid
                                    ,100
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,3
                                    ,vno
                                    ,DateTime.Now.ToShortDateString()
                                    ,flow.FName
                                    ,-1
                                    ,"100801"
                                    ,flow.CompanyID
                                    ,wf3.CashItem
                                    ,rmb1
                                    ,DateTime.Now.ToShortDateString()
                                    ,vid.ToString().PadLeft(16, '0')
                                    ,""});
                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                        new object[] { COMN.MyVars.CWDB 
                                    ,hid
                                    ,200
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,3
                                    ,vno
                                    ,DateTime.Now.ToShortDateString()
                                    ,flow.FName
                                    ,1
                                    ,"1010"
                                    ,flow.CompanyID
                                    ,wf3.CashItem
                                    ,rmb1
                                    ,DateTime.Now.ToShortDateString()
                                    ,(vid+1).ToString().PadLeft(16, '0')
                                    ,""});
                    int result_sql = DBHelper.ExecuteNonQuery(sql);
                    //var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                    //var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                    //db.AddCashVoucher(hid, rmb1, flow.FName, this.UserInfo.UserName, this.UserInfo.UserName, 3, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", flow.CashItem);
                    wf3.VoucherID = hid;
                    wf3.Rmb1 = rmb1;
                    //Response.Write(hid.Value.ToString() + "||" + vno.Value.ToString() + "<br/>" + hid_v + "||" + vno_v.ToString());
                }
                //添加票据申请凭证
                if (flow.Note > 0)
                {                 //-- 生成凭证头ID
                    string sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[DBO].[HVOUCHER]", COMN.MyVars.CWDB);
                    string hid = DBHelper.ExecuteScalar(sql).ToString().PadLeft(16, '0');
                    //-- 生成凭证号 根据年,月,凭证类型
                    sql = string.Format("SELECT	ISNULL((SELECT MAX(VNO)+1 FROM {0}.[DBO].[HVOUCHER] WHERE [year] = {1} AND [month] = {2} AND [vtype] = 3),1)", COMN.MyVars.CWDB, DateTime.Now.Year, DateTime.Now.Month);
                    string vno = DBHelper.ExecuteScalar(sql).ToString();
                    sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[dbo].[ivoucher]", COMN.MyVars.CWDB);
                    int vid = int.Parse(DBHelper.ExecuteScalar(sql).ToString());
                    //--	添加凭证头
                    sql = string.Format(@"INSERT INTO {0}.dbo.hvoucher([id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck],[vexpl],[modifydate])
                                                   VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}');",
                                        new object[]{COMN.MyVars.CWDB
                                    ,hid
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,4
                                    ,vno
                                    ,"01"
                                    ,DateTime.Now.ToShortDateString()
                                    ,0
                                    ,this.UserInfo.UserName
                                    ,this.UserInfo.UserName
                                    ,flow.FName
                                    ,DateTime.Now.ToShortDateString()});

                    //--	添加凭证行
                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                                        new object[] { COMN.MyVars.CWDB 
                                    ,hid
                                    ,100
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,4
                                    ,vno
                                    ,DateTime.Now.ToShortDateString()
                                    ,flow.FName
                                    ,-1
                                    ,"100802"
                                    ,flow.CompanyID
                                    ,wf3.CashItem
                                    ,rmb1
                                    ,DateTime.Now.ToShortDateString()
                                    ,vid.ToString().PadLeft(16, '0')
                                    ,""});
                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                        new object[] { COMN.MyVars.CWDB 
                                    ,hid
                                    ,200
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,4
                                    ,vno
                                    ,DateTime.Now.ToShortDateString()
                                    ,flow.FName
                                    ,1
                                    ,"1011"
                                    ,flow.CompanyID
                                    ,wf3.CashItem
                                    ,rmb1
                                    ,DateTime.Now.ToShortDateString()
                                    ,(vid+1).ToString().PadLeft(16, '0')
                                    ,""});
                    int result_sql = DBHelper.ExecuteNonQuery(sql);
                    //var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                    //var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                    //db.AddCashVoucher(hid, note1, flow.FName, this.UserInfo.UserName, this.UserInfo.UserName, 4, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", flow.CashItem);
                    wf3.VoucherID1 = hid;
                    wf3.Note1 = note1;
                }
                //标记审批状态为已经处理完成
                var wf = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);
                if (wf != null)
                {
                    wf.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsFinished;
                }
                //todo  正式需要打开
                //int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = "" };
            }
        }
    }
}