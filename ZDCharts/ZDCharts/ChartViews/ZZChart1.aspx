﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZZChart1.aspx.cs" Inherits="ZDCharts.ChartViews.ZZChart1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>合同付款情况</title>
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
                    'echarts/chart/line'
                ],
               function (ec) {
                   $('#main').css('height', $(window).height() * 0.8);
                   var myChart = ec.init(document.getElementById('main'));
                   myChart.showLoading({
                       text: "图表数据正在努力加载...",
                       effect: "spin"
                   });
                   option = {
                       title: { text: '合同付款审批情况', subtext: '按公司' },
                       tooltip: { trigger: 'axis' },
                       legend: { data: ['现金', '票据'] },
                       toolbox: {
                           show: true,
                           feature: {
                               mark: { show: true },
                               dataView: { show: true, readOnly: false },
                               magicType: { show: true, type: ['line', 'bar'] },
                               restore: { show: true },
                               saveAsImage: { show: true }
                           }
                       },
                       calculable: true,
                       xAxis: [{ type: 'category', data: [] }],
                       yAxis: [{ type: 'value' }], series: [{ name: '现金', type: 'bar', data: [] }, { name: '票据', type: 'bar', data: [], }]
                   };
                   $.ajax({
                       type: 'POST',
                       url: '/Handlers/Charts.ashx',
                       data: { Action: "GetData1", year: $("#year").find("option:selected").text(), month: $("#month").find("option:selected").text() },
                       success: function suc(result) {
                           option.xAxis[0].data = result.data.list1;
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
        <button id="btn" class="btn  btn-info btn-lg btn-block">查询</button>
    </div>
    <div class="collapse" id="collapse2">
        <button type="button" class="btn  btn-info btn-lg btn-block" onclick="refresh()">更改查询条件</button>
        <div id="main"></div>
    </div>
</body>
</html>