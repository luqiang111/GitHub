<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.ft.otp.util.tool.DateTool"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="view" uri="/WEB-INF/tld/view.tld" %>

<%
	String path = request.getContextPath();
	String serverCurrYM = DateTool.getCurDate("yyyyMM");
	String beginTime = DateTool.dateToStr(DateTool.getYearMonthBeginTime(Integer.parseInt(serverCurrYM)/100,Integer.parseInt(serverCurrYM)%100));
	String serverCurrTime = DateTool.getCurDate("yyyy-MM-dd HH:mm:ss");
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
 	<link rel="stylesheet" type="text/css" href="<%=path%>/manager/common/js/ligerUI/skins/Aqua/css/ligerui-all.css"/>
	<link rel="stylesheet" type="text/css" href="<%=path%>/manager/common/js/ligerUI/skins/Gray/css/grid.css"/>
	<link rel="stylesheet" type="text/css" href="<%=path%>/manager/common/js/ligerUI/skins/ligerui-icons.css"/>
    <link href="<%=path%>/manager/common/css/webapp.css" rel="stylesheet" type="text/css"/>
    <link href="<%=path%>/manager/common/css/title.css" rel="stylesheet" type="text/css"/>
    
	<script language="javascript" src="<%=path%>/manager/common/js/jquery/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="<%=path%>/manager/common/datepicker/WdatePicker.js"></script>
	<script language="javascript" src="<%=path%>/manager/common/js/jquery/jquery.form.js"></script>
	<script language="javascript" src="<%=path%>/manager/common/js/validate.js"></script>
	<script language="javascript" src="<%=path%>/manager/common/js/common_one.js"></script>
	<script type="text/javascript" src="<%=path%>/manager/common/js/ligerUI/js/core/base.js"></script>
    <script type="text/javascript" src="<%=path%>/manager/common/js/ligerUI/js/ligerui.min.js"></script>
    <script type="text/javascript" src="<%=path%>/manager/common/js/ligerUI/js/plugins/ligerDialog.js"></script>
	<script language="javascript" src="<%=path%>/manager/common/js/window/window.js"></script>
	<script language="javascript" src="<%=path%>/manager/common/js/fusioncharts/fusionCharts.js"></script>
	<script language="javascript" src="<%=path%>/manager/common/js/fusioncharts/fusionChartsExportComponent.js"></script>
	<script type="text/javascript" src="<%=path%>/manager/common/js/common_one.js"></script>
	<script language="javascript" src="<%=path%>/manager/orgunit/orgunit/js/commonOrgunits.js" charset="UTF-8"></script>
	
	<script language="javascript" type="text/javascript">
	<!--
	var cPath;
	var paramObj = new Object(); // 查询条件_统计时使用
    var reportType = "";// 统计类型
    var isInitChart = true; //是否初始化报表
	$(function(){
	
		//检查电脑浏览器是否安装FLASH插件
		if(!isInstallFlashPlug()) {
			isInitChart = false;
			var tipview = $.ligerDialog.tip({title: '<view:LanguageTag key="tkn_assign_tip_title"/>',height:80,content:'<view:LanguageTag key="common_flash_plugin"/>'});
			setTimeout(function(){tipview.close()},5000);
		}
	
		cPath = $("#contextPath").val();
		reportType = $("#reportType").val();
		
		if(reportType!="authcount"){
	    	// 如果不是认证、同步量统计设置时间为当前月
	    	$('#startDate').val("<%=beginTime%>");
			$('#endDate').val("<%=serverCurrTime%>");
	    }
		viewChart(true);
		
		$('#ListForm').bind('keyup', function(event){
			if (event.keyCode=="13"){
				//回车查询事件
				viewChart();
			}
		});
	});

	// 获取当前时间，格式为yyyy-MM-dd HH:mm:ss
	function getNowFormatDate() {
	    var date = new Date();
	    var seperator1 = "-";
	    var seperator2 = ":";
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
	            + " " + date.getHours() + seperator2 + date.getMinutes()
	            + seperator2 + date.getSeconds();
	    return currentdate;
	}
	
	function viewChart(tag){
		if(!isInitChart){
			return;
		}
	
		var domainAndOrgunitIds = $('#orgunitIds').val();
		var startDate = $('#startDate').val();
		var endDate = $('#endDate').val();
		if(endDate!="" && startDate!=""){
			if(startDate>endDate){
	 			FT.toAlert('warn','<view:LanguageTag key="report_sel_time_error"/>', null);
				return;
			}
		}
		
		// 判断时间段不能超过12个月
		if(reportType!="authcount"){
			var errMsg = '<view:LanguageTag key="report_sel_time_limit"/>';
			if(endDate=="" && startDate==""){ // 时间段不能为空
				FT.toAlert('warn','<view:LanguageTag key="report_sel_time_null"/>', null);
				return;
			}else{
				if(startDate == ""){ // 如果开始时间为空
					FT.toAlert('warn','<view:LanguageTag key="report_sel_time_start_null"/>', null);
					return;
				}
				if(endDate == ""){ // 如果结束时间为空，赋上当前时间
					endDate = getNowFormatDate();
				}
				var arrStartDate = startDate.split('-');
				var arrEndDate = endDate.split('-');
				if(parseInt(arrEndDate[0])-parseInt(arrStartDate[0])>1){
					FT.toAlert('warn',errMsg, null);
					return;
				}else if(parseInt(arrEndDate[0])-parseInt(arrStartDate[0])==1){
					if((12-parseInt(arrStartDate[1]))+parseInt(arrEndDate[1])>11){
						FT.toAlert('warn',errMsg, null);
						return;
					}
				}
			}
		}
				
		var method = "";
		var swfFile = "MSLine.swf";
	    if(reportType=="authcount"){
	    	// 认证服务器认证同步量统计
	    	method = "reportAuthCount";
	    	swfFile = "MSColumn3D.swf";
	    }else if(reportType=="timeauth"){
	    	// 认证服务器时段认证量统计
	    	method = "reportTimeAuthCount";
	    }else{
	    	// 用户门户访问量统计
	    	method = "reportPortalCount";
	    }
	    
	    var orgunitNames = $("#orgunitNames").val();
		paramObj.orgunitNames = encodeURI(orgunitNames);
	    
		var url = "<%=path%>/manager/report/reportAction!"+method+".action?handler="+getExportReportHandler("<%=path%>")+"&domainAndOrgunitIds="+domainAndOrgunitIds+"&startdate="+startDate+"&enddate="+endDate+"&domainAndOrgName="+paramObj.orgunitNames;
		//创建统计图
		createFusionCharts("<%=path%>/manager/common/charts/"+swfFile,'chart1',url,'reportChart',800,450);
		//设置导出相关
		if(tag){
			//setChartsExporter("fcExporter1","<%=path%>/manager/common/charts/FCExporter.swf","fcexpDiv");
		}
		
		// 统计图显示完成之后赋值查询条件
		paramObj.domainAndOrgunitIds = domainAndOrgunitIds;
		paramObj.startdate = startDate;
		paramObj.enddate = endDate;
	}
	
	// 导出报表
	function exportReport(method,pngfileName){
		// 报表的统计数据
		var chartObj = null;
		try{chartObj = getChartFromId("chart1");}catch(e){ }
		var csvData = "";
		if(chartObj!=null){
			csvData = chartObj.getDataAsCSV(); 
		}
		
        if(csvData!=""&&csvData!=undefined){
	    	var url = "<%=path%>/manager/report/reportAction!"+method+".action?exportType="+reportType+"&csvData="+encodeURI(csvData)+"&fileName="+pngfileName+"&domainAndOrgunitIds="+paramObj.domainAndOrgunitIds+"&startdate="+paramObj.startDate+"&enddate="+paramObj.endDate+"&domainAndOrgName="+paramObj.orgunitNames;
			$.post(url,
				function(msg){
				   if(msg.errorStr=='success'){
				  		// 文件下载
				   		window.location.href = "<%=path%>/manager/report/reportAction!downLoad.action?fileName="+encodeURI(msg.object);
				   }else{
				   		FT.toAlert('error','<view:LanguageTag key="report_export_faild"/>', null);
				   }
			},"json");
	    }
	}
	
	// 下载图片
    function downloadImg(fileName){
        window.location.href = "<%=path%>/manager/report/reportAction!downloadImg.action?fileName="+fileName;
    }
    
    // 提示组织机构为空，关闭窗口
	function closeOrgWin(object) {
		$.ligerDialog.success(object,'<view:LanguageTag key="common_syntax_tip"/>',function(){
			winOrgClose.close();
		});
	}
	
	//-->
	</script>
  </head>
  
  <body style="overflow-x:hidden">
  <input type="hidden" name="contextPath" value="<%=path%>" id="contextPath"/>
  <input id="reportType" type="hidden" type="text" value="${param.reportType}"/>
  <form name="ListForm" method="post" id="ListForm" action="">
    <table width="800" border="0" cellspacing="0" cellpadding="0" style="margin-top:6px">
      <tr>
        <td width="80" align="right"><view:LanguageTag key="common_title_orgunit"/><view:LanguageTag key="colon"/></td>
        <td width="160">
       		<input id="orgunitIds" name="orgunitIds" class="textarea100" type="hidden" value=""/>
       		<input id="orgunitNames" name="orgunitNames" class="formCss100" type="text" onClick="selOrgunits(7,'<%=path %>');" readonly/>      
		</td>
        <td width="80" align="right"><view:LanguageTag  key="common_syntax_start_time"/><view:LanguageTag key="colon"/></td>
        <td width="150">
       	  <input id="startDate" type="text" name="startDate" value="" onClick="WdatePicker({lang:'${language_session_key}', dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'endDate\')}', position:{left:2}});" readOnly class="formCss100" style="width:150px" />
		</td>
		<td width="80" align="right"><view:LanguageTag  key="common_syntax_end_time"/><view:LanguageTag key="colon"/></td>
        <td width="150">
    	  <input id="endDate" type="text" name="endDate" value="" onClick="WdatePicker({lang:'${language_session_key}', dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\')}', position:{left:2}});" readOnly class="formCss100" style="width:150px" />
		</td>
        <td width="100">&nbsp;&nbsp;&nbsp;&nbsp;
        	<span style="display:inline-block" class="query-button-css"><a href="#" onClick="viewChart()" class="isLink_LanSe" ><span><view:LanguageTag key="common_syntax_query"/>
        	</span></a></span></td>
      </tr>
    </table>
    </form>
	<hr class="hrLine" />
  	<center>
  		<div id="reportChart"></div><br/>
  		<img src="<%=path%>/images/icon/chart_bar.png" width="16" height="16" hspace="3" align="middle" /><a href="javascript:exportChart()">
  		<view:LanguageTag key="report_export_report"/></a>
  		<!-- <c:if test="${param.reportType =='authcount'}"><a href="javascript:exportReport('exportDetailReport')"><view:LanguageTag key="report_export_report_detail"/></a></c:if> -->
  	</center>
  </body>
</html>