﻿using Newtonsoft.Json.Linq;
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
            //decimal rmb1 = decimal.Parse(postdatajson.GetValue("Cash").ToString());
            //decimal note1 = decimal.Parse(postdatajson.GetValue("Note").ToString());
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var flow = db.V_Expense.SingleOrDefault(p => p.ID == id);
                var fowRows = db.V_ExpenseRows.Where(p => p.ID == id && p.WF4RowResult == "Y");
                DAL.WF_Flow3 wf3 = db.WF_Flow3.SingleOrDefault(p => p.FlowID == flow.FID);
                var wf = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);


                var temRow = db.WF_TemRows.SingleOrDefault(p => p.TemID == wf.TemID && p.NextID == 0);
                var node = db.WF_Nodes.SingleOrDefault(p => p.FlowID == wf3.FlowID && p.TemRowID == temRow.RID);
                var emp = db.V_Emps.SingleOrDefault(p => p.EmpID == node.EmpID);

                int vtype = 0;
                string acode_cr = string.Empty;
                string acode_dr = string.Empty;
                if (wf3.RmbType == "票据")
                {
                    acode_cr = "100802";
                    acode_dr = "1011";
                    vtype = 4;
                }
                else
                {
                    acode_cr = "100801";
                    acode_dr = "1010";
                    vtype = 3;
                }
                //-- 生成凭证头ID
                string sql = string.Format("SELECT MAX(CONVERT(BIGINT,ID))+1 FROM {0}.[DBO].[HVOUCHER] WHERE ID NOT LIKE '{1}%'", COMN.MyVars.CWDB, COMN.MyVars.PREFIX_HID);
                string hid = DBHelper.ExecuteScalar(sql).ToString().PadLeft(16, '0');
                //-- 生成凭证号 根据年,月,凭证类型
                sql = string.Format("SELECT	ISNULL((SELECT MAX(VNO)+1 FROM {0}.[DBO].[HVOUCHER] WHERE [year] = {1} AND [month] = {2} AND [vtype] = " + vtype + "),1)", COMN.MyVars.CWDB, DateTime.Now.Year, DateTime.Now.Month);
                string vno = DBHelper.ExecuteScalar(sql).ToString();
                sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[dbo].[ivoucher]", COMN.MyVars.CWDB);
                int vid = int.Parse(DBHelper.ExecuteScalar(sql).ToString());
                #region 添加凭证头
                sql = string.Format(@"INSERT INTO {0}.dbo.hvoucher([id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck],[vexpl],[modifydate],[vcheck0])
                                                   VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}');",
                    new object[]{COMN.MyVars.CWDB
                                    ,hid
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,vtype
                                    ,vno
                                    ,"0"//flow.CompanyID.Substring(0,2)
                                    ,DateTime.Now.ToShortDateString()
                                    ,0
                                    ,wf.Creater
                                    ,"李惠"
                                    ,flow.FName
                                    ,DateTime.Now.ToShortDateString(),emp.EmpName});
                #endregion
                #region 添加凭证行
                //                int mark = 0;
                //                int ino = 100;
                //                foreach (var item in fowRows)
                //                {
                //                    var wf4 = db.WF_Flow4.SingleOrDefault(p => p.ID == item.WF4RowID);
                //                    wf4.VoucherRowID = ino;
                //                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                //                     new object[] { COMN.MyVars.CWDB 
                //                                    ,hid
                //                                    ,ino
                //                                    ,DateTime.Now.Year
                //                                    ,DateTime.Now.Month
                //                                    ,vtype
                //                                    ,vno
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,item.Todo
                //                                    ,-1
                //                                    ,acode_cr
                //                                    ,flow.CompanyID
                //                                    ,item.NCode
                //                                    ,item.WF4RowRmb
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,(vid+mark++).ToString().PadLeft(16, '0')
                //                                    ,""});
                //                    ino += 100;
                //                }

                //                sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                //                    new object[] { COMN.MyVars.CWDB 
                //                                    ,hid
                //                                    ,ino
                //                                    ,DateTime.Now.Year
                //                                    ,DateTime.Now.Month
                //                                    ,vtype
                //                                    ,vno
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,flow.FName
                //                                    ,1
                //                                    ,acode_dr
                //                                    ,flow.CompanyID
                //                                    ,""// 借方NCODE 为空 待议
                //                                    ,wf3.Rmb
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,(vid+mark).ToString().PadLeft(16, '0')
                //                                    ,""});
                #endregion



                int result_sql = DBHelper.ExecuteNonQuery(sql);
                //var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                //var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                //db.AddCashVoucher(hid, rmb1, flow.FName, this.UserInfo.UserName, this.UserInfo.UserName, 3, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", flow.CashItem);
                wf3.VoucherID = hid;
                wf3.Rmb1 = 0;
                //Response.Write(hid.Value.ToString() + "||" + vno.Value.ToString() + "<br/>" + hid_v + "||" + vno_v.ToString());

                //添加票据申请凭证
                //                if (flow.Note > 0)
                //                {                 //-- 生成凭证头ID
                //                    string sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[DBO].[HVOUCHER]", COMN.MyVars.CWDB);
                //                    string hid = DBHelper.ExecuteScalar(sql).ToString().PadLeft(16, '0');
                //                    //-- 生成凭证号 根据年,月,凭证类型
                //                    sql = string.Format("SELECT	ISNULL((SELECT MAX(VNO)+1 FROM {0}.[DBO].[HVOUCHER] WHERE [year] = {1} AND [month] = {2} AND [vtype] = 3),1)", COMN.MyVars.CWDB, DateTime.Now.Year, DateTime.Now.Month);
                //                    string vno = DBHelper.ExecuteScalar(sql).ToString();
                //                    sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[dbo].[ivoucher]", COMN.MyVars.CWDB);
                //                    int vid = int.Parse(DBHelper.ExecuteScalar(sql).ToString());
                //                    //--	添加凭证头
                //                    sql = string.Format(@"INSERT INTO {0}.dbo.hvoucher([id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck],[vexpl],[modifydate])
                //                                                   VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}');",
                //                                        new object[]{COMN.MyVars.CWDB
                //                                    ,hid
                //                                    ,DateTime.Now.Year
                //                                    ,DateTime.Now.Month
                //                                    ,4
                //                                    ,vno
                //                                    ,"01"
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,0
                //                                    ,this.UserInfo.UserName
                //                                    ,this.UserInfo.UserName
                //                                    ,flow.FName
                //                                    ,DateTime.Now.ToShortDateString()});

                //                    //--	添加凭证行
                //                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                //                                        new object[] { COMN.MyVars.CWDB 
                //                                    ,hid
                //                                    ,100
                //                                    ,DateTime.Now.Year
                //                                    ,DateTime.Now.Month
                //                                    ,4
                //                                    ,vno
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,flow.FName
                //                                    ,-1
                //                                    ,"100802"
                //                                    ,flow.CompanyID
                //                                    ,wf3.CashItem
                //                                    ,rmb1
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,vid.ToString().PadLeft(16, '0')
                //                                    ,""});
                //                    sql += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                //                        new object[] { COMN.MyVars.CWDB 
                //                                    ,hid
                //                                    ,200
                //                                    ,DateTime.Now.Year
                //                                    ,DateTime.Now.Month
                //                                    ,4
                //                                    ,vno
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,flow.FName
                //                                    ,1
                //                                    ,"1011"
                //                                    ,flow.CompanyID
                //                                    ,wf3.CashItem
                //                                    ,rmb1
                //                                    ,DateTime.Now.ToShortDateString()
                //                                    ,(vid+1).ToString().PadLeft(16, '0')
                //                                    ,""});
                //                    int result_sql = DBHelper.ExecuteNonQuery(sql);
                //                    //var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                //                    //var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                //                    //db.AddCashVoucher(hid, note1, flow.FName, this.UserInfo.UserName, this.UserInfo.UserName, 4, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", flow.CashItem);
                //                    wf3.VoucherID1 = hid;
                //                    wf3.Note1 = note1;
                //                }
                //标记审批状态为已经处理完成
                //var wf = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);
                if (wf != null)
                {
                    wf.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsFinished;
                }
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = "" };
            }
        }
    }
}