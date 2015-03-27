<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Demo.aspx.cs" Inherits="ZDCharts.ChartViews.Demo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../dist/echarts.js"></script>
</head>
<body>
    <form id="f1" runat="server">
        <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
        <div id="main" style="height: 500px;"></div>
        <!-- ECharts单文件引入 -->
        <script type="text/javascript">
            // 路径配置
            require.config({
                paths: {
                    echarts: '../dist/'
                }
            });
            // 使用
            require(
                [
                    'echarts',
                    'echarts/chart/bar' // 使用柱状图就加载bar模块，按需加载
                ],
               function (ec) {
                   // 基于准备好的dom，初始化echarts图表
                   var myChart = ec.init(document.getElementById('main'));
                   myChart.showLoading({
                       text: "图表数据正在努力加载...",
                       effect: "spin"
                   });
                   // 为echarts对象加载数据 
                   $.ajax({
                       type: 'POST',
                       url: '../Handlers/Handler1.ashx',
                       data: {},
                       success: function suc(result) {
                           myChart.setOption(result);
                           myChart.hideLoading();
                       },
                       dataType: 'JSON'
                   });
               }
        );
        </script>
    </form>
</body>
</html>
