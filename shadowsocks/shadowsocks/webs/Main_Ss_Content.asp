﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>Shadowsocks - 账号信息配置</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/dbconf?p=ss&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/ss-menu.js"></script>
<style>
.Bar_container{
	width:85%;
	height:20px;
	border:1px inset #999;
	margin:0 auto;
	margin-top:20px \9;
	background-color:#FFFFFF;
	z-index:100;
}
#proceeding_img_text{
	position:absolute; 
	z-index:101; 
	font-size:11px; color:#000000; 
	line-height:21px;
	width: 83%;
}
#proceeding_img{
 	height:21px;
	background:#C0D1D3 url(/images/ss_proceding.gif);
}	
#Ss_node_list_Block_PC {
	border: 1px outset #999;
	background-color: #576D73;
	position: absolute;
	*margin-top:26px;
	margin-left: 3px;
	*margin-left:-129px;
	width: 255px;
	text-align: left;
	height: auto;
	overflow-y: auto;
	z-index: 200;
	padding: 1px;
	display: none;
}
#Ss_node_list_Block_PC div {
	background-color: #576D73;
	height: auto;
	*height:20px;
	line-height: 20px;
	text-decoration: none;
	font-family: Lucida Console;
	padding-left: 2px;
}
#Ss_node_list_Block_PC a {
	background-color: #EFEFEF;
	color: #FFF;
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	text-decoration: none;
}
#Ss_node_list_Block_PC div:hover, #Ss_node_list_Block a:hover {
	background-color: #3366FF;
	color: #FFFFFF;
	cursor: default;
}
#ss_node_edit{
	background: url(/images/New_ui/ss_list.png);
	background-position: 0px 0px;
	width: 30px;
	height: 35px;
}
.ss_node_list_viewlist {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	z-index: 200;
	background-color:#444f53;
	margin-left: 40px;
	margin-top: -1100px;
	width:950px;
	height:auto;
	box-shadow: 3px 3px 10px #000;
	display:block;
	overflow: auto;
}
.input_KCP_table{
	margin-left:2px;
	padding-left:0.4em;
	height:21px;
	width:158.2px;
	line-height:23px \9;	/*IE*/
	font-size:13px;
	font-family:'Courier New', Courier, mono;
	background-image:none;
	background-color: #576d73;
	border:1px solid gray;
	color:#FFFFFF;
}
.show-btn1,
.show-btn2,
.show-btn3,
.show-btn4{
    border: 1px solid #222;
    background: #576d73;
    font-size:10pt;
    color: #fff;
    padding: 10px 3.75px;
    border-radius: 5px 5px 0px 0px;
    width:8.45601%;
}
.active{
    background: #2f3a3e;
}
input[type=button]:focus {
    outline: none;
}
</style>
<script>
var socks5 = 0
var $j = jQuery.noConflict();
var over_var = 0;
var isMenuopen = 0;
var $G = function(id) {
    return document.getElementById(id);
};
String.prototype.replaceAll = function(s1,s2){
　　return this.replace(new RegExp(s1,"gm"),s2);
}
var refreshRate = 5;
function init() {
    show_menu(menu_hook);
    version_show();
    buildswitch();
    toggle_func();
    toggle_switch();
    detect_kcptun();
    refreshRate = getRefresh();
    for (var field in db_ss) {
		$j('#'+field).val(db_ss[field]);
	}
    if (typeof db_ss != "undefined") {
        update_ss_ui(db_ss);
        loadAllConfigs();
    } else {
        $G("logArea").innerHTML = "无法读取配置,jffs为空或配置文件不存在?";
    }
	var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_dnsmasq", "ss_redchn_wan_white_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_ip", "ss_redchn_wan_black_domain", "ss_basic_black_lan", "ss_basic_white_lan","ss_ipset_black_domain_web", "ss_ipset_white_domain_web", "ss_ipset_dnsmasq", "ss_ipset_black_ip", "ss_game_dnsmasq", "ss_gameV2_dnsmasq"];
	for (var i = 0; i < temp_ss.length; i++) {
		temp_str = $G(temp_ss[i]).value;
			$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
	}
    setTimeout("checkSSStatus();", 5000);
    setTimeout("write_ss_install_status()", 1000);
    updateSs_node_listView();
    var jffs2_scripts = '<% nvram_get("jffs2_scripts"); %>';
	if(jffs2_scripts == "0"){
		$j("#warn").html("<i>发现Enable JFFS custom scripts and configs选项未开启！</br></br>请开启并重启路由器后才能正常使用SS。<a href='/Advanced_System_Content.asp'><em><u> 前往设置 </u></em></a> </i>");
		document.form.ss_basic_enable.value = 0;
		inputCtrl(document.form.switch,0);
	}
	var _responseLen;
	var noChange = 0;
	var retArea = $G('log_content');
	retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
}

function detect_kcptun(){
    var kcptun_mode = '<% nvram_get("KCP_mode"); %>';
	if(kcptun_mode != "0" && kcptun_mode != ''){
		$G('ss_status1').style.display = "none";
		$G('tablet_show').style.display = "none";
		$G('basic_show').style.display = "none";
		$G('apply_button').style.display = "none";
		$G('warn1').style.display = "";
		document.form.ss_basic_enable.value = 0;
		inputCtrl(document.form.switch,0);
	}
}

function onSubmitCtrl() {
	ssmode = $G("ss_basic_mode").value;
	ssaction = $G("ss_basic_action").value;
	global_status_enable=false;
	checkSSStatus();
    if (validForm()) {
        if (0 == node_global_max) {
            var obj = ssform2obj();
            ss_node_object("1", obj, true,
            function(a) {
			setTimeout("checkSSStatus();", 50000); //make sure ss_status do not update during reloading
			if(ssaction == 1){
				if (ssmode == "2" || ssmode == "3"){			
				} else if (ssmode == "1"){
					showSSLoadingBar(5);
				} else if (ssmode == "0"){
					showSSLoadingBar(5);
				} else if (ssmode == "4"){
					showSSLoadingBar(6);
				} else if (ssmode == "5"){
					showSSLoadingBar(5);
				}
			}else if(ssaction == 2 || ssaction == 3 || ssaction == 4){
					showSSLoadingBar(2);
			}
        	document.form.action_mode.value = ' Refresh ';
        	updateOptions();
            });
        } else {
            var node_sel = $j('#ssconf_basic_node').val();
            var obj = ssform2obj();
            ss_node_object(node_sel, obj, true,
            function(a) {
			setTimeout("checkSSStatus();", 50000);
			if(ssaction == 1){
				if (ssmode == "2" || ssmode == "3"){
					showSSLoadingBar(5);
				} else if (ssmode == "1"){
					showSSLoadingBar(5);
				} else if (ssmode == "0"){
					showSSLoadingBar(5);
				} else if (ssmode == "4"){
					showSSLoadingBar(6);
				} else if (ssmode == "5"){
					showSSLoadingBar(5);
				}
			}else if(ssaction == 2 || ssaction == 3 || ssaction == 4){
					showSSLoadingBar(2);
			}
    		document.form.action_mode.value = ' Refresh ';
    		updateOptions();
            });
        }
    }
}


function updateOptions() {
	
	document.form.action = "/applydb.cgi?p=ss";
	document.form.SystemCmd.value = "ss_config.sh";
	document.form.submit();
}

function done_validating(action) {
	return true;
}

function save_ss_method(m) {
    var o = $G("ss_basic_method");
    for (var c = 0; c < o.length; c++) {
        if (o.options[c].value == m) {
            o.options[c].selected = true;
            break;
        }
    }
}

function update_ss_ui(obj) {
	for (var field in obj) {
		var el = $G(field);
		if (field == "ss_basic_method") {
			continue;
		} else if (field == "ss_basic_onetime_auth") {
			if (obj[field] != "1") {
				$j("#ss_basic_onetime_auth").val("0");
			} else {
				$j("#ss_basic_onetime_auth").val("1");
			}
			continue;
		} else if (field == "ss_basic_rss_protocol") {
			if (obj[field] != "origin" && obj[field] != "verify_simple" && obj[field] != "verify_deflate" &&  obj[field] != "auth_simple" && obj[field] != "auth_sha1" && obj[field] != "verify_sha1" && obj[field] != "auth_sha1_v2" ) {
				$j("#ss_basic_rss_protocol").val("origin");
			} else {
				$j("#ss_basic_rss_protocol").val(obj.ss_basic_rss_protocol);
			}
			continue;
		} else if (field == "ss_basic_rss_obfs") {
			if (obj[field] != "plain" && obj[field] != "http_simple" && obj[field] != "tls_simple" &&  obj[field] != "random_head" && obj[field] != "tls1.0_session_auth" && obj[field] != "tls1.2_ticket_auth" ) {
				$j("#ss_basic_rss_obfs").val("plain");
			} else {
				$j("#ss_basic_rss_obfs").val(obj.ss_basic_rss_obfs);
			}
			continue;
		} else if (field == "ss_basic_rss_obfs_param") {
			if (obj[field] == "undefied") {
				$j("#ss_basic_rss_obfs_param").val("");
			} else {
				$j("#ss_basic_rss_obfs_param").val(obj.ss_basic_rss_obfs_param);
			}
			continue;
		} else if (el != null && el.getAttribute("type") == "checkbox") {
			if (obj[field] != "1") {
				el.checked = false;
				$G("hd_" + field).value = "0";
			} else {
				el.checked = true;
				$G("hd_" + field).value = "1";
			}
			continue;
		}
		var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_dnsmasq", "ss_redchn_wan_white_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_ip", "ss_redchn_wan_black_domain", "ss_basic_black_lan", "ss_basic_white_lan","ss_ipset_black_domain_web", "ss_ipset_white_domain_web", "ss_ipset_dnsmasq", "ss_ipset_black_ip", "ss_game_dnsmasq", "ss_gameV2_dnsmasq"];
			for (var i = 0; i < temp_ss.length; i++) {
				temp_str = $G(temp_ss[i]).value;
				$G(temp_ss[i]).value = temp_str.replaceAll(",","\n");
		}
		if (el != null) {
			el.value = obj[field];
		}
	}
	$j("#ss_basic_method").val(obj.ss_basic_method);
}

function validForm() {
	var temp_ss = ["ss_redchn_isp_website_web", "ss_redchn_dnsmasq", "ss_redchn_wan_white_ip", "ss_redchn_wan_white_domain", "ss_redchn_wan_black_ip", "ss_redchn_wan_black_domain", "ss_basic_black_lan", "ss_basic_white_lan","ss_ipset_black_domain_web", "ss_ipset_white_domain_web", "ss_ipset_dnsmasq", "ss_ipset_black_ip", "ss_game_dnsmasq", "ss_gameV2_dnsmasq"];
	for(var i = 0; i < temp_ss.length; i++) {
		var temp_str = $G(temp_ss[i]).value;
		if(temp_str == "") {
			continue;
		}
		var lines = temp_str.split("\n");
		var rlt = "";
		for(var j = 0; j < lines.length; j++) {
			var nstr = lines[j].trim();
			if(nstr != "") {
				rlt = rlt + nstr + ",";
			}
		}
		if(rlt.length > 0) {
			rlt = rlt.substring(0, rlt.length-1);
		}
		if(rlt.length > 10000) {
			alert(temp_ss[i] + " 不能超过10000个字符");
			return false;
		}
		$G(temp_ss[i]).value = rlt;
	}
	return true;
}

