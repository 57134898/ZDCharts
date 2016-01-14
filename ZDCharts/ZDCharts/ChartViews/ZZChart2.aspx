<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZZChart2.aspx.cs" Inherits="ZDCharts.ChartViews.ZZChart2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>费用情况</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <script src="/Scripts/bootstrap.min.js"></script>
    <script src="/dist/echarts3-0.min.js"></script>
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
                data: { Action: "GetCompanyList" },
                success: function suc(result) {
                    for (var i = 0; i < result.data.length; i++) {
                        $("#company").append(" <option>" + result.data[i].bcode + "-" + result.data[i].shortname + "</option>");
                    }
                },
                dataType: 'JSON'
            });
            $('#collapse1').collapse('toggle');
        });
        function loadchart() {
            $("#main").width($(document).width() * 0.9);
            $("#main").height($(document).height() * 0.8);
            //alert($(document.body).width() + "|" + $(document).height());
            var myChart = echarts.init(document.getElementById('main'));
            myChart.showLoading();

            option = {
                title: { text: '费用支出' },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b}: {c} ({d}%)"
                },
                legend: {
                    top: 50,
                    orient: 'vertical',
                    x: 'left',
                    data: []
                },
                toolbox: {
                    show: true,
                    feature: {
                        mark: { show: true },
                        dataView: { show: true, readOnly: false },
                        magicType: {
                            show: true,
                            type: ['pie', 'funnel']
                        },
                        restore: { show: true },
                        saveAsImage: { show: true }
                    }
                },
                calculable: false,
                grid: {
                    x: '30%',
                },
                series: [
                    {
                        name: '类型',
                        type: 'pie',
                        selectedMode: 'single',
                        radius: [0, '30%'],

                        label: {
                            normal: {
                                position: 'inner'
                            }
                        },
                        labelLine: {
                            normal: {
                                show: false
                            }
                        },
                        data: []
                    },
                    {
                        name: '资金项目',
                        type: 'pie',
                        radius: ['40%', '55%'],
                        data: []
                    }
                ]
            };

            $.ajax({
                type: 'POST',
                url: '/Handlers/Charts.ashx',
                data: { Action: "GetData2", company: $("#company").find("option:selected").text(), year: $("#year").find("option:selected").text(), month: $("#month").find("option:selected").text() },
                success: function suc(result) {
                    option.legend.data = result.data.list1;
                    option.series[0].data = result.data.list2;
                    option.series[1].data = result.data.list3;
                    myChart.setOption(option);
                    myChart.hideLoading();
                },
                dataType: 'JSON'
            });
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
            <label class="control-label">公司</label>
            <select id="company" data-width="100%" class="form-control" style="width: '100%'; height: '100%'">
                <option>全部</option>
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
