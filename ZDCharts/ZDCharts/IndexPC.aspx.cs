﻿using System;
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
            string userjson = Request.Form["userinfo"];

            this.userinfo.Value = "userjson";
        }

    }
}