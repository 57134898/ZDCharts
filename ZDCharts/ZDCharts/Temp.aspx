<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Temp.aspx.cs" Inherits="ZDCharts.Temp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="Scripts/jquery-2.1.3.min.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $(".panel").hover(function () {
                $(this).removeClass("panel-default");
                $(this).addClass("panel-info");
            },
            function () {
                $(this).removeClass("panel-info");
                $(this).addClass("panel-default");
            });

            $(".panel").click(function () {

            });
        });

    </script>
    <title></title>
</head>
<body>
    <div class="jumbotron">


        <div class="panel panel-default">
            <div class="panel-heading">Panel heading without title</div>
            <div class="panel-body">
                Panel content
            </div>
        </div>

        <div class="panel panel-default">
            <div class="panel-heading">Panel heading without title</div>
            <div class="panel-body">
                Panel content
            </div>
        </div>
    </div>
</body>
</html>
