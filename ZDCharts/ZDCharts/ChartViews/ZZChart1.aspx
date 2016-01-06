<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZZChart1.aspx.cs" Inherits="ZDCharts.ChartViews.ZZChart1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title></title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {


            $("#btn").click(function () {
                alert(3);
                $.ajax({
                    type: 'POST',
                    url: '../Handlers/Charts.ashx',
                    data: { action: 'Getlist' },
                    success: function suc(result) {
                        alert(JSON.stringify(result));
                    },
                    dataType: 'JSON'
                });
            });
        });
    </script>
    <script src="/dist/echarts.js"></script>
</head>
<body>
    <button id="btn">aaa</button>
</body>
</html>
