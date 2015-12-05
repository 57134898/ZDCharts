using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZDCharts.SysViews
{
    public partial class AlterPsw : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                if (string.IsNullOrEmpty(this.psw1.Value))
                {
                    this.msg.InnerHtml = "密码不能为空";
                    return;
                }
                if (this.psw1.Value != this.psw2.Value)
                {
                    this.msg.InnerHtml = "两次密码输入级不一致";
                    return;
                }
                using (DAL.ContractEntities db = new DAL.ContractEntities())
                {
                    MODEL.UserInfo user = (MODEL.UserInfo)Session["user"];
                    var emp = db.Org_Emps.SingleOrDefault(p => p.EmpID == user.UserID);
                    emp.Psw = this.psw1.Value;
                    db.SaveChanges();
                    this.msg.InnerHtml = "修改成功，新密码为:"+this.psw1.Value;
                }
            }
        }
    }
}