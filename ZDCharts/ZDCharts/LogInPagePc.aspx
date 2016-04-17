<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogInPagePc.aspx.cs" Inherits="ZDCharts.LogInPagePc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>铸锻公司资金管理系统</title>
    <script src="Scripts/jquery-2.1.3.min.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.min.js"></script>
    <link href="Content/myStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            //var p = $("#p").val();
            //$('#myButton').on('click', function () {
            //    var $btn = $(this).button('登录中。。。')
            //    // business logic...
            //    $btn.button('reset')
            //})

            //$("#login").click(function () {
            //    var p = $("#p").val();
            //    var u = $("#u").val();
            //    //var btn = $(this).button('login');
            //    $("#login").button('loading');
            //    //alert(1);
            //    $.ajax({
            //        "type": "POST",
            //        "url": "Handlers/LogIn.ashx",
            //        "dataType": "json",
            //        "data": { Action: 'ValidateUser', u: u, p: p }, // 以json格式传递
            //        "success": function (result) {
            //            //alert(JSON.stringify(result));
            //            if (result.code == "0") {

            //                $("#userinfo").val(JSON.stringify(result.data));
            //                alert(JSON.stringify(result.data));
            //                $("#loginform").submit();
            //            } else {
            //                $("#errormsg").text(result.msg);
            //            }
            //            $("#login").button('reset');
            //        }
            //    });
            //});
            $("#login").click(function () {
                $("#login").button('loading');
            });
        });

    </script>
</head>
<body>
    <div class="head1">
        <br />
        <h1>沈阳铸锻工业有限公司</h1>
        <p>
            <h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                资金管理系统
            </h3>
            <br />
        </p>
    </div>
    <form id="loginform" action="LogInPagePc.aspx" method="post" runat="server">
        <div class="box">
            <div class="panel panel-primary">
                <div class="panel-heading">用户登录</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="control-label">账套</label>
                        <select id="accountBookInput" data-width="100%" class="form-control" runat="server">
                            <option value="1">铸锻公司</option>
                            <option value="2">独立分公司</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="usernameInput">用户名</label>
                        <input type="text" class="form-control" id="usernameInput" placeholder="请输入用户名" runat="server" />
                    </div>
                    <div class="form-group">
                        <label for="pswInput">密码</label>
                        <input type="password" class="form-control" id="pswInput" placeholder="请输入密码" runat="server" />
                    </div>
                    <div id="errormsg" runat="server"></div>
                    <button id="login" type="submit" data-loading-text=" 登录中..." autocomplete="off" class="btn btn-primary btn-block" runat="server">登录</button>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