function update_visibility() {
	ssmode = document.form.ss_basic_mode.value;
	ssenable = document.form.ss_basic_enable.value;
	crst = document.form.ss_basic_chromecast.value;
	sru = document.form.ss_basic_rule_update.value;
	slc = document.form.ss_basic_lan_control.value;
	std = readCookie("ss_table_detail");
	srp = document.form.ss_basic_rss_protocol.value;
	sro = document.form.ss_basic_rss_obfs.value;
	sur = document.form.hd_ss_basic_use_rss.value;
	if (srp == "origin"){
		$j("#ss_basic_rss_protocol_alert").html("原版协议");
	} else if (srp == "verify_simple"){
		$j("#ss_basic_rss_protocol_alert").html("带校验的协议");
	} else if (srp == "verify_deflate"){
		$j("#ss_basic_rss_protocol_alert").html("带压缩的协议");
	} else if (srp == "verify_sha1"){
		$j("#ss_basic_rss_protocol_alert").html("带验证抗CCA攻击的协议可兼容libev的OTA");
	} else if (srp == "auth_simple"){
		$j("#ss_basic_rss_protocol_alert").html("带验证抗重放攻击的协议");
	} else if (srp == "auth_sha1"){
		$j("#ss_basic_rss_protocol_alert").html("抗重放、CCA攻击协议");
	} else if (srp == "auth_sha1_v2"){
		$j("#ss_basic_rss_protocol_alert").html("抗重放、CCA攻击升级版协议");
	}

	if (sro == "plain"){
		$j("#ss_basic_rss_obfs_alert").html("不混淆");
	} else if (sro == "http_simple"){
		$j("#ss_basic_rss_obfs_alert").html("伪装为http协议");
	} else if (sro == "tls_simple"){
		$j("#ss_basic_rss_obfs_alert").html("模拟https/TLS1.2的握手过程，不建议使用");
	} else if (sro == "random_head"){
		$j("#ss_basic_rss_obfs_alert").html("发送一个随机包再通讯的协议");
	} else if (sro == "tls1.0_session_auth"){
		$j("#ss_basic_rss_obfs_alert").html("模拟tls1.0，不建议使用");
	} else if (sro == "tls1.2_ticket_auth"){
		$j("#ss_basic_rss_obfs_alert").html("模拟TLS1.2，强烈推荐");
	}
	
	if (ssmode == "0"){
		$j("#mode_state").html("SS运行状态");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("ShadowSocks 开关");
		$j("#ss_title").html("ShadowSocks - 账号信息配置");
		$j("#ss_info_table").html("ShadowSocks信息<i id='detail_show_hide' name='detail_show_hide' value='' class='clientlist_expander' style='cursor:pointer;margin-left: 565px;' onclick='show_detail(this);'>[ 简洁 ]</i>");
	} else if (ssmode == "1"){
		$j("#mode_state").html("SS运行状态【gfwlist模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("ShadowSocks 开关");
		$j("#ss_title").html("ShadowSocks - 账号信息配置");
		$j("#ss_info_table").html("ShadowSocks信息<i id='detail_show_hide' name='detail_show_hide' value='' class='clientlist_expander' style='cursor:pointer;margin-left: 565px;' onclick='show_detail(this);'>[ 简洁 ]</i>");
	} else if (ssmode == "2"){
		$j("#mode_state").html("SS运行状态【大陆白名单模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("ShadowSocks 开关");
		$j("#ss_title").html("ShadowSocks - 账号信息配置");
		$j("#ss_info_table").html("ShadowSocks信息<i id='detail_show_hide' name='detail_show_hide' value='' class='clientlist_expander' style='cursor:pointer;margin-left: 565px;' onclick='show_detail(this);'>[ 简洁 ]</i>");
	} else if (ssmode == "3"){
		$j("#mode_state").html("SS运行状态【游戏模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。</br><li><a href='http://koolshare.cn/thread-4519-1-1.html' target='_blank'><i>&nbsp;账号需支持UDP转发&nbsp;&nbsp;<u>FAQ</u></i></a></li>");
		$j("#ss_switch").html("ShadowSocks 开关");
		$j("#ss_title").html("ShadowSocks - 账号信息配置");
		$j("#ss_info_table").html("ShadowSocks信息<i id='detail_show_hide' name='detail_show_hide' value='' class='clientlist_expander' style='cursor:pointer;margin-left: 565px;' onclick='show_detail(this);'>[ 简洁 ]</i>");
	} else if (ssmode == "4"){
		$j("#mode_state").html("SS运行状态【游戏模式V2】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>游戏模式V2信息</em>表格中填入你的游戏模式V2账号信息，点击提交后就能使用代理服务。</br><li>游戏模式V2不兼容shadowsocks，你需要自己架设游戏模式V2的服务器才能使用这个模式</li><li>建议使用交换内存，以确保游戏模式V2更好的运行。&nbsp;&nbsp;<a href='http://koolshare.io/koolgame/latest/' target='_blank'><i><u>服务器端下载</u></i></a>&nbsp;&nbsp;<a style='margin-left: 20px;' href='https://koolshare.cn/thread-38263-1-1.html' target='_blank'><i><u>&nbsp;游戏模式v2服务器一键安装脚本</u></i></a>");
		$j("#ss_switch").html("游戏模式V2 开关");
		$j("#ss_title").html("游戏模式V2 - 账号信息配置");
		$j("#ss_info_table").html("游戏模式V2信息<i id='detail_show_hide' name='detail_show_hide' value='' class='clientlist_expander' style='cursor:pointer;margin-left: 587px;' onclick='show_detail(this);'>[ 简洁 ]</i>");
	} else if (ssmode == "5"){
		$j("#mode_state").html("SS运行状态【全局模式】");
		$j("#head_illustrate").html("<i>说明：</i>请在下面的<em>Shadowsocks信息</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。");
		$j("#ss_switch").html("ShadowSocks 开关");
		$j("#ss_title").html("ShadowSocks - 账号信息配置");
		$j("#ss_info_table").html("ShadowSocks信息<i id='detail_show_hide' name='detail_show_hide' value='' class='clientlist_expander' style='cursor:pointer;margin-left: 565px;' onclick='show_detail(this);'>[ 简洁 ]</i>");
	}


	showhide("show_btn3", (ssmode == "1" || ssmode == "2" ));

	
	showhide("ss_state1", (ssmode == "0"));
	showhide("ss_state2", (ssmode !== "0"));
	showhide("ss_state3", (ssmode !== "0"));
	showhide("update_rules", (ssmode !== "0"));
	showhide("game_alert", (ssmode == "3"));
	showhide("chromecast1", (crst == "0"));
	showhide("gfw_number", (ssmode == "1"));
	showhide("chn_number", (ssmode == "2" || ssmode == "3"));
	showhide("cdn_number", (ssmode == "2" || ssmode == "3"));
	showhide("ss_basic_rule_update_time", (sru == "1"));
	showhide("update_choose", (sru == "1"));
	//showhide("help", (ssmode !== "0"));
	//showhide("help_mode1", (ssmode == "1"));
	//showhide("help_mode2", (ssmode == "2"));
	//showhide("help_mode3", (ssmode == "3"));
	//showhide("help_mode4", (ssmode == "4"));
	showhide("ss_koolgame_udp_tr", (ssmode == "4"));
	//showhide("help_mode5", (ssmode == "5"));
	showhide("ss_basic_black_lan", (slc == "1"));
	showhide("ss_basic_white_lan", (slc == "2"));
	showhide("onetime_auth", (sur !== "1" && ssmode!== "4"));
	showhide("SSR_name", (ssmode!== "4"));	
	showhide("ss_basic_rss_protocol_tr", (sur == "1" && ssmode!== "4"));
	showhide("ss_basic_rss_obfs_tr", (sur == "1" && ssmode!== "4"));
	showhide("ss_basic_ticket_tr", (sur == "1" && ssmode!== "4" && document.form.ss_basic_rss_obfs.value == "tls1.2_ticket_auth" || document.form.ss_basic_rss_obfs.value == "http_simple"));



	rdc = document.form.ss_redchn_dns_china.value;
	rdf = document.form.ss_redchn_dns_foreign.value;
	rs = document.form.ss_redchn_sstunnel.value
	rcc = document.form.ss_redchn_chinadns_china.value
	rcf = document.form.ss_redchn_chinadns_foreign.value
	srpm= document.form.ss_redchn_pdnsd_method.value
	showhide("redchn_show_isp_dns", (rdc == "1"));
	showhide("ss_redchn_dns_china_user", (rdc == "5"));
	showhide("ss_redchn_opendns", (rdf == "1"));
	showhide("ss_redchn_sstunnel", (rdf == "2"));
	showhide("redchn_chinadns_china", (rdf == "3"));
	showhide("redchn_chinadns_foreign", (rdf == "3"));
	showhide("redchn_pdnsd_up_stream_tcp", (rdf == "6" && srpm == "2"));
	showhide("redchn_pdnsd_up_stream_udp", (rdf == "6" && srpm == "1"));
	showhide("ss_redchn_pdnsd_udp_server_dns2socks", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 1));
	showhide("ss_redchn_pdnsd_udp_server_dnscrypt", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 2));
	showhide("ss_redchn_pdnsd_udp_server_ss_tunnel", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 3));
	showhide("ss_redchn_pdnsd_udp_server_ss_tunnel_user", (rdf == "6" && srpm == "1" && document.form.ss_redchn_pdnsd_udp_server.value == 3 && document.form.ss_redchn_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("redchn_pdnsd_cache", (rdf == "6"));
	showhide("redchn_pdnsd_method", (rdf == "6"));
	showhide("ss_redchn_sstunnel_user", ((rdf == "2") && (rs == "4")));
	showhide("ss_redchn_chinadns_china_user", (rcc == "4"));
	showhide("ss_redchn_chinadns_foreign_user", (rcf == "4"));
	showhide("ss_redchn_dns2socks_user", (rdf == "4"));

    icd = document.form.ss_ipset_cdn_dns.value;
    ifd = document.form.ss_ipset_foreign_dns.value;
    it = document.form.ss_ipset_tunnel.value;
    sipm= document.form.ss_ipset_pdnsd_method.value
    showhide("ss_ipset_cdn_dns_user", (icd == "5"));
    showhide("china_dns1", (icd !== "5"));
    showhide("ss_ipset_opendns", (ifd == "0"));
    showhide("ss_ipset_foreign_dns1", (ifd == "2"));
    showhide("ss_ipset_foreign_dns2", (ifd == "0"));
    showhide("ss_ipset_tunnel", (ifd == "1"));
    showhide("ss_ipset_foreign_dns3", (ifd == "1"));
    showhide("ss_ipset_tunnel_user", ((ifd == "1") && (it == "4")));
    showhide("ss_ipset_dns2socks_user", (ifd == "2"));
    showhide("DNS2SOCKS1", (ifd == "2"));
	showhide("ipset_pdnsd_up_stream_tcp", (ifd == "4" && sipm == "2"));
	showhide("ipset_pdnsd_up_stream_udp", (ifd == "4" && sipm == "1"));
	showhide("ss_ipset_pdnsd_udp_server_dns2socks", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 1));
	showhide("ss_ipset_pdnsd_udp_server_dnscrypt", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 2));
	showhide("ss_ipset_pdnsd_udp_server_ss_tunnel", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 3));
	showhide("ss_ipset_pdnsd_udp_server_ss_tunnel_user", (ifd == "4" && sipm == "1" && document.form.ss_ipset_pdnsd_udp_server.value == 3 && document.form.ss_ipset_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("ipset_pdnsd_cache", (ifd == "4"));
	showhide("ipset_pdnsd_method", (ifd == "4"));

	gdc = document.form.ss_game_dns_china.value;
	gdf = document.form.ss_game_dns_foreign.value;
	gs = document.form.ss_game_sstunnel.value
	gcc = document.form.ss_game_chinadns_china.value
	gcf = document.form.ss_game_chinadns_foreign.value
	grpm= document.form.ss_game_pdnsd_method.value
	showhide("game_show_isp_dns", (gdc == "1"));
	showhide("ss_game_dns_china_user", (gdc == "5"));
	showhide("ss_game_opendns", (gdf == "1"));
	showhide("ss_game_sstunnel", (gdf == "2"));
	showhide("game_chinadns_china", (gdf == "3"));
	showhide("game_chinadns_foreign", (gdf == "3"));
	showhide("ss_game_sstunnel_user", ((gdf == "2") && (gs == "4")));
	showhide("ss_game_chinadns_china_user", (gcc == "4"));
	showhide("ss_game_chinadns_foreign_user", (gcf == "4"));
	showhide("ss_game_dns2socks_user", (gdf == "4"));
	showhide("game_pdnsd_up_stream_tcp", (gdf == "6" && grpm == "2"));
	showhide("game_pdnsd_up_stream_udp", (gdf == "6" && grpm == "1"));
	showhide("ss_game_pdnsd_udp_server_dns2socks", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 1));
	showhide("ss_game_pdnsd_udp_server_dnscrypt", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 2));
	showhide("ss_game_pdnsd_udp_server_ss_tunnel", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 3));
	showhide("ss_game_pdnsd_udp_server_ss_tunnel_user", (gdf == "6" && grpm == "1" && document.form.ss_game_pdnsd_udp_server.value == 3 && document.form.ss_game_pdnsd_udp_server_ss_tunnel.value == 4));
	showhide("game_pdnsd_cache", (gdf == "6"));
	showhide("game_pdnsd_method", (gdf == "6"));

	g2dc = document.form.ss_gameV2_dns_china.value;
	g2df = document.form.ss_gameV2_dns_foreign.value;
	showhide("gameV2_show_isp_dns", (g2dc == "1"));
	showhide("ss_gameV2_dns_china_user", (g2dc == "5"));
	showhide("ss_gameV2_dns_china_user_txt1", (g2dc !== "5"));
	showhide("ss_gameV2_dns_china_user_txt2", (g2dc == "5"));

	generate_options();
}

