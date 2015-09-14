<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NodeView.aspx.cs" Inherits="ZDCharts.WorkFlow.NodeView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <link href="../Content/bootstrap-select.min.css" rel="stylesheet" />
    <link href="../Content/bootstrap-switch/bootstrap3/bootstrap-switch.min.css" rel="stylesheet" />
    <link href="../Content/myStyle.css" rel="stylesheet" />
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <script src="../Scripts/bootstrap-select.min.js"></script>
    <script src="../Scripts/bootstrap-switch.min.js"></script>
    <script src="../Scripts/spin.min.js"></script>
    <script src="../Scripts/myjs.js"></script>
    <script type="text/javascript">
        function listclear() {
            $("#listdiv").empty();
        }
        function loadcompany() {
            //清空提交按钮
            $("#curnodeid").val("");
            $(window.parent.document).find("#pendspan").text("");
            //加载中动画开启
            var spinner = new Spinner(getSpinOpts()).spin(document.getElementById('listdiv'));
            //获取待审批单据，绑定到列表
            $.ajax({
                type: 'POST',
                url: '../Handlers/WFFlow1.ashx',
                data: { action: 'GetListGroupByCompany' },
                success: function suc(result) {
                    //alert(JSON.stringify(result));
                    //请求失败跳转到错误页
                    if (result.code != "0") {
                        redirecToErrorPage(result);
                        return;
                    }
                    //绑定数据
                    if (result.data == null || result.data.length <= 0) {
                        $("#listdiv").append("无数据");
                        spinner.stop();
                        return;
                    }
                    listclear();
                    for (var i = 0; i < result.data.length; i++) {
                        var shtml = "";
                        //alert(JSON.stringify(result.data));
                        shtml = shtml.concat("<a id='" + "a" + i.toString() + "' href='javascript:void(0)' companyid='" + result.data[i].CompanyID + "' class='list-group-item'><span class='badge'>" + result.data[i].Total + "</span>" + result.data[i].CompanyName + "</a>");
                        $("#listdiv").append(shtml);
                        //公司列表单击事件
                        $("#a" + i.toString()).click(function () {
                            //loadcontract($(this).attr("companyid"));
                            loadexpense($(this).attr("companyid"));
                        });
                    }
                    spinner.stop();
                },
                dataType: 'JSON'
            });
        }

        function loadcontract(myid) {
            listclear();
            var spinner2 = new Spinner(getSpinOpts()).spin(document.getElementById('listdiv'));
            //获取待审批单据，绑定到列表,客户列表事件
            $.ajax({
                type: 'POST',
                url: '../Handlers/WFFlow1.ashx',
                data: { action: 'GetList', myid: myid },
                success: function suc(result) {
                    //请求失败跳转到错误页
                    if (result.code != "0") {
                        redirecToErrorPage(result);
                        return;
                    }
                    if (result.data == null || result.data.length <= 0) {
                        $("#listdiv").append("无数据");
                        spinner1.stop();
                        return;
                    }
                    listclear();
                    //显示资金池余额
                    //获取资金池余额
                    $.ajax({
                        "type": "POST",
                        "url": "../handlers/Finance.ashx",
                        "dataType": "json",
                        "data": { Action: 'GetBalanceBy1221', companyid: "company2", DocID: myid }, // 以json格式传递
                        "success": function (resp) {
                            var bal = eval("(" + resp.data + ")");
                            //$("#balrmb4").html(bal.rmb4);
                            //$("#balnote4").html(bal.note4);
                            //$("#baltotal4").html(bal.total4);
                            var ss = "<a href='#' class='list-group-item' nodeid='node1'>";
                            ss += "<div class='panel panel-primary'>";
                            ss += "<div class='panel-heading'>资金池余额</div>";
                            ss += "<div class='panel-body'>";
                            ss += "<table class='table  table-striped'>";
                            ss += "<tr><td>合计:</td><td class='numFormat'>" + bal.total4 + "</td></tr>";
                            ss += "<tr><td>现汇:</td><td class='numFormat'>" + bal.rmb4 + "</td></tr>";
                            ss += "<tr><td>票据:</td><td class='numFormat'>" + bal.note4 + "</td></tr>";
                            ss += "</table></div></div></a>";
                            $("#listdiv").prepend(ss);
                            $("#listdiv").prepend("<a href='javascript: loadcompany() ' class='list-group-item list-group-item-success'>返回上级</a>");
                        }
                    });
                    //绑定数据
                    for (var i = 0; i < result.data.length; i++) {
                        var shtml = "";
                        //if (i == 0) {
                        //    shtml = shtml.concat("<a href='javascript: loadcompany() ' class='list-group-item list-group-item-success'>返回上级</a>");
                        //}
                        //alert(result.data[i].FID);
                        shtml = shtml.concat("<a class='list-group-item' nodeid='N" + result.data[i].WF4RowID + "'>");
                        shtml = shtml.concat("<div class='panel panel-primary'>");
                        shtml = shtml.concat("<div class='panel-heading'> <span fid='N" + result.data[i].WF4RowID + "' class='glyphicon glyphicon-asterisk' aria-hidden='true' result='O'></span>&nbsp;" + result.data[i].CompanyName + "</div>");
                        shtml = shtml.concat("<div class='panel-body'>");
                        shtml = shtml.concat("<table class='table  table-striped'>");
                        shtml = shtml.concat("<tr><td>摘要:</td><td class='numFormat'></td></tr>");
                        shtml = shtml.concat("<tr><td colspan='2'>" + (result.data[i].FName == null ? "" : result.data[i].Todo) + "</td></tr>");
                        shtml = shtml.concat("<tr><td>本次:</td><td class='numFormat'><h4><span class='label label-success'>" + result.data[i].WF4RowRmb + "</span></h4></td></tr>");
                        shtml = shtml.concat("<tr><td>申请人:</td><td class='numFormat'>" + result.data[i].Creater + "</td></tr>");
                        shtml = shtml.concat("<tr><td>日期:</td><td class='numFormat'>" + result.data[i].CreatedDate + "</td></tr>");
                        shtml = shtml.concat("</table></div>");
                        shtml = shtml.concat("<div class='panel-footer'>");
                        shtml = shtml.concat("<div class='btn-group' data-toggle='buttons'>");
                        shtml = shtml.concat("<label class='btn btn-default active'>");
                        shtml = shtml.concat("<input type='radio' result='O' name='options" + i.toString() + "' nodeid='N" + result.data[i].WF4RowID + "' autocomplete='off' checked>待定");
                        shtml = shtml.concat("</label>");
                        shtml = shtml.concat("<label class='btn btn-default'>");
                        shtml = shtml.concat("<input type='radio' result='Y'  name='options" + i.toString() + "' nodeid='N" + result.data[i].WF4RowID + "' autocomplete='off'>通过");
                        shtml = shtml.concat("</label>");
                        shtml = shtml.concat("<label class='btn btn-default'>");
                        shtml = shtml.concat("<input type='radio' result='N'  name='options" + i.toString() + "' nodeid='N" + result.data[i].WF4RowID + "' autocomplete='off'>拒绝");
                        shtml = shtml.concat("</label>");
                        shtml = shtml.concat("</div>");
                        //shtml = shtml.concat("<input  avalue='Y' name='c" + i.toString() + "' data-label-text='同意' type='radio' flowid='" + result.data[i].FID + "'>&nbsp;&nbsp;");
                        //shtml = shtml.concat("<input  avalue='N' name='c" + i.toString() + "' data-label-text='拒绝' type='radio' flowid='" + result.data[i].FID + "'>");
                        shtml = shtml.concat("</div></div></a>");
                        $("#listdiv").append(shtml);

                        $("input[type='radio']").change(function () {

                            var sp = $("span[fid='" + $(this).attr('nodeid') + "']");
                            sp.removeClass("glyphicon glyphicon-asterisk");
                            sp.removeClass("glyphicon glyphicon-ok");
                            sp.removeClass("glyphicon glyphicon-remove");
                            if ($(this).parent().text() == "通过") {
                                sp.addClass("glyphicon glyphicon-ok");
                                sp.attr("result", "Y");
                            }
                            else if ($(this).parent().text() == "拒绝") {
                                sp.addClass("glyphicon glyphicon-remove");
                                sp.attr("result", "N");
                            }
                            else {
                                sp.addClass("glyphicon glyphicon-asterisk");
                                sp.attr("result", "O");
                            }
                            //return;

                            //设置首页提交确认按钮数字图标
                            var pcount = $(".glyphicon-ok,.glyphicon-remove").length;
                            if (pcount == 0) {
                                $(window.parent.document).find("#pendspan").text("");
                            } else {
                                $(window.parent.document).find("#pendspan").text($(".glyphicon-ok,.glyphicon-remove").length);
                            }
                        });
                    }
                    spinner2.stop();
                },
                dataType: 'JSON'
            });
        }

        function loadexpense(companyid) {
            //清空提交按钮
            $("#curnodeid").val("");
            $(window.parent.document).find("#pendspan").text("");
            //加载中动画开启
            var spinner = new Spinner(getSpinOpts()).spin(document.getElementById('listdiv'));
            //获取待审批单据，绑定到列表
            $.ajax({
                type: 'POST',
                url: '../Handlers/WFFlow1.ashx',
                data: { action: 'GetListGroupByDoc', companyid: companyid },
                success: function suc(result) {
                    //alert(JSON.stringify(result));
                    //请求失败跳转到错误页
                    if (result.code != "0") {
                        redirecToErrorPage(result);
                        return;
                    }
                    listclear();
                    //绑定数据
                    if (result.data == null || result.data.length <= 0) {
                        $("#listdiv").append("无数据");
                        spinner.stop();
                        return;
                    }

                    for (var i = 0; i < result.data.length; i++) {
                        var shtml = "";
                        //alert(JSON.stringify(result.data));
                        shtml = shtml.concat("<a id='" + "a" + i.toString() + "' href='javascript:void(0)' myid='" + result.data[i].ID + "' class='list-group-item'><span class='badge'>" + result.data[i].RmbType + "</span><span class='badge'>" + result.data[i].Rmb + "</span>" + result.data[i].FName + "</a>");
                        $("#listdiv").append(shtml);
                        //公司列表单击事件
                        $("#a" + i.toString()).click(function () {
                            //alert(1);
                            loadcontract($(this).attr("myid"));
                        });
                    }
                    spinner.stop();
                },
                dataType: 'JSON'
            });
        }

        $(document).ready(function () {

            loadcompany();

            //commit按钮事件
            $("#commitBtn").click(function commit() {
                var pendingdata = $("#curnodeid").val();
                var spinner2 = new Spinner(getSpinOpts()).spin(document.getElementById('agreebtn'));
                $.ajax({
                    type: 'POST',
                    url: '../Handlers/WFFlow1.ashx',
                    data: { action: 'Commit', pendingdata: pendingdata },
                    success: function suc(result) {
                        if (result.code != "0") {
                            redirecToErrorPage(result);
                            return;
                        }
                        listclear();
                        loadcompany();
                        $("#curnodeid").val("");
                        $(window.parent.document).find("#pendspan").text("");
                        spinner2.stop();
                        $('#myModal').modal('hide');
                    },
                    dataType: 'JSON'
                });
            });
            //cannel按钮事件
            $("#cannelBtn").click(function () {
                $('#myModal').modal('hide');
            });
        });
        //弹出审批确认框
        function showmodal() {
            //显示弹出框
            $("#myModal").modal();
            //待审批单据编号与状态获取
            var pendArr = [];
            $("span.glyphicon-ok,.glyphicon-remove").each(function (i, item) {
                var f = {};
                f.fid = $(item).attr("fid");
                if ($(item).attr("result") == "Y") {
                    f.result = "Y";
                }
                if ($(item).attr("result") == "N") {
                    f.result = "N";
                }
                pendArr.push(f);
            });
            //审批需要数据绑定到curnodeid
            $("#curnodeid").val(JSON.stringify(pendArr));
        }
    </script>
