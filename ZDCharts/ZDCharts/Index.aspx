<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ZDCharts.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>资金审批系统</title>

    <script src="Scripts/jquery-2.1.3.min.js"></script>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/bootstrap-select.min.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/bootstrap-select.min.js"></script>
    <link href="Content/myStyle.css" rel="stylesheet" />
</head>
<body>
    <input id="userinfoinput" type="hidden" value="" runat="server" />
    <div id="userinfodiv">
        <!--<a href="#">张三</a>-->
        <input id="inputUser" type="hidden" />
    </div>
    <div id="nav1" class="btn-group btn-group-justified" role="group" aria-label="...">
        <div class="btn-group" role="group">
            <button type="button" class="btn btn-default isActive" urlstr="CashViews/NewMsg.html">合同付款</button>
        </div>
        <div class="btn-group" role="group">
            <button type="button" class="btn btn-default" urlstr="WorkFlow/NodeView.aspx">费用审批</button>
        </div>
        <div class="btn-group" role="group">
            <button type="button" class="btn btn-default">其他</button>
        </div>
    </div>
    <iframe id="mainform" frameborder="0" scrolling="auto" marginheight="0" marginwidth="0" width="100%" style="overflow-x: hidden"></iframe>
    <div id="d1">
        <button id="commitbtn" type="button" class="btn btn-info btn-lg btn-block">提交&nbsp;&nbsp;<span id="pendspan" class="badge"></span></button>
    </div>
</body>
</html>
<!-- JavaScript Test Zone -->
<script type="text/javascript">
    //扩展jquray获取URL参数方法
    (function ($) {
        $.getUrlParam = function (name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
    })(jQuery);
    //USER赋值
    var u = {};
    u.uid = $.getUrlParam("uid");
    u.psw = $.getUrlParam("psw")
    $("#inputUser").val(JSON.stringify(u));
    //alert($.getUrlParam("uid"));
    $(document).ready(function () {
        //初始化IFRAME高度
        $('#mainform').height($(window).height() - $('#userinfodiv').height() - $('#nav1').height() - $('#d1').height() - 10);
        //定时更新IFRAME高度，间隔1000毫秒
        setInterval(function () {
            $('#mainform').height($(window).height() - $('#userinfodiv').height() - $('#nav1').height() - $('#d1').height() - 10);
        }, 1000)
        //添加导航选项卡点击事件
        $(".btn-default").click(function () {
            //设置所有选项卡为不激活样式
            $(".btn-default").each(function () {
                $(this).removeClass("isActive");
            });
            //设置选中选项卡为激活样式
            $(this).addClass("isActive");
            //设置URL加载IFRAME内容
            $("#mainform").attr("src", $(this).attr("urlstr"));
        });
        //默认选中第一个选项卡
        $(".btn-default")[0].click();
        //提交按钮点击事件
        $("#commitbtn").click(function () {
            if ($("#pendspan").text() == "")
                return;
            //调用子NewMsg.html页面方法
            $("#mainform")[0].contentWindow.showmodal();
        });
    });
</script>




