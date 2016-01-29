<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogInPage.aspx.cs" Inherits="ZDCharts.LogInPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>铸锻公司资金审批</title>
    <link rel="shortcut icon" href="logoico.ico" type="image/x-icon" />
    <link rel="bookmark" href="logoico.ico" type="image/x-icon" />
    <link rel="icon" href="logoico.ico" type="image/x-icon" />
    <link rel="apple-touch-icon" href="logoico.ico" type="image/x-icon" />
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
<body style="margin-right: 2px; margin-left: 2px">
    <div style="background: #6f5499; width: 100%; height: 30%">
        <br />
        <div class="page-header">
            <h1 style="font-family: 微软雅黑; color: #FFFFFF">&nbsp;&nbsp;资金审批系统</h1>
        </div>
        <br />
    </div>
    <br />
    <form action="LogInPage.aspx" method="post" id="loginform" runat="server" style="margin-right: 10%; margin-left: 10%">
        <div class="form-group">
            <label for="usernameInput">用户名</label>
            <div>
                <input type="text" class="form-control" id="usernameInput" placeholder="输入用户名" value="0001" runat="server" />
            </div>
        </div>
        <div class="form-group">
            <label for="pswInput">密码</label>
            <div>
                <input type="password" class="form-control" id="pswInput" placeholder="输入密码" value="123" runat="server" />
            </div>
        </div>
        <div id="errormsg" runat="server"></div>
        <div class="form-group">
            <div>
                <button id="login" type="submit" data-loading-text=" 登录中..." autocomplete="off" runat="server" class="btn btn-primary btn-block">登陆</button>
            </div>
        </div>
    </form>
</body>
</html>