</head>
<body style="margin-right: 10px">
    <!--审批确认弹出层-->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h3 class="modal-title" id="myModalLabel">确认</h3>
                </div>
                <div class="modal-body">
                    <input id="curnodeid" type="hidden" />
                    <button id="commitBtn" type="button" class="btn btn-success btn-lg btn-block">确定</button>
                    <br />
                    <button id="cannelBtn" type="button" class="btn btn-danger btn-lg btn-block" data-dismiss="modal">取消</button>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <div class="list-group" id="listdiv">

        <!--<a href="#" class="list-group-item active">
            Cras justo odio
        </a>-->
        <!--行模板-->
        <!--<a href="#" class="list-group-item" nodeid="node1">
            <div class="panel panel-primary">
                <div class="panel-heading">辽宁艾美集团生物疫苗有限公司</div>
                <div class="panel-body">
                    <table class="table  table-striped">
                        <tr><td>合同号:</td><td class="numFormat">AM2015-00021</td></tr>
                        <tr><td>金额:</td><td class="numFormat">3,600,000</td></tr>
                        <tr><td>已付:</td><td class="numFormat">1,600,000</td></tr>
                        <tr><td>发票:</td><td class="numFormat">2,000.000</td></tr>
                        <tr><td>本次:</td><td class="numFormat"><h4><span class="label label-success">400,000</span></h4></td></tr>
                        <tr><td>标号:</td><td class="numFormat">AM2015-11212</td></tr>
                        <tr><td>申请人:</td><td class="numFormat">张三</td></tr>
                        <tr><td>日期:</td><td class="numFormat">2015-1-2</td></tr>
                    </table>
                </div>
                <div class="panel-footer">备注:着急发货，已备案</div>
            </div>
        </a>-->
    </div>
</body>
</html>
