using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZDCharts
{
    public partial class IndexPC : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            object oUser = Session["user"];
            if (oUser != null)
            {
                MODEL.UserInfo user = (MODEL.UserInfo)oUser;
                this.userinfoinput.Value = Newtonsoft.Json.JsonConvert.SerializeObject(user);
                this.company.InnerText = user.CompanyName;
                this.dept.InnerText = user.DeptName;
                this.role.InnerText = user.RoleName;
                this.name.InnerText = user.UserName;
                this.account.InnerText = user.AccountBookName;
            }

        }

    }
}