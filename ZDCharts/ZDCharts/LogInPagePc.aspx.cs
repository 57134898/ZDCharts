using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZDCharts
{
    public partial class LogInPagePc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.IsPostBack)
            {
                string username = this.usernameInput.Value;
                string password = this.pswInput.Value;
                using (DAL.ContractEntities db = new DAL.ContractEntities())
                {
                    var user = db.Org_Emps.SingleOrDefault(p => p.EmpName == username && password == p.Psw);
                    if (user == null)
                    {
                        this.errormsg.InnerText = "用户名或者密码错误";
                        //ClientScript.RegisterStartupScript(ClientScript.GetType(), "myscript", "<script>$('#errormsg').html('222222222222'); </script>");

                    }
                    else
                    {
                        Session["user"] = user;
                        Response.Redirect("IndexPC.aspx");
                    }
                }
            }
        }
    }
}