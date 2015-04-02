<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ZDCharts.ChartViews.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>

    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap.min.js"></script>
    <link href="../Content/bootstrap-select.min.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap-select.min.js"></script>
    <script src="../dist/echarts.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <select class="selectpicker" data-style="btn-warning">
            <option>Mustard</option>
            <option>Ketchup</option>
            <option>Relish</option>
        </select>
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
                   var myChart = ec.init(document.getElementById('main'));
                   var dataArr = ['500', '400', '600', '300'];

                   option = {
                       timeline: {
                           data: [
                               '2002-01-01', '2003-01-01', '2004-01-01'
                           ],
                           label:
                               {
                                   formatter: function (s) {
                                       return s.slice(0, 8);
                                   }
                               },
                           autoPlay: true,
                           playInterval: 1000
                       },
                       options: [
                           {
                               title: {
                                   'text': '2002全国宏观经济指标',
                                   'subtext': '数据来自国家统计局'
                               },
                               tooltip: { 'trigger': 'axis' },
                               legend: {
                                   x: 'right',
                                   'data': ['GDP', '金融', '房地产'],
                                   'selected': {
                                       'GDP': true,
                                       '金融': false,
                                       '房地产': true
                                   }
                               },
                               toolbox: {
                                   'show': true,
                                   orient: 'vertical',
                                   x: 'right',
                                   y: 'center',
                                   'feature': {
                                       'mark': { 'show': true },
                                       'dataView': { 'show': true, 'readOnly': false },
                                       'magicType': { 'show': true, 'type': ['line', 'bar', 'stack', 'tiled'] },
                                       'restore': { 'show': true },
                                       'saveAsImage': { 'show': true }
                                   }
                               },
                               calculable: true,
                               grid: { 'y': 80, 'y2': 100 },
                               xAxis: [{
                                   'type': 'category',
                                   'axisLabel': { 'interval': 0 },
                                   'data': [
                                       '北京', '\n天津', '河北', '\n山西'
                                   ]
                               }],
                               yAxis: [
                                   {
                                       'type': 'value',
                                       'name': 'GDP（亿元）',
                                       'max': 1000
                                   }
                               ],
                               series: [
                                   {
                                       'name': 'GDP',
                                       'type': 'bar',
                                       'markLine': {
                                           symbol: ['arrow', 'none'],
                                           symbolSize: [4, 2],
                                           itemStyle: {
                                               normal: {
                                                   lineStyle: { color: 'orange' },
                                                   barBorderColor: 'orange',
                                                   label: {
                                                       position: 'left',
                                                       formatter: function (params) {
                                                           return Math.round(params.value);
                                                       },
                                                       textStyle: { color: 'orange' }
                                                   }
                                               }
                                           },
                                           'data': [{ 'type': 'max', 'name': '最大值' }]
                                       },
                                       'data': dataArr
                                   },
                                   {
                                       'name': '金融', 'type': 'bar',
                                       'data': dataArr
                                   },
                                   {
                                       'name': '房地产', 'type': 'bar',
                                       'data': dataArr
                                   }
                               ]
                           },
                           {
                               title: { 'text': '2003全国宏观经济指标' },
                               series: [
                                   { 'data': dataArr },
                                   { 'data': dataArr },
                                   { 'data': dataArr }
                               ]
                           },
                           {
                               title: { 'text': '2004全国宏观经济指标' },
                               series: [
                                   { 'data': dataArr },
                                   { 'data': dataArr },
                                   { 'data': dataArr }
                               ]
                           }
                       ]
                   };
                   myChart.setOption(option);
               }
        );
        </script>
    </form>
</body>
</html>
