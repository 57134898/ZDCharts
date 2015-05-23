<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IndexPC.aspx.cs" Inherits="ZDCharts.IndexPC" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>资金管理系统PC</title>
    <script src="Scripts/jquery-2.1.3.min.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.min.js"></script>
    <link href="Content/myStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            //setInterval(function () {
            //    $("iframe[mytype='tabpage']").height($(window).height() - 10 - $('#headdiv').outerHeight(true) - $('#tabs').outerHeight(true));
            //}, 1000);
            $.ajax({
                "type": "POST",
                "url": "../handlers/Sys.ashx",
                "dataType": "json",
                "data": { Action: 'GetMenuList' }, // 以json格式传递
                "success": function (result) {
                    //添加左侧菜单
                    var shtml = "";
                    var filterarray = $.grep(result.data, function (value) {
                        return value.ParID == "P";
                    });
                    $.each(filterarray, function (index, value) {
                        shtml = shtml.concat("<div class='panel panel-info'>");
                        shtml = shtml.concat(" <div class='panel-heading' role='tab' id='headingOne' data-parent='#accordion' data-toggle='collapse' data-target='#" + "MPanel" + index.toString() + "' aria-expanded='false' aria-controls='" + "MPanel" + index.toString() + "'>");
                        shtml = shtml.concat(value.MenuName);
                        shtml = shtml.concat("</div>");
                        shtml = shtml.concat("<div id='" + "MPanel" + index.toString() + "' class='panel-collapse collapse' role='tabpanel' aria-labelledby='" + "M" + index.toString() + "'>");
                        shtml = shtml.concat("<div class='list-group'>");
                        var filterarray1 = $.grep(result.data, function (value1) {
                            return value1.ParID == value.MenuID;
                        });
                        $.each(filterarray1, function (index1, value1) {
                            shtml = shtml.concat("<a href='javascript:void(0)' mark='menuitem' url='" + value1.URL + "' class='list-group-item text-center'>" + value1.MenuName + "</a>");
                        });
                        shtml = shtml.concat("</div>");
                        shtml = shtml.concat("</div>");
                        shtml = shtml.concat("</div>");
                    });
                    $("#accordion").append(shtml);
                    $("a[mark='menuitem']").click(function () {
                        //下一个TAB索引
                        var nexttabindex = $('#tabs a').length;
                        //添加TAB标题
                        shtml = "";
                        shtml = shtml.concat("<li id='" + "Th" + nexttabindex + "' role='presentation'>");
                        shtml = shtml.concat("<a href='#" + "Tb" + nexttabindex + "'>");
                        shtml = shtml.concat($(this).html());
                        shtml = shtml.concat("<span id='" + "Tc" + nexttabindex + "' class='glyphicon glyphicon-remove myspancss' aria-hidden='true'></span>");
                        shtml = shtml.concat("</a></li>");
                        $("#tabs").append(shtml);
                        //添加TAB内容
                        shtml = "";
                        shtml = shtml.concat("<div role='tabpanel' class='tab-pane' id='" + "Tb" + nexttabindex + "'>");
                        shtml = shtml.concat("<div class='embed-responsive embed-responsive-16by9'>");
                        shtml = shtml.concat(" <iframe  class='embed-responsive-item'  src='" + $(this).attr("url") + "'  mytype='tabpage' frameborder='0' scrolling='auto' marginheight='0' marginwidth='0' width='100%' style='overflow-x:hidden'></iframe>");
                        shtml = shtml.concat("</div>");
                        shtml = shtml.concat("</div>");
                        $("#tabcontents").append(shtml);
                        //alert($(this).attr("url"));
                        //设置tab初始化
                        $('#tabs a').click(function (e) {
                            e.preventDefault();
                            $(this).tab('show')
                        })

                        //最新tabpage打开
                        $('#tabs a:last').tab('show');
                        $("#Tc" + nexttabindex).click(function () {
                            $("#Th" + nexttabindex).remove();
                            $("#Tb" + nexttabindex).remove();
                            $('#tabs a:last').tab('show');
                            //alert("#Th" + nexttabindex);
                        });

                    });
                }
            });
        });
    </script>
</head>
<body>
    <input id="userinfoinput" value="" runat="server" />
    <div id="headdiv" class="head">
        <div style="float: left">
            <h3><font class="menufore">&nbsp;$$$ 资金管理系统</font></h3>
        </div>
        <div style="float: right; padding: 5px 5px 5px 5px">
            <h5><span class="label label-info"><font class="menufore">辽宁艾美生物疫苗技术有限公司</font></span></h5>
            <h5 class="inline"><span class="label label-info"><font class="menufore">财务部</font></span></h5>
            <h5 class="inline"><span class="label label-info"><font class="menufore">财务总监</font></span></h5>
            <h5 class="inline"><span class="label label-info"><font class="menufore">张三</font></span></h5>
        </div>
        <br />
        <br />
        <br />
        <br />
    </div>
    <table width="100%" height="100%">
        <tr>
            <td width="20%" valign="top" style="padding: 0px 2px 2px 2px">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                </div>
            </td>
            <td style="background-color: #99CCCC" width="2px"></td>
            <td valign="top" style="padding: 0px 2px 2px 2px">
                <ul id="tabs" class="nav nav-tabs"></ul>
                <div id="tabcontents" class="tab-content">
                </div>
            </td>
        </tr>
    </table>


</body>
</html>

