<%@page import="swallow.framework.entitydescript.EntityDescript"%>
<%@page import="org.springframework.util.StringUtils"%>
<%@page import="swallow.framework.entitydescript.EntityProperty"%>
<%@page import="com.swallow3.codetool.RequestData"%>
<%@ page language="java"  pageEncoding="utf-8"%>
<%
//  系统control的代码模板
	EntityDescript data=(EntityDescript)request.getAttribute("data");
%>

package ${outPackage}.control;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiModelProperty;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import ${rawPackage}.${name};
import ${servicePackage}.${name}Service;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import swallow.framework.exception.SwallowException;
import swallow.framework.web.ApiResult;
import swallow.framework.web.BaseApiResult;
import swallow.framework.web.BasePageQueryBean;
import swallow.framework.web.PageListData;


/**
 * ${cnname}API接口
 */
@Slf4j
@RestController
@RequestMapping("/api/<%=StringUtils.uncapitalize(data.getName()) %>")
@Api(value = "${cnname}管理接口", tags = { "${cnname}管理API接口" })
public class ${name}Control {

  /**
   * 查询bean
   */
  @Data
  public static class QueryBean extends BasePageQueryBean {


<%
	for(EntityProperty prop:data.getProps()){
%>

    @ApiModelProperty(name="<%=prop.getCnname() %>")
    private <%=prop.getType() %> <%=prop.getName() %>;
<%
  }
%>
  }

  // 数据访问服务
  @Autowired
  private ${name}Service service;

  /**
   * 新增${cnname}接口
   */
  @PostMapping("add")
  @SuppressWarnings("unchecked")
  @ApiOperation(value = "新增${cnname}数据", produces = MediaType.APPLICATION_JSON_UTF8_VALUE, httpMethod = "POST")
  public ApiResult<${name}> addNew${name}(@ApiParam(value = "要新增的${cnname}") @RequestBody ${name} item) {
    try {

      return ApiResult.success(service.insertItem(item));
    } catch (SwallowException e) {
      log.error("新增${cnname}出错:" + e.getMessage(), e);
      return ApiResult.fail(e,"新增${cnname}出错:" + e.getMessage());
    }
  }

  /**
   * 修改${cnname}数据接口
   */
  @PostMapping("save")
  @SuppressWarnings("unchecked")
  @ApiOperation(value = "修改${cnname}数据", produces = MediaType.APPLICATION_JSON_UTF8_VALUE, httpMethod = "POST")
  public ApiResult<${name}> save${name}(@ApiParam(value = "要保存的${cnname}") @RequestBody ${name} item) {
    try {
      return ApiResult.success(service.updateItem(item));
    } catch (SwallowException e) {
      log.error("修改${cnname}出错:" + e.getMessage(), e);
      return ApiResult.fail(e,"修改${cnname}出错:" + e.getMessage());
    }
  }

  /**
   * 查询${cnname}数据列表
   */
  @PostMapping("listpages")
  @SuppressWarnings("unchecked")
  @ApiOperation(value = "查询${cnname}数据", produces = MediaType.APPLICATION_JSON_UTF8_VALUE, httpMethod = "POST")
  public ApiResult<PageListData<${name}>> query(@ApiParam(value = "查询条件") @RequestBody QueryBean query) {
    try {

      var res = service.getAllItemPageByQuerybean(query);

      return ApiResult.success(res);
    } catch (SwallowException e) {
      log.error("查询${cnname}数据出错:" + e.getMessage(), e);
      return ApiResult.fail(e,"查询${cnname}数据出错:" + e.getMessage());
    }
  }

  /**
   * 通过ID取得${cnname}
   */
  @RequestMapping("{id}")
  @SuppressWarnings("unchecked")
  @ApiOperation(value = "取得指定ID的${cnname}", produces = MediaType.APPLICATION_JSON_UTF8_VALUE, httpMethod = "GET")
  public ApiResult<${name}> get${name}ById(@ApiParam(value = "${cnname}的ID") @PathVariable long id) {
    try {
      var res = service.getItemById(id);

      return ApiResult.success(res);
    } catch (Exception e) {
      log.error("查询${cnname}出错:" + e.getMessage(), e);
      return ApiResult.fail(e,"查询${cnname}出错:" + e.getMessage());
    }
  }

  
  /**
   * 删除指定id的数据
   */
  @PostMapping("del")
  @ApiOperation(value = "删除指定ID的${cnname}列表", produces = MediaType.APPLICATION_JSON_UTF8_VALUE, httpMethod = "POST")
  public BaseApiResult deleteEMangerUser(@ApiParam(value = "${cnname}的ID列表") @RequestBody Long[] ids) {
    try {
      for (var id : ids)
        service.deleteItemById(id);
      return BaseApiResult.successResult();
    } catch (Exception e) {
      log.error("删除${cnname}出错:" + e.getMessage(), e);
      return BaseApiResult.failResult(e, "删除${cnname}出错:" + e.getMessage());
    }
  }

}