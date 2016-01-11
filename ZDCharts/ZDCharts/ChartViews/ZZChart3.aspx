﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZZChart3.aspx.cs" Inherits="ZDCharts.ChartViews.ZZChart3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>合同情况</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/bootstrap.min.js"></script>

    <script type="text/javascript">
        //重查
        function doagain() {
            $('#collapse1').collapse('toggle');
            $('#collapse2').collapse('toggle');
        }
        $(function () {
            $("#year").val(2016);
            $("#btn").click(function () {
                loadchart();
                doagain();
            });
            $.ajax({
                type: 'POST',
                url: '/Handlers/sys.ashx',
                data: { Action: "GetContractTpyeList" },
                success: function suc(result) {
                    for (var i = 0; i < result.data.length; i++) {
                        $("#contracttype").append(" <option>" + result.data[i].LID + "-" + result.data[i].LNAME + "</option>");
                    }
                },
                dataType: 'JSON'
            });
            $('#collapse1').collapse('toggle');
        });
        function loadchart() {
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
                    'echarts/chart/pie',
                    'echarts/chart/line',
                    'echarts/chart/funnel'
                ],
               function (ec) {
                   $('#main').css('height', $(window).height() * 0.8);
                   var myChart = ec.init(document.getElementById('main'));
                   myChart.showLoading({
                       text: "图表数据正在努力加载...",
                       effect: "spin"
                   });


                   var placeHoledStyle = {
                       normal: {
                           barBorderColor: 'rgba(0,0,0,0)',
                           color: 'rgba(0,0,0,0)'
                       },
                       emphasis: {
                           barBorderColor: 'rgba(0,0,0,0)',
                           color: 'rgba(0,0,0,0)'
                       }
                   };
                   var dataStyle = {
                       normal: {
                           label: {
                               show: true,
                               position: 'insideLeft',
                               formatter: '{c}%'
                           }
                       }
                   };
                   option = {
                       title: {
                           text: '多维条形图',
                           subtext: 'From ExcelHome',
                           sublink: 'http://e.weibo.com/1341556070/AiEscco0H'
                       },
                       tooltip: {
                           trigger: 'axis',
                           axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                               type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                           },
                           formatter: '{b}<br/>{a0}:{c0}%<br/>{a2}:{c2}%<br/>{a4}:{c4}%<br/>{a6}:{c6}%'
                       },
                       legend: {
                           y: 55,
                           itemGap: document.getElementById('main').offsetWidth / 8,
                           data: ['GML', 'PYP', 'WTC', 'ZTW']
                       },
                       toolbox: {
                           show: true,
                           feature: {
                               mark: { show: true },
                               dataView: { show: true, readOnly: false },
                               restore: { show: true },
                               saveAsImage: { show: true }
                           }
                       },
                       grid: {
                           y: 80,
                           y2: 30
                       },
                       xAxis: [
                           {
                               type: 'value',
                               position: 'top',
                               splitLine: { show: false },
                               axisLabel: { show: false }
                           }
                       ],
                       yAxis: [
                           {
                               type: 'category',
                               splitLine: { show: false },
                               data: ['重庆', '天津', '上海', '北京']
                           }
                       ],
                       series: [
                           {
                               name: 'GML',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: dataStyle,
                               data: [38, 50, 33, 72]
                           },
                           {
                               name: 'GML',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: placeHoledStyle,
                               data: [62, 50, 67, 28]
                           },
                           {
                               name: 'PYP',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: dataStyle,
                               data: [61, 41, 42, 30]
                           },
                           {
                               name: 'PYP',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: placeHoledStyle,
                               data: [39, 59, 58, 70]
                           },
                           {
                               name: 'WTC',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: dataStyle,
                               data: [37, 35, 44, 60]
                           },
                           {
                               name: 'WTC',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: placeHoledStyle,
                               data: [63, 65, 56, 40]
                           },
                           {
                               name: 'ZTW',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: dataStyle,
                               data: [71, 50, 31, 39]
                           },
                           {
                               name: 'ZTW',
                               type: 'bar',
                               stack: '总量',
                               itemStyle: placeHoledStyle,
                               data: [29, 50, 69, 61]
                           }
                       ]
                   };

                   myChart.setOption(option);
                   myChart.hideLoading();
                   //return;


                   var len = 0;
                   var w = $(document.body).width();
                   var h = $(document.body).height();
                   //alert($(document).height());
                   if (w > h) {
                       len = Math.round(h / 2);
                   } else {
                       len = Math.round(w / 2);
                   }
                   option.series[0].radius = [0, Math.round(len * 0.5)];
                   option.series[1].radius = [Math.round(len * 5 / 7), len];
                   $.ajax({
                       type: 'POST',
                       url: '/Handlers/Charts.ashx',
                       data: { Action: "GetData3", contracttype: $("#contracttype").find("option:selected").text(), year: $("#year").find("option:selected").text(), month: $("#month").find("option:selected").text() },
                       success: function suc(result) {
                           alert(JSON.stringify(result.data));
                           return;
                           option.legend.data = result.data.list1;
                           option.series[0].data = result.data.list2;
                           option.series[1].data = result.data.list3;
                           myChart.setOption(option);
                           myChart.hideLoading();
                       },
                       dataType: 'JSON'
                   });
               }
        );
        };
        function refresh() {
            location.reload();
        }
    </script>
    <script src="/dist/echarts.js"></script>
</head>
<body>
    <div class="collapse" id="collapse1">
        <div class="form-group">
            <label class="control-label">年</label>
            <select id="year" data-width="100%" class="form-control" style="width: '100%'; height: '100%'">
                <option>2014</option>
                <option>2015</option>
                <option>2016</option>
                <option>2017</option>
                <option>2018</option>
                <option>2019</option>
                <option>2020</option>
            </select>
        </div>
        <div class="form-group">
            <label class="control-label">月份</label>
            <select id="month" data-width="100%" class="form-control" style="width: '100%'; height: '100%'">
                <option>全部</option>
                <option>1</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
                <option>6</option>
                <option>7</option>
                <option>8</option>
                <option>9</option>
                <option>10</option>
                <option>11</option>
                <option>12</option>
            </select>
        </div>
        <div class="form-group">
            <label class="control-label">合同类型</label>
            <select id="contracttype" data-width="100%" class="form-control" style="width: '100%'; height: '100%'">
            </select>
        </div>
        <button id="btn" class="btn  btn-info btn-lg btn-block">查询</button>
    </div>
    <div class="collapse" id="collapse2">
        <button type="button" class="btn  btn-info btn-lg btn-block" onclick="refresh()">更改查询条件</button>
        <div id="main"></div>
    </div>
</body>
</html>