function generate_options(){
	var confs = ["4armed",  "cisco(opendns)",  "cisco-familyshield",  "cisco-ipv6",  "cisco-port53",  "cloudns-can",  "cloudns-syd",  "cs-cawest",  "cs-cfi",  "cs-cfii",  "cs-ch",  "cs-de",  "cs-fr",  "cs-fr2",  "cs-rome",  "cs-useast",  "cs-usnorth",  "cs-ussouth",  "cs-ussouth2",  "cs-uswest",  "cs-uswest2",  "d0wn-bg-ns1",  "d0wn-ch-ns1",  "d0wn-de-ns1",  "d0wn-fr-ns2",  "d0wn-gr-ns1",  "d0wn-hk-ns1",  "d0wn-it-ns1",  "d0wn-lv-ns1",  "d0wn-nl-ns1",  "d0wn-nl-ns2",  "d0wn-random-ns1",  "d0wn-random-ns2",  "d0wn-ro-ns1",  "d0wn-ru-ns1",  "d0wn-tz-ns1",  "d0wn-ua-ns1",  "dnscrypt.eu-dk",  "dnscrypt.eu-dk-ipv6",  "dnscrypt.eu-nl",  "dnscrypt.eu-nl-ipv6",  "dnscrypt.org-fr",  "fvz-rec-at-vie-01",  "fvz-rec-ca-tor-01",  "fvz-rec-ca-tor-01-ipv6",  "fvz-rec-de-fra-01",  "fvz-rec-gb-brs-01",  "fvz-rec-gb-lon-01",  "fvz-rec-gb-lon-03",  "fvz-rec-hk-ztw-01",  "fvz-rec-ie-du-01",  "fvz-rec-no-osl-01",  "fvz-rec-nz-akl-01",  "fvz-rec-nz-akl-01-ipv6",  "fvz-rec-us-ler-01",  "fvz-rec-us-mia-01",  "ipredator",  "ns0.dnscrypt.is",  "okturtles",  "opennic-tumabox",  "ovpnto-ro",  "ovpnto-se",  "ovpnto-se-ipv6",  "shea-us-noads",  "shea-us-noads-ipv6",  "soltysiak",  "soltysiak-ipv6",  "yandex"];
	var obj=$G('ss_redchn_opendns'); 
	var obj1=$G('ss_redchn_pdnsd_udp_server_dnscrypt'); 
	var obj2=$G('ss_ipset_opendns'); 
	var obj3=$G('ss_ipset_pdnsd_udp_server_dnscrypt'); 
	var obj4=$G('ss_game_opendns'); 
	var obj5=$G('ss_game_pdnsd_udp_server_dnscrypt'); 
	
	for(var i = 0; i < confs.length; i++) {
		obj.options.add(new Option(confs[i],confs[i]));
		obj1.options.add(new Option(confs[i],confs[i]));
		obj2.options.add(new Option(confs[i],confs[i]));
		obj3.options.add(new Option(confs[i],confs[i]));
		obj4.options.add(new Option(confs[i],confs[i]));
		obj5.options.add(new Option(confs[i],confs[i]));
	}
}

function oncheckclick(obj) {
	if (obj.checked) {
		$G("hd_" + obj.id).value = "1";
	} else {
		$G("hd_" + obj.id).value = "0";
	}
}

var global_status_enable = true;

