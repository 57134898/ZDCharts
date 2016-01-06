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
            $("#year").val(2016);
            $("#btn").val(function () {
                $.ajax({
                    type: 'POST',
                    url: '/Handlers/Charts.ashx',
                    data: { Action: "GetData1", year: $("#year").find("option:selected").text(), month: $("#month").find("option:selected").text() },
                    success: function suc(result) {
                        alert(JSON.stringify(result));
                        option.xAxis[0].data = result.data.list1;
                        option.series[0].data = result.data.list2;
                        option.series[1].data = result.data.list3;
                        myChart.setOption(option);
                        myChart.hideLoading();
                    },
                    dataType: 'JSON'
                });
            });
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
                   $('#main').css('height', $(window).height());
                   var myChart = ec.init(document.getElementById('main'));
                   myChart.showLoading({
                       text: "图表数据正在努力加载...",
                       effect: "spin"
                   });
                   option = {
                       title: {
                           text: '合同付款审批情况',
                           subtext: '按公司'
                       },
                       tooltip: {
                           trigger: 'axis'
                       },
                       legend: {
                           data: ['现金', '票据']
                       },
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
                       xAxis: [
                           {
                               type: 'category',
                               data: []//['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
                           }
                       ],
                       yAxis: [
                           {
                               type: 'value'
                           }
                       ],
                       series: [
                           {
                               name: '现金',
                               type: 'bar',
                               data: [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
                               markPoint: {
                                   data: [
                                       { type: 'max', name: '最大值' },
                                       { type: 'min', name: '最小值' }
                                   ]
                               },
                               markLine: {
                                   data: [
                                       { type: 'average', name: '平均值' }
                                   ]
                               }
                           },
                           {
                               name: '票据',
                               type: 'bar',
                               data: [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
                               markPoint: {
                                   data: [
                                       { name: '年最高', value: 182.2, xAxis: 7, yAxis: 183, symbolSize: 18 },
                                       { name: '年最低', value: 2.3, xAxis: 11, yAxis: 3 }
                                   ]
                               },
                               markLine: {
                                   data: [
                                       { type: 'average', name: '平均值' }
                                   ]
                               }
                           }
                       ]
                   };


               }
        );

        });
    </script>
    <script src="/dist/echarts.js"></script>
</head>
<body>
    <button id="btn">aaa</button>
    <div class="form-group">
        <label class="control-label">类型</label>
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
        <label class="control-label">类型</label>
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
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main"></div>
</body>
</html>
