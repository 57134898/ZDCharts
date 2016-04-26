using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using COMN;

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
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status && p.Hdw.StartsWith("0" + user.AccountBook));
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
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status && p.CNAME.IndexOf(searchTxt) >= 0 && p.Hdw.StartsWith("0" + user.AccountBook));
                    }
                    else
                    {
                        tempList = db.V_CashItem.Where(p => p.ApprovalStatus == status && p.CNAME.IndexOf(searchTxt) >= 0 && p.Hdw == user.CompanyID);
                    }
                }
                if (tempList.Count() > 0)
                {
                    //var pageList = tempList.OrderBy(p => p.Cash).Skip(pStart).Take(pLength).ToList();
                    //jo.Add("data", JToken.FromObject(pageList));
                    var jOrder = pJArr.SingleOrDefault(p => p["name"].ToString() == "order");
                    var keySelector = int.Parse(jOrder["value"][0]["column"].ToString());
                    var cols = pJArr.SingleOrDefault(p => p["name"].ToString() == "columns");
                    var proName = cols["value"][keySelector]["data"].ToString();
                    var pageList = tempList.OrderByPropertName(proName, jOrder["value"][0]["dir"].ToString() == "asc").Skip(pStart).Take(pLength);
                    jo.Add("data", JToken.FromObject(pageList.ToList()));
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
        /// <summary>
        /// 合同资金项目
        /// </summary>
        /// <returns></returns>
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
                        //tempList = db.V_Ncode.Where(p => p.ncode.IndexOf("0201") >= 0 || p.ncode.IndexOf("0202") >= 0);
                    }
                    else
                    {
                        tempList = db.V_Ncode.Where(p => p.ncode.IndexOf(searchTxt) >= 0 || p.nname.IndexOf(searchTxt) >= 0);
                        //tempList = db.V_Ncode.Where(p => p.ncode.IndexOf("0201") >= 0 || p.ncode.IndexOf("0202") >= 0).Where(p =>
                        //    p.ncode.IndexOf(searchTxt) >= 0
                        // || p.nname.IndexOf(searchTxt) >= 0);
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
        /// <summary>
        /// 费用资金项目
        /// </summary>
        /// <returns></returns>
        public Tools.JsonResponse GetNcodeList1()
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
                        tempList = db.V_Ncode.Where(p => p.ncode.IndexOf(searchTxt) >= 0 || p.nname.IndexOf(searchTxt) >= 0);
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
            try
            {
                string str = this.GetParam("postdata");
                var cashItem = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.CashItem>(str);

                using (DAL.ContractEntities db = new DAL.ContractEntities())
                {

                    //WF2 数据更新
                    var vcash = db.V_CashItem.SingleOrDefault(p => p.ID == cashItem.ID);

                    var wf2 = db.WF_Flow2.SingleOrDefault(p => p.FlowID == vcash.FlowID);
                    var wf = db.WF_Flows.SingleOrDefault(p => p.FID == wf2.FlowID);
                    //标记审批状态为已经处理完成
                    if (wf != null)
                    {
                        wf.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsFinished;
                    }

                    var temRow = db.WF_TemRows.SingleOrDefault(p => p.TemID == wf.TemID && p.NextID == 0);
                    var node = db.WF_Nodes.SingleOrDefault(p => p.FlowID == wf2.FlowID && p.TemRowID == temRow.RID);
                    var emp = db.V_Emps.SingleOrDefault(p => p.EmpID == node.EmpID);

                    wf2.Cash1 = cashItem.Cash;
                    wf2.Note1 = cashItem.Note;
                    wf2.MinusNote1 = cashItem.MNote;
                    wf2.IsFinished = "Y";
                    var list = db.WF_Flow1.Where(p => p.CashID == wf2.CashID);
                    decimal? total1 = cashItem.Cash + cashItem.Note - cashItem.MNote;
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
                    #region 添加凭证

                    //添加现汇申请凭证
                    if (cashItem.Cash > 0)
                    {
                        //-- 生成凭证头ID
                        string sql = string.Format("SELECT MAX(CONVERT(BIGINT,ID))+1 FROM {0}.[DBO].[HVOUCHER] WHERE ID NOT LIKE '{1}%'", COMN.MyVars.CWDB, COMN.MyVars.PREFIX_HID);
                        string hid = DBHelper.ExecuteScalar(sql).ToString().PadLeft(16, '0');
                        //-- 生成凭证号 根据年,月,凭证类型
                        sql = string.Format("SELECT	ISNULL((SELECT MAX(VNO)+1 FROM {0}.[DBO].[HVOUCHER] WHERE [year] = {1} AND [month] = {2} AND [vtype] = 3),1)", COMN.MyVars.CWDB, DateTime.Now.Year, DateTime.Now.Month);
                        string vno = DBHelper.ExecuteScalar(sql).ToString();
                        sql = string.Format("SELECT MAX(ID)+1 FROM {0}.[dbo].[ivoucher]", COMN.MyVars.CWDB);
                        int vid = int.Parse(DBHelper.ExecuteScalar(sql).ToString());
                        //--	添加凭证头
                        string sql_cash = string.Format(@"INSERT INTO {0}.dbo.hvoucher([id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck],[vexpl],[modifydate],[vcheck0])
                                                   VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}');",
                                                new object[]{COMN.MyVars.CWDB
                                    ,hid
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,3
                                    ,vno
                                    ,wf2.Hdw.Substring(0,2)
                                    ,DateTime.Now.ToShortDateString()
                                    ,0
                                    ,wf.Creater
                                    ,"李惠"
                                    ,"["+vcash.CompanyName+"]付["+vcash.CNAME+"]货款"
                                    ,DateTime.Now.ToShortDateString(),emp.EmpName});
                        #region 添加凭证行
                        //                        sql_cash += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                        //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                        //                                                new object[] { COMN.MyVars.CWDB 
                        //                                    ,hid
                        //                                    ,100
                        //                                    ,DateTime.Now.Year
                        //                                    ,DateTime.Now.Month
                        //                                    ,3
                        //                                    ,vno
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,"付["+vcash.CNAME+"]货款"
                        //                                    ,-1
                        //                                    ,"100801"
                        //                                    ,wf2.Hdw
                        //                                    ,wf2.NCodeC
                        //                                    ,cashItem.Cash
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,vid.ToString().PadLeft(16, '0')
                        //                                    ,""});
                        //                        sql_cash += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                        //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                        //                                new object[] { COMN.MyVars.CWDB 
                        //                                    ,hid
                        //                                    ,200
                        //                                    ,DateTime.Now.Year
                        //                                    ,DateTime.Now.Month
                        //                                    ,3
                        //                                    ,vno
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,"付["+vcash.CNAME+"]货款"
                        //                                    ,1
                        //                                    ,"1010"
                        //                                    ,wf2.Hdw
                        //                                    ,wf2.NCodeC
                        //                                    ,cashItem.Cash
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,(vid+1).ToString().PadLeft(16, '0')
                        //                                    ,""});
                        #endregion
                        int result_sql = DBHelper.ExecuteNonQuery(sql_cash);
                        wf2.CashVoucherID = hid;

                    }
                    //退现金凭证
                    else
                    {
                        //暂时不用做
                    }
                    ////添加票据申请凭证
                    if (cashItem.Note > 0)
                    {
                        //-- 生成凭证头ID
                        string sql_1 = string.Format("SELECT MAX(CONVERT(BIGINT,ID))+1 FROM {0}.[DBO].[HVOUCHER] WHERE ID NOT LIKE '{1}%'", COMN.MyVars.CWDB, COMN.MyVars.PREFIX_HID);
                        string hid_1 = DBHelper.ExecuteScalar(sql_1).ToString().PadLeft(16, '0');
                        //-- 生成凭证号 根据年,月,凭证类型
                        sql_1 = string.Format("SELECT	ISNULL((SELECT MAX(VNO)+1 FROM {0}.[DBO].[HVOUCHER] WHERE [year] = {1} AND [month] = {2} AND [vtype] = 4),1)", COMN.MyVars.CWDB, DateTime.Now.Year, DateTime.Now.Month);
                        string vno_1 = DBHelper.ExecuteScalar(sql_1).ToString();
                        sql_1 = string.Format("SELECT MAX(ID)+1 FROM {0}.[dbo].[ivoucher]", COMN.MyVars.CWDB);
                        int vid_1 = int.Parse(DBHelper.ExecuteScalar(sql_1).ToString());
                        //--	添加凭证头
                        string sql_2 = string.Format(@"INSERT INTO {0}.dbo.hvoucher([id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck],[vexpl],[modifydate],[vcheck0])
                                                   VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}');",
                                                new object[]{COMN.MyVars.CWDB
                                    ,hid_1
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,4
                                    ,vno_1
                                    ,wf2.Hdw.Substring(0,2)
                                    ,DateTime.Now.ToShortDateString()
                                    ,0
                                    ,wf.Creater
                                     ,"李惠"
                                    ,"付["+vcash.CNAME+"]货款"
                                    ,DateTime.Now.ToShortDateString(),emp.EmpName});
                        #region 添加凭证行
                        //                        sql_2 += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                        //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                        //                                            new object[] { COMN.MyVars.CWDB 
                        //                                    ,hid_1
                        //                                    ,100
                        //                                    ,DateTime.Now.Year
                        //                                    ,DateTime.Now.Month
                        //                                    ,4
                        //                                    ,vno_1
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,"付["+vcash.CNAME+"]货款"
                        //                                    ,-1
                        //                                    ,"100802"
                        //                                    ,wf2.Hdw
                        //                                    ,wf2.NCodeC
                        //                                    ,cashItem.Note
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,vid_1.ToString().PadLeft(16, '0')
                        //                                    ,""});
                        //                        sql_2 += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                        //                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                        //                            new object[] { COMN.MyVars.CWDB 
                        //                                    ,hid_1
                        //                                    ,200
                        //                                    ,DateTime.Now.Year
                        //                                    ,DateTime.Now.Month
                        //                                    ,4
                        //                                    ,vno_1
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,"付["+vcash.CNAME+"]货款"
                        //                                    ,1
                        //                                    ,"1011"
                        //                                    ,wf2.Hdw
                        //                                    ,wf2.NCodeC
                        //                                    ,cashItem.Note
                        //                                    ,DateTime.Now.ToShortDateString()
                        //                                    ,(vid_1+1).ToString().PadLeft(16, '0')
                        //                                    ,""});
                        #endregion
                        int result_sql = DBHelper.ExecuteNonQuery(sql_2);
                        wf2.NoteVoucherID = hid_1;
                    }

                    #endregion

                    #region 添加合同付款信息
                    //退款金额
                    decimal mRmb = decimal.Zero;
                    //退款合同对象
                    var mh1 = list.FirstOrDefault();
                    if (cashItem.Cash < 0)
                    {
                        mRmb += (cashItem.Cash * -1);
                        string _sql1 = string.Empty;
                        _sql1 = "INSERT INTO ACash (ExchangeDate, Cash, Note,VoucherFlag,Ccode,Type,Mz,hdw) VALUES (";
                        _sql1 += "'" + DateTime.Now.ToShortDateString() + "',";
                        _sql1 += "'" + cashItem.Cash + "',";
                        _sql1 += "'0',";
                        _sql1 += "'0',";
                        _sql1 += "'" + wf2.Ccode + "',";
                        _sql1 += "'付款',";
                        _sql1 += "'0'";
                        _sql1 += ",'" + wf2.Hdw + "') ";
                        string _cid = DBHelper.ExecuteScalar(_sql1).ToString();
                        wf2.CID1 = _cid;
                        string _sql2 = string.Empty;
                        _sql2 += " INSERT INTO AFKXX ([rmb], [hth], [xshth], [type],Cid,date) VALUES(";
                        _sql2 += "'" + cashItem.Cash + "',";
                        _sql2 += "'" + mh1.HCode + "',";
                        _sql2 += "'" + mh1.XSHcode + "',";
                        _sql2 += "'付款',";
                        _sql2 += _cid + ",'" + DateTime.Now.ToShortDateString() + "') ";
                        DBHelper.ExecuteNonQuery(_sql2);
                    }
                    if (cashItem.MNote != 0)
                    {
                        mRmb += (cashItem.MNote);
                        string __sql1 = string.Empty;
                        __sql1 = "INSERT INTO ACash (ExchangeDate, Cash, Note,VoucherFlag,Ccode,Type,Mz,hdw) VALUES (";
                        __sql1 += "'" + DateTime.Now.ToShortDateString() + "',";
                        __sql1 += "'0',";
                        __sql1 += "'" + (cashItem.MNote * -1) + "',";
                        __sql1 += "'0',";
                        __sql1 += "'" + wf2.Ccode + "',";
                        __sql1 += "'付款',";
                        __sql1 += "'0'";
                        __sql1 += ",'" + wf2.Hdw + "') ";
                        string __cid = DBHelper.ExecuteScalar(__sql1).ToString();
                        wf2.CID2 = __cid;
                        string __sql2 = string.Empty;
                        __sql2 += " INSERT INTO AFKXX ([rmb], [hth], [xshth], [type],Cid,date) VALUES(";
                        __sql2 += "'" + (cashItem.MNote * -1) + "',";
                        __sql2 += "'" + mh1.HCode + "',";
                        __sql2 += "'" + mh1.XSHcode + "',";
                        __sql2 += "'付款',";
                        __sql2 += __cid + ",'" + DateTime.Now.ToShortDateString() + "') ";
                        DBHelper.ExecuteNonQuery(__sql2);
                    }
                    string sql1 = string.Empty;
                    sql1 = "INSERT INTO ACash (ExchangeDate, Cash, Note,VoucherFlag,Ccode,Type,Mz,hdw) VALUES (";
                    sql1 += "'" + DateTime.Now.ToShortDateString() + "',";
                    if (cashItem.Cash <= 0)
                    {
                        sql1 += "'0',";
                    }
                    else
                    {
                        sql1 += "'" + cashItem.Cash + "',";
                    }

                    sql1 += "'" + cashItem.Note + "',";
                    sql1 += "'0',";
                    sql1 += "'" + wf2.Ccode + "',";
                    sql1 += "'付款',";
                    sql1 += "'0'";
                    sql1 += ",'" + wf2.Hdw + "') ";
                    string cid = DBHelper.ExecuteScalar(sql1).ToString();
                    wf2.CID = cid;
                    string sql2 = string.Empty;
                    foreach (var item in list)
                    {
                        if (item.Result == "Y")
                        {
                            if (item.HCode == mh1.HCode)
                            {
                                if ((item.Rmb + mRmb) == 0)
                                {
                                    continue;
                                }
                                sql2 += " INSERT INTO AFKXX ([rmb], [hth], [xshth], [type],Cid,date) VALUES(";
                                sql2 += "'" + (item.Rmb + mRmb).ToString() + "',";
                            }
                            else
                            {
                                if (item.Rmb == 0)
                                {
                                    continue;
                                }
                                sql2 += " INSERT INTO AFKXX ([rmb], [hth], [xshth], [type],Cid,date) VALUES(";
                                sql2 += "'" + item.Rmb + "',";
                            }

                            sql2 += "'" + item.HCode + "',";
                            sql2 += "'" + item.XSHcode + "',";
                            sql2 += "'付款',";
                            sql2 += cid + ",'" + DateTime.Now.ToShortDateString() + "') ";
                        }
                    }
                    DBHelper.ExecuteNonQuery(sql2);

                    #endregion

                    //保存
                    int result = db.SaveChanges();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = "" };
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}