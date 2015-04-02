<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ZDCharts.ChartViews.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>签订合同情况表</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap.min.js"></script>
    <link href="../Content/bootstrap-select.min.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap-select.min.js"></script>
    <script src="../dist/echarts.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <select class="selectpicker" data-style="btn-primary">
                <option>2012</option>
                <option>2013</option>
                <option>2014</option>
                <option>2015</option>
                <option>2016</option>
                <option>2017</option>
            </select>

            <select class="selectpicker" data-style="btn-warning">
                <option>2014</option>
                <option>2015</option>
                <option>2016</option>
                <option>2017</option>
            </select>
            <button class="btn btn-default"><span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询 </button>
        </div>

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
                    'echarts/chart/bar', // 使用柱状图就加载bar模块，按需加载
                    'echarts/chart/line'
                ],
               function (ec) {
                   var myChart = ec.init(document.getElementById('main'));
                   var dataArr = ['500', '400', '600', '300'];

                   option = {
                       timeline: {
                           data: [
                               //'2002-01-01', '2003-01-01', '2004-01-01'
                           ],
                           label:
                               {
                                   formatter: function (s) {
                                       return s.slice(0, 4);
                                   }
                               },
                           autoPlay: true,
                           playInterval: 1000
                       },
                       options: [
                           {
                               title: {
                                   'text': '',
                                   'subtext': '数据来铸锻公司合同信息管理系统'
                               },
                               tooltip: { 'trigger': 'axis' },
                               legend: {
                                   x: 'right',
                                   'data': ['签订', '回款', '发票'],
                                   'selected': {
                                       '签订': true,
                                       '回款': true,
                                       '发票': false
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
                                       //'北京', '\n天津', '河北', '\n山西'
                                   ]
                               }],
                               yAxis: [
                                   {
                                       'type': 'value',
                                       'name': '金额',
                                       'max': 60000
                                   }
                               ],
                               series: [
                                   {
                                       'name': '签订合同',
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
                                       'data': []
                                   },
                                   {
                                       'name': '回款', 'type': 'bar',
                                       'data': []
                                   },
                                   {
                                       'name': '发票', 'type': 'bar',
                                       'data': []
                                   }
                               ]
                           }
                           //,
                           //{
                           //    title: { 'text': '2003全国宏观经济指标' },
                           //    series: [
                           //        { 'data': dataArr },
                           //        { 'data': dataArr },
                           //        { 'data': dataArr }
                           //    ]
                           //}
                       ]
                   };

                   $.ajax({
                       type: 'POST',
                       url: '../Handlers/report1.ashx',
                       data: {},
                       success: function suc(result) {
                           //alert(result.jArr_options[0].series[0].data[1]);
                           try {
                               for (var i = 0; i < result.jArr_options.length; i++) {
                                   var mark = {
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
                                   };
                                   if (i == 0) {
                                       option.options[i].title.text = result.jArr_options[i].text;
                                       var d1 = result.jArr_options[0].series[0];
                                       var d2 = result.jArr_options[0].series[1];
                                       var d3 = result.jArr_options[0].series[2];
                                       option.options[0].series[0].data = d1.data;
                                       option.options[0].series[1].data = d2.data;
                                       option.options[0].series[2].data = d3.data;
                                       //传人X轴DATA ，公司信息
                                       option.options[0].xAxis[0].data = result.jArrrx_xAxis_Data
                                       
                                       //option.options[0].series[0].markLine = mark;
                                       //option.options[0].series[1].markLine = mark;
                                       //option.options[0].series[2].markLine = mark;

                                   } else {
                                       var opt1 = {};
                                       opt1.title = {};
                                       opt1.title.text = result.jArr_options[i].text;
                                       opt1.series = result.jArr_options[i].series
                                       //opt1.series[1].markLine = mark;
                                       option.options[i] = opt1;
                                   }
                               }
                               option.timeline.data = result.jArrr_timeline_Data;
                               //alert(JSON.stringify(option.options));
                           } catch (e) {
                               alert(e.message)
                           }
                           myChart.setOption(option);
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
