<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogInPage.aspx.cs" Inherits="ZDCharts.LogInPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>铸锻公司资金审批</title>
    <script src="Scripts/jquery-2.1.3.min.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <script src="Scripts/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#loginbtn").click(function () {
            //    //var url = "Index.html?userid='" + $("#inputUserID").val() + "'&psw='" + $("#inputPassword").val() + "'";
            //    var uid = $("#inputUserID").val();
            //    var psw = $("#inputPassword").val();
            //    location.href = "Index.html?uid=" + uid + "&psw=" + psw;
            //});
            $("#login").click(function () {
                $("#login").button('loading');
            });
        });
    </script>
</head>
<body>
    <form action="LogInPage.aspx" method="post" id="loginform" runat="server">
        <div class="form-group">
            <label for="usernameInput" class="col-sm-2 control-label">用户名</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="usernameInput" placeholder="输入用户名" value="0001" runat="server" />
            </div>
        </div>
        <div class="form-group">
            <label for="pswInput" class="col-sm-2 control-label">密码</label>
            <div class="col-sm-10">
                <input type="password" class="form-control" id="pswInput" placeholder="输入密码" value="123" runat="server" />
            </div>
        </div>
        <div id="errormsg" runat="server"></div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button id="login" type="submit" data-loading-text=" 登录中..." autocomplete="off" runat="server" class="btn btn-primary btn-block">登陆</button>
            </div>
        </div>
    </form>
</body>
</html>
