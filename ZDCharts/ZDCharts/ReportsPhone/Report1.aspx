<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report1.aspx.cs" Inherits="ZDCharts.ReportsPhone.Report1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>资金余额表</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/bootstrap.min.js"></script>
    <script src="../Scripts/spin.min.js"></script>
    <script src="/Scripts/myjs.js"></script>
    <script src="/dist/echarts3-0.min.js"></script>
    <script type="text/javascript">

        var option = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            legend: {
                data: ['合计', '现汇', '票据']
            },
            grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
            xAxis: [{ type: 'value' }],
            yAxis: [
                {
                    type: 'category',
                    axisTick: { show: false },
                    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                }
            ],
            series: [
                {
                    name: '合计',
                    type: 'bar',
                    itemStyle: {
                        normal: {
                            label: { show: true, position: 'inside' }
                        }
                    },
                    data: [200, 170, 240, 244, 200, 220, 210]
                },
                {
                    name: '现汇',
                    type: 'bar',
                    stack: '总量',
                    itemStyle: {
                        normal: {
                            label: { show: true }
                        }
                    },
                    data: [320, 302, 341, 374, 390, 450, 420]
                },
                {
                    name: '票据',
                    type: 'bar',
                    stack: '总量',
                    itemStyle: {
                        normal: {
                            label: { show: true, position: 'left' }
                        }
                    },
                    data: [-120, -132, -101, -134, -190, -230, -210]
                }
            ]
        };
        function loadchart() {
            $("#main").width($(document).width() * 0.9);
            $("#main").height(1000);
            var myChart = echarts.init(document.getElementById('main'));
            myChart.showLoading();
            myChart.setOption(option);
            myChart.hideLoading();
        };
        $(function () {
            var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('table'));
            $.ajax({
                type: 'POST',
                url: '/Handlers/Reoprts.ashx',//注意单词Reoprts不是Reports，拼写错误，懒得改了
                data: { action: 'GetData1' },
                success: function suc(result) {
                    $("#tablebody").empty();
                    //绑定数据
                    for (var i = 0; i < result.data.length; i++) {
                        var shtml = "";
                        shtml = shtml.concat("<tr" + (i % 2 == 0 ? " class='warning'" : "") + ">");
                        shtml = shtml.concat("<td>" + result.data[i].bname + "</td>");
                        shtml = shtml.concat("<td style='text-align: right'>" + result.data[i].total + "</td>");
                        shtml = shtml.concat("<td style='text-align: right'>" + result.data[i].cash + "</td>");
                        shtml = shtml.concat("<td style='text-align: right'>" + result.data[i].note + "</td>");
                        shtml = shtml.concat("</tr>");
                        $("#tablebody").append(shtml);
                        spinner1.stop();
                    }
                    option.yAxis[0].data = result.data0;
                    option.series[0].data = result.data1.list1;
                    option.series[1].data = result.data1.list2;
                    option.series[2].data = result.data1.list3;
                    loadchart();
                },
                dataType: 'JSON'
            });
        });
    </script>
    <script src="/dist/echarts.js"></script>
</head>
<body>
    <div class="page-header">
        <h3 style="text-align: center">资金余额表<small style="text-align: right">&nbsp;&nbsp;&nbsp;单位(万元)</small></h3>
    </div>
    <table id="table" class="table table-bordered">
        <thead>
            <tr class="info">
                <th rowspan="2" style="text-align: center; vertical-align: middle">公司</th>
                <th rowspan="2" style="text-align: center; vertical-align: middle">资金余额</th>
                <th colspan="2" style="text-align: center; vertical-align: middle">其中</th>
            </tr>
            <tr class="info">
                <th style="text-align: center; vertical-align: middle">现汇</th>
                <th style="text-align: center; vertical-align: middle">承兑</th>
            </tr>
        </thead>
        <tbody id="tablebody">
        </tbody>
        <%--        <tr class="warning">
            <td>销售分公司</td>
            <td style="text-align: right">1212212</td>
            <td style="text-align: right">32455454</td>
            <td style="text-align: right">32455454</td>
        </tr>
        <tr>
            <td style="text-align: right">销售分公司</td>
            <td style="text-align: right">1212212</td>
            <td style="text-align: right">32455454</td>
            <td style="text-align: right">32455454</td>
        </tr>--%>
    </table>
    <div id="main"></div>
</body>
</html>