function checkSSStatus() {
	if (db_ss['ss_basic_enable'] !== "0") {
	    if(!global_status_enable) {//not enabled
		    if(refreshRate > 0) {
			    setTimeout("checkSSStatus();", refreshRate * 100000);
		    }
		    return;
	    }
		$j.ajax({
		url: '/ss_status',
		dataType: "html",
        error: function(xhr) {
	        refreshRate = getRefresh();
	        if (refreshRate > 0)
            setTimeout("checkSSStatus();", refreshRate * 1000);
        },
		success: function() {
			if (db_ss['ss_basic_state_foreign'] == undefined){
				$G("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
        		$G("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
        		refreshRate = getRefresh();
				if (refreshRate > 0)
        		setTimeout("checkSSStatus();", refreshRate * 1000);
			} else {
				$j("#ss_state2").html("国外连接 - " + db_ss['ss_basic_state_foreign']);
				$j("#ss_state3").html("国内连接 - " + db_ss['ss_basic_state_china']);
				$G('update_button').style.display = "";
				refreshRate = getRefresh();
				if (refreshRate > 0)
        		setTimeout("checkSSStatus();", refreshRate * 1000);
    		}
		}
		});
	} else {
		$G("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
        $G("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
	}
}


function updatelist() {
    $j.ajax({
        url: 'apply.cgi?current_page=Main_Ss_Update.asp&next_page=Main_Ss_Content.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=update.sh&firmver=3.0.0.4',
        dataType: 'html',
        error: function(xhr) {},
        success: function(response) {
            if (response == "ok") {
                show_log_info();
            }
        }
    });
}

function ssconf_node2obj(node_sel) {
    var p = "ssconf_basic";
    if (typeof db_ss[p + "_server_" + node_sel] == "undefined") {
        var obj = {
            "ss_basic_server": "",
            "ss_basic_port": "",
            "ss_basic_password": "",
            "ss_basic_method": "table",
            "ss_basic_rss_protocol": "",
            "ss_basic_rss_obfs": "",
            "ss_basic_use_rss": "",
            "ss_basic_rss_obfs_param": "",
            "ss_basic_onetime_auth": ""
        };
        return obj;
    } else {
        var obj = {};
        var params = ["server", "mode", "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "onetime_auth"];
        for (var i = 0; i < params.length; i++) {
            obj["ss_basic_" + params[i]] = db_ss[p + "_" + params[i] + "_" + node_sel];
        }
        return obj;
    }
}

function ss_node_sel() {
    var node_sel = $G("ssconf_basic_node").value;
    var obj = ssconf_node2obj(node_sel);
    update_visibility();
    update_ss_ui(obj);

}

function ss_node_object(node_sel, obj, isSubmit, end) {
    var ns = {};
    var p = "ssconf_basic";
    var params = ["server", "mode", "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "onetime_auth"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + node_sel] = obj[params[i]];
        db_ss[p + "_" + params[i] + "_" + node_sel] = obj[params[i]];
    }
    if (isSubmit) {
        ns[p + "_node"] = node_sel;
        db_ss[p + "_node"] = node_sel;
    }
    $j.ajax({
        url: '/applydb.cgi?p=' + p,
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            end("error");
        },
        success: function(response) {
            end("ok");
        }
    });
}

function ssform2obj() {
    var obj = {};
    obj["mode"] = $G("ss_basic_mode").value;
    obj["server"] = $G("ss_basic_server").value;
    obj["port"] = $G("ss_basic_port").value;
    obj["password"] = $G("ss_basic_password").value;
    obj["method"] = $G("ss_basic_method").value;
    obj["rss_protocol"] = $G("ss_basic_rss_protocol").value;
    obj["rss_obfs"] = $G("ss_basic_rss_obfs").value;
    obj["rss_obfs_param"] = $G("ss_basic_rss_obfs_param").value;
    obj["use_rss"] = $G("hd_ss_basic_use_rss").value;
    obj["onetime_auth"] = $G("ss_basic_onetime_auth").value;
    return obj;
}

var ss_node_list_view_hide_flag = false;
function hide_ss_node_list_view_block() {
    if (ss_node_list_view_hide_flag) {
        fadeOut($G("ss_node_list_viewlist_content"), 10, 0);
        document.body.onclick = null;
        document.body.onresize = null;
        clientListViewMacUploadIcon = [];
        removeIframeClick("statusframe", hide_ss_node_list_view_block);
    }
    ss_node_list_view_hide_flag = true;
}

function show_ss_node_list_view_block() {
    ss_node_list_view_hide_flag = false;
}

function closeSs_node_listView() {
	global_ss_node_refresh=false;
    fadeOut($G("ss_node_list_viewlist_content"), 10, 0);
}

function refresh_popup_listview(confs) {
    $j("#ss_node_list_viewlist_content").remove();
    $j("<div class='ss_node_list_viewlist' id='ss_node_list_viewlist_content' style='display:none'>").appendTo(document.body);
    create_ss_node_list_listview(confs);
    registerIframeClick("statusframe", hide_ss_node_list_view_block);
}

function pop_ss_node_list_listview() {
    confs = getAllConfigs();
    refresh_popup_listview(confs);
    fadeIn($G("ss_node_list_viewlist_content"));
    cal_panel_block_clientList("ss_node_list_viewlist_content", 0.045);
    ss_node_list_view_hide_flag = false;
   	global_ss_node_refresh=true;
   	updateSs_node_listView();
}

function getAllConfigs() {
    var dic = {};
    node_global_max = 0;
    for (var field in db_ss) {
        names = field.split("_");
        dic[names[names.length - 1]] = 'ok';
    }
    confs = {};
    var p = "ssconf_basic";
    var params = ["name", "server", "port", "password", "method" ];
    for (var field in dic) {
        var obj = {};
        if (typeof db_ss[p + "_name_" + field] == "undefined") {
            obj["name"] = '节点' + field;
        } else {
            obj["name"] = db_ss[p + "_name_" + field];
        }
        if (typeof db_ss[p + "_ping_" + field] == "undefined") {
            obj["ping"] = '';
        } else if (db_ss[p + "_ping_" + field] == "failed") {
	        obj["ping"] = '<font color="#FFCC00">failed</font>';
	    } else {
            obj["ping"] = parseFloat(db_ss[p + "_ping_" + field].split(" ")[0]).toPrecision(3) + " ms / " + parseFloat(db_ss[p + "_ping_" + field].split(" ")[3]) + "%";
        }
        if (typeof db_ss[p + "_webtest_" + field] == "undefined") {
            obj["webtest"] = '';
        } else {
	        var time_total = parseFloat(db_ss[p + "_webtest_" + field].split(":")[0]).toFixed(2);
	        if (time_total == 0.00){
		        obj["webtest"] = '<font color=#FFCC00">failed</font>';
	        }else{
		         obj["webtest"] = parseFloat(db_ss[p + "_webtest_" + field].split(":")[0]).toFixed(2) + " s";
	        }
        }
        for (var i = 1; i < params.length; i++) {
            var ofield = p + "_" + params[i] + "_" + field;
            if (typeof db_ss[ofield] == "undefined") {
                obj = null;
                break;
            }
            obj[params[i]] = db_ss[ofield];
        }
        if (obj != null) {
            var node_i = parseInt(field);
            if (node_i > node_global_max) {
                node_global_max = node_i;
            }
            obj["node"] = field;
            confs[field] = obj;
        }
    }
    return confs;    
}

function ping_test(){
    global_ss_node_refresh = true;
	updateSs_node_listView();
	document.node_form.action_mode.value = ' Refresh ';
    document.node_form.submit();
}

function web_test(){
    global_ss_node_refresh = true;
	updateSs_node_listView();
	document.node_form.SystemCmd.value = "ss_webtest.sh";
	document.node_form.action_mode.value = ' Refresh ';
    document.node_form.submit();
}

function load_test_value(){
	if (typeof db_ss['ssconf_basic_Ping_Method']  == "undefined" ){
		$j("#ssconf_basic_Ping_Method").val("1");
	}else{
		$j("#ssconf_basic_Ping_Method").val(db_ss['ssconf_basic_Ping_Method']);
	}

	if (typeof db_ss['ssconf_basic_test_domain']  == "undefined" ){
		$j("#ssconf_basic_test_domain").val("https://www.google.com/");
	}else{
		$j("#ssconf_basic_test_domain").val(db_ss['ssconf_basic_test_domain']);
	}

}

function loadBasicOptions(confs) {
    var option = $j("#ssconf_basic_node");
    option.find('option').remove().end();
    for (var field in confs) {
        var c = confs[field];
        option.append($j("<option>", {
            value: field,
            text: c.name
        }));
    }
    if (node_global_max > 0) {
        var node_sel = "1";
        if (typeof db_ss.ssconf_basic_node != "undefined") {
            node_sel = db_ss.ssconf_basic_node;
        }
        option.val(node_sel);
        ss_node_sel();
    }
}

function loadAllConfigs() {
    confs = getAllConfigs();
    loadBasicOptions(confs);
    refresh_popup_listview(confs);
    load_test_value();
}

function add_conf_in_table(o) {
    var ns = {};
    var p = "ssconf_basic";
    node_global_max += 1;
    var params = ["name", "server", "mode",  "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "onetime_auth"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + node_global_max] = $j('#ssconf_table_' + params[i]).val();
    }
    $j.ajax({
        url: '/applydb.cgi?p=ss',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            updateSs_node_listView1();
        }
    });
}

function remove_conf_table(o) {
    var id = $j(o).attr("id");
    var ids = id.split("_");
    var p = "ssconf_basic";
    id = ids[ids.length - 1];
    var ns = {};
    var params = ["name", "server", "mode",  "port", "password", "method", "rss_protocol", "rss_obfs", "rss_obfs_param", "use_rss", "onetime_auth"];
    for (var i = 0; i < params.length; i++) {
        ns[p + "_" + params[i] + "_" + id] = "";
    }
    $j.ajax({
        url: '/applydb.cgi?use_rm=1&p=ss',
        contentType: "application/x-www-form-urlencoded",
        dataType: 'text',
        data: $j.param(ns),
        error: function(xhr) {
            console.log("error in posting config of table");
        },
        success: function(response) {
            updateSs_node_listView1();
        }
    });
}

function create_ss_node_list_listview(confs) {
    field_code = "";
    for (var field in confs) {
        var c = confs[field];
        field_code += "<tr height='40px'>";
        field_code += "<td>" + c["name"] + "</td>";
        field_code += "<td>" + c["server"] + "</td>";
        field_code += "<td>" + c["port"] + "</td>";
        field_code += "<td>" + c["password"] + "</td>";
        field_code += "<td>" + c["method"] + "</td>";
        field_code += "<td title='延迟/丢包'>" + c["ping"] + "</td>";
        field_code += "<td title='请求网页总时间'>" + c["webtest"] + "</td>";
        field_code += "<td><input id='td_node_" + c["node"] + "' class='remove_btn' type='button' onclick='return remove_conf_table(this);' value=''></td>";
        field_code += "</tr>";
    }
    if ($G("ss_node_list_viewlist_block") != null) {
        removeElement($G("ss_node_list_viewlist_block"));
    }
    var divObj = document.createElement("div");
    divObj.setAttribute("id", "ss_node_list_viewlist_block");
    var obj_width_map = [["15%", "45%", "20%", "20%"], ["10%", "45%", "19%", "19%", "7%"], ["14%", "14%", "10%", "14%", "14%", "14%", "10%", "10%"]];
    var obj_width = stainfo_support ? obj_width_map[2] : obj_width_map[1];
    var wl_colspan = stainfo_support ? 8 : 5;
    var code = "";
   
    code += "<div style='text-align:right;width:30px;position:relative;margin-top:0px;margin-left:96%;'><img src='/images/button-close.gif' style='width:30px;cursor:pointer' onclick='closeSs_node_listView();'></div>";
    code += "<form method='POST' name='node_form' action='/applydb.cgi?p=ssconf_basic_' target='hidden_frame'>";
    code += "<table width='100%' border='1' align='center' cellpadding='0' cellspacing='0' class='FormTable_table' style='margin-top:10px;'>";
    code += "<thead>";
    code += "<tr height='28px'>";
    code += "<td id='td_all_list_title' colspan='" + wl_colspan + "'>Shadowsocks节点配置</td>";
    code += "</tr>";
    code += "</thead>";
    code += "<tr id='tr_all_title' height='40px'>";
    code += "<th width=" + obj_width[0] + ">节点名称</th>";
    code += "<th width=" + obj_width[1] + ">服务器地址</th>";
    code += "<th width=" + obj_width[2] + ">端口</th>";
    code += "<th width=" + obj_width[3] + ">密码</th>";
    code += "<th width=" + obj_width[4] + ">加密方式</th>";
    code += "<th width=" + obj_width[5] + "><input type='button' id='ping_btn' name='ping_btn' class='button_gen' onclick='ping_test();' value='ping test'/></th>";
    code += "<th width=" + obj_width[6] + "><input type='button' id='connec_btn' name='connec_btn' class='button_gen'  onclick='web_test();' value='web test'/></th>";
    code += "<th width=" + obj_width[7] + ">添加<br>删除</th>";
    code += "</tr>";
    code += "<tr height='40px'>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_name' style='width:120px' onclick='disable_ss_node_list_refresh();' name='ssconf_table_name' value='' ></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_server' style='width:120px' onclick='disable_ss_node_list_refresh();' name='ssconf_table_server' value='' ></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_port' style='width:120px' onclick='disable_ss_node_list_refresh();' name='ssconf_table_port' value='' ></td>";
    code += "<td><input type='text' class='input_ss_table' id='ssconf_table_password' style='width:120px' onclick='disable_ss_node_list_refresh();' name='ssconf_table_password' value='' ></td>";
    code += "<td><select id='ssconf_table_method' name='ssconf_table_method' style='width:130px;margin:0px 0px 0px 2px;' onclick='disable_ss_node_list_refresh();' class='input_option' />"
    code += "<option class='content_input_fd' value='table'>table</option>";
    code += "<option class='content_input_fd' value='rc4'>rc4</option>";
    code += "<option class='content_input_fd' value='rc4-md5'>rc4-md5</option>";
    code += "<option class='content_input_fd' value='aes-128-cfb'>aes-128-cfb</option>";
    code += "<option class='content_input_fd' value='aes-192-cfb'>aes-192-cfb</option>";
    code += "<option class='content_input_fd' value='aes-256-cfb' selected=''>aes-256-cfb</option>";
    code += "<option class='content_input_fd' value='bf-cfb'>bf-cfb</option>";
    code += "<option class='content_input_fd' value='camellia-128-cfb'>camellia-128-cfb</option>";
    code += "<option class='content_input_fd' value='camellia-192-cfb'>camellia-192-cfb</option>";
    code += "<option class='content_input_fd' value='camellia-256-cfb'>camellia-256-cfb</option>";
    code += "<option class='content_input_fd' value='cast5-cfb'>cast5-cfb</option>";
    code += "<option class='content_input_fd' value='des-cfb'>des-cfb</option>";
    code += "<option class='content_input_fd' value='idea-cfb'>idea-cfb</option>";
    code += "<option class='content_input_fd' value='rc2-cfb'>rc2-cfb</option>";
    code += "<option class='content_input_fd' value='seed-cfb'>seed-cfb</option>";
    code += "<option class='content_input_fd' value='salsa20'>salsa20</option>";
    code += "<option class='content_input_fd' value='chacha20'>chacha20</option>";
    code += "<option class='content_input_fd' value='chacha20-ietf'>chacha20-ietf</option>";
    code += "</select>";
    code += "</td>"; 
    code += "<input type='hidden' name='action_mode' value=''/>"
    code += "<input type='hidden' name='SystemCmd' value='ss_ping.sh'/>"
    code += "<input type='hidden' name='current_page' value='Main_Ss_Content.asp'/>"
    code += "<td><select id='ssconf_basic_Ping_Method' name='ssconf_basic_Ping_Method' style='width:130px;margin:0px 0px 0px 2px;' onclick='disable_ss_node_list_refresh();' class='input_option' />"
    code += "<option class='content_input_fd' value='1'>单线ping(10次/节点)</option>";
    code += "<option class='content_input_fd' value='2'>并发ping(10次/节点)</option>";
    code += "<option class='content_input_fd' value='3'>并发ping(20次/节点)</option>";
    code += "<option class='content_input_fd' value='4'>并发ping(50次/节点)</option>";
    code += "</select>";
    code += "</td>";
    code += "<td><select id='ssconf_basic_test_domain' name='ssconf_basic_test_domain' style='width:auto;margin:0px 0px 0px 2px;' onclick='disable_ss_node_list_refresh();' class='input_option' />"
    code += "<option class='content_input_fd' value='https://www.google.com/'>google.com</option>";
    code += "<option class='content_input_fd' value='https://www.youtube.com/'>youtube.com</option>";
    code += "</select>";
    code += "</td>";
    code += "<td><input class='add_btn' onclick='add_conf_in_table(this);' type='button' value=''></td>";
    code += "</tr>";
    code += field_code;
    code += "<tr>";
    code += "</tr>";
    code += "</table>";
    code += "</form>";
    code += "<div style='align:center;margin-left:220px;margin-top:15px'>";
    code += "<form method='POST' name='file_form' action='/ssupload.cgi?a=/tmp/ss_conf_backup.txt' target='hidden_frame'>";
    code += "<table>";
    code += "<tr>";
    code += "<td style='border:1px'>";
    code += "<input type='button' class='button_gen' onclick='remove_SS_node();' value='清空配置'/>";
    code += "</td>";
    code += "<td style='border:1px'>";
    code += "<input style='margin-left:50px;' type='button' class='button_gen' onclick='download_SS_node();' value='导出配置'/>";
    code += "</td>";
    code += "<td style='border:1px'>";
    code += "<input style='margin-left:50px;' type='button' id='upload_btn' class='button_gen' onclick='upload_SS_node();' value='恢复配置'/>";
    code += "</td>";
    code += "<td style='border:1px'>";
    code += "<input style='color:#FFCC00;*color:#000;width: 200px;'id='ss_file' onclick='disable_ss_node_list_refresh();' type='file' name='file'/>";
    code += "<img id='loadingicon' style='margin-left:5px;margin-right:5px;display:none;' src='/images/InternetScan.gif'/>";
    code += "<span id='ss_file_info' style='display:none;'>完成</span>";
    code += "</td>";
    code += "</tr>";
    code += "</table>";
    code += "</form>";
    code += "<div style='align:center;margin-left:180px;margin-top:20px;margin-bottom:20px;'><input type='button' class='button_gen' onclick='closeSs_node_listView();' value='返回'></div>";
    code += "</div>";
    code += "<div id='clientlist_all_list_Block'></div>";
    divObj.innerHTML = code;
    $G("ss_node_list_viewlist_content").appendChild(divObj);
}

function download_SS_node() {
	location.href='ss_conf_backup.txt';
}

function upload_SS_node() {
	if ($G('ss_file').value == "") return false;
	global_ss_node_refresh = false;
	$G('ss_file_info').style.display = "none";
	$G('loadingicon').style.display = "block";
	document.file_form.enctype = "multipart/form-data";
	document.file_form.encoding = "multipart/form-data";
	document.file_form.submit();	
	}
	
function upload_ok(isok) {
	var info = $G('ss_file_info');
	if(isok==1){
		info.innerHTML="上传完成";
		restore_ss_conf();
	} else {
		info.innerHTML="上传失败";
	}
	info.style.display = "block";
	$G('loadingicon').style.display = "none";
}

function restore_ss_conf() {
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ss_conf_restore.sh";
	if (validForm()){
		document.form.submit();
	}
    //setTimeout("onSubmitCtrl();", 2000);
    refreshpage(2);
}

function remove_SS_node() {
	global_status_enable=false;
	checkSSStatus();
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ss_conf_remove.sh";
	if (validForm()){
		document.form.submit();
	}
    refreshpage(2);
}

var global_ss_node_refresh = false;
function updateSs_node_listView() {
    if(!global_ss_node_refresh) {
	   	return;
	}
    $j.ajax({
        url: '/dbconf?p=ss',
        dataType: 'html',
        error: function(xhr) {            
	        },
        success: function(response) {
            $j.globalEval(response);
            loadAllConfigs();
            cal_panel_block_clientList("ss_node_list_viewlist_content", 0.037);
            $j("#ss_node_list_viewlist_content").show();
        }
    });
    setTimeout("updateSs_node_listView()", 2000);
}

function disable_ss_node_list_refresh(){
	global_ss_node_refresh = false;
	updateSs_node_listView();
}

function updateSs_node_listView1() {
    $j.ajax({
        url: '/dbconf?p=ss',
        dataType: 'html',
        error: function(xhr) {            
	        },
        success: function(response) {
            $j.globalEval(response);
            loadAllConfigs();
            cal_panel_block_clientList("ss_node_list_viewlist_content", 0.037);
            $j("#ss_node_list_viewlist_content").show();
        }
    });
}

function cal_panel_block_clientList(obj, multiple) {
	var isMobile = function() {
		var tmo_support = ('<% nvram_get("rc_support"); %>'.search("tmo") == -1) ? false : true;
		if(!tmo_support)
			return false;
		
		if(	navigator.userAgent.match(/iPhone/i)	|| 
			navigator.userAgent.match(/iPod/i)		||
			navigator.userAgent.match(/iPad/i)		||
			(navigator.userAgent.match(/Android/i) && (navigator.userAgent.match(/Mobile/i) || navigator.userAgent.match(/Tablet/i))) ||
			(navigator.userAgent.match(/Opera/i) && (navigator.userAgent.match(/Mobi/i) || navigator.userAgent.match(/Mini/i))) ||	// Opera mobile or Opera Mini
			navigator.userAgent.match(/IEMobile/i)	||	// IE Mobile
			navigator.userAgent.match(/BlackBerry/i)	//BlackBerry
		 ) {
			return true;
		}
		else {
			return false;
		}
	};
	var blockmarginLeft;
	if (window.innerWidth) {
		winWidth = window.innerWidth;
	}
	else if ((document.body) && (document.body.clientWidth)) {
		winWidth = document.body.clientWidth;
	}
	//if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth) {
	//	winWidth = document.documentElement.clientWidth;
	//}

	if(winWidth > 1050) {
		winPadding = (winWidth - 1050) / 2;
		winWidth = 1105;
		blockmarginLeft = (winWidth * multiple) + winPadding;
	}
	else if(winWidth <= 1050) {
		if(isMobile()) {
			if(document.body.scrollLeft < 50) {
				blockmarginLeft= (winWidth) * multiple + document.body.scrollLeft;
			}
			else if(document.body.scrollLeft >320) {
				blockmarginLeft = 320;
			}
			else {
				blockmarginLeft = document.body.scrollLeft;
			}	
		}
		else {
			blockmarginLeft = (winWidth) * multiple + document.body.scrollLeft;	
		}
	}

	$G(obj).style.marginLeft = blockmarginLeft + "px";
}

function show_detail(thisObj) {
    var state1 = readCookie("ss_table_detail")
    var ssmode = $G("ss_basic_mode").value;
    if (state1 == "1") {
        slideDown("add_fun", 350);
        //slideDown("help_mode", 350);
        thisObj.innerHTML = "[ 简洁 ]";
        createCookie("ss_table_detail", 0, 365);
    } else {
        slideUp("add_fun", 350);
        //slideUp("help_mode", 350);
        thisObj.innerHTML = "[ 详细 ]";
        createCookie("ss_table_detail", 1, 365);
    }
}

function init_detail() {
    var std = readCookie("ss_table_detail")
    var ssmode = $G("ss_basic_mode").value;
    if (std == "1") {
        $G("add_fun").style.display = "none";
        //$G("help_mode").style.display = "none";
        $j("#detail_show_hide").html("[ 详细 ]");
    } else {
        $G("add_fun").style.display = "";
        //$G("help_mode").style.display = "";
        $j("#detail_show_hide").html("[ 简洁 ]");
    }
}

function createCookie(name, value, days) {
    var expires;
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    } else {
        expires = "";
    }
    document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
}

function readCookie(name) {
    var nameEQ = encodeURIComponent(name) + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
    }
    return null;
}

function setRefresh(obj) {
	refreshRate = obj.value;
	cookie.set('status_restart', refreshRate, 300);
	checkSSStatus();
}
function getRefresh() {
	val = parseInt(cookie.get('status_restart'));
	if ((val != 0) && (val != 5) && (val != 10) && (val != 15) && (val != 30) && (val != 60))
	val = 10;
	$G('refreshrate').value = val;
	return val;
}

function version_show(){
    $j.ajax({
        url: 'http://koolshare.ngrok.wang:5000/shadowsocks/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
            if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
	            if(res["version"] == db_ss["ss_basic_version_local"]){
		        	$j("#ss_version_show").html("<i>当前版本：" + db_ss["ss_basic_version_local"]);
	       		}else if(res["version"] !== db_ss["ss_basic_version_local"]) {
                    $j("#ss_version_show").html("<i>当前版本：" + db_ss["ss_basic_version_local"]);
                    $j("#updateBtn").html("<i>升级到：" + res.version  + "</i>");
		        }
            }
        }
    });
}

