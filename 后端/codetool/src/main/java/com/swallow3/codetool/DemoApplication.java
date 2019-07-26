package com.swallow3.codetool;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import swallow.framework.entitydescript.EntityDescript;

@Controller
@RequestMapping("/api")
@SpringBootApplication
public class DemoApplication {
	private Logger log = LoggerFactory.getLogger(DemoApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@Autowired
	private ObjectMapper obMapper;

	@PostMapping("control")
	public ModelAndView ControlTmpl(@RequestBody RequestData data,HttpServletRequest request) {
		var mv = new ModelAndView("Swallow3ControlTmpl");
		
		EntityDescript descript = data.getEntityinfo();
		
		mv.addObject("name",descript.getName());
		request.setAttribute("name",descript.getName());

		mv.addObject("data", descript);
		request.setAttribute("data", descript);

		// 添加类的包名称
		mv.addObject("outPackage", data.getPackagePath());
		request.setAttribute("outPackage", data.getPackagePath());

		// 添加原始包名称
		String strRawPackage=getRawPackageName(descript.getFullName());
		mv.addObject("rawPackage", strRawPackage);
		request.setAttribute("rawPackage", strRawPackage);

		// 设置文件名称
		String fileName = String.format("%sControl", StringUtils.capitalize(descript.getName()));
		mv.addObject("fileName", fileName);
		request.setAttribute("fileName", fileName);
		
		// 设置中文名称
		mv.addObject("cnname",descript.getCnname());
		request.setAttribute("cnname",descript.getCnname());
		
		// 取得Service包的路径
		String servicePackage=strRawPackage.replace(".entity.", ".service.");
		mv.addObject("servicePackage",servicePackage);
		request.setAttribute("servicePackage",servicePackage);
		

		return mv;
	}
	
	/**
	 * api导出的实现
	 * @param data
	 * @param request
	 * @return
	 */
	@PostMapping("tsapi")
	public ModelAndView TsApiTmpl(@RequestBody EntityDescript data,HttpServletRequest request) {
		var mv = new ModelAndView("Swallow3ApiJsTs");

		EntityDescript descript = data;

		mv.addObject("data", descript);
		request.setAttribute("data", descript);
		
		mv.addObject("name",descript.getName());
		request.setAttribute("name",descript.getName());
		
		// 设置url地址
		String apiUrl="/api/"+ StringUtils.uncapitalize(descript.getName());
		mv.addObject("apiurl", apiUrl);
		request.setAttribute("apiurl", apiUrl);
		
		return mv;
	}
	
	/**
	 * 表格列定义导出的实现
	 * @param data
	 * @param request
	 * @return
	 */
	@PostMapping("tstablecols")
	public ModelAndView TsTableColsTmpl(@RequestBody EntityDescript data,HttpServletRequest request) {
		var mv = new ModelAndView("Swallow3TableViewColDefineTs");

		EntityDescript descript = data;
		
		

		mv.addObject("data", descript);
		request.setAttribute("data", descript);
		
		return mv;
	}
	
	@RequestMapping("test")
	public String Test() {
		return "Test";
	}

	/**
	 * 从文件中读取json字串
	 * 
	 * @param filePath
	 * @return
	 */
	private EntityDescript readJsonFromFile(String filePath) {
		try {
			return obMapper.readValue(new File(filePath), EntityDescript.class);
		} catch (Exception e) {
			log.error(String.format("读取文件%s的json数据出错!", filePath), e);
			throw new RuntimeException(String.format("读取文件%s的json数据出错!", filePath), e);
		}
	}

	/**
	 * 取得原始的包名称
	 * @param className
	 * @return
	 */
	private String getRawPackageName(String className) {
		Assert.isTrue(StringUtils.hasText(className),"参数className不允许为空");
		var list = Arrays.asList(className.split("\\."));
		var arrayList=new ArrayList<>(list);
		// 删除最后一个成员
		arrayList.remove(list.size() - 1);
		String rawPackage = String.join(".", arrayList);
		return rawPackage;
	}

}
