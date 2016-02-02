<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report1.aspx.cs" Inherits="ZDCharts.ReportsPhone.Report1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>资金余额表</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/bootstrap.min.js"></script>
    <script src="/Scripts/myjs.js"></script>
    <script type="text/javascript">
        //重查
        $(function () {
            var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('table1'));
            spinner1.stop();
        });


    </script>
    <script src="/dist/echarts.js"></script>
</head>
<body>
    <table id="table1" class="table table-bordered">
        <thead>
            <tr>
                <th rowspan="2">公司</th>
                <th rowspan="2">资金余额</th>
                <th colspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">其中</th>
            </tr>
            <tr>
                <th>现汇</th>
                <th>承兑</th>
            </tr>
        </thead>
        <tr class="active">
            <td>公司</td>
            <td>现金</td>
            <td>票据</td>
            <td>合计</td>
        </tr>
        <tr class="info">
            <td>销售分公司</td>
            <td>1212212</td>
            <td>32455454</td>
            <td>32455454</td>
        </tr>
        <tr class="success">
            <td>铸钢分公司</td>
            <td>1212212</td>
            <td>32455454</td>
            <td>32455454</td>
        </tr>
    </table>
</body>
</html>