function write_ss_install_status(){
		$j.ajax({
		type: "get",
		url: "dbconf?p=ss",
		dataType: "script",
		success: function() {
		if (db_ss['ss_basic_install_status'] == "1"){
			$j("#ss_install_show").html("<i>正在下载更新...</i>");
			$G('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "2"){
			$j("#ss_install_show").html("<i>正在安装更新...</i>");
			$G('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "3"){
			$j("#ss_install_show").html("<i>安装更新成功，5秒自动重启SS！</i>");
			$G('ss_version_show').style.display = "none";
			version_show();
			setTimeout("write_ss_install_status()", 200000);
			setTimeout("onSubmitCtrl();", 4000);
		} else if (db_ss['ss_basic_install_status'] == "4"){
			$j("#ss_install_show").html("<i>下载文件校验不一致！</i>");
			$G('ss_version_show').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "5"){
			$j("#ss_install_show").html("<i>然而并没有更新！</i>");
			$G('ss_version_show').style.display = "none";
			$G('update_button').style.display = "";
			global_status_enable=true;
			checkSSStatus();
		} else if (db_ss['ss_basic_install_status'] == "6"){
			$G('ss_version_show').style.display = "none";
			$j("#ss_install_show").html("<i>正在检查是否有更新~</i>");
			$G('update_button').style.display = "none";
		} else if (db_ss['ss_basic_install_status'] == "7"){
			$j("#ss_install_show").html("<i>检测更新错误！</i>");
		} else if (db_ss['ss_basic_install_status'] == "8"){
			$j("#ss_install_show").html("<i>更换备用更新服务器1！</i>");
		} else if (db_ss['ss_basic_install_status'] == "0"){
			$j("#ss_install_show").html("");
			//$G('update_button').style.display = "";
			$G('ss_version_show').style.display = "";
		}else {
			$j("#ss_install_show").html("");
			//$G('update_button').style.display = "";
			$G('ss_version_show').style.display = "";
		}
		setTimeout("write_ss_install_status()", 2000);
		}
		});
	}

function update_ss(){
	global_status_enable=false;
	checkSSStatus();
	//document.form.ss_basic_update_check.value = 1;
	document.form.action_mode.value = ' Refresh ';
    document.form.SystemCmd.value = "ss_update.sh";
	if (validForm()){
		document.form.submit();
	}
}
function buildswitch(){
	$j("#switch").click(
	function(){
		var ssmode = $G("ss_basic_mode").value;
		if($G('switch').checked){
			document.form.action_mode.value = ' Refresh ';
			$G('ss_basic_enable').value = 1;
			$G("ss_status1").style.display = "";
			$G("tablet_show").style.display = "";
			$G("basic_show").style.display = "";
			$G("apply_button").style.display = "";
			update_visibility();
		}else{
			document.form.ss_basic_enable.value = 0;
			showSSLoadingBar(8);
			document.form.action_mode.value = ' Refresh ';
			document.form.action = "/applydb.cgi?p=ss";
			document.form.SystemCmd.value = "ss_config.sh";
			if (validForm()){
				document.form.submit();
			}
			$G("basic_show").style.display = "none";
		}
	});
}

function toggle_switch(){
	if (db_ss['ss_basic_enable'] == "1"){
		$G("switch").checked = true;
    	update_visibility();
	} else {
		$G("switch").checked = false;
		$G("ss_status1").style.display = "none";
		$G("tablet_show").style.display = "none";
		$G("basic_show").style.display = "none";
		$G("apply_button").style.display = "none";
	}
}

function toggle_func(){
	ssmode = $G("ss_basic_mode").value;
	document.form.ss_basic_action.value = 1;
	$j('.show-btn1').addClass('active');
	$j(".show-btn1").click(
	function(){
		$j('.show-btn1').addClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		$G("basic_show").style.display = "";
		$G("add_fun").style.display = "none";
		$G("redchn_dns").style.display = "none";
		$G("redchn_list").style.display = "none";
		$G("ipset_dns").style.display = "none";
		$G("ipset_list").style.display = "none";
		$G("game_dns").style.display = "none";
		$G("game_list").style.display = "none";
		$G("gameV2_dns").style.display = "none";
		$G("gameV2_list").style.display = "none";
		$G("overall_dns").style.display = "none";
		$G("overall_list").style.display = "none";	
		$j("#cmdBtn").html("提交");
		document.form.ss_basic_action.value = 1;
	});
		$j(".show-btn2").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').addClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').removeClass('active');
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$j("#cmdBtn").html("应用DNS设定");
		document.form.ss_basic_action.value = 2;
		if (ssmode == "1"){
			$G("ipset_dns").style.display = "";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "2"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "3"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";		
		}else if(ssmode == "4"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "5"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "";
			$G("overall_list").style.display = "none";	
		}
		update_visibility();
	});
	$j(".show-btn3").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').addClass('active');
		$j('.show-btn4').removeClass('active');
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$j("#cmdBtn").html("应用黑白名单");
		document.form.ss_basic_action.value = 3;
		if (ssmode == "1"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "2"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "3"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "4"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "none";	
		}else if(ssmode == "5"){
			$G("ipset_dns").style.display = "none";
			$G("ipset_list").style.display = "none";
			$G("redchn_dns").style.display = "none";
			$G("redchn_list").style.display = "none";
			$G("game_dns").style.display = "none";
			$G("game_list").style.display = "none";
			$G("gameV2_dns").style.display = "none";
			$G("gameV2_list").style.display = "none";
			$G("overall_dns").style.display = "none";
			$G("overall_list").style.display = "";	
		}
			update_visibility();
	});
		$j(".show-btn4").click(
	function(){
		$j('.show-btn1').removeClass('active');
		$j('.show-btn2').removeClass('active');
		$j('.show-btn3').removeClass('active');
		$j('.show-btn4').addClass('active');
		$G("basic_show").style.display = "none";
		$G("add_fun").style.display = "";
		$G("redchn_dns").style.display = "none";
		$G("redchn_list").style.display = "none";
		$G("ipset_dns").style.display = "none";
		$G("ipset_list").style.display = "none";
		$G("game_dns").style.display = "none";
		$G("game_list").style.display = "none";
		$G("gameV2_dns").style.display = "none";
		$G("gameV2_list").style.display = "none";
		$G("overall_dns").style.display = "none";
		$G("overall_list").style.display = "none";	
		$j("#cmdBtn").html("应用附加功能");
		document.form.ss_basic_action.value = 4;
		update_visibility();
	});	
}
function show_log_info(){
		$G("tablet_show").style.display = "none";
		$G("add_fun").style.display = "none";
		$G("apply_button").style.display = "none";
		$G("line_image1").style.display = "none";
		$G("log_content").style.display = "";
		$G("return_button").style.display = "";
		checkCmdRet();
}
function return_basic(){
		$G("tablet_show").style.display = "";
		$G("add_fun").style.display = "";
		$G("apply_button").style.display = "";
		$G("line_image1").style.display = "";
		$G("log_content").style.display = "none";
		$G("return_button").style.display = "none";
		$G("loading_icon").style.display = "none";
}

