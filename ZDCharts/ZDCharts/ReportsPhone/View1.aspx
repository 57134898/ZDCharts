<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="View1.aspx.cs" Inherits="ZDCharts.ReportsPhone.View1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>查询</title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#collapse1').collapse('toggle');
            var a =7*0.8;
            alert(a);
        })
    </script>
</head>
<body style="margin: 1px">
    <div class="collapse" id="collapse1">
        <div class="form-group">
            <label for="date1">开始日期</label>
            <input type="date" class="form-control" id="psw1" placeholder="密码" runat="server" />
        </div>
        <div class="form-group">
            <label for="date2">结束日期</label>
            <input type="date" class="form-control" id="psw2" placeholder="密码确认" runat="server" />
        </div>
        <div class="form-group">
            <label class="control-label">类型</label>
            <select id="rmbtype" data-width="100%" class="form-control">
                <option>合同</option>
                <option>费用</option>
            </select>
        </div>
        <button id="enterBtn" type="button" data-toggle="popover" class="btn btn-primary btn-lg btn-block">查询</button>
        <div id="msg" runat="server"></div>
    </div>
    <div class="collapse" id="collapse2"></div>
</body>
</html>
