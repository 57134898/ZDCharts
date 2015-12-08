using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VoucherAction
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.dataGridView1.Rows.Clear();
            this.timer1.Interval = Convert.ToInt16(this.numericUpDown1.Value);
            this.timer1.Start();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.timer1.Stop();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            try
            {
                Console.WriteLine("作业中....");
                string sql = string.Empty;
                sql += @"SELECT [id],[year],[month],[vtype],[vno],[bcode],[vdate],[vappendix],[vprepare],[vcheck0],[vcheck],[vkeeper],[gentype],[vexpl],[modifydate]
                              FROM HVOUCHER WHERE id not in (SELECT distinct hid FROM IVOUCHER ) and year >2014 and vprepare != 'system' and vprepare!= 'Admin'";
                DataTable badvoucherlist = DBHelper1.ExecuteDataTable(sql);
                foreach (DataRow r in badvoucherlist.Rows)
                {
                    string sql1 = string.Format(@"  SELECT * FROM [WF_Flow2]  WHERE CashVoucherID = '{0}' OR NoteVoucherID='{0}'", r["id"].ToString());
                    DataTable flow2list = DBHelper.ExecuteDataTable(sql1);
                    foreach (DataRow r1 in flow2list.Rows)
                    {
                        //合同现汇凭证
                        if (r["id"].ToString() == r1["CashVoucherID"].ToString())
                        {
                            #region 生成凭证
                            string sqlvid = "select max(id)+1 from ivoucher";
                            object obj = DBHelper1.ExecuteScalar(sqlvid);
                            if (obj != null)
                            {
                                string vid = obj.ToString().PadLeft(16, '0');
                                string sql_cash = string.Empty;
                                sql_cash += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}',{15},'{16}');",
                                      new object[] { COMN.MyVars.CWDB ,r1["CashVoucherID"].ToString(),100,r["year"].ToString() ,r["month"].ToString() ,3,r["vno"].ToString() ,DateTime.Now.ToShortDateString()
                                                ,r["vexpl"].ToString() ,-1,"100801",r1["hdw"].ToString(),r1["NCodeC"].ToString(),r1["Cash1"].ToString(),r["vdate"].ToString() ,vid,""});
                                sql_cash += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}',{15},'{16}');",
                                      new object[] { COMN.MyVars.CWDB ,r1["CashVoucherID"].ToString(),200,r["year"].ToString() ,r["month"].ToString() ,3,r["vno"].ToString() ,DateTime.Now.ToShortDateString()
                                                ,r["vexpl"].ToString() ,-1,"1010",r1["hdw"].ToString(),r1["NCodeC"].ToString(),r1["Cash1"].ToString(),r["vdate"].ToString() ,vid,""});
                                int result = DBHelper1.ExecuteNonQuery(sql_cash);
                                Console.WriteLine(sql_cash);
                            }
                            #endregion
                        }
                        //合同费用凭证
                        if (r["id"].ToString() == r1["NoteVoucherID"].ToString())
                        {
                            #region 生成凭证
                            string sqlvid = "select max(id)+1 from ivoucher";
                            object obj = DBHelper1.ExecuteScalar(sqlvid);
                            if (obj != null)
                            {
                                string vid = obj.ToString().PadLeft(16, '0');
                                string sql_note = string.Empty;
                                sql_note += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}',{15},'{16}');",
                                      new object[] { COMN.MyVars.CWDB ,r1["CashVoucherID"].ToString(),100,r["year"].ToString() ,r["month"].ToString() ,4,r["vno"].ToString() ,DateTime.Now.ToShortDateString()
                                                ,r["vexpl"].ToString() ,-1,"100802",r1["hdw"].ToString(),r1["NCodeC"].ToString(),r1["Cash1"].ToString(),r["vdate"].ToString() ,vid,""});
                                sql_note += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}',{15},'{16}');",
                                      new object[] { COMN.MyVars.CWDB ,r1["CashVoucherID"].ToString(),200,r["year"].ToString() ,r["month"].ToString() ,4,r["vno"].ToString() ,DateTime.Now.ToShortDateString()
                                                ,r["vexpl"].ToString() ,-1,"1011",r1["hdw"].ToString(),r1["NCodeC"].ToString(),r1["Cash1"].ToString(),r["vdate"].ToString() ,vid,""});
                                int result = DBHelper1.ExecuteNonQuery(sql_note);
                                Console.WriteLine(sql_note);
                            }
                            #endregion
                        }
                    }
                    string sql3 = string.Format(@"  SELECT * FROM [WF_Flow3]  WHERE VoucherID = '{0}' ", r["id"].ToString());
                    DataTable flow3list = DBHelper.ExecuteDataTable(sql2);
                    foreach (DataRow r3 in flow3list.Rows)
                    {
                        if (r["id"].ToString() == r3["VoucherID"].ToString())
                        {
                            string sql4 = string.Format(@"  SELECT * FROM [WF_Flow4]  WHERE FlowID = '{0}' ", r3["FlowID"].ToString());
                            DataTable flow4list = DBHelper.ExecuteDataTable(sql4);
                            #region 生成凭证
                            string sqlvid = "select max(id)+1 from ivoucher";
                            object obj = DBHelper1.ExecuteScalar(sqlvid);
                            if (obj != null)
                            {
                                string vid = obj.ToString().PadLeft(16, '0');
                                string sql_expense = string.Empty;
                                foreach (DataRow item in flow4list.Rows)
                                {
                                    sql_expense += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                                     new object[] { COMN.MyVars.CWDB 
                                    ,r["id"].ToString()
                                    ,r["vno"].ToString()
                                    ,r["year"].ToString()
                                    ,r["month"].ToString()
                                    ,vtype
                                    ,vno
                                    ,r["vdate"].ToString()
                                    ,item.Todo
                                    ,-1
                                    ,acode_cr
                                    ,flow.CompanyID
                                    ,item.NCode
                                    ,item.WF4RowRmb
                                    ,DateTime.Now.ToShortDateString()
                                    ,vid
                                    ,""});
                                    ino += 100;
                                }

                                sql_expense += string.Format(@"  INSERT INTO {0}.dbo.ivoucher([hid] ,[ino] ,[year] ,[month] ,[vtype] ,[vno] ,[vdate] ,[expl] ,[vdc] ,[acode] ,[bcode] ,[ncode] ,[rmb] ,[odate] ,[id],qtyunit)
                                               VALUES('{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}',{13},'{14}','{15}','{16}');",
                                    new object[] { COMN.MyVars.CWDB 
                                    ,hid
                                    ,ino
                                    ,DateTime.Now.Year
                                    ,DateTime.Now.Month
                                    ,vtype
                                    ,vno
                                    ,DateTime.Now.ToShortDateString()
                                    ,flow.FName
                                    ,1
                                    ,acode_dr
                                    ,flow.CompanyID
                                    ,""// 借方NCODE 为空 待议
                                    ,wf3.Rmb
                                    ,DateTime.Now.ToShortDateString()
                                    ,(vid+mark).ToString().PadLeft(16, '0')
                                    ,""});
                                int result = DBHelper1.ExecuteNonQuery(sql_expense);
                                Console.WriteLine(sql_expense);
                            }
                            #endregion
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                this.timer1.Stop();
                MessageBox.Show(ex.Message);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.timer1.Interval = Convert.ToInt16(this.numericUpDown1.Value);
            DBHelper.DBHelperInit(1);
            DBHelper1.DBHelperInit(2);
        }
    }
}
