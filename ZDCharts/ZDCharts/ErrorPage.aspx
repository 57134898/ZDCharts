<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="ZDCharts.ErrorPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>出错了</title>
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }

        html, body {
            height: 100%;
        }

        body {
            text-align: center;
            font: 14px/1.5 Microsoft YaHei, simhei;
            background: -moz-radial-gradient(center, ellipse cover, rgba(0,0,0,0) 0%, rgba(218,218,218,0.65) 100%); /* FF3.6+ */
            background: -webkit-gradient(radial, center center, 0px, center center, 100%, color-stop(0%,rgba(0,0,0,0)), color-stop(100%,rgba(218,218,218,0.65))); /* Chrome,Safari4+ */
            background: -webkit-radial-gradient(center, ellipse cover, rgba(0,0,0,0) 0%,rgba(218,218,218,0.65) 100%); /* Chrome10+,Safari5.1+ */
            background: -o-radial-gradient(center, ellipse cover, rgba(0,0,0,0) 0%,rgba(218,218,218,0.65) 100%); /* Opera 12+ */
            background: -ms-radial-gradient(center, ellipse cover, rgba(0,0,0,0) 0%,rgba(218,218,218,0.65) 100%); /* IE10+ */
            background: radial-gradient(ellipse at center, rgba(0,0,0,0) 0%,rgba(218,218,218,0.65) 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#00000000', endColorstr='#a6dadada',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */
        }

        .img {
            margin-top: 50px;
        }

        h2 {
            line-height: 60px;
            font-weight: 400;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <p class="img">
            <img src="Images/crying.png" alt="555555...">
        </p>
        <h2>哎呀...您访问的页面出现了问题</h2>
        <div>
            <br />
            <p>
                <a href="LogInPage.aspx">
                    <h3>返回首页</h3>
                </a>
                <br />
                <a href="javascript :history.back(-1)">
                    <h3>返回上一页</h3>
                </a>
            </p>
            <div id="codediv" runat="server"></div>
            <div id="msgdiv" runat="server"></div>
        </div>
    </form>
</body>
</html>
