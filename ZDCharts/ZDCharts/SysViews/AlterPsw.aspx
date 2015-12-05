<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlterPsw.aspx.cs" Inherits="ZDCharts.SysViews.AlterPsw" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>修改密码</title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <script type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server" action="AlterPsw.aspx">
        <div class="panel">
            <%--<div class="panel-heading" id="panelheadtext">修改密码</div>--%>
            <div class="panel-body">
                <div class="form-group">
                    <label for="psw1">密码</label>
                    <input type="password" class="form-control" id="psw1" placeholder="密码" runat="server" />
                </div>
                <div class="form-group">
                    <label for="psw2">密码确认</label>
                    <input type="password" class="form-control" id="psw2" placeholder="密码确认"  runat="server" />
                </div>
                <div id="msg" runat="server"></div>
            </div>
            <div class="panel-footer">
                <button id="savbtn" type="submit" data-toggle="popover" class="btn btn-primary">&nbsp;&nbsp;&nbsp;保&nbsp;存&nbsp;&nbsp;&nbsp;</button>
                <button id="canbtn" type="button" class="btn btn-default">&nbsp;&nbsp;&nbsp;取&nbsp;消&nbsp;&nbsp;&nbsp;</button>
            </div>
        </div>
    </form>
</body>
</html>
