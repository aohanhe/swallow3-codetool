<%@page import="swallow.framework.entitydescript.EntityDescript"%>
<%@page import="org.springframework.util.StringUtils"%>
<%@page import="swallow.framework.entitydescript.EntityProperty"%>
<%@page import="com.swallow3.codetool.RequestData"%>
<%@ page language="java"  pageEncoding="utf-8"%>
<%
//  系统control的代码模板
	EntityDescript data=(EntityDescript)request.getAttribute("data");
%>

import request, { ResponseData, PagerResponseData, PagerQueryData } from '@/libs/request'
/**
 * 应用模块对象数据定义
 */
export interface ${name} {
<%
	for(EntityProperty prop:data.getProps()){
%>
    // <%=prop.getCnname() %>
    <%=prop.getName()%>?: <%=prop.getJsType() %>
<%
}
%>    
}

/**
 * 应用模块分页结果定义
 */
export interface ${name}Pager extends PagerResponseData<${name}>{
}

/**
 * 应用模块管理的API处理服务
 */
export default class ${name}Service {
  // 向服务查询数据并分页返回结果
  static fecthList (query:PagerQueryData):Promise<${name}Pager> {
    // 向服务器查询数据
    return request<${name}Pager>({
      url: '${apiurl}/listpages',
      method: 'post',
      data: query
    })
  }

  // 保存数据到远程服务器
  static saveNewItem (item:${name}):Promise<ResponseData> {
    return request<ResponseData>({
      url: '${apiurl}/add',
      method: 'post',
      data: item
    })
  }

  // 更新数据到远程服务器
  static updateItem (item:${name}):Promise<ResponseData> {
    return request<ResponseData>({
      url: '${apiurl}/save',
      method: 'post',
      data: item
    })
  }

  // 删除指定ID的数据
  static deleteItemByIds (ids:Array<number>):Promise<ResponseData> {
    return request<ResponseData>({
      url: '${apiurl}/del',
      method: 'post',
      data: ids
    })
  }

  // 通过ID取得数据
  static getItemById (id:number):Promise<ResponseData> {
    return request<ResponseData>({
      url: '${apiurl}/' + id,
      method: 'get'
    })
  }
}

