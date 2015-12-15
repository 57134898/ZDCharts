<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="View1.aspx.cs" Inherits="ZDCharts.ReportsPhone.View1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>查询</title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#collapse1').collapse('toggle');
            $("#enterBtn").click(function () {
                $('#collapse1').collapse('toggle');
                $('#collapse2').collapse('toggle');
                $("#listdiv").empty();
                $("#listdiv").append("<a href='javascript: doagain()' class='list-group-item list-group-item-success'>更改查询条件</a>");
                var filter = {};
                filter.date1 = $("#date1").val();
                filter.date2 = $("#date2").val();
                filter.ctype = $("#ctype").val();
                filter.cstatus = $("#cstatus").val();
                $.ajax({
                    "type": "POST",
                    "url": "/handlers/Quary1.ashx",
                    "dataType": "json",
                    "data": { Action: 'GetContractCashList', filter: JSON.stringify(filter) }, // 以json格式传递
                    "success": function (resp) {

                        for (var i = 0; i < resp.data.length; i++) {
                            //alert(resp.data[i].CashItems.CNAME);
                            var shtml = "";
                            shtml = shtml.concat("<a class='list-group-item'>");
                            shtml = shtml.concat("<div class='panel panel-primary'>");
                            shtml = shtml.concat("<div class='panel-heading'> <span class='glyphicon glyphicon-asterisk' aria-hidden='true'></span>&nbsp;" + resp.data[i].CashItems.CNAME + "</div>");
                            shtml = shtml.concat("<div class='panel-body'>");
                            shtml = shtml.concat("<table class='table  table-striped'>");
                            shtml = shtml.concat("<tr><td>资金项目:</td><td class='numFormat'>" + "2222" + "</td></tr>");
                            shtml = shtml.concat("</table></div>");
                            shtml = shtml.concat("<div class='panel-footer'>");
                            shtml = shtml.concat("</div></div></a>");
                            $("#listdiv").append(shtml);
                            $("#tem").val(shtml);
                        }
                    }
                });
            });
        })
        //重查
        function doagain() {
            $('#collapse1').collapse('toggle');
            $('#collapse2').collapse('toggle');
        }
    </script>
</head>
<body style="margin: 1px">
    <div class="collapse" id="collapse1">
        <div class="form-group">
            <label for="date1">开始日期</label>
            <input type="date" class="form-control" id="psw1" placeholder="密码" runat="server" />
        </div>
        <div class="form-group">
            <label for="date2">结束日期</label>
            <input type="date" class="form-control" id="psw2" placeholder="密码确认" runat="server" />
        </div>
        <div class="form-group">
            <label class="control-label">类型</label>
            <select id="ctype" data-width="100%" class="form-control">
                <option>合同</option>
                <option>费用</option>
            </select>
        </div>
        <div class="form-group">
            <label class="control-label">审批结果</label>
            <select id="cstatus" data-width="100%" class="form-control">
                <option>同意</option>
                <option>拒绝</option>
            </select>
        </div>
        <button id="enterBtn" type="button" data-toggle="popover" class="btn btn-primary btn-lg btn-block">查询</button>
        <div id="msg" runat="server"></div>
    </div>
    <div class="collapse" id="collapse2">
        <div class="list-group" id="listdiv">

            <a class='list-group-item'>
                <%--<div class='panel panel-primary'>
                    <div class='panel-heading'><span class='glyphicon glyphicon-asterisk' aria-hidden='true'></span>&nbsp;11111</div>
                    <div class='panel-body'>
                        <table class='table  table-striped'>
                            <tr>
                                <td>资金项目:</td>
                                <td class='numFormat'>2222</td>
                            </tr>
                        </table>
                    </div>
                    <div class='panel-footer'></div>
                </div>--%>
            </a>
        </div>
    </div>

</body>
</html>