var _responseLen;
var noChange = 0;
function checkCmdRet(){

	$j.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet();", 1000);
			},
		success: function(response){
			var retArea = $G("log_content1");
			if(response.search("XU6J03M6") != -1){
				$G("loadingIcon").style.display = "none";
				retArea.value = response.replace("XU6J03M6", " ");
				//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
				retArea.scrollTop = retArea.scrollHeight;
				return false;
			}
			
			if(_responseLen == response.length)
				noChange++;
			else
				noChange = 0;
				
			if(noChange > 10){
				$G("loadingIcon").style.display = "none";
				//retArea.scrollTop = retArea.scrollHeight;
				setTimeout("checkCmdRet();", 1000);
			}else{
				$G("loadingIcon").style.display = "";
				setTimeout("checkCmdRet();", 1000);
			}
			
			retArea.value = response;
			//retArea.scrollTop = retArea.scrollHeight - retArea.clientHeight;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}

</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<div id="LoadingBar" class="popup_bar_bg">
<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
	<tr>
		<td height="100">
		<div id="loading_block3" style="margin:10px auto;width:85%; font-size:12pt;"></div>
		<div id="loading_block1" class="Bar_container">
			<span id="proceeding_img_text"></span>
			<div id="proceeding_img"></div>
		</div>
		
		<div id="loading_block2" style="margin:10px auto; width:85%;">此期间请勿访问屏蔽网址，以免污染DNS进入缓存</div>
		</td>
	</tr>
</table>
</div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/applydb.cgi?p=ss" target="hidden_frame">
<input type="hidden" name="current_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="next_page" value="Main_Ss_Content.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="6"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" id="ss_basic_enable" name="ss_basic_enable" value="0" />
<input type="hidden" id="ss_basic_action" name="ss_basic_action" value="1" />
<input type="hidden" id="ss_basic_install_status" name="ss_basic_install_status" value="0" />
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value=""/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<!--=====Beginning of Main Menu=====-->
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>
			<!--=====Beginning of Main Content=====-->
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" id="table_for_all" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle" id="ss_title">Shadowsocks - 账号信息配置</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote" id="head_illustrate"><i>说明：</i>请在下面的<em>账号设置</em>表格中填入你的Shadowsocks账号信息，选择好一个模式，点击提交后就能使用代理服务。</div>
										<div style="margin-top: 20px;text-align: center;font-size: 18px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"></div>
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ss_switch_table">
											<thead>
											<tr>
												<td colspan="2">开关</td>
											</tr>
											</thead>
											<tr>
											<th id="ss_switch">ShadowSocks 开关</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell;float: left;">
														<label for="switch">
															<input id="switch" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div id="update_button" style="padding-top:5px;margin-left:100px;margin-top:-38px;float: left;">
														<button id="updateBtn" class="button_gen" onclick="update_ss();">检查更新</button>
														<a style="margin-left: 178px;" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/shadowsocks/Changelog.txt" target="_blank"><em>[<u> 更新日志 </u>]</em></a>
													</div>
													<div id="ss_version_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"><i>当前版本：<% dbus_get_def("ss_basic_version_local", "未知"); %></i></div>
													<div id="ss_install_show" style="padding-top:5px;margin-left:230px;margin-top:0px;"></div>	
												</td>
											</tr>
                                    	</table>
                                    	<div id="ss_status1">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="ss_state">
												<th id="mode_state" width="35%">SS运行状态</th>
													<td>
														<a>
															<span style="display: none" id="ss_state1">尚未启用! </span>
															<span id="ss_state2">国外连接 - Waiting...</span>
															<br/>
															<span id="ss_state3">国内连接 - Waiting...</span>
														</a>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse"  width="100%" height="37px">
										        <tr width="235px">
                                    	            <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                    	                <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="账号设置"/>
                                    	                <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="DNS设定"/>
                                    	                <input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="黑白名单"/>
                                    	                <input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="附加功能"/>
                                    	            </td>
                                    	        </tr>
											</table>
										</div>
										<!--=====bacic show =====-->
										<div id="basic_show">
											<table style="margin:-1px 0px 0px 0px;" width="100%"  border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="node_select">
													<th width="35%">节点选择</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<select id="ssconf_basic_node" name="ssconf_basic_node" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="ss_node_sel();update_visibility();" >
															</select>
														</div>
														<div id="ss_node_edit" style="float:left; width:35px; height:35px;margin:-3px 0px -5px 2px;cursor:pointer" onclick="pop_ss_node_list_listview(true);"></div>
													</td>
												</tr>
												<tr>
													<th width="35%">模式</th>
													<td>
														<select id="ss_basic_mode" name="ss_basic_mode" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="1">【1】 GFWlist模式</option>
															<option value="2">【2】 大陆白名单模式</option>
															<option value="3">【3】 游戏模式</option>
															<option value="4">【4】 游戏模式V2</option>
															<option value="5">【5】 全局代理模式</option>
														</select>
														<div id="SSR_name"style="margin-left:170px;margin-top:-20px;margin-bottom:0px;">
															<input type="checkbox" id="ss_basic_use_rss" onclick="oncheckclick(this);update_visibility();" />
															<input type="hidden" id="hd_ss_basic_use_rss" name="ss_basic_use_rss" value="" />
															使用SSR
														</div>
														<div id="game_alert" style="margin-left:270px;margin-top:-20px;margin-bottom:0px;">
															<a href="http://koolshare.cn/thread-4519-1-1.html" target="_blank"><i>&nbsp;账号需支持UDP转发&nbsp;&nbsp;<u>FAQ</u></i></a>
														</div>
													</td>
												</tr>
												<tr id="server_tr">
													<th width="35%">服务器</th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_basic_server" name="ss_basic_server" maxlength="100" value=""/>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="35%">服务器端口</th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_basic_port" name="ss_basic_port" maxlength="100" value="" />
													</td>
												</tr>
												<tr id="pass_tr">
													<th width="35%">密码</th>
													<td>
														<input type="password" name="ss_basic_password" id="ss_basic_password" class="ssconfig input_ss_table" maxlength="100" value=""></input>
														<div style="margin-left:170px;margin-top:-20px;margin-bottom:0px"><input type="checkbox" name="show_pass" onclick="pass_checked(document.form.ss_basic_password);">
															显示密码
														</div>
													</td>
												</tr>												
												<tr id="method_tr">
													<th width="35%">加密方式</th>
													<td>
														<select id="ss_basic_method" name="ss_basic_method" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
															<option class="content_input_fd" value="table">table</option>
															<option class="content_input_fd" value="rc4">rc4</option>
															<option class="content_input_fd" value="rc4-md5">rc4-md5</option>
															<option class="content_input_fd" value="aes-128-cfb">aes-128-cfb</option>
															<option class="content_input_fd" value="aes-192-cfb">aes-192-cfb</option>
															<option class="content_input_fd" value="aes-256-cfb" selected="">aes-256-cfb</option>
															<option class="content_input_fd" value="bf-cfb">bf-cfb</option>
															<option class="content_input_fd" value="camellia-128-cfb">camellia-128-cfb</option>
															<option class="content_input_fd" value="camellia-192-cfb">camellia-192-cfb</option>
															<option class="content_input_fd" value="camellia-256-cfb">camellia-256-cfb</option>
															<option class="content_input_fd" value="cast5-cfb">cast5-cfb</option>
															<option class="content_input_fd" value="des-cfb">des-cfb</option>
															<option class="content_input_fd" value="idea-cfb">idea-cfb</option>
															<option class="content_input_fd" value="rc2-cfb">rc2-cfb</option>
															<option class="content_input_fd" value="seed-cfb">seed-cfb</option>
															<option class="content_input_fd" value="salsa20">salsa20</option>
															<option class="content_input_fd" value="chacha20">chacha20</option>
															<option class="content_input_fd" value="chacha20-ietf">chacha20-ietf</option>
														</select>
													</td>
												</tr>
												<tr id="ss_koolgame_udp_tr" >
													<th width="35%">UDP通道</th>
													<td>
														<select id="ss_basic_koolgame_udp" name="ss_basic_koolgame_udp" style="width:164px;margin:0px 0px 0px 2px;" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">udp in udp</option>
															<option value="1">udp in tcp</option>
														</select>
													</td>
												</tr>
												<tr id="onetime_auth">
													<th width="35%"><a href="https://shadowsocks.org/en/spec/one-time-auth.html" target="_blank"><u>一次性验证(OTA)</font></u></a></th>
													<td>
														<select id="ss_basic_onetime_auth" name="ss_basic_onetime_auth" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
															<option class="content_input_fd" value="1">开启</option>
															<option class="content_input_fd" value="0">关闭</option>
														</select>
														<span id="ss_basic_onetime_auth_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_rss_protocol_tr">
													<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>协议 (protocol)</u></a></th>
													<td>
														<select id="ss_basic_rss_protocol" name="ss_basic_rss_protocol" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" onchange="update_visibility();" >
															<option class="content_input_fd" value="origin">origin</option>
															<option class="content_input_fd" value="verify_simple">verify_simple</option>
															<option class="content_input_fd" value="verify_deflate">verify_deflate</option>
															<option class="content_input_fd" value="verify_sha1">verify_sha1</option>
															<option class="content_input_fd" value="auth_simple">auth_simple</option>
															<option class="content_input_fd" value="auth_sha1">auth_sha1</option>
															<option class="content_input_fd" value="auth_sha1_v2">auth_sha1_v2</option>
														</select>
														<span id="ss_basic_rss_protocol_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px">yuanben</span>
													</td>
												</tr>
												<tr id="ss_basic_rss_obfs_tr">
													<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup" target="_blank"><u>混淆插件 (obfs)</u></a></th>
													<td>
														<select id="ss_basic_rss_obfs" name="ss_basic_rss_obfs" style="width:164px;margin:0px 0px 0px 2px;" class="input_option"  onchange="update_visibility();" >
															<option class="content_input_fd" value="plain">plain</option>
															<option class="content_input_fd" value="http_simple">http_simple</option>
															<option class="content_input_fd" value="tls_simple">tls_simple</option>
															<option class="content_input_fd" value="random_head">random_head</option>
															<option class="content_input_fd" value="tls1.0_session_auth">tls1.0_session_auth</option>
															<option class="content_input_fd" value="tls1.2_ticket_auth">tls1.2_ticket_auth</option>
														</select>
														<span id="ss_basic_rss_obfs_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px"></span>
													</td>
												</tr>
												<tr id="ss_basic_ticket_tr">
													<th width="35%"><a href="https://github.com/breakwa11/shadowsocks-rss/blob/master/ssr.md" target="_blank"><u>自定义参数 (obfs_param)</u></a></th>
													<td>
														<input type="text" name="ss_basic_rss_obfs_param" id="ss_basic_rss_obfs_param" placeholder="cloudflare.com"  class="ssconfig input_ss_table" maxlength="100" value=""></input>
														<span id="ss_basic_ticket_tr_alert" style="margin-left:5px;margin-top:-20px;margin-bottom:0px">不知道如何填写请留空</span>
													</td>
												</tr>											
											</table>
										</div>
										
										<!--=====gfwlist_dns=====-->
										<div id="ipset_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th id="china_dns" width="20%">选择国内DNS</th>
													<td>
														<select id="ss_ipset_cdn_dns" name="ss_ipset_cdn_dns" class="input_option" onclick="update_visibility();" >
															<option value="1">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
															<input type="text" class="ssconfig input_ss_table" id="ss_ipset_cdn_dns_user" name="ss_ipset_cdn_dns_user" maxlength="100" value="">
															<span id="china_dns1">默认：运营商DNS【自动获取】</span>
															<br/>
															<span id="china_dns1">选择国内DNS解析gfwlist之外的域名</span>
													</td>
												</tr>
												<tr>
													<th width="20%">选择国外DNS</th>
													<td>
														<select id="ss_ipset_foreign_dns" name="ss_ipset_foreign_dns" class="input_option" onclick="update_visibility();" >
															<option value="2">DNS2SOCKS</option>
															<option value="0">dnscrypt-proxy</option>
															<option value="1">ss-tunnel</option>
															<option value="3">Pcap_DNSProxy</option>
															<option value="4">pdnsd</option>
														</select>
														<select id="ss_ipset_opendns" name="ss_ipset_opendns" class="input_option"></select>
														<select id="ss_ipset_tunnel" name="ss_ipset_tunnel" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Goole DNS1 [8.8.8.8]</option>
															<option value="3">Goole DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
															<input type="text" class="ssconfig input_ss_table" id="ss_ipset_tunnel_user" name="ss_ipset_tunnel_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
															<input type="text" class="ssconfig input_ss_table" id="ss_ipset_dns2socks_user" name="ss_ipset_dns2socks_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="8.8.8.8:53">
															<span id="ss_ipset_foreign_dns1">默认：DNS2SOCKS</span> <br/>
															<span id="DNS2SOCKS1">启用DNS2SOCKS后会自动开启SOCKS5</span>
															<span id="ss_ipset_foreign_dns2">用dnscrypt-proxy加密解析gfwlist中的<% nvram_get("ss_ipset_numbers"); %>条域名</span>
															<span id="ss_ipset_foreign_dns3">
																ss-tunnel通过udp转发将DNS交给SS服务器解析gfwlist中的<% nvram_get("ss_ipset_numbers"); %>条域名<br/>！！ss-tunnel需要ss账号支持udp转发才能使用！！
															</span>
													</td>
												</tr>
												<tr id="ipset_pdnsd_method">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="ss_ipset_pdnsd_method" name="ss_ipset_pdnsd_method" class="input_option" onclick="update_visibility();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="ipset_pdnsd_up_stream_tcp">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_ip" name="ss_ipset_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_port" name="ss_ipset_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="ipset_pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="ipset_pdnsd_up_stream_udp">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></th>
													<td>
														<select id="ss_ipset_pdnsd_udp_server" name="ss_ipset_pdnsd_udp_server" class="input_option" onclick="update_visibility();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
															
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_udp_server_dns2socks" name="ss_ipset_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_ipset_pdnsd_udp_server_dnscrypt" name="ss_ipset_pdnsd_udp_server_dnscrypt" class="input_option"></select>
														<select id="ss_ipset_pdnsd_udp_server_ss_tunnel" name="ss_ipset_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Goole DNS1 [8.8.8.8]</option>
															<option value="3">Goole DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_udp_server_ss_tunnel_user" name="ss_ipset_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="ipset_pdnsd_cache">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_cache_min" name="ss_ipset_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="ssconfig input_ss_table" id="ss_ipset_pdnsd_server_cache_max" name="ss_ipset_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="ipset_pdnsd1">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
													<th width="20%">自定义dnsmasq</th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18
# 如果填入了错误的格式，可能会导致页面错乱，请用命令：dbus remove ss_ipset_dnsmasq，手动清除此项配置。" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_dnsmasq" name="ss_ipset_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====redchn_dns=====-->
										<div id="redchn_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="redchn_dns_plan_china">
													<th width="20%">选择国内DNS</th>
													<td>
														<select id="ss_redchn_dns_china" name="ss_redchn_dns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_dns_china_user" name="ss_redchn_dns_china_user" maxlength="100" value="">
														<span id="redchn_show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span> <br/>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
													<th width="20%">选择国外DNS</th>
													<td>
														<select id="ss_redchn_dns_foreign" name="ss_redchn_dns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="4">DNS2SOCKS</option>
															<option value="1">dnscrypt-proxy</option>
															<option value="2">ss-tunnel</option>
															<option value="3">ChinaDNS</option>
															<option value="5">Pcap_DNSProxy</option>
															<option value="6">pdnsd</option>
														</select>
														<select id="ss_redchn_opendns" name="ss_redchn_opendns" class="input_option"></select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_dns2socks_user" name="ss_redchn_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_redchn_sstunnel" name="ss_redchn_sstunnel" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Goole DNS1 [8.8.8.8]</option>
															<option value="3">Goole DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_sstunnel_user" name="ss_redchn_sstunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													</td>
												</tr>
												<tr id="redchn_chinadns_china">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国内DNS</font></th>
													<td>
														<select id="ss_redchn_chinadns_china" name="ss_redchn_chinadns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">阿里DNS1【223.5.5.5】</option>
															<option value="2">阿里DNS2【223.6.6.6】</option>
															<option value="3">114DNS【114.114.114.114】</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_chinadns_china_user" name="ss_redchn_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													</td>
												</tr>
												<tr id="redchn_chinadns_foreign">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国外DNS</font></th>
													<td>
														<select id="ss_redchn_chinadns_foreign" name="ss_redchn_chinadns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Google DNS1 [8.8.8.8]</option>
															<option value="3">Google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_chinadns_foreign_user" name="ss_redchn_chinadns_foreign_user" maxlength="100" value="">
														<span>此处DNS通过ss-tunnel转发给SS服务器解析</span> <br/>
													</td>
												</tr>
												<tr id="redchn_pdnsd_method">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="ss_redchn_pdnsd_method" name="ss_redchn_pdnsd_method" class="input_option" onclick="update_visibility();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="redchn_pdnsd_up_stream_tcp">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_ip" name="ss_redchn_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_port" name="ss_redchn_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="redchn_pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="redchn_pdnsd_up_stream_udp">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></th>
													<td>
														<select id="ss_redchn_pdnsd_udp_server" name="ss_redchn_pdnsd_udp_server" class="input_option" onclick="update_visibility();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_udp_server_dns2socks" name="ss_redchn_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_redchn_pdnsd_udp_server_dnscrypt" name="ss_redchn_pdnsd_udp_server_dnscrypt" class="input_option"></select>
														<select id="ss_redchn_pdnsd_udp_server_ss_tunnel" name="ss_redchn_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Goole DNS1 [8.8.8.8]</option>
															<option value="3">Goole DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_udp_server_ss_tunnel_user" name="ss_redchn_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="redchn_pdnsd_cache">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_cache_min" name="ss_redchn_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="ssconfig input_ss_table" id="ss_redchn_pdnsd_server_cache_max" name="ss_redchn_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="redchn_pdnsd1">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
													<th width="20%">自定义需要CDN加速网站
														<br/>
														<br/>
														<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/cdn.txt" target="_blank"><font color="#ffcc00"><u>查看默认添加的<% nvram_get("cdn_numbers"); %>条国内域名</u></font></a>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制用国内DNS解析的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经添加了1万多条国内域名，请勿重复添加！
# 注意：不支持通配符！" cols="50" rows="7" id="ss_redchn_isp_website_web" name="ss_redchn_isp_website_web" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
												<th width="20%">自定义dnsmasq</th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;" id="ss_redchn_dnsmasq" name="ss_redchn_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====game_dns=====-->
										<div id="game_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="game_dns_plan_china">
												<th width="20%">选择国内DNS</th>
													<td>
														<select id="ss_game_dns_china" name="ss_game_dns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_dns_china_user" name="ss_game_dns_china_user" maxlength="100" value=""></input>
														<span id="game_show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
												<th width="20%">选择国外DNS</th>
													<td>
														<select id="ss_game_dns_foreign" name="ss_game_dns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="4">DNS2SOCKS</option>
															<option value="1">dnscrypt-proxy</option>
															<option value="2">ss-tunnel</option>
															<option value="3">ChinaDNS（CDN最优）</option>
															<option value="5">PcapDNSProxy</option>
															<option value="6">pdnsd</option>
														</select>
														<select id="ss_game_opendns" name="ss_game_opendns" class="input_option"></select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_dns2socks_user" name="ss_game_dns2socks_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_game_sstunnel" name="ss_game_sstunnel" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Goole DNS1 [8.8.8.8]</option>
															<option value="3">Goole DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_sstunnel_user" name="ss_game_sstunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
													</td>
												</tr>
												<tr id="game_chinadns_china">
												<th width="20%">ChinaDNS国内DNS</th>
													<td>
														<select id="ss_game_chinadns_china" name="ss_game_chinadns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">阿里DNS1【223.5.5.5】</option>
															<option value="2">阿里DNS2【223.6.6.6】</option>
															<option value="3">114DNS【114.114.114.114】</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_chinadns_china_user" name="ss_game_chinadns_china_user" placeholder="需端口号如：8.8.8.8:53" maxlength="100" value="">
													</td>
												</tr>
												<tr id="game_chinadns_foreign">
												<th width="20%">ChinaDNS国外DNS</th>
													<td>
														<select id="ss_game_chinadns_foreign" name="ss_game_chinadns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Google DNS1 [8.8.8.8]</option>
															<option value="3">Google DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_chinadns_foreign_user" name="ss_game_chinadns_foreign_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="">
															<span>此处DNS通过ss-tunnel转发给SS服务器解析</span> 
													</td>
												</tr>
												<tr id="game_pdnsd_method">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font></th>
													<td>
														<select id="ss_game_pdnsd_method" name="ss_game_pdnsd_method" class="input_option" onclick="update_visibility();" >
															<option value="1" selected >仅udp查询</option>
															<option value="2">仅tcp查询</option>
														</select>
													</td>
												</tr>
												<tr id="game_pdnsd_up_stream_tcp">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_ip" name="ss_game_pdnsd_server_ip" placeholder="DNS地址：8.8.4.4" style="width:128px;" maxlength="100" value="8.8.4.4">
														：
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_port" name="ss_game_pdnsd_server_port" placeholder="DNS端口" style="width:50px;" maxlength="6" value="53">
														
														<span id="game_pdnsd1">请填写支持TCP查询的DNS服务器</span>
													</td>
												</tr>
												<tr id="game_pdnsd_up_stream_udp">
													<th width="20%" ><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font></th>
													<td>
														<select id="ss_game_pdnsd_udp_server" name="ss_game_pdnsd_udp_server" class="input_option" onclick="update_visibility();" >
															<option value="1">DNS2SOCKS</option>
															<option value="2">dnscrypt-proxy</option>
															<option value="3">ss-tunnel</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_udp_server_dns2socks" name="ss_game_pdnsd_udp_server_dns2socks" style="width:128px;" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<select id="ss_game_pdnsd_udp_server_dnscrypt" name="ss_game_pdnsd_udp_server_dnscrypt" class="input_option"></select>
														<select id="ss_game_pdnsd_udp_server_ss_tunnel" name="ss_game_pdnsd_udp_server_ss_tunnel" class="input_option" onclick="update_visibility();" >
															<option value="1">OpenDNS [208.67.220.220]</option>
															<option value="2">Goole DNS1 [8.8.8.8]</option>
															<option value="3">Goole DNS2 [8.8.4.4]</option>
															<option value="4">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_udp_server_ss_tunnel_user" name="ss_game_pdnsd_udp_server_ss_tunnel_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8">
													</td>
												</tr>
												<tr id="game_pdnsd_cache">
													<th width="20%"><font color="#66FF66">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font></th>
													<td>
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_cache_min" name="ss_game_pdnsd_server_cache_min" title="最小TTL时间" style="width:30px;" maxlength="100" value="24h">
														→
														<input type="text" class="ssconfig input_ss_table" id="ss_game_pdnsd_server_cache_max" name="ss_game_pdnsd_server_cache_max" title="最长TTL时间" style="width:30px;" maxlength="100" value="1w">
														
														<span id="game_pdnsd1">填写最小TTL时间与最长TTL时间</span>
													</td>
												</tr>
												<tr>
												<th width="20%">自定义dnsmasq</th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_game_dnsmasq" name="ss_game_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====gameV2_dns=====-->
										<div id="gameV2_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="gameV2_dns_plan_china">
												<th width="20%">选择国内DNS</th>
													<td>
														<select id="ss_gameV2_dns_china" name="ss_gameV2_dns_china" class="input_option" onclick="update_visibility();" >
															<option value="1">运营商DNS【自动获取】</option>
															<option value="2">阿里DNS1【223.5.5.5】</option>
															<option value="3">阿里DNS2【223.6.6.6】</option>
															<option value="4">114DNS【114.114.114.114】</option>
															<option value="6">百度DNS【180.76.76.76】</option>
															<option value="7">cnnic DNS【1.2.4.8】</option>
															<option value="8">dnspod DNS【119.29.29.29】</option>
															<option value="5">自定义</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_gameV2_dns_china_user" name="ss_gameV2_dns_china_user" maxlength="100" value=""></input>
														<span id="gameV2_show_isp_dns">【<% nvram_get("wan0_dns"); %>】</span> <br/>
														<span id="ss_gameV2_dns_china_user_txt1">默认：运营商DNS【用于解析国内6000+个域名】</span> 
														<span id="ss_gameV2_dns_china_user_txt2">确保你自定义输入的国内DNS在chnroute中</span>
													</td>
												</tr>
												<tr id="dns_plan_foreign">
												<th width="20%">选择国外DNS</th>
													<td>
														<select id="ss_gameV2_dns_foreign" name="ss_gameV2_dns_foreign" class="input_option" onclick="update_visibility();" >
															<option value="1" disabled selected>DNS2SS</option>
														</select>
														<input type="text" class="ssconfig input_ss_table" id="ss_gameV2_dns2ss_user" name="ss_gameV2_dns2ss_user" maxlength="100" placeholder="需端口号如：8.8.8.8:53" value="8.8.8.8:53">
														<br/>
															<span id="dns_plan_foreign0">默认：koolgame内置DNS2SS，用以解析国内6000+域名以外的国内域名和国外域名</span>
													</td>
												</tr>
												<tr>
												<th width="20%">自定义dnsmasq</th>
													<td>
														<textarea placeholder="# 填入自定义的dnsmasq设置，一行一个
# 例如hosts设置：
address=/koolshare.cn/2.2.2.2
# 防DNS劫持设置：
bogus-nxdomain=220.250.64.18" rows=12 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_gameV2_dnsmasq" name="ss_gameV2_dnsmasq" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====overall_dns=====-->
										<div id="overall_dns" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                    						  <tr>
                    						    <th width="10%"><b>
                    						      <center>
                    						        <font color="#ffcc00">全局模式</font>
                    						      </center>
                    						      </b></th>
                    						    <td><select id="ss_overall_mode" name="ss_overall_mode" class="input_option">
                    						        <option value="0">全局HTTP(s)</option>
                    						        <option value="1">全局TCP</option>
                    						      </select>
                    						      <span>默认：全局HTTP(s)</span></td>
                    						  </tr>
                    						  <tr>
                    						    <th width="20%"><center>
                    						        <b><font color="#ffcc00">全局模式DNS</font></b>
                    						      </center></th>
                    						    <td><select id="ss_overall_dns" name="ss_overall_dns" class="input_option">
                    						        <option value="0">OpenDNS方式</option>
                    						        <option value="1">UDP转发方式</option>
                    						        <option value="2">OpenDNS方式 + UDP转发方式</option>
                    						      </select>
                    						      <span>默认：OpenDNS方式 </span></td>
                    						  </tr>
                    						</table>
                    					</div>

										<!--=====ipset_list=====-->
										<div id="ipset_list" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="20%">域名白名单（新增）</th>
													<td>
														<textarea placeholder="# 此处填入不需要走ss的域名，一行一个，格式如下：
google.com.sg
youtube.com
# 默认gfwlist以外的域名都不会走ss，故添加gfwlist内的域名才有意义!
# 屏蔽一个域名可能导致其他网址被屏蔽，例如解析结果一致的youtube.com和google.com.
# 只有域名污染，没有IP未阻断的网站，不能被屏蔽，例如twitter.com." rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_white_domain_web" name="ss_ipset_white_domain_web" title=""></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%">域名黑名单
														<br/>
														<br/>
														<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/gfwlist.conf" target="_blank">
															<u>查看默认添加的<% nvram_get("ss_ipset_numbers"); %>条域名黑名单(gfwlist)</u>
														</a>
													</th>
													<td>
														<textarea placeholder="# 此处填入需要强制走ss的域名，一行一个，格式如下：
koolshare.cn
baidu.com
# 默认已经由gfwlist提供了上千条被墙域名，请勿重复添加!" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_black_domain_web" name="ss_ipset_black_domain_web" title=""></textarea>
													</td>
												</tr>	
												<tr>
													<th width="20%">IP/CIDR黑名单</th>
													<td>
														<textarea placeholder="# 此处填入需要强制走kcptun的IP或IP段（CIDR格式），一行一个，格式如下：
91.108.4.0/22
91.108.56.0/24
109.239.140.0/24
67.198.55.0/24
# 对于某些没有域名但是被墙的服务很有用处，比如telegram等!" rows="7" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_ipset_black_ip" name="ss_ipset_black_ip" title=""></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====redchn_list=====-->
										<div id="redchn_list" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="20%">IP白名单<br>
														<br>
														<font color="#ffcc00">添加不需要走代理的外网ip地址</font>
													</th>
													<td>
														<textarea placeholder="# 填入不需要走代理的外网ip地址，一行一个，格式（IP/CIDR）如下
2.2.2.2
3.3.3.3
4.4.4.4/24
# 因为默认大陆的ip都不会走SS，所以此处填入国外IP/CIDR更有意义！" cols="50" rows="7" id="ss_redchn_wan_white_ip" name="ss_redchn_wan_white_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%">域名白名单<br>
														<br>
														<font color="#ffcc00">添加不需要走代理的域名</font>
													</th>
													<td>
														<textarea placeholder="# 填入不需要走代理的域名，一行一个，格式如下：
google.com
facebook.com
# 因为默认大陆的ip都不会走SS，所以此处填入国外域名更有意义！
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="7" id="ss_redchn_wan_white_domain" name="ss_redchn_wan_white_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%">IP黑名单<br>
														<br>
														<font color="#ffcc00">添加需要强制走代理的外网ip地址</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制走代理的外网ip地址，一行一个，格式（IP/CIDR）如下：
5.5.5.5
6.6.6.6
7.7.7.7/8
# 因为默认大陆以外ip都会走SS，所以此处填入国内IP/CIDR更有意义！" cols="50" rows="7" id="ss_redchn_wan_black_ip" name="ss_redchn_wan_black_ip" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
												<tr>
													<th width="20%">域名黑名单<br>
														<br>
														<font color="#ffcc00">添加需要强制走代理的域名</font>
													</th>
													<td>
														<textarea placeholder="# 填入需要强制走代理的域名，一行一个，格式如下：
baidu.com
taobao.com
# 因为默认大陆以外的ip都会走SS，所以此处填入国内域名更有意义！
# 需要清空电脑DNS缓存，才能立即看到效果。" cols="50" rows="7" id="ss_redchn_wan_black_domain" name="ss_redchn_wan_black_domain" style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;"></textarea>
													</td>
												</tr>
											</table>
										</div>

										<!--=====game_list=====-->
										<div id="game_list" style="display: none;">

										</div>
										
										<!--=====gameV2_list=====-->
										<div id="gameV2_list" style="display: none;">

										</div>

										<!--=====overall_list=====-->
										<div id="overall_list" style="display: none;">

										</div>

										<!--===== addon =====-->
										<div id="add_fun" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr>
													<th>查看日志信息</th>
													<td>
														<input class="button_gen" id="logBtn" onclick="show_log_info()" type="button" value="查看日志"/>
													</td>
												</tr>
												<tr>
													<th>状态更新间隔</th>
													<td>
														<select title="立即生效，无须提交" name="refreshrate" id="refreshrate" class="input_option" onchange="setRefresh(this);">
															<option value="0">不更新</option>
															<option value="5">5s</option>
															<option value="10" selected>10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
												<tr  id="gfw_number">
													<th id="gfw_nu1" width="35%">当前gfwlist域名数量</th>
													<td id="gfw_nu2">
															<% nvram_get("ipset_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/gfwlist.conf" target="_blank">
																<i><% nvram_get("update_ipset"); %></i>
														</a>
													</td>
												</tr>
												<tr  id="chn_number">
													<th id="chn_nu1" width="35%">当前大陆白名单IP段数量</th>
												<td id="chn_nu2">
													<p>
														<% nvram_get("chnroute_numbers"); %>&nbsp;行，最后更新版本：
														<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/chnroute.txt" target="_blank">
															<i><% nvram_get("update_chnroute"); %></i>
														</a>
													</p>
												</td>
												</tr>
												<tr  id="cdn_number">
													<th id="cdn_nu1" width="35%">当前国内域名数量</th>
													<td id="cdn_nu2">
														<p>
														<% nvram_get("cdn_numbers"); %>&nbsp;条，最后更新版本：
															<a href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/cdn.txt" target="_blank">
																<i><% nvram_get("update_cdn"); %></i>
															</a>
														</p>
													</td>
												</tr>
												<tr id="chromecast">
													<th width="35%">Chromecast支持</th>
													<td>
														<select id="ss_basic_chromecast" name="ss_basic_chromecast" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
															<span id="chromecast1"> 建议开启chromecast支持 </span>
													</td>
												</tr>
												<tr id="update_rules">
													<th width="35%">Shadowsocks规则自动更新</th>
													<td>
														<select id="ss_basic_rule_update" name="ss_basic_rule_update" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">禁用</option>
															<option value="1">开启</option>
														</select>
														<select id="ss_basic_rule_update_time" name="ss_basic_rule_update_time" class="ssconfig input_option" title="选择规则列表自动更新时间，更新后将自动重启SS" onchange="update_visibility();" >
															<option value="0">00:00点</option>
															<option value="1">01:00点</option>
															<option value="2">02:00点</option>
															<option value="3">03:00点</option>
															<option value="4">04:00点</option>
															<option value="5">05:00点</option>
															<option value="6">06:00点</option>
															<option value="7">07:00点</option>
															<option value="8">08:00点</option>
															<option value="9">09:00点</option>
															<option value="10">10:00点</option>
															<option value="11">11:00点</option>
															<option value="12">12:00点</option>
															<option value="13">13:00点</option>
															<option value="14">14:00点</option>
															<option value="15">15:00点</option>
															<option value="16">16:00点</option>
															<option value="17">17:00点</option>
															<option value="18">18:00点</option>
															<option value="19">19:00点</option>
															<option value="20">20:00点</option>
															<option value="21">21:00点</option>
															<option value="22">22:00点</option>
															<option value="23">23:00点</option>
														</select>
															&nbsp;
															<a id="update_choose">
																<input type="checkbox" id="ss_basic_gfwlist_update" name="a" title="选择此项应用gfwlist自动更新" onclick="oncheckclick(this);">gfwlist
																<input type="checkbox" id="ss_basic_chnroute_update" name="a2" onclick="oncheckclick(this);">chnroute
																<input type="checkbox" id="ss_basic_cdn_update" name="a3" onclick="oncheckclick(this);">CDN
																<input type="hidden" id="hd_ss_basic_gfwlist_update" name="ss_basic_gfwlist_update" value=""/>
																<input type="hidden" id="hd_ss_basic_chnroute_update" name="ss_basic_chnroute_update" value=""/>
																<input type="hidden" id="hd_ss_basic_cdn_update" name="ss_basic_cdn_update" value=""/>
															</a>
																<input id="update_now" onclick="updatelist()" style="font-family:'Courier New'; Courier, mono; font-size:11px;" type="submit" value="立即更新" />
															<a href="http://192.168.1.1/Main_SsLog_Content.asp" target="_blank"></a>
													</td>
												</tr>
												<tr id="ss_lan_control">
													<th width="35%">局域网客户端控制&nbsp;&nbsp;&nbsp;&nbsp;<select id="ss_basic_lan_control" name="ss_basic_lan_control" class="input_ss_table" style="width:auto;height:25px;margin-left: 0px;" onchange="update_visibility();">
															<option value="0">禁用</option>
															<option value="1">黑名单模式</option>
															<option value="2">白名单模式</option>
														</select>
													</th>
													<td>
														<textarea placeholder="填入需要限制客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=3 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_basic_black_lan" name="ss_basic_black_lan" title=""></textarea>
														<textarea placeholder="填入仅允许的客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=3 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;" id="ss_basic_white_lan" name="ss_basic_white_lan" title=""></textarea>
													</td>
												</tr>
												<tr id="ss_sleep_tr">
													<th width="35%">开机启动延时</th>
													<td>
														<select id="ss_basic_sleep" name="ss_basic_sleep" class="ssconfig input_option" onchange="update_visibility();" >
															<option value="0">0s</option>
															<option value="5">5s</option>
															<option value="10">10s</option>
															<option value="15">15s</option>
															<option value="30">30s</option>
															<option value="60">60s</option>
														</select>
													</td>
												</tr>
											</table>
										</div>

										<!--log_content-->
										<div id="log_content" style="margin-top:10px;display: none;">
											<textarea cols="63" rows="30" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;"></textarea>
										</div>

										<div class="apply_gen" id="loading_icon">
											<img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif">
										</div>
										<div id="return_button" class="apply_gen" style="display: none;">
											<input class="button_gen" id="returnBtn" onClick="return_basic()" type="button" value="返回"/>
										</div>
										
										<div id="apply_button"class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl()">提交</button>
										</div>
										<div id="warn1" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;"class="formfontdesc" id="cmdDesc"><i>你开启了kcptun,请先关闭后才能开启Shadowsocks</i></div>
										<div id="line_image1" style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>

										<div class="KoolshareBottom">
											论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											博客技术支持： <a href="http://www.mjy211.com" target="_blank"> <i><u>www.mjy211.com</u></i> </a> <br/>
											Github项目： <a href="https://github.com/koolshare/koolshare.github.io" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
											Shell by： <a href="mailto:sadoneli@gmail.com"> <i>sadoneli</i> , Web by： <i>Xiaobao</i></a>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		<!--=====End of Main Content=====-->
		</td>
		<td width="10" align="center" valign="top"></td>
	</tr>
</table>
</form>
<div id="footer"></div>
</body>
<script type="text/javascript">
<!--[if !IE]>-->
jQuery.noConflict();
(function($){
var i = 0;
})(jQuery);
<!--<![endif]-->
</script>
</html>

