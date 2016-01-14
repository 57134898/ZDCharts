<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChartList.aspx.cs" Inherits="ZDCharts.ChartViews.ChartList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>图表</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/bootstrap.min.js"></script>

</head>
<body>
    <div class="list-group">
        <a href="ZZChart1.aspx" class="list-group-item list-group-item-success">合同付款审批情况图</a>
        <a href="ZZChart2.aspx" class="list-group-item list-group-item-info">费用审批情况图</a>
        <a href="ZZChart3.aspx" class="list-group-item list-group-item-warning">合同发票情况</a>
        <a href="ZZChart4.aspx" class="list-group-item list-group-item-danger">收支情况</a>
    </div>
</body>
</html>
