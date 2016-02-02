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
    <script type="text/javascript">
        //重查
        function addKannma(number) {
            var num = number + "";
            num = num.replace(new RegExp(",", "g"), "");
            // 正负号处理   
            var symble = "";
            if (/^([-+]).*$/.test(num)) {
                symble = num.replace(/^([-+]).*$/, "$1");
                num = num.replace(/^([-+])(.*)$/, "$2");
            }

            if (/^[0-9]+(\.[0-9]+)?$/.test(num)) {
                var num = num.replace(new RegExp("^[0]+", "g"), "");
                if (/^\./.test(num)) {
                    num = "0" + num;
                }

                var decimal = num.replace(/^[0-9]+(\.[0-9]+)?$/, "$1");
                var integer = num.replace(/^([0-9]+)(\.[0-9]+)?$/, "$1");

                var re = /(\d+)(\d{3})/;

                while (re.test(integer)) {
                    integer = integer.replace(re, "$1,$2");
                }
                return symble + integer + decimal;

            } else {
                return number;
            }
        }
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
                },
                dataType: 'JSON'
            });
        });
    </script>
    <script src="/dist/echarts.js"></script>
</head>
<body>
    <br />
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
</body>
</html>
