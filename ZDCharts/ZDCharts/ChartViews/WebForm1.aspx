<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ZDCharts.ChartViews.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/spin.js"></script>
    <script src="../dist/echarts.js"></script>

</head>
<body>
    <form id="f1" runat="server">
        <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
        <div id="loadingdiv" />
        <div id="main" style="height: 400px;"></div>
        <!-- ECharts单文件引入 -->
        <script type="text/javascript">
            $(document).ready(function () {
                var opts = {
                    lines: 12, // The number of lines to draw
                    length: 7, // The length of each line
                    width: 5, // The line thickness
                    radius: 10, // The radius of the inner circle
                    corners: 1, // Corner roundness (0..1)
                    rotate: 0, // The rotation offset
                    direction: 1, // 1: clockwise, -1: counterclockwise
                    color: '#000', // #rgb or #rrggbb or array of colors
                    speed: 1, // Rounds per second
                    trail: 100, // Afterglow percentage
                    shadow: true, // Whether to render a shadow
                    hwaccel: false, // Whether to use hardware acceleration
                    className: 'spinner', // The CSS class to assign to the spinner
                    zIndex: 2e9, // The z-index (defaults to 2000000000)
                    top: '30%', // Top position relative to parent
                    left: '50%' // Left position relative to parent
                };
                var target = $("#loadingdiv").get(0);

                var spinner = new Spinner(opts).spin(target);

                function success(data) {
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
                            var option = {
                                tooltip: {
                                    show: true
                                },
                                legend: {
                                    data: ['销量']
                                },
                                xAxis: [
                                    {
                                        type: 'category',
                                        data: data
                                    }
                                ],
                                yAxis: [
                                    {
                                        type: 'value'
                                    }
                                ],
                                series: [
                                    {
                                        "name": "销量",
                                        "type": "bar",
                                        "data": [5, 20, 40, 10, 10, 20]
                                    }
                                ]
                            };
                            myChart.setOption(option);
                        }
                    );
                    spinner.spin();
                }



                $.ajax({
                    type: 'POST',
                    url: '../Handlers/Handler1.ashx',
                    data: {},
                    success: success,
                    dataType: 'JSON'
                });
            });
        </script>
    </form>
</body>
</html>
