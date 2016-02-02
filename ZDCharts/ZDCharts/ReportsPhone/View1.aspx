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
    <script src="../Scripts/spin.min.js"></script>
    <script src="../Scripts/myjs.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#collapse1').collapse('toggle');
            $("#enterBtn").click(function () {
                $('#collapse1').collapse('toggle');
                $('#collapse2').collapse('toggle');
                //$("#listdiv").append("<a href='javascript: doagain()' class='list-group-item list-group-item-success'>更改查询条件</a>");
                loadcompany();
            });
        })
        //重查
        function doagain() {
            $('#collapse1').collapse('toggle');
            $('#collapse2').collapse('toggle');
        }
        function loadcompany() {
            var filter = {};
            filter.date1 = $("#date1").val();
            filter.date2 = $("#date2").val();
            filter.ctype = $("#ctype").val();
            filter.cstatus = $("#cstatus").val();
            var titlecss = "";
            if ($("#cstatus").val() == "同意") {
                titlecss = " panel-success";
            } else {
                titlecss = " panel-danger";
            }
            var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('listdiv'));
            $.ajax({
                "type": "POST",
                "url": "/handlers/Quary1.ashx",
                "dataType": "json",
                "data": { Action: 'GetContractCashListByCompany', filter: JSON.stringify(filter) }, // 以json格式传递
                "success": function (resp) {
                    $("#listdiv").empty();
                    if (resp.data.length == 0) {
                        $("#listdiv").append("无数据");
                    }
                    for (var i = 0; i < resp.data.length; i++) {
                        var shtml = "";
                        if ($("#ctype").val() == "合同") {
                            //alert()
                            shtml = shtml.concat("<a mark='r' ctype='c' href='javascript:void(0)' companyid='" + resp.data[i].CompanyID + "' class='list-group-item'><span class='badge'>" + resp.data[i].Total + "</span>" + resp.data[i].CompanyName + "</a>");

                        } else {
                            shtml = shtml.concat("<a mark='r'  ctype='e' href='javascript:void(0)' companyid='" + resp.data[i].CompanyID + "' class='list-group-item'><span class='badge'>" + resp.data[i].Total + "</span>" + resp.data[i].CompanyName + "</a>");
                        }
                        $("#listdiv").append(shtml);
                    }
                    $("a[mark='r']").click(function () {
                        if ($(this).attr("ctype") == "c") {
                            loadcontractbycustomer($(this).attr("companyid"));
                        } else {
                            loadlist($(this).attr("companyid"));
                        }
                    });
                    spinner1.stop();
                }
            });
        }

        function loadcontractbycustomer(companyid) {
            var filter = {};
            filter.date1 = $("#date1").val();
            filter.date2 = $("#date2").val();
            filter.ctype = $("#ctype").val();
            filter.cstatus = $("#cstatus").val();
            var titlecss = "";
            if ($("#cstatus").val() == "同意") {
                titlecss = " panel-success";
            } else {
                titlecss = " panel-danger";
            }
            var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('listdiv'));
            $.ajax({
                "type": "POST",
                "url": "/handlers/Quary1.ashx",
                "dataType": "json",
                "data": { Action: 'GetContractCashListByCustomer', filter: JSON.stringify(filter), companyid: companyid }, // 以json格式传递
                "success": function (resp) {
                    $("#listdiv").empty();
                    if (resp.data.length == 0) {
                        $("#listdiv").append("无数据");
                    }
                    for (var i = 0; i < resp.data.length; i++) {
                        var shtml = "";
                        shtml = shtml.concat("<a mark='r1' ctype='c' href='javascript:void(0)' customerid='" + resp.data[i].CustomerID + "' class='list-group-item'><span class='badge'>" + resp.data[i].Total + "</span>" + resp.data[i].CustomerName + "</a>");
                        $("#listdiv").append(shtml);
                        $("a[mark='r1']").click(function () {
                            loadlist($(this).attr("customerid"));
                        });
                    }
                    spinner1.stop();
                }
            });
        }

        function loadlist(id) {
            var filter = {};
            filter.date1 = $("#date1").val();
            filter.date2 = $("#date2").val();
            filter.ctype = $("#ctype").val();
            filter.cstatus = $("#cstatus").val();
            var titlecss = "";
            if ($("#cstatus").val() == "同意") {
                titlecss = " panel-success";
            } else {
                titlecss = " panel-danger";
            }
            var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('listdiv'));
            $.ajax({
                "type": "POST",
                "url": "/handlers/Quary1.ashx",
                "dataType": "json",
                "data": { Action: 'GetContractCashList', filter: JSON.stringify(filter), id: id }, // 以json格式传递
                "success": function (resp) {
                    $("#listdiv").empty();
                    $("#listdiv").append("<a href='javascript: loadcompany()' class='list-group-item list-group-item-success'>返回</a>");
                    if (resp.data.length == 0) {
                        $("#listdiv").append("无数据");
                    }
                    for (var i = 0; i < resp.data.length; i++) {
                        var shtml = "";
                        if ($("#ctype").val() == "合同") {
                            shtml = shtml.concat("<a class='list-group-item'>");
                            shtml = shtml.concat("<div class='panel" + titlecss + "'>");
                            shtml = shtml.concat("<div class='panel-heading'> <span class='glyphicon glyphicon-asterisk' aria-hidden='true'></span>&nbsp;" + resp.data[i].CashItems.CompanyName + "</div>");
                            shtml = shtml.concat("<div class='panel-body'>");
                            shtml = shtml.concat("<table class='table  table-striped'>");
                            shtml = shtml.concat("<tr><td>客户:</td><td class='numFormat'>" + resp.data[i].CashItems.CNAME + "</td></tr>");
                            shtml = shtml.concat("<tr><td>金额:</td><td class='numFormat'>" + resp.data[i].CashItems.Total + "</td></tr>");
                            shtml = shtml.concat("<tr><td>审批日期:</td><td class='numFormat'>" + resp.data[i].Nodes.CreatedDate + "</td></tr>");
                            shtml = shtml.concat("<tr><td>资金项目:</td><td class='numFormat'>" + resp.data[i].CashItems.NCodeCName + "</td></tr>");
                            shtml = shtml.concat("<tr><td>状态:</td><td class='numFormat'>" + resp.data[i].CashItems.ApprovalStatusName + "</td></tr>");
                            shtml = shtml.concat("<tr><td>现汇:</td><td class='numFormat'>" + resp.data[i].CashItems.Cash + "</td></tr>");
                            shtml = shtml.concat("<tr><td>票据:</td><td class='numFormat'>" + resp.data[i].CashItems.Note + "</td></tr>");
                            shtml = shtml.concat("<tr><td>退票据:</td><td class='numFormat'>" + resp.data[i].CashItems.MinusNote + "</td></tr>");
                            shtml = shtml.concat("<tr><td>审批人:</td><td class='numFormat'>" + resp.data[i].Emp.EmpName + "</td></tr>");
                            shtml = shtml.concat("</table></div>");
                            shtml = shtml.concat("<div class='panel-footer'>");
                            shtml = shtml.concat("</div></div></a>");
                        } else {
                            shtml = shtml.concat("<a class='list-group-item'><span class='badge'>" + resp.data[i].Expenses.Rmb + "</span>" + resp.data[i].Expenses.FName);
                            shtml = shtml.concat("<div class='collapse'>");
                            shtml = shtml.concat("<br/>");
                            shtml = shtml.concat("<div class='panel" + titlecss + "'>");
                            shtml = shtml.concat("<div class='panel-heading'> <span class='glyphicon glyphicon-asterisk' aria-hidden='true'></span>&nbsp;" + resp.data[i].Expenses.CompanyName + "</div>");
                            shtml = shtml.concat("<div class='panel-body'>");
                            shtml = shtml.concat("<table class='table  table-striped'>");
                            shtml = shtml.concat("<tr><td>摘要:</td><td class='numFormat'>" + resp.data[i].Expenses.FName + "</td></tr>");
                            shtml = shtml.concat("<tr><td>金额:</td><td class='numFormat'>" + resp.data[i].Expenses.Rmb + "</td></tr>");
                            shtml = shtml.concat("<tr><td>审批日期:</td><td class='numFormat'>" + resp.data[i].Nodes.CreatedDate + "</td></tr>");
                            shtml = shtml.concat("<tr><td>状态:</td><td class='numFormat'>" + resp.data[i].Expenses.ApprovalStatusName + "</td></tr>");
                            shtml = shtml.concat("<tr><td>类型:</td><td class='numFormat'>" + resp.data[i].Expenses.RmbType + "</td></tr>");
                            shtml = shtml.concat("<tr><td>审批人:</td><td class='numFormat'>" + resp.data[i].Emp.EmpName + "</td></tr>");
                            shtml = shtml.concat("</div></div>");
                            //shtml = shtml.concat("<div class='panel-footer'>");
                            shtml = shtml.concat("</div></div></a>");
                        }
                        $("#listdiv").append(shtml);
                    }
                    $(".list-group-item").click(function () {
                        $(this).find(".collapse").collapse('toggle');
                    });
                    spinner1.stop();
                }
            });
        }
    </script>
</head>
<body style="margin: 1px">
    <div class="collapse" id="collapse1">
        <div class="form-group">
            <label for="date1">开始日期(不填默认3天前)</label>
            <input type="date" class="form-control" id="date1" placeholder="密码" runat="server" />
        </div>
        <div class="form-group">
            <label for="date2">结束日期(不填默认当天)</label>
            <input type="date" class="form-control" id="date2" placeholder="密码确认" runat="server" />
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
        <br />
        <a href="../ChartViews/ChartList.aspx" class="btn btn-danger btn-lg btn-block">
            <span class="glyphicon glyphicon-stats" aria-hidden="true"></span>图表
        </a>
        <br />
        <a href="ReprotList.aspx" class="btn btn-success btn-lg btn-block">
            <span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>报表
        </a>
        <div id="msg" runat="server"></div>
    </div>
    <div class="collapse" id="collapse2">
        <button type="button" class="btn  btn-info btn-lg btn-block" onclick="doagain()">更改查询条件</button>
        <div class="list-group" id="listdiv">
            <%--<a class='list-group-item'>
                <div class='panel panel-danger'>
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
                </div>
            </a>--%>
        </div>
    </div>
</body>
</html>
