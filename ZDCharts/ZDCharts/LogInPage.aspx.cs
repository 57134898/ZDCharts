using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZDCharts
{
    public partial class LogInPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.IsPostBack)
            {
                string username = this.usernameInput.Value;
                string password = this.pswInput.Value;
                using (DAL.ContractEntities db = new DAL.ContractEntities())
                {
                    var emp = db.V_Emps.SingleOrDefault(p => p.EmpName == username && password == p.Psw);
                    if (emp == null)
                    {
                        this.errormsg.InnerText = "用户名或者密码错误";
                        //ClientScript.RegisterStartupScript(ClientScript.GetType(), "myscript", "<script>$('#errormsg').html('222222222222'); </script>");
                    }
                    else
                    {
                        MODEL.UserInfo userinfo = new MODEL.UserInfo()
                        {
                            UserID = emp.EmpID,
                            UserName = emp.EmpName,
                            CompanyID = "0" + this.accountBookInput.Value + emp.CompanyID.Substring(2),
                            CompanyName = emp.CompanyName,
                            RoleID = emp.RoleID,
                            RoleName = emp.RoleName,
                            DeptID = emp.DeptID,
                            DeptName = emp.DeptName,
                            AccountBook = this.accountBookInput.Value,
                            AccountBookName = this.accountBookInput.Items[this.accountBookInput.SelectedIndex].Text
                        };
                        Session["user"] = userinfo;
                        Response.Redirect("Index.aspx");
                    }
                }
            }
        }
    }
}